#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <TurboAIHelpFunctions.au3>
#include-once

; Label Sizes
Global Const $labelWidth = 150
Global Const $labelHeight = 20

; CTRLS GUI Hero
Global $ctrlColor
Global $ctrlPosition
Global $ctrlLevel
Global $ctrlHealth
Global $ctrlDead

; CTRLS componets Game
Global $ctrlIngame
Global $ctrlTimer
Global $ctrlFaction

; CTRLS componetes Towers
Global $ctrlOffT1_Frindly
Global $ctrlOffT2_Frindly
Global $ctrlOffT3_Frindly
Global $ctrlMidT1_Frindly
Global $ctrlMidT2_Frindly
Global $ctrlMidT3_Frindly
Global $ctrlSafelaneT1_Frindly
Global $ctrlSafelaneT2_Frindly
Global $ctrlSafelaneT3_Frindly

Global $ctrlOffT1_Enemy
Global $ctrlOffT2_Enemy
Global $ctrlOffT3_Enemy
Global $ctrlMidT1_Enemy
Global $ctrlMidT2_Enemy
Global $ctrlMidT3_Enemy
Global $ctrlSafelaneT1_Enemy
Global $ctrlSafelaneT2_Enemy
Global $ctrlSafelaneT3_Enemy

; CTRLS Log
Global $ctrlLog


; START: MODULE TEST CODE

#cs
 _mainGui()
_GUIHero()
_GUIGame()
_GUITowers()
_GUILog()

For $i = 0 to 9
    sleep(100)
    _setGUIHero (255,0,1,10,false)
    _addEntryGUILog("test",642)
Next
_clearEntriesGUILog()
_addEntryGUILog("test",642)
sleep(100)
_addEntryGUILog("test",642)
sleep(100)
_addEntryGUILog("test",642)
_clearEntriesGUILog()
_addEntryGUILog("test",642)
sleep(2000)
#ce


; END MODULE TEST CODE

Func _renderGUI()
	_GUImain()
	_GUIHero()
	_GUIGame()
	_GUITowers()
	_GUILog()
EndFunc

Func _GUImain()
	Opt("GUICoordMode", 0)
	Opt("GUIOnEventMode", 1)
	$hMainGUI = GUICreate("Turbo AI Monitor", @DesktopWidth / 2, @DesktopHeight / 2)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exitButton")
	GUISetState(@SW_SHOW, $hMainGUI)
EndFunc   ;==>_GUImain

Func _GUILog()
	Local $guiLog = ""
	GUICtrlCreateGroup("Log", -635, 40, 400, 300)
	$ctrlLog = GUICtrlCreateEdit($guiLog, 10, 20, 380, 300)
EndFunc   ;==>_GUILog

Func _addEntryGUILog($setLogEntry, $setTimer)
	If Not (IsNumber($setTimer)) Then
		Return
	EndIf

	Local $minutes = Int(_convertTimer($setTimer) / 60)
	Local $seconds = Mod(_convertTimer($setTimer), 60)
	Local $sTime = $minutes & ":" & $seconds & " "
	Local $sLogEntry = $sTime & $setLogEntry & @CRLF
	GUICtrlSetData($ctrlLog, $sLogEntry, 1)
EndFunc   ;==>_addEntryGUILog

Func _clearEntriesGUILog()
	Local $sEmpty = "Log Reset" & @CRLF
	GUICtrlSetData($ctrlLog, $sEmpty)
EndFunc   ;==>_clearEntriesGUILog

Func _GUIGame()
	Local $guiIngame = ""
	Local $guiTimer = ""
	Local $guiFaction = ""
	GUICtrlCreateGroup("Game", 200, -100, 200, 200)
	$ctrlIngame = GUICtrlCreateLabel("In-Game: " & $guiIngame, 5, 20, $labelWidth, $labelHeight)
	$ctrlTimer = GUICtrlCreateLabel("Timer/sec: " & $guiTimer, 0, 20, $labelWidth, $labelHeight)
	$ctrlFaction = GUICtrlCreateLabel("Faction: " & $guiFaction, 0, 20, $labelWidth, $labelHeight)

EndFunc   ;==>_GUIGame

Func _setGUIGame($setIngame, $setTimer, $setFaction)
	Local $sFaction
	If $setFaction = -1 Then
		$sFaction = "Not Set"
	EndIf
	If $setFaction == True Then
		$sFaction = "Radiant"
	EndIf
	If $setFaction == False Then
		$sFaction = "Dire"
	EndIf
	GUICtrlSetData($ctrlIngame, "In-Game: " & $setIngame)
	GUICtrlSetData($ctrlTimer, "Timer/Sec: " & $setTimer)
	GUICtrlSetData($ctrlFaction, "Faction: " & $sFaction)

