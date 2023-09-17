(* 

9/17/2023
Tested with EOS 3.2.3 and QLab v5.2.3 on macOS Ventura 13.5.2

ETC EOS Control Cue Generator for QLab via CSV

HOW TO USE-
On your EOS console, go to the menu and go to File > Export > CSV.
Deselect all options and select only Cues.
Save the file to a flash drive or location you are able to network into and access that file on your Mac running QLab.
Then run this script in QLab and select the CSV file you made and go through the prompts depending on whether you are controlling via MIDI or OSC.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

DEMONSTRATION VIDEO:
https://www.youtube.com/watch?v=0Ckfvs_V6Rg&feature-youtu.be

File Name: QLab 5 - ETC EOS - Control Cue Generator for QLab via CSV

Written by Chase Elison 
chase@chaseelison.com

Script originated from Jack Baxter. Thanks!
Snippets of code from Taylor Glad, including the code to create a new cue list. Thanks!
CSV Reading Functionality from Nigel Garvey - https://macscripter.net/viewtopic.php?pid=125444#p125444

*)

--NEW as of QLab 5.0.9 - You now need to specify whether or not you want to use a user. Do so here.
--If the boolean is false, the second variable does not matter.
set eosSpecifyUser to false
set eosUser to 5

--DEFAULTS: Set values to these if you don't want to be prompted for settings when you run this script:
set qlabCueType to "" -- "" if prompt, otherwise one of: {"Network", "MIDI"}
set qlabCuePatch to 0 -- 0 if prompt
set qlabMidiDeviceID to -1 -- -1 if prompt
set cueNamePrefix to "" -- "" if prompt
set includeEOSCueLabels to false -- false will prompt
set useCueNumbers to "" -- "" if prompt, otherwise one of: {"EOS Cue Numbers", "QLab Default Numbers", "No Numbers"} 


tell application id "com.figure53.QLab.5" to tell front workspace
	
	--
	-- BEGIN QLab VERSION CHECK SNIPPET
	-- Chase Elison 11/28/2022
	--
	set versionOfQLab to get version of application "QLab"
	set text item delimiters of AppleScript to "."
	set versionNumber to text items of versionOfQLab
	set isVersion5 to (item 1 of versionNumber is "5") as boolean
	set isNewVersionWithUser to false as boolean
	-- By default, it will not add user data
	if (item 2 of versionNumber is "0") and (item 3 of versionNumber as integer is 9) then
		-- Is build .0.9 or higher, therefore will add user info in cues.
		set isNewVersionWithUser to true
	else if item 2 of versionNumber as integer is 1 then
		-- Is greater than build .1.x, it will be presumed that newer versions will follow the same format
		-- At time of writing this, 11/28/2022, QLab 5.0.10 is newest version.
		set isNewVersionWithUser to true
	end if
	--
	-- END QLab VERSION CHECK SNIPPET
	-- Variable isNewVersionWithuser will indicate whether the cues should be generated with user data or not.
	--
	
	set qlabCueProblems to 0
	
	if edit mode is false then return
	display dialog "Do you have the CSV file exported from EOS with only cues selected ready to go?" with title "EOS CSV Cue Generator" with icon 1 buttons {"No", "Yes"} default button "Yes"
	
	if button returned of result = "Yes" then
		set csvFilePrompt to choose file with prompt "Please select an image to process:" of type {"csv"}
	else
		
		display dialog "On your EOS console, go to the menu and choose File > Export > CSV. Choose a location to save the file (Either on a flash drive, or somewhere you can access the file over the network).
		
Deselect all of the options, and select CUES only to be exported.
		
Once you have the file on your Mac, run this script and select the file :)" with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
		return
	end if
