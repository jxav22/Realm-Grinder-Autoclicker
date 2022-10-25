#Include range.ahk

; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 20000 ; Delay between upgrading everything

; Repeating subroutine for clicking
startAutoClicker:
	ControlClick, X600 Y400, ahk_exe RealmGrinderDesktop.exe
return

upgradeAll:
	; Click BUY ALL
	Sleep, 100
	ControlClick, X310 Y90, ahk_exe RealmGrinderDesktop.exe

	; Click individual building upgrades
	upgradeXLocation := 800
	upgradeYLocation := 595

	distanceToNextUpgrade := 50

	For i in range(8) {
		Sleep, 100
		ControlClick, X%upgradeXLocation% Y%upgradeYLocation%, ahk_exe RealmGrinderDesktop.exe
		upgradeYLocation -= distanceToNextUpgrade
		Sleep, 100
	}
return

; Main code
isProgramStarted := false

F12::
	isProgramStarted := !isProgramStarted

	if isProgramStarted {
		MsgBox, Started

		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1
		SetTimer, upgradeAll, %UPGRADE_ALL_DELAY_RATE%
	} else {
		SetTimer, startAutoClicker, Off
		SetTimer, upgradeAll, Off

		MsgBox, Stopped
	}
return

F11::gosub, upgradeAll