#Include range.ahk

; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 20000 ; Delay between upgrading everything
UPGRADE_EXCHANGE_DELAY_RATE := 180000 ; Delay between getting the token exchange upgrades

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

	; Click individual upgrades
	For i in range(8) {
		Sleep, 50
		ControlClick, X%upgradeXPosition% Y%upgradeYPosition%, ahk_exe RealmGrinderDesktop.exe
		upgradeYPosition -= distanceToNextUpgrade
		Sleep, 50
	}
return

upgradeExchange:
	Sleep, 100
	; open exchange
	ControlClick, X130 Y180, ahk_exe RealmGrinderDesktop.exe,,,, NA
	Sleep, 100

	; Location of the top most upgrade
	upgradeXPosition := 720
	upgradeYPosition := 250

	distanceToNextUpgrade := 50

	; Click individual upgrades
	For i in range(6) {
		; Skip the Elven upgrade
		if (i == 1) {
			upgradeYPosition += distanceToNextUpgrade
			continue
		}

		Sleep, 50
		ControlClick, X%upgradeXPosition% Y%upgradeYPosition%, ahk_exe RealmGrinderDesktop.exe
		upgradeYPosition += distanceToNextUpgrade
		Sleep, 50
	}

	; close exchange
	ControlClick, X790 Y120, ahk_exe RealmGrinderDesktop.exe
	Sleep, 50
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
		SetTimer, upgradeExchange, %UPGRADE_EXCHANGE_DELAY_RATE%, 1
	} else {
		; Shut down everything
		SetTimer, startAutoClicker, Off
		SetTimer, upgradeAll, Off
		SetTimer, upgradeExchange, Off

		MsgBox, Stopped
	}
return

F11::gosub, upgradeAll

F10::gosub, upgradeExchange