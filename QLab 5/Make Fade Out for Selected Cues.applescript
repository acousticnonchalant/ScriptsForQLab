(* 

9/16/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Make Fade Out for Selected Cues
This script will make a fade out cue for a selection of cues and then select the first of them once completed. It will prompt the user to input a duration.
See below for a fade time variable which you can set if you want to bypass the dialog.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

File Name: QLab 5 - Make Fade Out From Selected Cues

Written by Chase Elison 
chase@chaseelison.com

*)

--Set the variable to 0 if you want the dialog to appear:
set userFadeDuration to 0

tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	if userFadeDuration ≤ 0 then
		display dialog "Set fade duration to:" default answer "5" with title "Make Fade Out" with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
		set userFadeDuration to text returned of result
	end if
	set theSelection to selected
	repeat with eachCue in theSelection
		try
			if q type of eachCue is in {"Group", "Audio", "Mic", "Fade", "Video", "Camera", "Text"} then
				make type "Fade"
				set fadeCue to last item of (selected as list)
				
				if q type of eachCue is "Fade" then
					set targetCue to cue target of eachCue
				else
					set targetCue to eachCue
				end if
				set cue target of fadeCue to targetCue
				
				if q type of targetCue is "Group" then
					set fade mode of fadeCue to relative
				else
					set fade mode of fadeCue to absolute
				end if
				
				fadeCue setLevel row 0 column 0 db -120
				set duration of fadeCue to userFadeDuration
				set stop target when done of fadeCue to true
				if q type of targetCue is in {"Video", "Camera", "Text"} then
					set doOpacity to true
				else if q type of targetCue is "Group" then
					set doOpacity to false
					repeat with groupCueChild in cues of eachCue as list
						if q type of groupCueChild is in {"Video", "Camera", "Text"} then
							set doOpacity to true
						end if
					end repeat
				else
					set doOpacity to false
				end if
				if doOpacity then
					set opacity of fadeCue to 0
					set do opacity of fadeCue to true
				end if
				set q number of fadeCue to ""
				set q name of fadeCue to "FADE OUT - " & q display name of targetCue
				--This freaking statement is impossibly persnickity. Do not mess it up:
				tell parent of eachCue
					move cue id (uniqueID of fadeCue) to after cue id (uniqueID of eachCue)
				end tell
			end if
		end try
	end repeat
	--The following stupid persnickity statement will select the first selected cue before the script started.
	set selected to cue id (uniqueID of item 1 of theSelection) of (parent of item 1 of theSelection)
end tell
