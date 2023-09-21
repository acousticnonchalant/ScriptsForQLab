(* 

9/16/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Active Cue Level Adjust, Based on Cue's Output Routing
This script will change volume on all CURRENTLY PLAYING tracks if they are routed to the outputs defined below. Will only work in edit mode.
See below for user variables, such as whether or not you want to set an absolute level or a relative level, and what the level will be,
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

File Name: QLab 5 - Level Adjust - Specific Output

Written by Chase Elison 
chase@chaseelison.com

*)

set onlyWorkInEditMode to false

-- Change the value to true and change the absolute level if you wish to set the level to a defined level and not a relative level
set makeAbsoluteLevel to false
set absoluteLevel to 0

-- Change this level if you want to add/subtract from the current level
set relativeLevel to 1

-- Change the values in the following variable to reflect the output(s) of the cue you wish to adjust
set userSearchColumns to {1, 2}

tell application id "com.figure53.QLab.5" to tell front workspace
	if onlyWorkInEditMode then
		set doScript to edit mode
	else
		set doScript to true
	end if
	if doScript is true then
		set theSelection to active cues
		-- theSelection is the cues that are currently active
		repeat with eachCue in theSelection
			if q type of eachCue is in {"Audio", "Video", "Mic"} then
				-- If the current cue is an audio or video cue
				tell front workspace
					set matchesRouting to false
					-- Default answer is false.
					repeat with eachRow from 1 to audio input channels of eachCue
						--Check each row of the audio cue
						repeat with eachSearchColumn in userSearchColumns
							--Check each user defined column
							if (eachCue getLevel row eachRow column eachSearchColumn) is 0 and eachCue is running and percent pre wait elapsed of eachCue is 0 then
								--If the vaule of the row and column tested is 0, and the cue is running (not paused), and the cue is not pre-waiting, then the current cue is a match.
								set matchesRouting to true
							end if
							--display dialog "GetLevel " & eachRow & " " & userSearchColumn & " " & q display name of eachCue & (eachCue getLevel row eachRow column userSearchColumn)
						end repeat
					end repeat
					--display dialog "cue " & q display name of eachCue & " matches? " & matchesRouting
					if matchesRouting is true then
						--Cue has been determined to be a match
						if makeAbsoluteLevel is true then
							--If the user wants to set the level to an absolute level, then do so!
							eachCue setLevel row 0 column 0 db absoluteLevel
						else
							--If the user does not want an absolute level, then add the definied relative level to current level
							set currentLevel to eachCue getLevel row 0 column 0
							set newLevel to currentLevel + relativeLevel
							eachCue setLevel row 0 column 0 db newLevel
						end if
					end if
				end tell
			end if
		end repeat
	end if
end tell

(*

Changes-

9/16/2023 - No change, just verified working

*)