EndFunc   ;==>_setGUIGame

Func _GUITowers()
	; Frindly
	Local $guiTower_MidT1_Frindly
	Local $guiTower_MidT2_Frindly
	Local $guiTower_MidT3_Frindly
	Local $guiTower_SafeLaneT1_Frindly
	Local $guiTower_SafeLaneT2_Frindly
	Local $guiTower_SafeLaneT3_Frindly
	Local $guiTower_OfflaneT1_Frindly
	Local $guiTower_OfflaneT2_Frindly
	Local $guiTower_OfflaneT3_Frindly

	; Enemy
	Local $guiTower_MidT1_Enemy
	Local $guiTower_MidT2_Enemy
	Local $guiTower_MidT3_Enemy
	Local $guiTower_SafeLaneT1_Enemy
	Local $guiTower_SafeLaneT2_Enemy
	Local $guiTower_SafeLaneT3_Enemy
	Local $guiTower_OfflaneT1_Enemy
	Local $guiTower_OfflaneT2_Enemy
	Local $guiTower_OfflaneT3_Enemy
	; Tower Group
	GUICtrlCreateGroup("Towers: Frindly Top | Enemy Bottom", 200, -60, 330, 200)
	; Offlane
	GUICtrlCreateGroup("Offlane", 10, 20, 100, 170)
	; Frindly
	$ctrlOffT1_Frindly = GUICtrlCreateLabel("F-T1: " & $guiTower_OfflaneT1_Frindly, 5, 20, $labelWidth / 2, $labelHeight)
	$ctrlOffT2_Frindly = GUICtrlCreateLabel("F-T2: " & $guiTower_OfflaneT2_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlOffT3_Frindly = GUICtrlCreateLabel("F-T3: " & $guiTower_OfflaneT3_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	GUICtrlCreateLabel("", 0, 20, $labelWidth / 2, $labelHeight)             ; Empty Space
	; Enemy
	$ctrlOffT1_Enemy = GUICtrlCreateLabel("E-T1: " & $guiTower_OfflaneT1_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlOffT2_Enemy = GUICtrlCreateLabel("E-T2: " & $guiTower_OfflaneT2_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlOffT3_Enemy = GUICtrlCreateLabel("E-T3: " & $guiTower_OfflaneT3_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	; Mid
	GUICtrlCreateGroup("Mid", 100, -140, 100, 170)
	; Frindly
	$ctrlMidT1_Frindly = GUICtrlCreateLabel("F-T1: " & $guiTower_MidT1_Frindly, 5, 20, $labelWidth / 2, $labelHeight)
	$ctrlMidT2_Frindly = GUICtrlCreateLabel("F-T2: " & $guiTower_MidT2_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlMidT3_Frindly = GUICtrlCreateLabel("F-T3: " & $guiTower_MidT3_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	GUICtrlCreateLabel("", 0, 20, $labelWidth / 2, $labelHeight)             ; Empty Space
	; Enemy
	$ctrlMidT1_Enemy = GUICtrlCreateLabel("E-T1: " & $guiTower_MidT1_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlMidT2_Enemy = GUICtrlCreateLabel("E-T2: " & $guiTower_MidT2_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlMidT3_Enemy = GUICtrlCreateLabel("E-T3: " & $guiTower_MidT3_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	; Safelane
	GUICtrlCreateGroup("Safelane", 100, -140, 100, 170)
	; Frindly
	$ctrlSafelaneT1_Frindly = GUICtrlCreateLabel("F-T1: " & $guiTower_SafeLaneT1_Frindly, 5, 20, $labelWidth / 2, $labelHeight)
	$ctrlSafelaneT2_Frindly = GUICtrlCreateLabel("F-T2: " & $guiTower_SafeLaneT2_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlSafelaneT3_Frindly = GUICtrlCreateLabel("F-T3: " & $guiTower_SafeLaneT3_Frindly, 0, 20, $labelWidth / 2, $labelHeight)
	GUICtrlCreateLabel("", 0, 20, $labelWidth / 2, $labelHeight)             ; Empty Space
	; Enemy
	$ctrlSafelaneT1_Enemy = GUICtrlCreateLabel("E-T1: " & $guiTower_SafeLaneT1_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlSafelaneT2_Enemy = GUICtrlCreateLabel("E-T2: " & $guiTower_SafeLaneT2_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
	$ctrlSafelaneT3_Enemy = GUICtrlCreateLabel("E-T3: " & $guiTower_SafeLaneT3_Enemy, 0, 20, $labelWidth / 2, $labelHeight)
EndFunc   ;==>_GUITowers

Func _setGUITowers($setFrindlyTowers, $setEnemyTowers)

	If Not (IsArray($setFrindlyTowers) And IsArray($setEnemyTowers)) Then
		Return False
	EndIf
	; Frindly Towers
	; Offlane
	; GUICtrlSetData($ctrlColor, "Color: " & $setColor)
	GUICtrlSetData($ctrlOffT1_Frindly, "F-T1: " & $setFrindlyTowers[0])
	GUICtrlSetData($ctrlOffT2_Frindly, "F-T2: " & $setFrindlyTowers[1])
	GUICtrlSetData($ctrlOffT3_Frindly, "F-T3: " & $setFrindlyTowers[2])
	; Mid
	GUICtrlSetData($ctrlMidT1_Frindly, "F-T1: " & $setFrindlyTowers[3])
	GUICtrlSetData($ctrlMidT2_Frindly, "F-T2: " & $setFrindlyTowers[4])
	GUICtrlSetData($ctrlMidT3_Frindly, "F-T3: " & $setFrindlyTowers[5])
	; Safelane
	GUICtrlSetData($ctrlSafelaneT1_Frindly, "F-T1: " & $setFrindlyTowers[6])
	GUICtrlSetData($ctrlSafelaneT2_Frindly, "F-T2: " & $setFrindlyTowers[7])
	GUICtrlSetData($ctrlSafelaneT3_Frindly, "F-T3: " & $setFrindlyTowers[8])

	; Enemy Towers
	; Offlane
	GUICtrlSetData($ctrlOffT1_Enemy, "E-T1: " & $setEnemyTowers[0])
	GUICtrlSetData($ctrlOffT2_Enemy, "E-T2: " & $setEnemyTowers[1])
	GUICtrlSetData($ctrlOffT3_Enemy, "E-T3: " & $setEnemyTowers[2])
	; Mid
	GUICtrlSetData($ctrlMidT1_Enemy, "E-T1: " & $setEnemyTowers[3])
	GUICtrlSetData($ctrlMidT2_Enemy, "E-T2: " & $setEnemyTowers[4])
	GUICtrlSetData($ctrlMidT3_Enemy, "E-T3: " & $setEnemyTowers[5])
	; Safelane
	GUICtrlSetData($ctrlSafelaneT1_Enemy, "E-T1: " & $setEnemyTowers[6])
	GUICtrlSetData($ctrlSafelaneT2_Enemy, "E-T2: " & $setEnemyTowers[7])
	GUICtrlSetData($ctrlSafelaneT3_Enemy, "E-T3: " & $setEnemyTowers[8])
EndFunc   ;==>_setGUITowers

Func _GUIHero()
	Local $guiColor = ""
	Local $guiPosition = ""
	Local $guiLevel = ""
	Local $guiHealth = ""
	Local $guiDead = ""
	; Main Group
	GUICtrlCreateGroup("Player Values", 10, 5, 200, 200)
	; Group GUI
	$ctrlColor = GUICtrlCreateLabel("Color: " & $guiColor, 5, 20, $labelWidth, $labelHeight)
	$ctrlPosition = GUICtrlCreateLabel("Position: " & $guiPosition, 0, 20, $labelWidth, $labelHeight)
	$ctrlLevel = GUICtrlCreateLabel("Level: " & $guiLevel, 0, 20, $labelWidth, $labelHeight)
	$ctrlHealth = GUICtrlCreateLabel("Low-Health: " & $guiHealth, 0, 20, $labelWidth, $labelHeight)
	$ctrlDead = GUICtrlCreateLabel("Dead: " & $guiDead, 0, 20, $labelWidth, $labelHeight)
EndFunc   ;==>_GUIHero

Func _setGUIHero($setColor, $setPosition, $setLevel, $setHealth, $setDead)
	Local $sPosition
	; Build Position String - Array or Non array
	If IsArray($setPosition) Then
		$sPosition = "Position: " & "X" & $setPosition[0] & " Y" & $setPosition[1]
	Else
		$sPosition = "Position: " & $setPosition
	EndIf
	GUICtrlSetData($ctrlColor, "Color: " & $setColor)
	GUICtrlSetColor($ctrlColor, $setColor)
	GUICtrlSetData($ctrlPosition, $sPosition)
	GUICtrlSetData($ctrlLevel, "Level: " & $setLevel)
	GUICtrlSetData($ctrlHealth, "Low-Health: " & $setHealth)
	GUICtrlSetData($ctrlDead, "Dead: " & $setDead)
EndFunc   ;==>_setGUIHero

Func _exitButton()
	Exit
EndFunc   ;==>_exitButton
