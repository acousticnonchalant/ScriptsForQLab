(*

9/28/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2 on a Yamaha QL5 with software v5.81

THIS SCRIPT IS VERY MUCH A WORK IN PROGRESS! Use at your own risk.

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

Yamaha QL1/5 MIDI SysEx Cue Generator
This script will generate a SysEx message to send to a Yamaha QL5 that you can put into QLab.
SysEx is nice, because unlike Control Change messages, it is directly telling the board what to do. With Control Change messages, you have to go into MIDI settings on the board and tell it what to do when it sends a certain message. The SysEx message basically says "Yamaha QL console, please do this very specific thing" so there is not an additional layer of translation to worry about.

File Name: QLab 5 - Yamaha QL - SysEx Message Generator

Written by Chase Elison 
chase@chaseelison.com

*)

set yamahaMidiChannel to 1 --second hex value, 1N where N is your channel number
set yamahaMixerIdentifier to "3E 19" --third and fourth hex value, no end space

set qlabCuePatch to 1

set faderLevels to {"-inf", "-30", "-28", "-25", "-24", "-22", "-20", "-18", "-16", "-15", "-12", "-10", "-5", "0", "+5", "+10"}
set faderValues to {"00 00", "02 43", "02 57", "02 75", "02 7F", "03 13", "03 27", "03 4F", "03 77", "04 0B", "04 47", "04 6F", "05 53", "06 37", "07 1B", "07 7F"}

tell application id "com.figure53.QLab.5" to tell front workspace
	set yamahaCommands to {"Channel Fader Move", "Stereo Fader Move", "Channel On/Off", "Stereo On/Off"}
	set yamahaCommand to choose from list yamahaCommands with prompt "Select command:" default items {"Channel Fader Move"}
	set yamahaCommand to yamahaCommand as text
	
	if yamahaCommand contains "Channel" then
		display dialog "Channel?" with icon 1 default answer "1"
		set yamahaChannel to text returned of result as integer
		if yamahaChannel is less than 1 or yamahaChannel is greater than 64 then return
	else if yamahaCommand contains "Stereo" then
		display dialog "Stereo #?" with icon 1 default answer "1"
		set yamahaStereo to text returned of result as integer
		if yamahaStereo is less than 1 or yamahaStereo is greater than 8 then return
		set yamahaChannel to 71 + (yamahaStereo * 2) --seems like stereos start at 73
	end if
	
	if yamahaCommand is in {"Channel Fader Move", "Stereo Fader Move"} then
		-- 00 37 is fader move
		set yamahaElementHex to "00 37" -- no end space
		--no index
		set yamahaIndexHex to "00 00" -- no end space
		set yamahaValue to choose from list faderLevels with prompt "Fader Level:" default items {(item 1 of faderLevels)}
		set listIndex to 0
		repeat with i from 1 to the count of faderLevels
			if item i of faderLevels is yamahaValue as text then
				set listIndex to i
			end if
		end repeat
		if listIndex is 0 then return
		set yamahaValueHex to item listIndex of faderValues
		set qlabCommandLabel to "Channel " & yamahaChannel & " Fader to " & yamahaValue as text
	else if yamahaCommand is in {"Channel On/Off", "Stereo On/Off"} then
		-- 00 35 is on/off
		set yamahaElementHex to "00 35" -- no end space
		--no index
		set yamahaIndexHex to "00 00" -- no end space
		set yamahaOnOff to display dialog "On or Off?" with icon 1 buttons {"Cancel", "On", "Off"} default button "On"
		if button returned of yamahaOnOff is "On" then
			set yamahaValueHex to "00 01"
		else if button returned of yamahaOnOff is "Off" then
			set yamahaValueHex to "00 00"
		end if
		set qlabCommandLabel to "Channel " & yamahaChannel & " " & button returned of yamahaOnOff
	end if
	--display dialog "Fader value between 0 and 1919 (1591 = 0)" with icon 1 default answer "1591"
	--set yamahaValue to text returned of result as integer
end tell


--set valueCount to 1
--repeat until valueCount > (count of faderLevels)
--set yamahaValue to item valueCount of faderValues

--Parse QLab input data
set yamahaChannelHex to getHighLowHex(yamahaChannel - 1) -- Ch 64 = id 63... etc

