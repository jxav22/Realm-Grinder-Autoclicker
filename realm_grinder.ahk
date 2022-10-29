#MaxThreads 2
#SingleInstance Force
#Include range.ahk

; Preferences

; The faction list, as visible in the token upgrade panel
global FACTION_LIST := ["FAIRY", "ELVEN", "ANGEL", "GOBLIN", "UNDEAD", "DEMON"]
global CURRENT_FACTION := "ELVEN"

global CLICK_DELAY_RATE := 50 ; Delay between clicks in miliseconds
global UPGRADE_ALL_DELAY_RATE := 2 * 60 * 1000 ; Delay between upgrading everything
global UPGRADE_EXCHANGE_DELAY_RATE := 3 * 60 * 1000 ; Delay between getting the token exchange upgrades
global ABDICATION_RATE := 30 * 60 * 1000 ; Delay between abdications

global MANA_RECHARGE_RATE := 5
global MAX_MANA_CAPACITY := 1000
global MANA_RECHARGE_TIME := Ceil(MAX_MANA_CAPACITY / MANA_RECHARGE_RATE) * 1000

global SHORT_PAUSE := 100
global LONG_PAUSE := 500

; Program code starts here

class ExchangeScreen
{
	; Location of the top most exchange token upgrade, defined as the center of the upgrade button.
	static topExchangeUpgradePosition := {"X": 880, "Y": 300}
	static distanceToNextUpgrade := 50

	; Open the exchange token screen
	open(){
		Sleep, % SHORT_PAUSE
		Click(130, 180)
		Sleep, % SHORT_PAUSE
	}

	; Close the exchange token screen
	close(){
		Sleep, % SHORT_PAUSE
		Click(970, 180)
		Sleep, % SHORT_PAUSE
	}

	; Buy an upgrade
	; upgradeSlot = the order the upgrade is in, with the top upgrade having the position '0'.
	upgrade(upgradeSlot){
		; Location of the upgrade
		upgradeXPosition := this.topExchangeUpgradePosition["X"]
		upgradeYPosition := this.topExchangeUpgradePosition["Y"] + (this.distanceToNextUpgrade * upgradeSlot)

		; Buy upgrade
		Sleep, % SHORT_PAUSE
		Click(upgradeXPosition, upgradeYPosition)
		Sleep, % SHORT_PAUSE
	}

	; Upgrade everything, except the current faction
	upgradeAll(){
		for upgradeSlot, faction in FACTION_LIST {
			; skip the current faction
			if (faction == CURRENT_FACTION)
				continue

			this.upgrade(upgradeSlot - 1)
		}
	}
}

class MainScreen
{
	; Location of the top most, and left most, upgrade
	static topUpgradePosition := {"X": 127, "Y": 177}
	static distanceToNextUpgrade := 60

	; Location of the top most building upgrade
	static topBuildingUpgradePosition := {"X": 1200, "Y": 80}
	static distanceToNextBuildingUpgrade := 60

	buyUpgrade(upgradeRow, upgradeColumn){
		; Location of the upgrade
		upgradeXPosition := this.topUpgradePosition["X"] + (this.distanceToNextUpgrade * upgradeColumn)
		upgradeYPosition := this.topUpgradePosition["Y"] + (this.distanceToNextUpgrade * upgradeRow)

		; Buy upgrade
		Sleep, % SHORT_PAUSE
		Click(upgradeXPosition, upgradeYPosition)
		Sleep, % SHORT_PAUSE
	}

	buyAllUpgrades(){
		Sleep, % SHORT_PAUSE
		Click(310, 90)
		Sleep, % SHORT_PAUSE
	}

	buyBuildingUpgrade(upgradeSlot){
		; Location of the upgrade
		upgradeXPosition := this.topBuildingUpgradePosition["X"]
		upgradeYPosition := this.topBuildingUpgradePosition["Y"] + (this.distanceToNextBuildingUpgrade * upgradeSlot)

		; Buy upgrade
		Sleep, % SHORT_PAUSE
		Click(upgradeXPosition, upgradeYPosition)
		Sleep, % SHORT_PAUSE
	}

	switchBuyAmount(){
		Sleep, % SHORT_PAUSE
		Click(1000, 690)
		Sleep, % SHORT_PAUSE
	}

	abdicate(){
		; click the abdication button
		Click(220, 55)
		Sleep, % LONG_PAUSE

		; confirm abdication
		Click(590, 490)
		Sleep, % LONG_PAUSE
	}
}

Click(X, Y){
	ControlClick, X%X% Y%Y%, ahk_exe RealmGrinderDesktop.exe,,,, NA
}

FarmClicks(clickAmount){
	for i in range(clickAmount){
		Sleep, %CLICK_DELAY_RATE%
		gosub, startAutoClicker
	}
}

CastSpell(spellSlot, amount := 1){
	for i in range(amount){
		Sleep, % SHORT_PAUSE
		ControlSend, ahk_parent, %spellSlot%, ahk_exe RealmGrinderDesktop.exe
		Sleep, % SHORT_PAUSE
	}
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
	MainScreen.buyAllUpgrades()

	; get the upgrades individually
	for i in range(10, 2, -1){
		MainScreen.buyBuildingUpgrade(i)
	}
return

upgradeExchange:
	ExchangeScreen.open()
	ExchangeScreen.upgradeAll()
	ExchangeScreen.close()
return

abdicate:
	Sleep, % SHORT_PAUSE
	; close exchange (HANDLED POTENTIAL EDGE CASE)
	ExchangeScreen.close()
	Sleep, % LONG_PAUSE

	MainScreen.abdicate()

	; click BUY ALL twice
	for i in range(2){
		MainScreen.buyAllUpgrades()
		Sleep, % LONG_PAUSE
	}

	; switch to BUY 1
	for i in range(3){
		MainScreen.switchBuyAmount()
		Sleep, % LONG_PAUSE
	}

	; buy 10 farms
	for i in range(10){
		MainScreen.buyBuildingUpgrade(0)
		Sleep, % LONG_PAUSE
	}

	; buy proof of good deed
	MainScreen.buyUpgrade(0, 2)
	Sleep, % LONG_PAUSE

	; switch to BUY 10
	MainScreen.switchBuyAmount()
	Sleep, % LONG_PAUSE

	; buy 90 farms
	for i in range(9){
		MainScreen.buyBuildingUpgrade(0)
		Sleep, % LONG_PAUSE
	}

	; switch to BUY 100
	MainScreen.switchBuyAmount()
	Sleep, % LONG_PAUSE

	; buy 100 of each beginner building
	Sleep, % LONG_PAUSE
	MainScreen.buyBuildingUpgrade(1)
	Sleep, % LONG_PAUSE
	MainScreen.buyBuildingUpgrade(2)
	Sleep, % LONG_PAUSE

	; grind exchange tokens until it's > 20
	FarmClicks(100)

	; upgrade everything in the middle of grinding. Haven't confirmed if this has an actual benefit
	gosub, upgradeAll

	FarmClicks(500)

	; buy Elven trade treaty
	Sleep, % LONG_PAUSE * 6
	MainScreen.buyUpgrade(0, 3)
	Sleep, % LONG_PAUSE
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
		SetTimer, spellCycle, Off
		SetTimer, abdicate, Off

		DisplayToolTip("STOPPED AUTOMATIC GAME MANAGEMENT")
	}
return
