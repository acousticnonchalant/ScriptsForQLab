(* 

9/12/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Timeline Group from Selected Cues
This script will make a timeline group out of selected cues and copy the name, number and color from the first cue in the list.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

Written by Chase Elison 
chase@chaseelison.com

*)

set copyFirstCueNotesToGroup to false -- Whether or not to copy the cue notes from the first cue to the group cue
set copyContinueModeToGroup to false -- Whether or not to use the same continue mode the first cue had

tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	set theSelection to selected
	--The following is omitted so it will create a group even with just one selected. Useful sometimes!
	--if (count of theSelection) is less than 2 then return
	set firstCue to item 1 of theSelection
	make type "Group"
	set groupCue to last item of (selected as list)
	set mode of groupCue to timeline
	if copyContinueModeToGroup then
		set continue mode of groupCue to continue mode of firstCue
	else
		set continue mode of groupCue to do_not_continue
	end if
	set q name of groupCue to q display name of firstCue
	if copyFirstCueNotesToGroup then
		set notes of groupCue to notes of firstCue
	end if
	set newNumber to q number of firstCue
	set q number of firstCue to ""
	set q number of groupCue to newNumber
	set q color of groupCue to q color of firstCue
	repeat with eachCue in theSelection
		move cue id (uniqueID of eachCue) of (parent of eachCue) to end of groupCue
	end repeat
end tell

(*

Changes-
9/12/23 - Added option to copy notes from the first cue to the group cue
9/12/23 - Added option to copy the continue mode from the first cue to the group cue

*)