(* 

11/8/2023
Tested with QLab v5.3 on macOS Ventura 13.6.1

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Make Fade In for Selected Cues
This script will fade in a selection of cues and then select the first of them once completed. It will prompt the user to input a duration.
See below for a fade time variable which you can set if you want to bypass the dialog.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

File Name: QLab 5 - Make Fade In From Selected Cues

Written by Chase Elison 
chase@chaseelison.com

*)

--Set the variable to 0 if you want the dialog to appear:
set userFadeDuration to 0

set copyColorFromOriginalCue to true

--The following will be ignored if you are copying color from original cue:
set qlabFirstColor to "" -- Leave as "" if you want no color
set qlabUseSecondColor to false
set qlabSecondColor to "" -- Leave as "" if you want no color

tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	if userFadeDuration ≤ 0 then
		display dialog "Set fade duration to:" default answer "5" with title "Make Fade In" with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
		set userFadeDuration to text returned of result
	end if
	set theSelection to selected
	set endSelection to item 1 of theSelection
	repeat with eachCue in theSelection
		--try
		if q type of eachCue is in {"Audio", "Mic", "Video", "Camera", "Text"} then
			set sourceLevel to eachCue getLevel row 0 column 0
			eachCue setLevel row 0 column 0 db -120
			make type "Fade"
			set fadeCue to last item of (selected as list)
			set q number of fadeCue to ""
			set cue target of fadeCue to eachCue
			set duration of fadeCue to userFadeDuration
			set stop target when done of fadeCue to false
			set fade mode of fadeCue to absolute
			fadeCue setLevel row 0 column 0 db sourceLevel
			if q type of eachCue is in {"Video", "Camera", "Text"} then
				set sourceOpacity to opacity of eachCue
				set opacity of eachCue to 0
				if sourceOpacity is 0 then
					set opacity of fadeCue to 100
				else
					set opacity of fadeCue to sourceOpacity
				end if
				set do opacity of fadeCue to true
			end if
			set q name of fadeCue to "FADE IN - " & q display name of eachCue
			--Now lets group it, if it isn't already
			if q type of parent of eachCue is "Group" then
				if mode of parent of eachCue is not in {timeline} then
					set continue mode of eachCue to auto_continue
				else
					set pre wait of fadeCue to pre wait of eachCue
				end if
				tell parent of fadeCue
					move cue id (uniqueID of fadeCue) to after cue id (uniqueID of eachCue)
				end tell
			else
				--If cue wasn't in a group, then group it and the fade cue together.
				make type "Group"
				set groupCue to last item of (selected as list)
				tell parent of groupCue
					move cue id (uniqueID of groupCue) to after cue id (uniqueID of eachCue)
				end tell
				set q name of groupCue to q display name of eachCue
				set sourceNumber to q number of eachCue
				set q number of eachCue to ""
				set q number of groupCue to sourceNumber
				set mode of groupCue to timeline
				--Copy the pre-wait from original cue and remove pre-wait from cue in group
				set pre wait of groupCue to pre wait of eachCue
				set pre wait of eachCue to 0
				if (uniqueID of eachCue) is (uniqueID of item 1 of theSelection) then
					set endSelection to groupCue
				end if
				move cue id (uniqueID of eachCue) of (parent of eachCue) to end of groupCue
				move cue id (uniqueID of fadeCue) of (parent of fadeCue) to end of groupCue
				
			end if
			--Color shenanigans:
			set originalFirstColor to q color of eachCue
			set originalUseSecondColor to use q color 2 of eachCue
			set originalSecondColor to q color 2 of eachCue
			
			try
				if copyColorFromOriginalCue then
					--Fade...
					set q color of fadeCue to originalFirstColor
					set use q color 2 of fadeCue to originalUseSecondColor
					set q color 2 of fadeCue to originalSecondColor
					--Group...
					if q type of parent of eachCue is not "Group" then
						set q color of groupCue to originalFirstColor
						set use q color 2 of groupCue to originalUseSecondColor
						set q color 2 of groupCue to originalSecondColor
					end if
				else
					if qlabFirstColor is not "" then
						--Fade...
						set q color of fadeCue to qlabFirstColor
						--Group...
						if q type of parent of eachCue is not "Group" then
							set q color of groupCue to qlabFirstColor
						end if
						if qlabUseSecondColor then
							--Fade...
							set use q color 2 of fadeCue to true
							set q color 2 of fadeCue to qlabSecondColor
							--Group...
							if q type of parent of eachCue is not "Group" then
								set use q color 2 of groupCue to true
								set q color 2 of groupCue to qlabSecondColor
							end if
						end if
					end if
				end if
			end try
		end if
		--end try
	end repeat
	--The following stupid persnickity statement will select the first selected cue before the script started.
	set selected to cue id (uniqueID of endSelection) of (parent of endSelection)
end tell

(*

Changes-

10/14/2023 - If the original cue's opacity is 0, the script will assume you want it to fade up to 100%. I found that if I copied a cue that had already faded in, it already had a value of 0 and running the script again would fade the opacity to 0 because that was the original value and found that rather annoying.
11/8/2023 - Added variables to set a color for new cues at the top of the script.

*)
