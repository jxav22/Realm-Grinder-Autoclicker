#Include range.ahk

; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 20000 ; Delay between upgrading everything

; Repeating subroutines for performing clicks
startAutoClicker:
	ControlClick, X600 Y400, ahk_exe RealmGrinderDesktop.exe
return

upgradeAll:
	; Click BUY ALL
	Sleep, 50
	ControlClick, X310 Y90, ahk_exe RealmGrinderDesktop.exe

	; Location of the bottom most upgrade
	upgradeXPosition := 800
	upgradeYPosition := 595

	distanceToNextUpgrade := 50

	; Click individual building upgrades
	For i in range(8) {
		Sleep, 50
		ControlClick, X%upgradeXPosition% Y%upgradeYPosition%, ahk_exe RealmGrinderDesktop.exe
		upgradeYPosition -= distanceToNextUpgrade
		Sleep, 50
	}
return

; Main code
isProgramStarted := false

F12::
	isProgramStarted := !isProgramStarted

	if isProgramStarted {
		MsgBox, Started

		; Set up everything
		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1
		SetTimer, upgradeAll, %UPGRADE_ALL_DELAY_RATE%
	} else {
		; Shut down everything
		SetTimer, startAutoClicker, Off
		SetTimer, upgradeAll, Off

		MsgBox, Stopped
	}
return

F11::gosub, upgradeAll