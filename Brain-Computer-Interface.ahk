; 2019-11-21 Anonymized to remove sensitive information, changed to paths to fake paths
;FormatTime, Time,, MM/dd/yy hh:mm tt 
;Send  Ticket Assigned To%A_Space% - TTA %Time%{left 24}
;WinGetPos, winX, winY, winW, winH, Online Analysis
;MsgBox, 16, Width & Height, Width: %winW%. Height: %winH%
;LOCATIONS
	;Click 50, 190 ;Data Translator Online Button
^#0::
	;~ PSExec_exe:="psexec.exe"
	;~ PSExec_params= \\tdt-pc -i -d -u USER -p PASS "C:\Program Files\AutoHotkey\Autohotkey.exe" C:\bci1TDT.ahk
	;~ PSExec_cmd:=PSExec_exe " " PSExec_params

	;~ Run, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\
	;~ Run, E:\lab\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%	
	SetTitleMatchMode, slow
	WinMove, %A_YYYY%%A_MM%%A_DD%, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%, 0, 455, 595, 600
	WinMove, %A_YYYY%%A_MM%%A_DD%, E:\lab\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%, 595, 455, 595, 600
	SetTitleMatchMode, fast
;
; Network Camera Code
;
	;~ IfWinNotExist, Network Camera
		;~ Run, chrome.exe --new-window http://CAMERAURL

	;~ SetTitleMatchMode, RegEx
	;~ WinWait, ,(Authentication Required)|(Network Camera)
	;~ ControlSend, Authentication Required, {enter}
	;~ WinWait, Network Camera
	;~ WinMove, Network Camera,, 1140, 425, 780, 735
	
return

^#9::
coincidentSpikeDir = F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\coincidentSpikeDetection
	changeDirectory(coincidentSpikeDir)
return

^#8::
; Quick parameter switching
	WinActivate,Lab Main
	SetControlDelay, 100
	ControlClick, x20 y36,Lab Main,,,,NA
	Send {l}
	Send {enter}
	Sleep, 1000
	ControlSetText, Edit1, C:\bci1\Parameter Files\rig01, Select a system parameters file
	ControlSend, Edit1, {enter}, Select a system parameters file
return

