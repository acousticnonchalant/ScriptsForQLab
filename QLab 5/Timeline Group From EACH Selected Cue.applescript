(*

5/7/2025
Tested with QLab v5.4.8 on macOS Sonoma 14.7.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Timeline Group From EACH Selected Cue
This script will make a timeline group for EACH item you have selected. It will pull the number and color from the cue it is grouping.

File Name: QLab 5 - Timeline Group From EACH Selected Cue

Written by Chase Elison
chase@chaseelison.com

*)

tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	set theSelection to selected
	--Following line added 5/7/2025 because otherwise the script groups all the cues ruining the continue mode.
	set selected to item 1 of theSelection
	repeat with eachCue in theSelection
		set continueMode to continue mode of eachCue
		make type "Group"
		set groupCue to last item of (selected as list)
		set mode of groupCue to timeline
		set continue mode of groupCue to continueMode
		set q name of groupCue to q display name of eachCue
		set newNumber to q number of eachCue
		set q number of eachCue to ""
		set q number of groupCue to newNumber
		set q color of groupCue to q color of eachCue
		move cue id (uniqueID of eachCue) of (parent of eachCue) to end of groupCue
	end repeat
end tell

(*

Changes-
5/7/2025 - Changed the order of operations because the script would inadvertently wipe out all cues' continue mode before.

*)
