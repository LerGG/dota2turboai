#include <Array.au3>
#include <TurboAIConst.au3>
#include <TurboAIHelpFunctions.au3>
#include <TurboAIFunctions.au3>
#include <TurboAIDraftFunctions.au3>
#include <TurboAIGameFunctions.au3>
#include <TurboAIGUI.au3>

; BINDINGS
HotKeySet("{F7}", "_exit")

; Ingame State Variables
Global $arrTeamColors = -1
Global $arrEnemyColors = -1
Global $bStateFaction = -1
Global $bStateIngame = False
Global $bPreGame = False

Global $arrTowersEnemy_X = 0
Global $arrTowersEnemy_Y = 0
Global $arrTowersEnemy
Global $arrTowersFrindly_X = 0
Global $arrTowersFrindly_Y = 0
Global $arrTowersFrindly
Global $arrTowerStateEnemy
Global $arrTowerStateFrindly
Global $posRespawn = 0
Global $arrOwnNeutralCamps_X = -1
Global $arrOwnNeutralCamps_Y = -1

; Player variables
Global $posPlayer = 0
Global $colorPlayer = 0
Global $playerLevel = 0
Global $playerLowHealth = False
Global $playerDead = False

Global $enemyHeroVisible = False

; Timer
Global $hTimer = 0
Global $active_timer = True

; Items
Global $salveDelivery = False

; #MAIN# ==============================================================================================================
; # Script Main Loop
; #====================================================================================================================
; Renders inital GUI GUI
_renderGUI()
While 1
	Sleep(50)
	_main()
WEnd

Func _main()
	_mainMenu()
EndFunc   ;==>_main

; #FUNCTION# ====================================================================================================================
; Name ..........: _timerMainMenu
; Description ...: Starts timer when main menu is found.
; Syntax ........: _timerMainMenu()
; ===============================================================================================================================
Func _timerMainMenu()
	If _checkMainMenu() Then
		If $active_timer = True Then
			$hTimer = TimerInit()
		EndIf
		$active_timer = False
		Return
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _startGametime
; Description ...: Starts timer if ingame
; Syntax ........: _startGametime()
; Return values .: None
; ===============================================================================================================================
Func _startGametime()
	If _checkIngame() = True and $active_timer = False Then
		$hTimer = TimerInit()
		$active_timer = True
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkFaction
; Description ...: Set global variable for faction.
; Syntax ........: _checkFaction()
; ===============================================================================================================================
Func _setFaction()
	If _checkRadiant() = True Then
		$bStateFaction = True ; True = Radiant
		_addEntryGUILog("_checkRadiant(): Radiant", $hTimer)
	ElseIf _checkDire() = True Then
		$bStateFaction = False ; False = Dire
		_addEntryGUILog("_checkRadiant(): Dire", $hTimer)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setTeamColors
; Description ...:  Sets Team colors
; Syntax ........: _setTeamColors()
; ===============================================================================================================================
Func _setTeamColors()
	; Set Radiant
	If $bStateFaction = True Then
		$arrTeamColors = $arrColorPlayersRadiant
		$arrEnemyColors = $arrColorPlayersDire
		_addEntryGUILog("_setTeamColors(): Radiant", $hTimer)
	EndIf
	; Set Dire
	If $bStateFaction = False Then
		$arrTeamColors = $arrColorPlayersDire
		$arrEnemyColors = $arrColorPlayersRadiant
		_addEntryGUILog("_setTeamColors(): Dire", $hTimer)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setPlayerColor
