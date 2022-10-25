#SingleInstance Force
#Include range.ahk

; Preferences
CLICK_DELAY_RATE := 100 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 20000 ; Delay between upgrading everything
UPGRADE_EXCHANGE_DELAY_RATE := 180000 ; Delay between getting the token exchange upgrades

MANA_RECHARGE_RATE := 21.1
MAX_MANA_CAPACITY := 1269

MANA_RECHARGE_TIME := Ceil(MAX_MANA_CAPACITY / MANA_RECHARGE_RATE) * 1000

; Program code starts here
Click(X, Y){
	ControlClick, X%X% Y%Y%, ahk_exe RealmGrinderDesktop.exe,,,, NA
}

CastSpell(spellSlot, amount := 1){
	for i in range(amount){
		ControlSend, ahk_parent, %spellSlot%, ahk_exe RealmGrinderDesktop.exe
	}
}

BuyBuildingUpgrade(upgradeSlot){
	; Location of the top most building upgrade
	buildingUpgradePosition := {"X": 1200, "Y": 50}
	distanceToNextUpgrade := 60

	; Location of the upgrade
	upgradeXPosition := buildingUpgradePosition["X"]
	upgradeYPosition := buildingUpgradePosition["Y"] + (distanceToNextUpgrade * upgradeSlot)

	; Buy upgrade
	Click(upgradeXPosition, upgradeYPosition)
}

BuyExchangeTokenUpgrade(upgradeSlot){
	; Location of the top most exchange token upgrade
	exchangeUpgradePosition := {"X": 880, "Y": 300}
	distanceToNextUpgrade := 50

	; Location of the upgrade
	upgradeXPosition := exchangeUpgradePosition["X"]
	upgradeYPosition := exchangeUpgradePosition["Y"] + (distanceToNextUpgrade * upgradeSlot)

	; Buy upgrade
	Click(upgradeXPosition, upgradeYPosition)
}

DisplayToolTip(text, duration := 1000){
	ToolTip, %text%
	Sleep, %duration%
	ToolTip
}

; The spell combo
spellCycle:
	; Cast Tax Collection
	Sleep, 50
	CastSpell(1, 3)
	Sleep, 50
return

startAutoClicker:
	Click(800, 500)
return

upgradeAll:
	; Click BUY ALL
	Sleep, 50
	Click(310, 90)
	Sleep, 50

	; get the upgrades individually
	for i in range(10, 3, -1){
		Sleep, 100
		BuyBuildingUpgrade(i)
		Sleep, 100
	}
return

upgradeExchange:
	Sleep, 100
	; open exchange
	Click(130, 180)

	; get the upgrades individually
	For i in range(6) {
		; skip the Angel upgrade
		if (i == 0)
			continue

		Sleep, 100
		BuyExchangeTokenUpgrade(i)
		Sleep, 100
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
		DisplayToolTip("STARTED MAIN SCRIPT")

		; Set up everything
		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1
		SetTimer, upgradeAll, %UPGRADE_ALL_DELAY_RATE%
		SetTimer, upgradeExchange, %UPGRADE_EXCHANGE_DELAY_RATE%, 2
		SetTimer, spellCycle, %MANA_RECHARGE_TIME%, 1
	} else {
		; Shut down everything
		SetTimer, startAutoClicker, Off
		SetTimer, upgradeAll, Off
		SetTimer, upgradeExchange, Off
		SetTimer, spellCycle, Off

		DisplayToolTip("STOPPED MAIN SCRIPT")
	}
return

F11::gosub, upgradeAll

F10::gosub, upgradeExchange

F9::gosub, spellCycle