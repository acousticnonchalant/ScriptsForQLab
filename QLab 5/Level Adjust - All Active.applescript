(* 

9/16/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Active Cue Level Adjust
This script will change volume on all CURRENTLY PLAYING tracks. Will only work in edit mode.
See below for user variables, such as whether or not you want to set an absolute level or a relative level, what the level will be, and whether to check if in edit mode.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

File Name: QLab 5 - Level Adjust - All Active

Written by Chase Elison 
chase@chaseelison.com

*)


set onlyWorkInEditMode to false

-- Change the value to true and change the absolute level if you wish to set the level to a defined level and not a relative level
set makeAbsoluteLevel to false
set absoluteLevel to 0

-- Change this level if you want to add/subtract from the current level
set relativeLevel to 1

tell application id "com.figure53.QLab.5" to tell front workspace
	if onlyWorkInEditMode then
		set doScript to edit mode
	else
		set doScript to true
	end if
	if doScript is true then
		set theSelection to active cues
		repeat with eachCue in theSelection
			if q type of eachCue is in {"Audio", "Video", "Mic"} and eachCue is running and percent pre wait elapsed of eachCue is 0 then
				--If the cue is an audio or video cue, and the cue is running (not paused), and the cue is not pre-waiting, then the current cue is a match.
				tell front workspace
					if makeAbsoluteLevel is true then
						--If the user wants to set the level to an absolute level, then do so!
						eachCue setLevel row 0 column 0 db absoluteLevel
					else
						--If the user does not want an absolute level, then add the definied relative level to current level
						set currentLevel to eachCue getLevel row 0 column 0
						set newLevel to currentLevel + relativeLevel
						eachCue setLevel row 0 column 0 db newLevel
					end if
				end tell
			end if
		end repeat
	end if
end tell

(*

Changes-
9/16/23 - No change, just verified working

*)
