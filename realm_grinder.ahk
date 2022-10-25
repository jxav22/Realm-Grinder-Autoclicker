#SingleInstance Force
#Include range.ahk

; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 20000 ; Delay between upgrading everything
UPGRADE_EXCHANGE_DELAY_RATE := 180000 ; Delay between getting the token exchange upgrades

; Repeating subroutines for performing clicks
Click(X, Y){
	ControlClick, X%X% Y%Y%, ahk_exe RealmGrinderDesktop.exe,,,, NA
}

startAutoClicker:
	Click(800, 500)
return

upgradeAll:
	; Click BUY ALL
	Sleep, 50
	Click(310, 90)

	; Location of the bottom most upgrade
	upgradeXPosition := 1200
	upgradeYPosition := 685

	distanceToNextUpgrade := 50

	; Click individual upgrades
	For i in range(9) {
		Sleep, 50
		Click(upgradeXPosition, upgradeYPosition)
		upgradeYPosition -= distanceToNextUpgrade
		Sleep, 50
	}
return

upgradeExchange:
	Sleep, 100
	; open exchange
	Click(130, 180)
	Sleep, 100

	; Location of the top most upgrade
	upgradeXPosition := 880
	upgradeYPosition := 300

	distanceToNextUpgrade := 50

	; Click individual upgrades
	For i in range(6) {
		; Skip the Angel upgrade
		if (i == 2) {
			upgradeYPosition += distanceToNextUpgrade
			continue
		}

		Sleep, 50
		Click(upgradeXPosition, upgradeYPosition)
		upgradeYPosition += distanceToNextUpgrade
		Sleep, 50
	}

	; close exchange
	Click(970, 180)
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
