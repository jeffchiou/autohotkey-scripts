;*****************************************************************************
; Jeffrey Chiou's Semi-Anonymized Script for Surface
;*****************************************************************************
#SingleInstance Force
#NoEnv

;=============================================================================
; Global Variables
;=============================================================================
EnvGet, DROPBOX, DROPBOX

;=============================================================================
; Simple Hotkeys
;=============================================================================
~^+;::SendInput, ^z
~^+q::SendInput, ^x
~^+j::SendInput, ^c
~^+k::SendInput, ^v
^#Down::SendInput, {PgDn}
^#Up::SendInput, {PgUp}

;=============================================================================
; AppsKey Hotkeys
;=============================================================================
; Keep AppsKey working (mostly) normally.
AppsKey::Send {AppsKey}
AppsKey & Down::SendInput, {PgDn}
Appskey & Up::SendInput, {PgUp}

AppsKey & Left::
if GetKeyState("Shift")
	SendInput, +{Home}
else
	SendInput, {Home}
return

AppsKey & Right::
if GetKeyState("Shift")
	SendInput, +{End}
else
	SendInput, {End}
return

AppsKey & t::SendInput, ^t
AppsKey & w::SendInput, ^w

AppsKey & m::
DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UIntP, CurrMouseSpeed, UInt, 0)
if (CurrMouseSpeed>10){
	DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 9, UInt, 0)
	Mode = Slow
}
else {
	DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 13, UInt, 0) 
	Mode = Fast
}
DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UIntP, NewMouseSpeed, UInt, 0)
ToolTip, Mouse Speed Changed.`nMode: %Mode%`nSpeed: %NewMouseSpeed%
SetTimer, RemoveToolTip, 1000
return

;=============================================================================
; Other Hotkeys
;=============================================================================
; Reserved Ctrl+Win Hotkeys:
; 	Ctrl+Win+D			New Virtual Desktop
; 	Ctrl+Win+f4			Close Virtual Desktop
; 	Ctrl+Win+Left/Right	Switch Virtual Desktops

^#1::
path = %DROPBOX%
openOrSwitchToFolder(path)
return

^#2::
fileNameAndPath = %A_MyDocuments%\MATLABFOLDER1\helpTemplateSimple.m
insertTextFromFile(fileNameAndPath) 
return

^#3::
fileNameAndPath = %A_MyDocuments%\MATLABFOLDER1\helpTemplate.m
insertTextFromFile(fileNameAndPath) 
return

^#4::
fileNameAndPath = %A_MyDocuments%\MATLABFOLDER1\parseParametersTemplate.m
insertTextFromFile(fileNameAndPath) 
return

^#0::
SendInput {LWin Down}{p}
Sleep, 300
SendInput {p}
Sleep, 100
SendInput {p}
Sleep, 100
SendInput {LWin Up}
Sleep, 100
SendInput {Enter}
return

^#a::
Run %A_MyDocuments%\AHKFOLDER1
IfWinNotExist, SciTE4AutoHotkey
	Run C:\Program Files\AutoHotkey\SciTE\SciTE.exe
else WinActivate, SciTE4AutoHotkey
return

^#p::
^#c::
Run %DROPBOX%\YOURFOLDER1
WinWait, YOURFOLDER1_NAME
SendInput, {LWin Down}{Left}
Sleep, 50
SendInput, {Up}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
Run %A_MyDocuments%\MATLABFOLDER1
WinWait, MATLABFOLDER1_NAME
SendInput, {LWin Down}{Right}
Sleep, 50
SendInput, {Up}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
Run %DROPBOX%\YOURFOLDER2
WinWait, YOURFOLDER2_NAME
SendInput, {LWin Down}{Left}
Sleep, 50
SendInput, {Down}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
Run %A_MyDocuments%\YOURFOLDER3
WinWait, YOURFOLDER3_NAME
SendInput, {LWin Down}{Right}
Sleep, 50
SendInput, {Down}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
Run YOURFOLDER4
WinWait, YOURFOLDER4_NAME
ResizeAndCenter(800, 600)
return