; Description ...:  Determines player color at game start
; Syntax ........: _setPlayerColor()
; ===============================================================================================================================
Func _setPlayerColor()

	; Stores playerposition color
	Local $colorTemp

	While $colorPlayer = 0 and _checkIngame() = True
		_addEntryGUILog("_setPlayerColor(): Searching", $hTimer)
		; Radiant Base Movement
		If $bStateFaction = True Then
			; Select Hero
			Send("1")
			Sleep(500)
			Local $pos1 = _buildPoint(75,1054)
			_AttackAndMovement(0,$pos1)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer, $hTimer)
				ExitLoop
			EndIf

			Local $pos2 = _buildPoint(64,1015)
			_AttackAndMovement(0,$pos2)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer,$hTimer)
				ExitLoop
			EndIf
			Local $pos3 = _buildPoint(50,1004)
			_AttackAndMovement(1,$pos3)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer, $hTimer)
				ExitLoop
			EndIf
			Local $pos4 = _buildPoint(35,997)
			_AttackAndMovement(1,$pos4)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer, $hTimer)
				ExitLoop
			EndIf
			Local $pos5 = _buildPoint(12,997)
			_AttackAndMovement(1,$pos5)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer, $hTimer)
				ExitLoop
			EndIf

			Local $pos6 = _buildPoint(19,1042)
			_AttackAndMovement(1,$pos6)
			Sleep(Random(3500,5000))
			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer, $hTimer)
				ExitLoop
			EndIf
		EndIf

		; Dire Base Movement
		If $bStateFaction = False Then
			Send("1")
			Local $pos1 = _buildPoint(194,826)
			_AttackAndMovement(1,$pos1)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf
			Local $pos2 = _buildPoint(200,865)
			_AttackAndMovement(1,$pos2)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf
			Local $pos3 = _buildPoint(226,889)
			_AttackAndMovement(1,$pos3)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf
			Local $pos4 = _buildPoint(265,892)
			_AttackAndMovement(1,$pos4)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf
			Local $pos5 = _buildPoint(262,842)
			_AttackAndMovement(1,$pos5)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf

			Local $pos6 = _buildPoint(237,827)
			_AttackAndMovement(1,$pos6)
			Sleep(Random(3500,5000))

			$colorTemp = _findPlayerColor($arrTeamColors,$colorPlayer)
			If $colorTemp > 0 Then
				$colorPlayer = $colorTemp
				_addEntryGUILog("_setPlayerColor(): " & $colorPlayer  , $hTimer)
				ExitLoop
			EndIf
		EndIf
	WEnd
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setBuildings
; Description ...: Set inital tower states for enemy and frindly buildings
; Syntax ........: _setBuildings()
; ===============================================================================================================================
Func _setBuildings()
	; Set Radiant Side
	If $bStateFaction = True Then
		; Enemy Towers
		$arrTowersEnemy_X = $arrDire_Tower_PosX
		$arrTowersEnemy_Y = $arrDire_Tower_PosY
		$arrTowersEnemy = _buildPointArray($arrDire_Tower_PosX, $arrDire_Tower_PosY)
		; Frindly Towers
		$arrTowersFrindly_X = $arrRadiant_Tower_PosX
		$arrTowersFrindly_Y = $arrRadiant_Tower_PosY
		$arrTowersFrindly = _buildPointArray($arrTowersFrindly_X, $arrTowersFrindly_Y)
	EndIf
	; Set Dire Side
	If $bStateFaction = False Then
		; Enemy Towers
		$arrTowersEnemy_X = $arrRadiant_Tower_PosX
		$arrTowersEnemy_Y = $arrRadiant_Tower_PosY
		$arrTowersEnemy = _buildPointArray($arrTowersEnemy_X,$arrTowersEnemy_Y)
		; Frindly Towers
		$arrTowersFrindly_X = $arrDire_Tower_PosX
		$arrTowersFrindly_Y = $arrDire_Tower_PosY
		$arrTowersFrindly = _buildPointArray($arrTowersFrindly_X,$arrTowersFrindly_Y)
	EndIf
	_addEntryGUILog("_setBuildings(): Frindly/Enemy Set", $hTimer)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setBuildingStates
; Description ...: Generates building states for all towers ingame
; Syntax ........: _setBuildingStates()
; ===============================================================================================================================
Func _setBuildingStates()
	$arrTowerStateEnemy = _generateBuildingState(0,$arrTowersEnemy_X,$arrTowersEnemy_Y)
	$arrTowerStateFrindly = _generateBuildingState(1,$arrTowersFrindly_X,$arrTowersFrindly_Y)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setThrone