^#1:: ; ctrl windows 1
; Opens excel, host, data translator, notepad++. Makes directories, runs TDT script on TDT-PC

	IfWinNotExist, Data Translator
		Run, "C:\Executables\Data Translator\slick_data_translator.exe"
	
	if (A_YYYY = 2014) {
		Run, "\\SERVER\lab\Training Logs\bci1\bci1 training log 2014.xlsx"
	} else {
		Run, "\\SERVER\lab\Training Logs\bci1"
	}
	
	IfWinNotExist, ahk_class Notepad++
		Run, "C:\Program Files\Notepad++\notepad++.exe"
	
	FileCreateDir, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%
	gradualTrainingFolders = brainControl,coincidentSpikeDetection,decoders,training,gradualtraining
	intrinsicDimFolders = bci1%A_YYYY%%A_MM%%A_DD%SessionMATFiles,coincidentSpikeDetection,observationTraining,brainControl1,brainControl2,handControl1,handControl2,rest1,rest2,distraction
	intrinsicDimVideoFolders = coincidentSpikeDetection,observationTraining,brainControl1,handControl1,rest1,youtube1,youtube2
	Loop,Parse,intrinsicDimFolders,`,
	{
		FileCreateDir, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\%A_LoopField%
	}
	
	FileCreateDir, E:\lab\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%
	Run, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\
	Run, E:\lab\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%	
	Run, psexec.exe \\tdt-pc -i -d -u USER -p PASS$ cmd /c C:\bci1TDT.ahk
	
	IfWinNotExist, "Lab Main"
		Run, "C:\Executables\Host App\host_app.exe" -- phasespace
	
return ; end of ctrl windows 1

^#2:: ; ctrl windows 2

	WinMove, Data Translator, , 2925, 480
	WinMove, ahk_class XLMAIN, , 1915, -5, 1020, 600
	WinMove, ahk_class ahk_class Notepad++, ,1915, 515, 1020, 540
	WinActivate, MATLAB Command Window
	WinMove, MATLAB Command Window, , 2935, 0, 665, 525
	
	IfWinExist, Trace Plot
		WinMinimize, Trace Plot
		
	IfWinExist, PSTH and Raster 
		WinMinimize, PSTH and Raster
		
	IfWinExist, 3D Plot
		WinMinimize, 3D Plot

	IfWinExist, Online Analysis
		WinGetPos, winX,,,, Online Analysis
		if (winX >= 0)
		{
			WinGet, active_id, ID, Online Analysis
			Win__Fling(1, active_id)
		}
	
	WinMove, Current Parameters, , 410, 0
	WinMove, Lab Main, , 0, 0
	WinMove, System Monitor, , 1297, 0
	WinMove, 3D Calibration, , 780, 0
	WinMove, TDT Information, , 775, 280	
	WinMove, XY Plot, , 1190, 330
	
	SetTitleMatchMode, slow
	WinMove, %A_YYYY%%A_MM%%A_DD%, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%, 0, 455, 595, 600
	WinMove, %A_YYYY%%A_MM%%A_DD%, E:\lab\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%, 595, 455, 595, 600
	SetTitleMatchMode, fast
	
	WinActivate, Lab Main
	SetControlDelay, 100
	ControlClick, x20 y36,Lab Main,,,,NA
	Send {l}
	Send {enter}
	Sleep, 1000
	ControlSetText, Edit1, C:\bci1\Parameter Files\rig01, Select a system parameters file
	ControlSend, Edit1, {enter}, Select a system parameters file
return ; end of ctrl windows 2

^#3:: ; ctrl windows 3
	WinActivate,Lab Main
	SetControlDelay, 100
	ControlClick, x47 y321,Lab Main,,,,NA
	ControlClick, x150 y330,Lab Main,,,,NA
	SendInput, F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\distraction
return ; end of ctrl windows 3

^#4::
	WinActivate, Data Translator
	;SendInput, {tab}
	Click 80 , 80, 3 ;triple click
	coincidentSpikeDir = F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\coincidentSpikeDetection
	
	SendInput, %coincidentSpikeDir%
	;SendInput, {tab}
	Click 100, 130, 3 ;triple click
	SendInput, 00bci1%A_YYYY%%A_MM%%A_DD%coincidentSpikeDetection_withSnippetInfo_us_waveform.mat	
	Click 210, 295 ; Data Translator Extract Snippet Info Button
	
	SetTitleMatchMode, RegEx
	WinWait, Select Snippet Data*
	WinMove, Select Snippet Data*,,2550,505
	WinActivate, Select Snippet Data*
	Click 30, 150 ; Channel
	Click 30, 170 ; Sort Number
	Click 30, 190 ; Timestamp
	Click 52, 340 ; Precision
	Click 135, 350 ;Save
	Sleep, 200
	
	WinActivate, Data Translator
	Click 210, 335 ; Extract Snippet Waveforms
	
	changeDirectory(coincidentSpikeDir)
return

^#5::
; Changes trials for training
	trainingDir = F:\Data\bci1\%A_YYYY%\%A_MM%\%A_YYYY%%A_MM%%A_DD%\observationTraining
	IfNotExist, %trainingDir%
		FileCreateDir, %trainingDir%
	
	WinActivate, Data Translator
	Click 80 , 80, 3 ;triple click directory field
	SendInput, %training%
	Click 100, 130, 3 ;triple click filename
	SendInput, 01bci1%A_YYYY%%A_MM%%A_DD%trainingUDP	
	Click 55, 185 ; Data Translator Online/Offline Button
	Click 70, 245 ; Data Translator Preprocess Button
	Click 260, 225, 2 ; Double click processing delay
	SendInput, 1
	Click, 400, 195, 3 ; Triple click preprocess.m file
	SendInput, C:\bci1\preprocess scripts\allTrialTypes_2D_bci1.m
	Click, 400, 245, 3 ; Triple click preprocessed data filename
	SendInput, 01bci1%A_YYYY%%A_MM%%A_DD%trainingUDPProcessed
	Click, 100, 550 ; Data Translator Start Button
	
	changeDirectory(trainingDir)
	increaseBlock()
return ; end of ctrl win 5

^#6::
; Closes things
return ; end of ctrl win 6

changeDirectory(directory)
{
	WinActivate,Lab Main
	SetControlDelay, 100
	ControlClick, x150 y330,Lab Main,,,3,NA
	SendInput, {down}{down}{end}
	SendInput, +{home}{up}
	SendInput, %directory%
}

increaseBlock()
{
	WinActivate,Lab Main
	SetControlDelay, 100
	ControlClick, x372 y382,Lab Main,,,,NA
}






^!n:: ; ctrl alt n

	IfWinExist, Trace Plot
		WinMinimize, Trace Plot
		
	IfWinExist, PSTH and Raster 
		WinMinimize, PSTH and Raster
		
	IfWinExist, 3D Plot
		WinMinimize, 3D Plot

	IfWinExist, Online Analysis
		WinGetPos, winX,,,, Online Analysis
		if (winX >= 0)
		{
			WinGet, active_id, ID, Online Analysis
			Win__Fling(1, active_id)
		}

return ; end of ctrl alt n

^!+n:: ; ctrl alt shift n - undo ctrl alt n
	IfWinExist, PSTH and Raster 
		WinRestore, PSTH and Raster

	IfWinExist, Trace Plot
		WinRestore, Trace Plot

	IfWinExist, 3D Plot
		WinRestore, 3D Plotf

	IfWinExist, Online Analysis
		WinGetPos, winX,,,, Online Analysis
		if (winX < 0)
		{
			WinGet, active_id, ID, Online Analysis
			Win__Fling(-1, active_id)
		}
return ; end of ctrl alt shift n

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