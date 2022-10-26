#SingleInstance Force
#Include range.ahk

; Preferences

; The faction list, as visible in the token upgrade panel
FACTION_LIST := ["FAIRY", "ELVEN", "ANGEL", "GOBLIN", "UNDEAD", "DEMON"]
CURRENT_FACTION := "ELVEN"

CLICK_DELAY_RATE := 50 ; Delay between clicks in miliseconds
UPGRADE_ALL_DELAY_RATE := 2 * 60 * 1000 ; Delay between upgrading everything
UPGRADE_EXCHANGE_DELAY_RATE := 3 * 60 * 1000 ; Delay between getting the token exchange upgrades
ABDICATION_RATE := 30 * 60 * 1000 ; Delay between abdications

MANA_RECHARGE_RATE := 5
MAX_MANA_CAPACITY := 1000
MANA_RECHARGE_TIME := Ceil(MAX_MANA_CAPACITY / MANA_RECHARGE_RATE) * 1000

; Program code starts here

Click(X, Y){
	ControlClick, X%X% Y%Y%, ahk_exe RealmGrinderDesktop.exe,,,, NA
}

FarmClicks(clickAmount){
	for i in range(clickAmount){
		gosub, startAutoClicker
		Sleep, %CLICK_DELAY_RATE%
	}
}

CastSpell(spellSlot, amount := 1){
	for i in range(amount){
		Sleep, 50
		ControlSend, ahk_parent, %spellSlot%, ahk_exe RealmGrinderDesktop.exe
		Sleep, 50
	}
}

BuyBuildingUpgrade(upgradeSlot){
	; Location of the top most building upgrade
	buildingUpgradePosition := {"X": 1200, "Y": 80}
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

; casts this cycle of spells every time mana recharges to full
spellCycle:
	CastSpell(4)
return

startAutoClicker:
	Click(800, 500)
return

upgradeAll:
	; click BUY ALL
	Sleep, 50
	Click(310, 90)
	Sleep, 50

	; get the upgrades individually
	for i in range(10, 2, -1){
		Sleep, 100
		BuyBuildingUpgrade(i)
		Sleep, 100
	}
return

upgradeExchange:
	; open exchange
	Sleep, 100
	Click(130, 180)

	; get the upgrades individually
	For index, FACTION in FACTION_LIST {
		; skip the current faction
		if (FACTION == CURRENT_FACTION)
			continue

		Sleep, 100
		BuyExchangeTokenUpgrade(index - 1)
		Sleep, 100
	}

	; close exchange
	Click(970, 180)
	Sleep, 50
return

BuyUpgrade(upgradeRow, upgradeColumn){
	; Location of the top left most upgrade
	exchangeUpgradePosition := {"X": 127, "Y": 177}
	distanceToNextUpgrade := 60

	; Location of the upgrade
	upgradeXPosition := exchangeUpgradePosition["X"] + (distanceToNextUpgrade * upgradeColumn)
	upgradeYPosition := exchangeUpgradePosition["Y"] + (distanceToNextUpgrade * upgradeRow)

	; Buy upgrade
	Click(upgradeXPosition, upgradeYPosition)
}

abdicate:
	Sleep, 500
	; close exchange (HANDLED POTENTIAL EDGE CASE)
	Click(970, 180)
	Sleep, 500

	; click the abdication button
	Click(220, 55)
	Sleep, 500

	; confirm abdication
	Click(590, 490)
	Sleep, 500

	; click BUY ALL twice
	for i in range(2){
		Click(310, 90)
		Sleep, 500
	}

	; switch to BUY 1
	for i in range(3){
		Click(1000, 690)
		Sleep, 500
	}

	; buy 10 farms
	for i in range(10){
		BuyBuildingUpgrade(0)
		Sleep, 500
	}

	; buy proof of good deed
	BuyUpgrade(0, 1)
	Sleep, 500

	; switch to BUY 10
	Click(1000, 690)
	Sleep, 500

	; buy 90 farms
	for i in range(9){
		BuyBuildingUpgrade(0)
		Sleep, 500
	}

	; switch to BUY 100
	Click(1000, 690)
	Sleep, 500

	; buy 100 of each beginner building
	Sleep, 500
	BuyBuildingUpgrade(1)
	Sleep, 500
	BuyBuildingUpgrade(2)
	Sleep, 500

	FarmClicks(100)

	gosub, upgradeAll

	FarmClicks(500)

	; buy Elven trade treaty
	Sleep, 500
	BuyUpgrade(0, 2)
	Sleep, 500
return

; Main code
isProgramStarted := false

F8::
	DisplayToolTip("ABDICATING...", 500)
	gosub, abdicate
return

F9::
	DisplayToolTip("RUNNING SPELLS...", 500)
	gosub, spellCycle
return

F10::
	DisplayToolTip("UPGRADING TOKENS...", 500)
	gosub, upgradeExchange
return

F11::
	DisplayToolTip("PURCHASING UPGRADES...", 500)
	gosub, upgradeAll
return

F12::
	isProgramStarted := !isProgramStarted

	if isProgramStarted {
		DisplayToolTip("STARTED AUTOMATIC GAME MANAGEMENT")

		; Set up everything
		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1
		SetTimer, upgradeAll, %UPGRADE_ALL_DELAY_RATE%
		SetTimer, upgradeExchange, %UPGRADE_EXCHANGE_DELAY_RATE%, 2
		SetTimer, spellCycle, %MANA_RECHARGE_TIME%, 1
		SetTimer, abdicate, %ABDICATION_RATE%, 3
	} else {
		; Shut down everything
		SetTimer, startAutoClicker, Off
		SetTimer, upgradeAll, Off
		SetTimer, upgradeExchange, Off
		SetTimer, spellCycle, %MANA_RECHARGE_TIME%, Off
		SetTimer, abdicate, Off

		DisplayToolTip("STOPPED AUTOMATIC GAME MANAGEMENT")
	}
return
