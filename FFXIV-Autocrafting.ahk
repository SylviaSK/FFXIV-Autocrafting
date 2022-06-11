#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;=================
; Global Variables
;=================
DetectHiddenWindows, On ;allow it to send to FFXIV while minimized
global breakLoop := 0
;default values on launch, will be overwrote in Numpad3/4
global prevCommandStr := ""
global SendArray := ["=", "=", "-", "'"]
global SleepArray := [2000, 2000, 40500, 12000]
global numberOfLoops := 0
global startTime := 0

;=================
; Load Functions
;=================
SendAndSleep(Keys, Duration){
	;ControlSend,, %Keys%
	Send, %Keys%
	Sleep, %Duration%
}

; Runs the entire command detailed in SendArray and SleepArray, will break early if breakLoop is true
RunCommand(){
	Loop % SendArray.MaxIndex(){
		SendAndSleep(SendArray[A_Index], SleepArray[A_Index])
		if (breakLoop)
			break
	}
	return
}

StrToCommand(str)
{
	SendArray := []
	SleepArray := []
	tempStr := RegExReplace(str, " ", "")
	flag := true
	while % flag{
		firstCommaLocation := RegExMatch(tempStr, "`,",,2) ;find first instance of , excluding the first character
		if (firstCommaLocation == 0) ;error
			break
		secondCommaLocation := RegExMatch(tempStr, "`,",,firstCommaLocation+2)
		if (secondCommaLocation == 0) ; a valid end of input
		{
			flag := false
			secondCommaLocation := 999 ; to ensure we grab the rest of the characters
		}

		; grab the substrings and push onto the arrays
		commandStr := SubStr(tempStr,1, firstCommaLocation-1)
		sleepDelay := SubStr(tempStr, firstCommaLocation+1, secondCommaLocation-firstCommaLocation-1)
		SendArray.Push(commandStr)
		SleepArray.Push(sleepDelay)
		; trim string for new cycle
		tempStr := SubStr(tempStr, secondCommaLocation+1)
	}
	return
}

;=========
; Hotkeys
;=========

; Input number of times to run the macro
Numpad3::
	InputBox, numberOfLoops, Input Duration, Number of loops to run`n0 or less will loop indefinitely,,,150,,,,, %numberOfLoops%
return

; write your own loop very easily!
Numpad4::
	InputBox, prevCommandStr, Input Command, Seperated by commas i.e. =`,2000`,=`,2000`,-`,405000 `nSpaces do not affect it. `n(=`,2000 is equal to =`, 2000),,,150,,,,, %prevCommandStr%
	if !ErrorLevel{
		StrToCommand(prevCommandStr)
	}
	return
	
; Main sending loop, will cycle until Numpad6 is pressed
Numpad5::
	windowid = % WinExist("A") ; Grab the current active window's id, once this is done, controlSend will automatically use it as the id
	breakLoop := false
	if (numberOfLoops <= 0) {
		Loop{
			RunCommand()
			if (breakLoop)
				break
		}
	} else {
		Loop %numberOfLoops% {
			RunCommand()
			if (breakLoop)
				break
		}
	}
	return

; Break out of Numpad5's loop
Numpad6::
	breakLoop = true
	return

;Timing function
Numpad7::
	if (startTime != 0) {
		startTime -= %A_TickCount%
		Msgbox % "Time in ms " . Abs(startTime)
		startTime := 0
	}
	else {
		startTime := A_TickCount
	}
	return

; Reload the script
Numpad0::
	Reload
	Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
	IfMsgBox, Yes, Edit
	return

return
