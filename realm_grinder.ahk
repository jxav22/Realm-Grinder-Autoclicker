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
	Click(600, 400)
return

upgradeAll:
	; Click BUY ALL
	Sleep, 50
	Click(310, 90)

	; Location of the bottom most upgrade
	upgradeXPosition := 800
	upgradeYPosition := 595

	distanceToNextUpgrade := 50

	; Click individual upgrades
	For i in range(8) {
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
	upgradeXPosition := 720
	upgradeYPosition := 250

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
	Click(790, 120)
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

; The spell combo
spellCycle:
	; Cast Holy Light
	Sleep, 50
	Click(690, 265)
	Sleep, 50

	; Cast God's Hand
	Sleep, 50
	Click(690, 315)
	Sleep, 50

	; Spam Cast Tax Collection
	for i in range(30){
		Sleep, 50
		Click(690, 165)
		Sleep, 50
	}
return

F11::gosub, upgradeAll

F10::gosub, upgradeExchange

F9::gosub, spellCycle