; Description ...: Set respawn coordinates
; Syntax ........: _setThrone()
; ===============================================================================================================================
Func _setThrone()
	; Set Radiant Throne Position
	If $bStateFaction = True Then
		$posRespawn = $arrRadiantThrone
		_addEntryGUILog("_setThrone(): Radiant", $hTimer)
	EndIf
	; Set Dire Throne Position
	If $bStateFaction = False Then
		$posRespawn = $arrDireThrone
		_addEntryGUILog("_setThrone(): Dire", $hTimer)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _setOwnNeutralcampPositions
; Description ...: Set neutral camp positions
; Syntax ........: _setOwnNeutralcampPositions()
; ===============================================================================================================================
Func _setNeutralcampPositions()
	; Set Radiant neutral Positions
	If $bStateFaction = True Then
		$arrOwnNeutralCamps_X = $arrRadiantCamps_X
		$arrOwnNeutralCamps_Y = $arrRadiantCamps_Y
	EndIf
	; Set Radiant neutral Positions
	If $bStateFaction = False Then
		$arrOwnNeutralCamps_X = $arrDireCamps_X
		$arrOwnNeutralCamps_Y = $arrDireCamps_Y
	EndIf
	_addEntryGUILog("_setNeutralcampPositions(): Own Jungle Set", $hTimer)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _initateGame
; Description ...: Initiate ingame state
; Syntax ........: _initateGame()
; ===============================================================================================================================
Func _initateGame()
	If $bStateIngame = False and _checkIngame() = True Then
		_addEntryGUILog("_initateGame(): Start", $hTimer)
		$bStateIngame = True
		_clearEntriesGUILog()
		_startGametime()
		Sleep(3000) ; wait load screen
		_setFaction()
		_setTeamColors()
		_setThrone()
		_setBuildings()
		Send("1") ; Selects hero
		_AttackAndMovement(0, $posRespawn)
		Send("1") ; Selects hero
		_AttackAndMovement(0, $posRespawn)
		sleep(12000)
		_setPlayerColor()
		_setNeutralcampPositions()
		_addEntryGUILog("_initateGame(): Complete", $hTimer)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _playGame