--Generate the message
set qlabSysexMessage to "43 "
set qlabSysexMessage to qlabSysexMessage & "1" & getSingleHex(yamahaMidiChannel - 1) & " "
set qlabSysexMessage to qlabSysexMessage & yamahaMixerIdentifier & " 01  "
set qlabSysexMessage to qlabSysexMessage & yamahaElementHex & "  "
set qlabSysexMessage to qlabSysexMessage & yamahaIndexHex & "  "
set qlabSysexMessage to qlabSysexMessage & yamahaChannelHex & "  "
--idk what this is, but it seems to want "00 00 00" here:
set qlabSysexMessage to qlabSysexMessage & "00 00 00  "
set qlabSysexMessage to qlabSysexMessage & yamahaValueHex

tell application id "com.figure53.QLab.5" to tell front workspace
	make type "MIDI"
	set qlabNewCue to last item of (selected as list)
	set message type of qlabNewCue to sysex
	set midi patch number of qlabNewCue to qlabCuePatch
	set sysex message of qlabNewCue to qlabSysexMessage
	set q name of qlabNewCue to "Yamaha QL " & qlabCommandLabel
	set q number of qlabNewCue to ""
end tell
--	set valueCount to valueCount + 1
--end repeat

(* F0 start and F7 end are implied by QLab

Channel 1 mix 13 off
43 10 3E 19 01 00 49 00 27 00 00 00 00 00 00 00
43 Yamaha
10 0=MIDI Channel Number - 1
3E Digital Mixer
19 QL series
01 Parameter Change
00 Element L
49 Element H (0049=Send)
00 Index L
27 Index H (0027=Mix 13 On/Off)
00 Channel L
00 Channel H - 1 (0000 = Channel 1)
00 ??
00 ??
00 ?? i don't know what these 3 do. It seems to want 3 sets of "00" here.
00 Value L
00 Value H (0000 = Off, 0001 = on)

Channel 3 mix 13 on
43 10 3E 19 01 00 49 00 27 00 02 00 00 00 00 01

Channel 3 mix 14 on
43 10 3E 19 01 00 49 00 2A 00 02 00 00 00 00 01

Channel 2 mix 13 off
43 10 3E 19 01 00 49 00 27 00 01 00 00 00 00 00

Channel 64 mix 13 off
43 10 3E 19 01 00 49 00 27 00 3F 00 00 00 00 00

Channel 1 mix 1 off
43 10 3E 19 01 00 49 00 03 00 00 00 00 00 00 00

Channel 1 mix 2 off
43 10 3E 19 01 00 49 00 06 00 00 00 00 00 00 00

Channel 1 fader @ -inf
43 10 3e 19 01 00 37 00 00 00 00 00 00 00 00 00

Channel 2 Fader @ -inf
43 10 3E 19 01 00 37 00 00 00 01 00 00 00 00 00
43 Yamaha
10 0=MIDI Channel Number - 1
3E Digital Mixer
19 QL series
01 Parameter Change
00 Element L
37 Element H (0037=Fader)
00 Index L
00 Index H (0000 seems to be what is needed here)
00 Channel L
01 Channel H - 1 (0001 = Channel 2)
00 ??
00 ??
00 ?? i don't know what these 3 do. It seems to want 3 sets of "00" here.
00 Value L
00 Value H (0000 = -inf, 07F7 = +10db, 0637 = 0db)

FADER MAX 1919 07 7F
FADER 0DB 1591 06 37
*)

on getHex(inputValue as integer)
	set hexCharacters to "0123456789ABCDEF"
	set hexByte1 to (inputValue - (inputValue mod 16)) / 16 as integer
	set hexByte2 to inputValue mod 16 as integer
	return (character (hexByte1 + 1) of hexCharacters) & (character (hexByte2 + 1) of hexCharacters)
end getHex

on getSingleHex(inputValue as integer)
	set hexCharacters to "0123456789ABCDEF"
	set hexByte to inputValue
	return (character (hexByte + 1) of hexCharacters)
end getSingleHex

on getHighLowHex(inputValue as integer)
	set hexHigh to (inputValue - (inputValue mod 256)) / 256 as integer
	set hexLow to inputValue mod 256 as integer
	return getHex(hexHigh) & " " & getHex(hexLow)
end getHighLowHex
