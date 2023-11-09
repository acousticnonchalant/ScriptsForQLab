(* 

11/9/2023
Tested with QLab v5.3 on macOS Ventura 13.6.1

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Make Slideshow
This script will make a slideshow out of images using QLab 5's new Playlist group. Useful for a pre-show slideshow. See below for a fade time variable and a slide duration, which you can set if you want to bypass the dialog.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

File Name: QLab 5 - Make Image Slideshow

Written by Chase Elison 
chase@chaseelison.com

*)

--Set the variable to 0 if you want the dialog to appear:
set userFadeDuration to 0
set userSlideDuration to 0

set copyColorFromOriginalCue to true

--The following will be ignored if you are copying color from original cue:
set qlabFirstColor to "" -- Leave as "" if you want no color
set qlabUseSecondColor to false
set qlabSecondColor to "" -- Leave as "" if you want no color

tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	if userFadeDuration is less than or equal to 0 then
		display dialog "Set fade duration to:" default answer "3" with title "Make Slideshow" with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
		set userFadeDuration to text returned of result
	end if
	if userSlideDuration is less than or equal to 0 then
		display dialog "Set slide duration to:" default answer "15" with title "Make Slideshow" with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
		set userSlideDuration to text returned of result
	end if
	set theSelection to selected
	set endSelection to item 1 of theSelection
	
	--This is one place the script differs from the usual "Fade in and out"
	set selected to cue id (uniqueID of endSelection) of (parent of endSelection)
	make type "Group"
	set playlistGroupCue to last item of (selected as list)
	set q number of playlistGroupCue to ""
	set q name of playlistGroupCue to "Slideshow"
	set mode of playlistGroupCue to playlist
	set playlist loop of playlistGroupCue to true
	set playlist shuffle of playlistGroupCue to false
	set playlist crossfade of playlistGroupCue to false
	
	repeat with eachCue in theSelection
		if q type of eachCue is in {"Audio", "Mic", "Video", "Camera", "Text"} then
			try
				set originalLevel to eachCue getLevel row 0 column 0
				eachCue setLevel row 0 column 0 db -120
			end try
			
			make type "Fade"
			set fadeInCue to last item of (selected as list)
			
			set cue target of fadeInCue to eachCue
			set duration of fadeInCue to userFadeDuration
			set stop target when done of fadeInCue to false
			set fade mode of fadeInCue to absolute
			try
				fadeInCue setLevel row 0 column 0 db originalLevel
			end try
			set q name of fadeInCue to "FADE IN - " & q display name of eachCue
			
			set originalNumber to q number of eachCue
			
			make type "Group"
			set groupCue to last item of (selected as list)
			
			set continue mode of groupCue to continue mode of eachCue
			set continue mode of eachCue to do_not_continue
			set q name of groupCue to q display name of eachCue
			set mode of groupCue to timeline
			
			make type "Fade"
			set fadeOutCue to last item of (selected as list)
			
			set cue target of fadeOutCue to eachCue
			set duration of fadeOutCue to userFadeDuration
			set stop target when done of fadeOutCue to true
			set fade mode of fadeOutCue to absolute
			try
				fadeOutCue setLevel row 0 column 0 db -120
			end try
			set q name of fadeOutCue to "FADE OUT - " & q display name of eachCue
			set pre wait of fadeOutCue to userSlideDuration
			
			if q type of eachCue is in {"Video", "Camera", "Text"} then
				set originalOpacity to opacity of eachCue
				set opacity of eachCue to 0
				if originalOpacity is 0 then
					set opacity of fadeInCue to 100
				else
					set opacity of fadeInCue to originalOpacity
				end if
				set do opacity of fadeInCue to 1
				set opacity of fadeOutCue to 0
				set do opacity of fadeOutCue to 1
			end if
			
			--This part is choreographed. Allow me to explain:
			--First, move the group cue after the original cue:
			tell parent of groupCue
				move cue id (uniqueID of groupCue) to after cue id (uniqueID of eachCue)
			end tell
			--Then, move the original cue into the group
			move cue id (uniqueID of eachCue) of (parent of eachCue) to end of groupCue
			--And the fade in cue
			move cue id (uniqueID of fadeInCue) of (parent of fadeInCue) to end of groupCue
			--Then move the fade out cue after the group cue!
			tell parent of fadeOutCue
				move cue id (uniqueID of fadeOutCue) to after cue id (uniqueID of groupCue)
			end tell
			--Now lets move all that shiz into the new playlist
			move cue id (uniqueID of groupCue) of (parent of groupCue) to end of playlistGroupCue
			move cue id (uniqueID of fadeOutCue) of (parent of fadeOutCue) to end of playlistGroupCue
			
			set q number of eachCue to ""
			set q number of fadeInCue to ""
			set q number of fadeOutCue to ""
			set q number of groupCue to ""
			
			--Color shenanigans:
			set originalFirstColor to q color of eachCue
			set originalUseSecondColor to use q color 2 of eachCue
			set originalSecondColor to q color 2 of eachCue
			
			try
				if copyColorFromOriginalCue then
					--In...
					set q color of fadeInCue to originalFirstColor
					set use q color 2 of fadeInCue to originalUseSecondColor
					set q color 2 of fadeInCue to originalSecondColor
					--Out...
					set q color of fadeOutCue to originalFirstColor
					set use q color 2 of fadeOutCue to originalUseSecondColor
					set q color 2 of fadeOutCue to originalSecondColor
					--Group...
					set q color of groupCue to originalFirstColor
					set use q color 2 of groupCue to originalUseSecondColor
					set q color 2 of groupCue to originalSecondColor
				else
					if qlabFirstColor is not "" then
						--In...
						set q color of fadeInCue to qlabFirstColor
						--Out...
						set q color of fadeOutCue to qlabFirstColor
						--Group...
						set q color of groupCue to qlabFirstColor
						if qlabUseSecondColor then
							--In...
							set use q color 2 of fadeInCue to true
							set q color 2 of fadeInCue to qlabSecondColor
							--Out...
							set use q color 2 of fadeOutCue to true
							set q color 2 of fadeOutCue to qlabSecondColor
							--Group...
							set use q color 2 of groupCue to true
							set q color 2 of groupCue to qlabSecondColor
						end if
					end if
				end if
			end try
		end if
	end repeat
	--The following stupid persnickity statement will select the first selected cue before the script started.
	--set selected to cue id (uniqueID of endSelection) of (parent of endSelection)
end tell