; Description ...:  Plays game if ingame
; Syntax ........: _playGame()
; ===============================================================================================================================
Func _playGame()

	If $bStateingame = True and _checkIngame() = True Then
		; Clear log every minute to prevent overflow
		If Mod(_convertTimer($hTimer), 60) = 0 Then
			_clearEntriesGUILog()
		EndIf
		_preGame()
		_setBuildingStates()
		_dead()
		_heal()
		Local $bLevel = _skillHero($playerLevel)
		; Updates player level
    	If $bLevel = True Then
        	$playerLevel += 1			
    	EndIf

		; Send quickbuy
		If Mod(_convertTimer($hTimer), 10) = 0 Then
			Send("t")
		EndIf

		; Buy Items
		If Mod(_convertTimer($hTimer), 30) = 0 Then
			_buyItems()
			_addEntryGUILog("_buyItems: Buying Items", $hTimer)
		EndIf

		; Findplayer 
		$posPlayer = _findplayerPosition($colorPlayer)
		_addEntryGUILog("_findplayerPosition: Farm Neutrals", $hTimer)
		If IsArray ($posPlayer) Then
			Local $posCampTemp = _findNextCamp($posPlayer, $arrOwnNeutralCamps_X, $arrOwnNeutralCamps_Y)
			_addEntryGUILog("_findNextCamp: Next Camp returned", $hTimer)
			If isArray ($posCampTemp) Then
				_AttackAndMovement(1,$posCampTemp)
			EndIf
		EndIf

		; Dodge enemy players
		$enemyHeroVisible = _findEnemyHealthBar($iColor_EnemyHeroHP, 1)
		If IsArray($enemyHeroVisible) = True Then
			Local $iTimer = 0
			; use all spells on enemy
			_MouseMove($enemyHeroVisible)
			Send("v")
			Sleep(Random(50,70,1))
			Send("y")
			Sleep(Random(50,70,1))
			Send("x")
			Sleep(Random(50,70,1))
			Send("c")
			Sleep(Random(50,70,1))
			Do
				If IsArray($posPlayer) Then
					$posNextTower = _findNextTower($posPlayer, $arrTowersFrindly_X, $arrTowersFrindly_Y, $arrTowerStateFrindly)
					If IsArray($posNextTower) Then
						_AttackAndMovement(0,$posNextTower)
					ElseIf Not(IsArray($posNextTower)) Then
						_AttackAndMovement(0,$posRespawn)
					EndIf
					ElseIf Not(IsArray($posPlayer)) Then
						_AttackAndMovement(0,$posRespawn)
				EndIf
				$enemyHeroVisible = _findEnemyHealthBar($iColor_EnemyHeroHP, 0)
				$iTimer += 1
				_addEntryGUILog("_findEnemyHeroBar: Dodge Enemy Player", $hTimer)
			Until IsArray($enemyHeroVisible) = False OR $iTimer = 5 OR _checkinGame() = False
		EndIf

		_attackVisibleCreeps($iColor_EnemyCreepHpBar, $iColor_EnemyCreepMissingHP)
		
		; Updates Gui
		_setGUIHero($colorPlayer,$posPlayer,$playerLevel,$playerLowHealth,$playerDead)
		_setGUIGame($bStateIngame,_convertTimer($htimer),$bStateFaction)
		_setGUITowers($arrTowerStateFrindly,$arrTowerStateEnemy)

		; Recursion while ingame
		Return _playGame() 
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ===========================================================================================================m111169874303a169874303a=========
; Name ..........: _resetGame
; Description ...: Resets ingame state
; Syntax ........: _resetGame()
; ===============================================================================================================================
Func _resetGame()
	If $bStateIngame = True and _checkIngame() = False Then
		_addEntryGUILog("_resetGame(): Started", 0)
		$bStateIngame = False
		$bstateFaction = -1
		$arrTeamColors = -1
		$colorPlayer = 0
		$arrTowersEnemy_X = 0
		$arrTowersEnemy_Y = 0
		$arrTowersFrindly_X = 0
		$arrTowersFrindly_Y = 0
		$arrTowerStateEnemy = 0
		$arrTowersEnemy = 0
		$arrTowersFrindly = 0
		$arrTowerStateFrindly = 0
		$arrOwnNeutralCamps_X = -1
		$arrOwnNeutralCamps_Y = -1
		$posPlayer = 0
		$playerLevel = 0
		$playerHealth = True
		$playerDead = False
		$enemyHeroVisible = False
		$preGame = False
		_addEntryGUILog("_resetGame(): Complete", 0)
		_clearEntriesGUILog()
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _dead
; Description ...: Checks if dead, Pauses and queues actions after death
; Syntax ........: _dead()
; ===============================================================================================================================
Func _dead()
	; Sets Global State
	$playerDead = _checkDead()
	If $playerDead = True Then
		_chatWheel()
		_addEntryGUILog("_dead(): Dead", $hTimer)
		Do
			Sleep(100)
		Until _checkDead() = False
		_addEntryGUILog("_dead(): Respawn", $hTimer)
		$posPlayer = $posRespawn
		_AttackAndMovement(0,$posRespawn)
 		sleep(random(1000,1500,1))
		_useTP($arrTowersFrindly[Random(0,8,1)])
		_addEntryGUILog("_dead(): TP to Random Tower ", $hTimer) 
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _preGame
; Description ...: Pre game actions
; Syntax ........: _preGame()
; ===============================================================================================================================
Func _preGame()
	; Pre Game
	If $bPreGame = False AND _convertTimer($htimer) > 25 AND _convertTimer($htimer) < 65 Then
		; Move Hero to random T1 Tower
		Local $towerPos
		Local $randomNumber = Random(1,3,1)
		If $randomNumber = 1 Then
			$towerPos = $arrTowersFrindly[0] ; Off
		EndIf
		If $randomNumber = 2 Then
			$towerPos = $arrTowersFrindly[3] ; Mid
		EndIf
		If $randomNumber = 3 Then
			$towerPos = $arrTowersFrindly[6] ; Safe
		EndIf
		$towerPos[0] += 5
		$towerPos[1] += 5
		_AttackAndMovement(0,$towerPos)
		$bPreGame = True 
		_addEntryGUILog("_preGame(): Complete ", $hTimer)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _push