^#f::
path = %DROPBOX%\YOURFOLDER5
openOrSwitchToFolder(path)
return

^#n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

; Pen Eraser Single Click
#F20::^z
; Pen Eraser Double Click
#F19::
if WinActive("ahk_exe ONENOTE.exe")
{
	WinGetPos, onX, onY, onWidth, onHeight, A
	SendInput, {F11}
	Sleep, 550
	SendInput, !2
	Sleep, 550
	clickX := onWidth-282
	Click, %clickX%, 40
	Sleep, 550
	Click, 200, 170
	MouseMove, 100, 390, 10

}
return
; Pen Eraser Hold Click
#F18::
if WinActive("ahk_exe ONENOTE.exe")
{
	SendInput, {Alt Down}
	Sleep, 50
	SendInput, {N}
	Sleep, 50
	SendInput, {Alt Up}
	Sleep, 100
	SendInput, {R}
	WinWait, ahk_exe ONENOTEM.exe
	WinWaitClose, ahk_exe ONENOTEM.exe
	Sleep, 500
	SendInput, ^a
	Sleep, 100
	SendInput, {Backspace}
	Sleep, 100
	SendInput, ^a
	Sleep, 100
	SendInput, {Backspace}
	Sleep, 100
	SendInput, ^a
	Sleep, 100
	SendInput, {Backspace}
}
else {
	SendInput, {PrintScreen}
}
return
;=============================================================================
; General Functions
;=============================================================================
openOrSwitchToFolder(path) {
	;ahk_class #32770 is the class for the Open and Save Dialog Boxes
	if WinActive("ahk_class #32770")
	{
		SendInput, ^l
		SendInput, %path%
		SendInput, {Enter}		
	}
	else
		Run, %path%
}

