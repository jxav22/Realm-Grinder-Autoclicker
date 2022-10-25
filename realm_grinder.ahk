; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds

; Repeating subroutine for clicking
startAutoClicker:
	ControlClick, X600 Y400, ahk_exe RealmGrinderDesktop.exe
return

; Main code
isProgramStarted := false

F12::
	isProgramStarted := !isProgramStarted

	if isProgramStarted {
		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1
	} else {
		SetTimer, startAutoClicker, Off

		MsgBox, Stopped
	}
return