; Description ...: Push function if enemy is afk
; Syntax ........: _push()
; ===============================================================================================================================
Func _push()
	; Check if mid tower is up
	If $arrTowerStateFrindly[3] = 1 Then
		; Wave arrive in middle
		If (_convertTimer($hTimer) > 82) and $arrTowerStateEnemy[3] = 1 Then
			; Attack T1 midlane and wave
			_AttackAndMovement(1,$arrTowersEnemy[3]) ; T1
		EndIf
		If $arrTowerStateEnemy[3] = 0 Then
			; Attack T2 midlane and wave
			_AttackAndMovement(1,$arrTowersEnemy[4]) ; T2

		EndIf
		If $arrTowerStateEnemy[4] = 0 Then
			; Attack T3 midlane and wave
			_AttackAndMovement(1,$arrTowersEnemy[5]) ; T3
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _defend
; Description ...: Defend function if enemy team is pushing
; Syntax ........: _defend()
; ===============================================================================================================================
Func _defend()
	Local $posNextCamp
	; Check if mid tower is down
	If $arrTowerStateFrindly[3] = 0 Then
		$posPlayer = _findplayerPosition($colorPlayer)
		If IsArray($posplayer) Then
			$posNextCamp = _findNextCamp($posPlayer,$arrCamps_X,$arrCamps_Y)
			_AttackAndMovement(1,$posNextCamp)
		Else
			$posNextCamp = _findNextCamp($posRespawn,$arrCamps_X,$arrCamps_Y)
			_AttackAndMovement(1,$posNextCamp)
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _heal
; Description ...: Checks for low health and retreats / heals hero.
; Syntax ........: _heal()
; ===============================================================================================================================
Func _heal()
	Local $posNextTower
	Local $iTimer = 0
	$playerLowHealth = _checkLowHealth()
	If $playerLowHealth = True Then
		_chatWheel()
		_addEntryGUILog("_heal(): Low Health", $hTimer)
		; Move to next tower or base
		$posPlayer = _findplayerPosition($colorPlayer)
		If IsArray($posPlayer) Then
			$posNextTower = _findNextTower($posPlayer, $arrTowersFrindly_X, $arrTowersFrindly_Y, $arrTowerStateFrindly)
			If IsArray($posNextTower) Then
				_AttackAndMovement(0,$posNextTower)
			ElseIf Not(IsArray($posNextTower)) Then
				_AttackAndMovement(0,$posRespawn)
			EndIf
		ElseIf Not(IsArray($posPlayer)) Then
			_AttackAndMovement(0,$posRespawn)
		EndIf
		; Check if salve is already delivered
		If $salveDelivery = False AND _checkDead() = False Then
			_buysalve()
			$salveDelivery = True
			_addEntryGUILog("_heal(): Salve Delivery", $hTimer)
			Do 
				Sleep(100)
				$iTimer += 1
			Until _useSalve() = True OR $iTimer = 100 OR _checkDead() = True ; Exit loop after 10 sec
			_addEntryGUILog("_heal(): Salve Used or Timer", $hTimer)
			$salveDelivery = False
			$iTimer = 0
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _mainMenu
; Description ...:  Holds Main Menu Functions
; Syntax ........: _mainMenu()
; Return values .: None
; ===============================================================================================================================
Func _mainMenu()
	_timerMainMenu()
	_acceptReadyCheck()
	_acceptGame()
	_draft()
	_initateGame()
	_playGame()
	_resetGame()
EndFunc