insertTextFromFile(fileNameAndPath) {
	#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
	SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	lineno = 1 ; Sets line number variable "lineno" to 1, so script starts at first line of the chosen file.
	
	Loop ; start reading loop.
	{   
		FileReadLine, line, %fileNameAndPath%, %lineno% ; Read the chosen file, the specified line, and place result into variable "line".
		if ErrorLevel = 1 ; If there's no line to read, the end of the file has been reached, or some other problem, exit the loop.
		   break
		SendInput %line%`n ; Sends line to current active window or field.
		Sleep, 100 ; Add pause. If left out, script seems to send two, three or even four lines at once?
		lineno++ ; Increment the line number to read variable by 1, so the script reads the next line in the next pass of the loop.   
	}
	
	ToolTip, The end of the file has been reached or there was a problem. ; If the script gets here, then there were no more lines to read (end of file?).
	SetTimer, RemoveToolTip, 5000
}

RemoveToolTip: ; Start of code to turn off the ToolTip.
	SetTimer, RemoveToolTip, Off ; Set timer off
	ToolTip ; ToolTip with no parameters removes the currently displayed ToolTip
return ; Back to script once ToolTip has been removed.

;=============================================================================
; Window Manipulation Functions
;=============================================================================
; Gets the edge that the taskbar is docked to.  Returns:
;   "top"
;   "right"
;   "bottom"
;   "left"
GetTaskbarEdge() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,

  if (TW = A_ScreenWidth) { ; Vertical Taskbar
    if (TY = 0) {
      return "top"
    } else {
      return "bottom"
    }
  } else { ; Horizontal Taskbar
    if (TX = 0) {
      return "left"
    } else {
      return "right"
    }
  }
}

GetScreenTop() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top") {
    return TH
  } else {
    return 0
  }
}

GetScreenLeft() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "left") {
    return TW
  } else {
    return 0
  }
}

GetScreenWidth() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top" or TaskbarEdge = "bottom") {
    return A_ScreenWidth
  } else {
    return A_ScreenWidth - TW
  }
}

GetScreenHeight() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top" or TaskbarEdge = "bottom") {
    return A_ScreenHeight - TH
  } else {
    return A_ScreenHeight
  }
}

ResizeAndCenter(w, h)
{
  ScreenX := GetScreenLeft()
  ScreenY := GetScreenTop()
  ScreenWidth := GetScreenWidth()
  ScreenHeight := GetScreenHeight()

  WinMove A,,ScreenX + (ScreenWidth/2)-(w/2),ScreenY + (ScreenHeight/2)-(h/2),w,h
}

;; ------------------NOTE: MODIFIED WINMOVE COMMAND AT THE BOTTOM---------------------
;; Fling (or shift) a window from one monitor to the next in a multi-monitor system.
;;
;; Function Parameters:
;;
;;		FlingDirection		The direction of the fling, expected to be either +1 or -1.
;;							The function is not limited to just two monitors; it supports
;;							as many monitors as are currently connected to the system and
;;							can fling a window serially through each of them in turn.
;;
;;		WinID				The window ID of the window to move. There are two special WinID
;;							values supported:
;;
;;							1) The value "A" means to use the Active window (default).
;;							2) The value "M" means to use the window currently under the Mouse.
;;
;; The flinged window will be resized to have the same *relative* size in the new monitor.
;; For example, if the window originally occupied the entire right half of the screen,
;; it will again on the new monitor (assuming the window can be resized).
;;
;; Minimized windows are not modified; they are left exactly where they were.
;;
;; The return value of the function is non-zero if the window was successfully flung.
;;
;; Example hotkeys:
;;	#NumpadEnter::	Win__Fling(1, "A")	; Windows-NumpadEnter flings the active window
;;	#LButton::		Win__Fling(1, "M")	; Windows-LeftClick flings the window under the mouse
;;
;; Copyright (c) 2010 Patrick Sheppard
;; All Rights Reserved

Win__Fling(FlingDirection = 1, WinID = "A")
{
	; Figure out which window to move based on the "WinID" function parameter:
	;	1) The letter "A" means to use the Active window
	;	2) The letter "M" means to use the window under the Mouse
	; Otherwise, the parameter value is assumed to be the AHK window ID of the window to use.

	if (WinID = "A")
	{
		; If the user supplied an "A" as the window ID, we use the Active window
		WinID := WinExist("A")
	}
	else if (WinID = "M")
	{
		; If the user supplied an "M" as the window ID, we use the window currently under the Mouse
		MouseGetPos, MouseX, MouseY, WinID		; MouseX & MouseY are retrieved but, for now, not used
	}

	; Check to make sure we are working with a valid window
	IfWinNotExist, ahk_id %WinID%
	{
		; Make a short noise so the user knows to stop expecting something fun to happen.
		SoundPlay, *64
		
		; Debug Support
		;MsgBox, 16, Window Fling: Error, Specified window does not exist.`nWindow ID = %WinID%

		return 0
	}

	; Here's where we find out just how many monitors we're dealing with
	SysGet, MonitorCount, MonitorCount

	if (MonitorCount <= 1)
	{
		; Honestly, there's not much to do in a one-monitor system
		return 1
	}

	; For each active monitor, we get Top, Bottom, Left, Right of the monitor's
	;  'Work Area' (i.e., excluding taskbar, etc.). From these values we compute Width and Height.
	;  Results get put into variables named like "Monitor1Top" and "Monitor2Width", etc.,
	;  with the monitor number embedded in the middle of the variable name.

	Loop, %MonitorCount%
	{
		SysGet, Monitor%A_Index%, MonitorWorkArea, %A_Index%
		Monitor%A_Index%Width  := Monitor%A_Index%Right  - Monitor%A_Index%Left
		Monitor%A_Index%Height := Monitor%A_Index%Bottom - Monitor%A_Index%Top
	}

	; Retrieve the target window's original minimized / maximized state
	WinGet, WinOriginalMinMaxState, MinMax, ahk_id %WinID%

	; We don't do anything with minimized windows (for now... this may change)
	if (WinOriginalMinMaxState = -1)
	{
		; Debatable as to whether or not this should be flagged as an error
		return 0
	}
	
	; If the window started out maximized, then the plan is to:
	;	(a) restore it,
	;	(b) fling it, then
	;	(c) re-maximize it on the target monitor.
	;
	; The reason for this is so that the usual maximize / restore windows controls
	; work as you'd expect. You want Windows to use the dimensions of the non-maximized
	; window when you click the little restore icon on a previously flung (maximized) window.
	
	if (WinOriginalMinMaxState = 1)
	{
		; Restore a maximized window to its previous state / size ... before "flinging".
		;
		; Programming Note: It would be nice to hide the window before doing this ... 
		; the window does some visual calisthenics that the user may construe as a bug.
		; Unfortunately, if you hide a window then you can no longer work with it. <Sigh>

		WinRestore, ahk_id %WinID%
	}

	; Retrieve the target window's original (non-maximized) dimensions
	WinGetPos, WinX, WinY, WinW, WinH, ahk_id %WinID%

	; Find the point at the centre of the target window then use it
	; to determine the monitor to which the target window belongs
	; (windows don't have to be entirely contained inside any one monitor's area).
	
	WinCentreX := WinX + WinW / 2
	WinCentreY := WinY + WinH / 2

	CurrMonitor = 0
	Loop, %MonitorCount%
	{
		if (    (WinCentreX >= Monitor%A_Index%Left) and (WinCentreX < Monitor%A_Index%Right )
		    and (WinCentreY >= Monitor%A_Index%Top ) and (WinCentreY < Monitor%A_Index%Bottom))
		{
			CurrMonitor = %A_Index%
			break
		}
	}

	; Compute the number of the next monitor in the direction of the specified fling (+1 or -1)
	;  Valid monitor numbers are 1..MonitorCount, and we effect a circular fling.
	NextMonitor := CurrMonitor + FlingDirection
	if (NextMonitor > MonitorCount)
	{
		NextMonitor = 1
	}
	else if (NextMonitor <= 0)
	{
		NextMonitor = %MonitorCount%
	}

	; Scale the position / dimensions of the target window by the ratio of the monitor sizes.
	; Programming Note: Do multiplies before divides in order to maintain accuracy in the integer calculation.
	WinFlingX := (WinX - Monitor%CurrMonitor%Left) * Monitor%NextMonitor%Width  // Monitor%CurrMonitor%Width  + Monitor%NextMonitor%Left
	WinFlingY := (WinY - Monitor%CurrMonitor%Top ) * Monitor%NextMonitor%Height // Monitor%CurrMonitor%Height + Monitor%NextMonitor%Top
	WinFlingW :=  WinW							   * Monitor%NextMonitor%Width  // Monitor%CurrMonitor%Width
	WinFlingH :=  WinH							   * Monitor%NextMonitor%Height // Monitor%CurrMonitor%Height

	; It's time for the target window to make its big move
	WinMove, ahk_id %WinID%,, WinFlingX, WinFlingY ; , WinFlingW, WinFlingH

	; If the window used to be maximized, maximize it again on its new monitor
	if (WinOriginalMinMaxState = 1)
	{
		WinMaximize, ahk_id %WinID%
	}

	return 1
}

;=============================================================================
; Two-Finger Swipe Left for Backward Navigation
;=============================================================================
WheelRight::
 winc_pressesR += 1
 SetTimer, Whright, 400 ; Wait for more presses within a 400 millisecond window.
return
 
Whright:
 SetTimer, Whright, off ; Disable timer after first time its called.
 if winc_pressesR >= 16 ; The key was pressed once or more.
 {
  SendInput, !{Left} ; Send alt + left for back button (in Chrome at least)
 }
 ; Regardless of which action above was triggered, reset the count to prepare for the next series of presses:
 winc_pressesR = 0
return
 
;=============================================================================
; Two-Finger Swipe Right for Forward Navigation
;=============================================================================
WheelLeft::
 winc_pressesL += 1
 SetTimer, Whleft, 400 ; Wait for more presses within a 400 millisecond window.
return
 
Whleft:
 SetTimer, Whleft, off ; Disable timer after first time its called.
 if winc_pressesL >= 16 ; The key was pressed once or more.
 {
  SendInput, !{Right} ; Send alt + left for forward button (in Chrome at least)
 }
 ; Regardless of which action above was triggered, reset the count to prepare for the next series of presses:
 winc_pressesL = 0
 return