end tell
set csvFile to csvToList(read csvFilePrompt, {}, {trimming:true})
tell application id "com.figure53.QLab.5" to tell front workspace
	if qlabCueType is "" then
		display dialog "Do you need to generate OSC (network) cues or  MIDI cues?" with title "EOS CSV Cue Generator" with icon 1 buttons {"Network", "MIDI"} default button "Network"
		if button returned of result = "Network" then
			set qlabCueType to "Network"
		else if button returned of result = "MIDI" then
			set qlabCueType to "MIDI"
		else
			return
		end if
	end if
	
	if qlabCuePatch is 0 then
		display dialog qlabCueType & " Destination (Patch)? Leave as 1 if you have only one destination, which is the console." with icon 1 default answer "1"
		try
			set qlabCuePatch to (text returned of result) as integer
			if (qlabCuePatch is 0) or (qlabCuePatch > 16) then
				display dialog "ERROR - must be a number between 1 and 16" with icon 1 buttons {"OK"} default button 1
				return
			end if
		on error the errorMessage
			display dialog "ERROR - " & errorMessage with icon 1 buttons {"OK"} default button 1
			return
		end try
	end if
	
	--9/17/23 Validate EOS network cue
	if qlabCueType is "Network" then
		make type "network"
		set networkTestingCue to last item of (selected as list)
		set network patch number of networkTestingCue to qlabCuePatch
		if isNewVersionWithUser then
			set networkTestingCueParameterValues to {"cue", "yes", 2, "fireInList", 3, 4}
		else
			set networkTestingCueParameterValues to {"cue", "fireInList", 3, 4}
		end if
		set parameter values of networkTestingCue to networkTestingCueParameterValues
		set networkCueTestResult to count of parameter values of networkTestingCue
		set patchName to network patch name of networkTestingCue
		tell parent of networkTestingCue
			delete cue id (uniqueID of networkTestingCue)
		end tell
		if networkCueTestResult is not (count of networkTestingCueParameterValues) then
			display dialog "It appears your patch is not set correctly. Please first check that the patch you have chosen, network patch \"" & patchName & "\" is correct. If it is, please go to your settings (Gear icon in the bottom right of QLab) and under network, change the type of \"" & patchName & "\" to \"ETC Eos Family\"." with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
			return
		end if
	end if
	
	if qlabCueType is "MIDI" and (qlabMidiDeviceID < 0 or qlabMidiDeviceID > 127) then
		display dialog "EOS - MIDI RX Device ID?" with icon 1 default answer "0"
		try
			set qlabMidiDeviceID to (text returned of result) as integer
			if (qlabMidiDeviceID < 0) or (qlabMidiDeviceID > 127) then
				display dialog "ERROR - must be a number between 0 and 127" with icon 1 buttons {"OK"} default button 1
				return
			end if
		on error the errorMessage
			display dialog "ERROR - " & errorMessage with icon 1 buttons {"OK"} default button 1
			return
		end try
	end if
	
	if cueNamePrefix is "" then
		set cueNamePrefix to the text returned of (display dialog "What prefix would you like for the cues? (e.g. Q1, Light Cue 1, LQ1...)" with icon 1 default answer "Q")
	end if
	
	if includeEOSCueLabels is false then
		display dialog "Would you like to copy the labels from EOS cues to the cue names in QLab?" with icon 1 buttons {"No", "Yes"} default button "No"
		if button returned of result = "Yes" then
			set includeEOSCueLabels to true
		end if
	end if
	
	if useCueNumbers is not in {"EOS Cue Numbers", "QLab Default Numbers", "No Numbers"} then
		set useCueNumbers to button returned of (display dialog "Do you want to use EOS cue numbers as QLab cue numbers, allow QLab to choose numbers, or use no numbers?" buttons {"EOS Cue Numbers", "QLab Default Numbers", "No Numbers"} with icon 1 default button "No Numbers")
	end if
	
	try
		set current cue list to last cue list whose q name is "EOS Light Cues"
	on error number the errorNumber
		if errorNumber is -1719 then
			make type "cue list"
			set q name of last cue list to "EOS Light Cues"
			set current cue list to last cue list whose q name is "EOS Light Cues"
		end if
	end try
	
	make type "memo"
	set headerMemoCue to last item of (selected as list)
	set q color of headerMemoCue to "Yellow"
	set q name of headerMemoCue to (("EOS Light Cues - Generated from file " & csvFilePrompt as text) & " - " & (current date) as text) & " - Starts Below"
	set notes of headerMemoCue to "EOS CSV Import Code Written by Chase Elison"
	set q number of headerMemoCue to ""
	set continue mode of headerMemoCue to do_not_continue
	
	set EOSCueLabelColumn to 7
	set EOSCueListColumn to 3
	set EOSCueNumberColumn to 4
	set EOSAutoFollowColumn to 24
	set EOSCueLinkColumn to 25
	set EOSTargetTypeColumn to 2
	set ExcelStartRow to 4
	
	
	set currentRow to ExcelStartRow
	set eosRedCueCount to 0
	
	repeat until (item 1 of item currentRow of csvFile is "END_TARGETS")
		--First, verify that the row is a cue:
		if item EOSTargetTypeColumn of item currentRow of csvFile is "Cue" then
			--Reset cue red status
			set qlabMakeCueRed to false
			set eosSpecialPrefixes to ""
			
			--Check the EOS cue list and prepend to cue name if it is not 1
			set eosCueList to item EOSCueListColumn of item currentRow of csvFile
			if eosCueList is "0" then
				set eosSpecifyCueList to false
				set eosCueListPrefix to ""
			else if eosCueList is "1" then
				set eosSpecifyCueList to true
				set eosCueListPrefix to ""
			else
				set eosSpecifyCueList to true
				set eosCueListPrecix to eosCueList & "/"
			end if
			(* remove this block if working
			if eosCueList is not "1" and eosCueList is not "0" then
				set eosCueListPrefix to eosCueList & "/"
			else
				set eosCueListPrefix to ""
			end if
			*)
			
			--Check that the EOS Cue number is not a "point" cue and make the value an integer if not
			set eosCueNumber to item EOSCueNumberColumn of item currentRow of csvFile
			
			--Check that the EOS cue label is not blank, and if the user desires, append label text to end of QLab cue name
			if item EOSCueLabelColumn of item currentRow of csvFile is not "" and includeEOSCueLabels is true then
				set eosCueLabel to " - " & item EOSCueLabelColumn of item currentRow of csvFile
			else
				set eosCueLabel to ""
			end if
			
			--Check if EOS cue follows from a previous cue
			set followCellValue to item EOSAutoFollowColumn of item (currentRow - 1) of csvFile
			if followCellValue starts with "F" or followCellValue starts with "H" then -- and (value of cell (EOSCueLinkColumn & currentRow) as string) is not ""
				set eosSpecialPrefixes to "(" & followCellValue & ") " & eosSpecialPrefixes
				set qlabMakeCueRed to true
			end if
			
			--Check if EOS cue links to another cue
			
			if item EOSCueLinkColumn of item currentRow of csvFile is not "" then
				set eosSpecialPrefixes to "(Link: " & cueNamePrefix & item EOSCueLinkColumn of item currentRow of csvFile & ") " & eosSpecialPrefixes
				set qlabMakeCueRed to true
			end if
			set qlabCueName to eosSpecialPrefixes & cueNamePrefix & eosCueListPrefix & eosCueNumber & eosCueLabel
			set qlabOSCCommand to "/eos/cue/" & eosCueList & "/" & eosCueNumber & "/fire" as string -- Not needed if using a proper V5 cue
			
			
			
			if qlabCueType is "Network" then
				make type "network"
				set qlabNewCue to last item of (selected as list)
				(* QLab 5: *)
				--
				-- BEGIN EOS Cue Generator Snippet
				-- Chase Elison 11/28/2022
				--
				
				-- First item will always be "cue"
				set networkCueValues to {"cue"}
				if isNewVersionWithUser then
					-- Check with the version snippet to see if user info is required
					if eosSpecifyUser then
						-- if specifying the user, the 2nd item will be "yes" and the 3rd item will be the user number
						set networkCueValues to networkCueValues & "yes" & eosUser
					else
						-- if not, the 2nd item will be "no"
						set networkCueValues to networkCueValues & "no"
					end if
				end if
				if eosSpecifyCueList then
					-- if specifying the list, the next 2 values will be "fireInList" and the list number.
					set networkCueValues to networkCueValues & "fireInList" & eosCueList
				else
					--if not, the next 1 value will be "fire"
					set networkCueValues to networkCueValues & "fire"
				end if
				-- Lastly, the cue number.
				set networkCueValues to networkCueValues & eosCueNumber
				set network patch number of qlabNewCue to qlabCuePatch
				set parameter values of qlabNewCue to networkCueValues
				if (count of parameter values of qlabNewCue) is not (count of networkCueValues) then
					set q name of qlabNewCue to "PROBLEM - " & q display name of qlabNewCue
					set q color of qlabNewCue to "red"
					set flagged of qlabNewCue to true
					set qlabCueProblems to qlabCueProblems + 1
				end if
				--
				-- END EOS Cue Generator Snippet
				--
			else if qlabCueType is "MIDI" then
				make type "midi"
				set qlabNewCue to last item of (selected as list)
				set message type of qlabNewCue to msc
				set command format of qlabNewCue to 1 -- Lighting (General)
				set command number of qlabNewCue to 1 -- GO
				set deviceID of qlabNewCue to qlabMidiDeviceID
				set q_list of qlabNewCue to eosCueList
				set q_number of qlabNewCue to eosCueNumber
			end if
			set pre wait of qlabNewCue to 0
			set duration of qlabNewCue to 0
			set post wait of qlabNewCue to 0
			if qlabCueProblems is 0 then
				set q name of qlabNewCue to qlabCueName
			end if
			--set patch of qlabNewCue to qlabCuePatch
			if q type of qlabNewCue is "network" then
				--if (countOfItems is not 4 and eosCueList is not "0") or (countOfItems is not 3 and eosCueList is "0") then
				if qlabCueProblems > 0 then
					display dialog "It appears your patch is not set correctly. Please first check that the patch you have chosen, network patch \"" & patchName & "\" is correct. If it is, please go to your settings (Gear icon in the bottom right of QLab) and under network, change the type of \"" & patchName & "\" to \"ETC Eos Family\"." with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
					return
				end if
				--This is a tiny bit redundant since the new snippet that makes network cues flags them,
				--but for this specific script it'll be good to have a full stop before it continues on making
				--tons of errors before the user can fix it.
			else if q type of qlabNewCue is "MIDI" then
				set midi patch number of qlabNewCue to qlabCuePatch
			end if
			set continue mode of qlabNewCue to do_not_continue
			if useCueNumbers = "EOS Cue Numbers" then
				set q number of qlabNewCue to eosCueNumber
			else if useCueNumbers = "No Numbers" then
				set q number of qlabNewCue to ""
			end if
			
			
			
			if qlabMakeCueRed then
				set q color of qlabNewCue to "Red"
				set eosRedCueCount to eosRedCueCount + 1
			end if
			
		end if
		set currentRow to currentRow + 1
	end repeat
	if eosRedCueCount > 0 then
		display dialog "There were " & eosRedCueCount & " cues that either auto-follow or have links. They have been colored red. Double check with lighting designer to see what to do about these cues. :)" with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
	end if
	display dialog "All done! Happy programming! Remember to get some sleep at some point :)" with title "EOS CSV Cue Generator" with icon 1 buttons "Thanks!" default button "Thanks!"
