;*****************************************************************************
; Script for JCDesktop2016
;*****************************************************************************
; Uses functions in Lib folder
; Requires Dropbox environment variable to be set

;=============================================================================
; Setup
;=============================================================================
; Run script as Administrator
SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%"

#NoEnv ; Recommended for all new scripts
#SingleInstance Force ; Running one instance at a time enables easier editing

EnvGet, DROPBOX, Dropbox 

;=============================================================================
; Main Hotkeys
;=============================================================================
; Reserved Ctrl+Win Hotkeys:
; 	Ctrl+Win+D			New Virtual Desktop
; 	Ctrl+Win+f4			Close Virtual Desktop
; 	Ctrl+Win+Left/Right	Switch Virtual Desktops

^#f::
OpenOrSwitchToFolder(DROPBOX . "\Personal\Finance")
return

^#p::
OpenOrSwitchToFolder(DROPBOX . "\PigX")
WinWait, PigX
SendInput, {LWin Down}{Left}
Sleep, 50
SendInput, {Up}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
openOrSwitchToFolder(A_MyDocuments . "\git")
WinWait, git
SendInput, {LWin Down}{Left}
Sleep, 50
SendInput, {Down}
Sleep, 50
SendInput, {LWin Up}
Sleep, 50
Run C:\Program Files\Microsoft VS Code\Code.exe
WinWait, Visual Studio Code
SendInput, {LWin Down}{Right}
Sleep, 50
SendInput, {LWin Up}
return

