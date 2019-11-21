OpenOrSwitchToFolder(path) {
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