end tell

--- END SCRIPT, BEGIN CSV SCRIPT ---

(* Assumes that the CSV text follows the RFC 4180 convention:
   Records are delimited by CRLF line breaks (but LFs or CRs are OK too with this script).
   The last record in the text may or may not be followed by a line break.
   Fields in the same record are separated by commas (but a different separator can be specified here with an optional parameter).
   The last field in a record is NOT followed by a field separator. Each record has (number of separators + 1) fields, even when these are empty.
   All the records should have the same number of fields (but this script just renders what it finds).
   Any field value may be enquoted with double-quotes and should be if the value contains line breaks, separator characters, or double-quotes.
   Double-quote pairs within quoted fields represent escaped double-quotes.
   Trailing or leading spaces in unquoted fields are part of the field values (but trimming can specified here with an optional parameter).
   By implication, spaces (or anything else!) outside the quotes of quoted fields are not allowed.
       
   No other variations are currently supported. *)

on csvToList(csvText, implementation)
	-- The 'implementation' parameter is a record with optional properties specifying the field separator character and/or trimming state. The defaults are: {separator:",", trimming:false}.
	set {separator:separator, trimming:trimming} to (implementation & {separator:",", trimming:false})
	
	script o -- For fast list access.
		property textBlocks : missing value -- For the double-quote-delimited text item(s) of the CSV text.
		property possibleFields : missing value -- For the separator-delimited text items of a non-quoted block.
		property subpossibilities : missing value -- For the paragraphs of any non-quoted field candidate actually covering multiple records. (Single-column CSVs only.)
		property fieldsOfCurrentRecord : {} -- For the fields of the CSV record currently being processed.
		property finalResult : {} -- For the final list-of-lists result.
	end script
	
	set astid to AppleScript's text item delimiters
	
	considering case
		set AppleScript's text item delimiters to quote
		set o's textBlocks to csvText's text items
		-- o's textBlocks is a list of the CSV text's text items after delimitation with the double-quote character.
		-- Assuming the convention described at top of this script, the number of blocks is always odd.
		-- Even-numbered blocks, if any, are the unquoted contents of quoted fields (or parts thereof) and don't need parsing.
		-- Odd-numbered blocks are everything else. Empty strings in odd-numbered slots (except at the beginning and end) are due to escaped double-quotes in quoted fields.
		
		set blockCount to (count o's textBlocks)
		set escapedQuoteFound to false
		-- Parse the odd-numbered blocks only.
		repeat with i from 1 to blockCount by 2
			set thisBlock to item i of o's textBlocks
			if (((count thisBlock) > 0) or (i is blockCount)) then
				-- Either this block is not "" or it's the last item in the list, so it's not due to an escaped double-quote. Add the quoted field just skipped (if any) to the field list for the current record.
				if (escapedQuoteFound) then
					-- The quoted field contained escaped double-quote(s) (now unescaped) and is spread over three or more blocks. Join the blocks, add the result to the current field list, and cancel the escapedQuoteFound flag.
					set AppleScript's text item delimiters to ""
					set end of o's fieldsOfCurrentRecord to (items quotedFieldStart thru (i - 1) of o's textBlocks) as text
					set escapedQuoteFound to false
				else if (i > 1) then -- (if this isn't the first block)
					-- The preceding even-numbered block is an entire quoted field. Add it to the current field list as is.
					set end of o's fieldsOfCurrentRecord to item (i - 1) of o's textBlocks
				end if
				
				-- Now parse the current block's separator-delimited text items, which are either complete non-quoted fields, stubs from the removal of quoted fields, or still-joined fields from adjacent records.
				set AppleScript's text item delimiters to separator
				set o's possibleFields to thisBlock's text items
				set possibleFieldCount to (count o's possibleFields)
				repeat with j from 1 to possibleFieldCount
					set thisPossibleField to item j of o's possibleFields
					set c to (count thisPossibleField each paragraph)
					if (c < 2) then
						-- This possible field doesn't contain a line break. If it's not the stub of a preceding or following quoted field, add it (trimmed if trimming) to the current field list.
						-- It's not a stub if it's an inner candidate from the block, the last candidate from the last block, the first candidate from the first block, or it contains non-white characters.
						if (((j > 1) and ((j < possibleFieldCount) or (i is blockCount))) or ((j is 1) and (i is 1)) or (notBlank(thisPossibleField))) then set end of o's fieldsOfCurrentRecord to trim(thisPossibleField, trimming)
					else if (c is 2) then -- Special-cased for efficiency.
						-- This possible field contains a line break, so it's really two possible fields from consecutive records. Split it.
						set subpossibility1 to paragraph 1 of thisPossibleField
						set subpossibility2 to paragraph 2 of thisPossibleField
						-- If the first subpossibility's not just the stub of a preceding quoted field, add it to the field list for the current record.
						if ((j > 1) or (i is 1) or (notBlank(subpossibility1))) then set end of o's fieldsOfCurrentRecord to trim(subpossibility1, trimming)
						-- Add the now-complete field list to the final result list and start one for a new record.
						set end of o's finalResult to o's fieldsOfCurrentRecord
						set o's fieldsOfCurrentRecord to {}
						-- If the second subpossibility's not the stub of a following quoted field, add it to the new list.
						if ((j < possibleFieldCount) or (notBlank(subpossibility2))) then set end of o's fieldsOfCurrentRecord to trim(subpossibility2, trimming)
					else
						-- This possible field contains more than one line break, so it's three or more possible fields from consecutive single-field records. Split it.
						set o's subpossibilities to thisPossibleField's paragraphs
						-- With each subpossibility except the last, complete the field list for the current record and initialise another. Omit the first subpossibility if it's just the stub of a preceding quoted field.
						repeat with k from 1 to c - 1
							set thisSubpossibility to item k of o's subpossibilities
							if ((k > 1) or (j > 1) or (i is 1) or (notBlank(thisSubpossibility))) then set end of o's fieldsOfCurrentRecord to trim(thisSubpossibility, trimming)
							set end of o's finalResult to o's fieldsOfCurrentRecord
							set o's fieldsOfCurrentRecord to {}
						end repeat
						-- With the last subpossibility, just add it to the new field list (if it's not the stub of a following quoted field).
						set thisSubpossibility to end of o's subpossibilities
						if ((j < possibleFieldCount) or (notBlank(thisSubpossibility))) then set end of o's fieldsOfCurrentRecord to trim(thisSubpossibility, trimming)
					end if
				end repeat
				
				-- Otherwise, the current block's an empty text item due to either an escaped double-quote in a quoted field or the opening quote of a quoted field at the very beginning of the CSV text.
			else if (escapedQuoteFound) then
				-- It's another escaped double-quote in a quoted field already flagged as containing one. Just replace the empty text with a literal double-quote.
				set item i of o's textBlocks to quote
			else if (i > 1) then -- (if this isn't the first block)
				-- It's the first escaped double-quote in a quoted field. Replace the empty text with a literal double-quote, note the index of the preceding even-numbered block (the first part of the field), and flag the find.
				set item i of o's textBlocks to quote
				set quotedFieldStart to i - 1
				set escapedQuoteFound to true
			end if
		end repeat
	end considering
	
	set AppleScript's text item delimiters to astid
	
	-- Add the remaining field list to the output if it's not empty or if the output list itself has remained empty.
	if ((o's fieldsOfCurrentRecord is not {}) or (o's finalResult is {})) then set end of o's finalResult to o's fieldsOfCurrentRecord
	
	return o's finalResult
end csvToList

-- Test whether or not a string contains any non-white characters.
on notBlank(txt)
	ignoring white space
		return (txt > "")
	end ignoring
end notBlank

-- Trim any leading or trailing spaces from a string.
on trim(txt, trimming)
	if (trimming) then
		set c to (count txt)
		repeat while ((txt begins with space) and (c > 1))
			set txt to text 2 thru -1 of txt
			set c to c - 1
		end repeat
		repeat while ((txt ends with space) and (c > 1))
			set txt to text 1 thru -2 of txt
			set c to c - 1
		end repeat
		if (txt is space) then set txt to ""
	end if
	
	return txt
end trim

(*

Changes-

v5.1 Added support for cue list 0, which if I recall correctly, is how Element consoles export their cue list
v5.0.11 Changed the version numbering just to annoy people, and made changes to allow for Qlab 5.0.9's added user options in their library definitions.
9/16/2023 - No change to code. No longer doing version numbers.
9/17/2023 - Added logic earlier on to validate whether or not the network cues are set up correctly. Added logic to see if a cue list already exists and use that same one if possible. Added memo cue for logging when cues were generated.

*)