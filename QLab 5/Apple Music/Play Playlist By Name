(* 

9/21/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Apple Music (fka iTunes) Play Specific Playlist by Name
Finds a playlist with a specific name in your library and plays it. Works with owned music and streamed music.
Change the variables below to indicate the name of the playlist you want to play, volume, EQ, shuffle and repeat settings.

File Name: QLab 5 - Apple Music - Play Playlist By Name

Written by Chase Elison 
chase@chaseelison.com

*)

set playlistName to "My Top Rated"
set volumePercent to 99
set EnableEQ to false
set shufflePlaylist to true
set repeatPlaylist to true

tell application id "com.apple.Music"
	activate
	set allPlaylists to (get every playlist)
	repeat with eachPlaylist in allPlaylists
		if name of eachPlaylist as text is playlistName then
			play eachPlaylist
			delay 0.5
			set the view of the front browser window to eachPlaylist
			exit repeat
		end if
	end repeat
	set sound volume to volumePercent
	set EQ enabled to EnableEQ
	set shuffle enabled to shufflePlaylist
	if repeatPlaylist is true then
		set song repeat to all
	else
		set song repeat to off
	end if
end tell
