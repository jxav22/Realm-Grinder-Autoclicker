; Preferences
CLICK_DELAY_RATE := 10 ; Delay between clicks in miliseconds

; Spell cast rates
MANA_GENERATION_RATE := 13

; HOLY LIGHT
HOLY_LIGHT_COST := 900
HOLY_LIGHT_CAST_RATE := Ceil(HOLY_LIGHT_COST / MANA_GENERATION_RATE) * 1000

TOTAL_CAST_RATE := HOLY_LIGHT_CAST_RATE

; Repeating subroutines for clicking different stuff
startAutoClicker:
	ControlClick, X600 Y400, ahk_exe RealmGrinderDesktop.exe
return

castHolyLight:
	ControlClick, X685 Y265, ahk_exe RealmGrinderDesktop.exe
return

spellCycle:
	cast_delay := HOLY_LIGHT_CAST_RATE
	SetTimer, castHolyLight, % -cast_delay
return

; Main code
isProgramStarted := false

F12::
	isProgramStarted := !isProgramStarted

	if isProgramStarted {
		MsgBox, Started

		; Casts the first spell
		gosub, castHolyLight

		SetTimer, startAutoClicker, %CLICK_DELAY_RATE%, -1

		SetTimer, spellCycle, %TOTAL_CAST_RATE%

	} else {
		SetTimer, startAutoClicker, Off
		SetTimer, spellCycle, Off

		MsgBox, Stopped
	}
return