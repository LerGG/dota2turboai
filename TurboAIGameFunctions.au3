#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTuBe

 Script Function:
	Ingame Functions

#ce ----------------------------------------------------------------------------

#include <TurboAIConst.au3>
#include <TurboAIHelpFunctions.au3>
#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _AttackAndMovement
; Description ...:
; Syntax ........: _AttackAndMovement($bAttack, $Pos)
; Parameters ....: $bAttack             - 0 = Move; 1 = Attack
;                  $Pos                 - Position
; ===============================================================================================================================
Func _AttackAndMovement($bAttack, $Pos)
	; Expcetion
	If Not IsArray($Pos) Then
		_tt("_AttackAndMovement: $pos is no Array")
		sleep(1000)
		return
	EndIf
	; Attack Move
	If $bAttack = 1 Then
		MouseMove($Pos[0], $Pos[1])
		Send("a")
	ElseIf $bAttack = 0 Then
		MouseMove($Pos[0], $Pos[1])
		Send("m")
		; Needed to complete movement (To fast update = no movement = might stuck)
		Sleep(Random(800,900))
	Else
		_MsgBox("_AttackAndMovement: Wrong Attack Parameter")
		Exit
	EndIf
EndFunc   ;==>_AttackAndMovement

Func _attackVisibleCreeps($colorFullHP,$colorDamagedHP)
	; Scan for creeps
	$enemyVisiblePos = _findEnemyHealthBar($colorFullHP, 1) 
	If IsArray($enemyVisiblePos) Then
		; Variables
		Local $tempPosAttack_1 = 0
		Local $tempPosAttack_2 = 0
		Local $colorCount_1 = 0
		Local $colorCount_2 = 0
		; Exit timer
		Local $hLoopTimer = TimerInit()
		do 

			$tempPosAttack_1 = _pointPixelsearch($enemyVisiblePos,150,100,$colorFullHP,3,2) 
			$tempPosAttack_2 = _pointPixelsearch($enemyVisiblePos,150,100,$colorDamagedHP,3,2)

			; Scan to right
			if IsArray ($tempPosAttack_1) Then
				For $i = 0 to 7 
					Local $tempPos = PixelSearch($tempPosAttack_1[0]+$i,$tempPosAttack_1[1], $tempPosAttack_1[0]+$i,$tempPosAttack_1[1],$colorFullHP,3)
					If IsArray($tempPos) Then
						$colorCount_1 = $colorcount_1 + 1
					EndIf
					If $colorCount_1 > 3 Then
						_MouseMove($tempPosAttack_1)
						ExitLoop
					EndIf
				Next
			EndIf
			; Scan to left
			If IsArray ($tempPosAttack_2) Then
				For $i = 0 to 7 
					Local $tempPos = PixelSearch($tempPosAttack_2[0]+$i,$tempPosAttack_2[1], $tempPosAttack_2[0]+$i,$tempPosAttack_2[1],$colorDamagedHP,3)
					If IsArray($tempPos) Then
						$colorCount_1 = $colorcount_1 + 1
					EndIf
					If $colorCount_1 > 3 Then
						_MouseMove($tempPosAttack_2)
						ExitLoop
					EndIf
				Next
			EndIf

		Until $tempPosAttack_1 = False AND $tempPosAttack_2 = False OR _checkLowHealth() = True OR _convertTimer($hLoopTimer) > 30 OR _checkinGame() = False
		$hLoopTimer = 0 ; Clear loop timer
	EndIf
EndFunc

Func _chatWheel()
	Send("{j down}")
	Sleep(100)
	; Hero Laugh
	MouseMove(@DeskTopWidth/2,(@DeskTopHeight/2)-(@DeskTopHeight/4))
	Sleep(100)
    Send("{j up}")
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkDead
; Syntax ........: _checkDead()
; Return values .: False = Alive ; True = Dead
; ===============================================================================================================================
Func _checkDead()
	Local $Pos = PixelSearch(731, 1020, 736, 1041, $color_lowHealth, 5)
	If IsArray($Pos) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkDead

; #FUNCTION# ===================================================================
; Name ..........: _checkinGame
; Description ...: Checks if in-game
; Syntax ........: _checkinGame()
; Return values .: True = in-game; False
; ==============================================================================
Func _checkinGame()
	Local $cs_current = PixelChecksum(130,800,135,805)
	If $cs_current = $cs_ingame OR $cs_current = $cs_ingame_simpleBG Then
		Return True
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkRadiant
; Description ...: Checks if spawned on Radiant Side
; Syntax ........: _checkRadiant()
; Return values .: True = Radiant ; False = Not Found
; ===============================================================================================================================
Func _checkRadiant()
	; Radiant Base
	If IsArray(PixelSearch(10, 996, 73, 1057, 7923201, 3)) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkRadiant

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkDire
; Description ...: Checks if spawned on Radiant Side
; Syntax ........: _checkDire()
; Return values .: True = Dire ; False not Found
; ===============================================================================================================================
Func _checkDire()
	; Dire Base
	If IsArray(PixelSearch(193, 815, 265, 893, 7923201, 3)) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkDire

; #FUNCTION# ====================================================================================================================
; Name ..........: _generateBuildingState
; Description ...:	Iterates building position arrays and checks if up or down
; Syntax ........: _generateBuildingState($bIsFrindly, $arrX, $arrY, $iArrLengths)
; Parameters ....: $bIsFrindly          - 0 = enemy; 1 = Frindly
;                  $arrX                - Array with X Coordinates
;                  $arrY                - Array with Y Coordinates
; Return values .: Array with Building States; 0 or 1
; ===============================================================================================================================
Func _generateBuildingState($bIsFrindly, $arrX, $arrY)
	; Exception Handling
	If IsArray($arrX) And IsArray($arrY) And UBound($arrX) = UBound($arrY) Then
		Local $iArrLength = UBound($arrX)
		; Initialize Array Range
		Local $iBuildingStates[$iArrLength]
		; Check building state for every Index
		For $i = 0 To $iArrLength - 1
			Local $pos_current = _buildPoint($arrX[$i], $arrY[$i])
			$iBuildingStates[$i] = _checkBuildingState($bIsFrindly, $pos_current)
		Next
		Return $iBuildingStates
	Else
		_tt(" _generateBuildingState: Wrong Data Type or Array Length not Matching")
		Return 0
	EndIf
EndFunc   ;==>_generateBuildingState

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkBuildingState
; Description ...: Checks a Coordinate on Minimap for Building status
; Syntax ........: _checkBuildingState($bIsFrindly, $Pos)
; Parameters ....: $bIsFrindly          - 0 = Enemy; 1 = Frindly; Use 0,1
;                  $Pos                 - Building position on Minimap
; Return values .: True if Up / False if down
; ===============================================================================================================================
Func _checkBuildingState($bIsFrindly, $Pos)

	; Check Exceptions
	If IsArray($Pos) And ($bIsFrindly = 0 Or $bIsFrindly = 1) Then
		; Frindly Building
		If $bIsFrindly = 1 Then
			Local $posTemp
			$posTemp = _pointPixelsearch($Pos, 10, 10, $iColor_Frindly_Building, 2, 1)
			If IsArray($posTemp) Then
				Return 1
			Else
				Return 0
			EndIf
			; Enemy Building
		ElseIf $bIsFrindly = 0 Then
			Local $posTemp
			$posTemp = _pointPixelsearch($Pos, 5, 5, $iColor_Enemy_Building, 1, 1)
			If IsArray($posTemp) Then
				Return 1
			Else
				Return 0
			EndIf
		EndIf
	Else
		; Exception
		_MsgBox("_checkBuildingState Wrong Parameters")
		Exit
	EndIf
EndFunc   ;==>_checkBuildingState

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkTP
; Description ...: Checks TP slot for TP cooldown
; Syntax ........: _checkTP()
; Return values .: True = Found; False = Not Found
; ===============================================================================================================================
Func _checkTP()
	Local $iColorTpScroll = PixelGetColor(1321,1043)
	If $color_TPScrollReady = $iColorTpScroll Then
		Return True
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkLevelUp
; Syntax ........: _checkLevelUp()
; Return values .: True / False
; ===============================================================================================================================
Func _checkLevelUp()
    ; Positions for 4 Skill Heroes
    ; Q W E ULTIMATE TALENT
	Local $Pos1 = PixelSearch(829,920, 829,920, $iColorLevelUp, 2)
    Local $Pos2 = PixelSearch(894,920, 894,920, $iColorLevelUp, 2)
    Local $Pos3 = PixelSearch(958,920, 958,920, $iColorLevelUp, 2)
    Local $Pos4 = PixelSearch(1024,920, 1024,920, $iColorLevelUp, 2)
    Local $Pos5 = PixelSearch(761,919,761,919, $iColorLevelUp, 2)
	If IsArray($Pos1) _ 
        OR IsArray($Pos2) _ 
        OR IsArray($Pos3) _ 
        OR IsArray($Pos4) _ 
        OR IsArray($Pos5) Then
		Return True
    EndIf

    ; Positions for 5 Skill Heroes
    ; Q W E ULTIMATE TALENT
    $Pos1 = PixelSearch(811,920, 811,920, $iColorLevelUp, 1)
    $Pos2 = PixelSearch(868,920, 868,920, $iColorLevelUp, 1)
    $Pos3 = PixelSearch(926,920, 926,920, $iColorLevelUp, 1)
    $Pos4 = PixelSearch(1042,920, 1042,920, $iColorLevelUp, 1)
    $Pos5 = PixelSearch(746,919,746,919, $iColorLevelUp, 1)
	If IsArray($Pos1) _ 
        OR IsArray($Pos2) _ 
        OR IsArray($Pos3) _ 
        OR IsArray($Pos4) _ 
        OR IsArray($Pos5) Then
		Return True
    EndIf
	Return False
EndFunc   ;==>_checkLevelUp

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkLowHealth
; Description ...: Checks if health is low
; Syntax ........: _checkLowHealth()
; Return values .: True = Low; False = Not Low
; ===============================================================================================================================
Func _checkLowHealth()
	If IsArray(PixelSearch(736,1020, 811,1022, $color_lowHealth, 2)) Then
		Return True
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _CreepFightExist
; Description ...:  Checks if Creep Waves are connetcted
; Syntax ........: _CreepFightExist($Pos)
; Parameters ....: $Pos                 - Wave Position
; Return values .: True / False
; ===============================================================================================================================
Func _CreepFightExist($Pos)
	_exceptionPosition($Pos,"_CreepFightExist")
	Local $creepShade = 4
	Local $Offset = 20
	If _MiniMapMarkerExist($iColor_Enemy_Unit, $Pos, $Offset, $creepShade) And _MiniMapMarkerExist($iColor_Frindly_Creep, $Pos, $Offset, $creepShade) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_CreepFightExist

; #FUNCTION# ====================================================================================================================
; Name ..........: _MiniMapMarkerExist
; Description ...: Searches around a position for a given color in offset range
; Syntax ........: _MiniMapMarkerExist($iColor, $Pos, $iOffset)
; Parameters ....: $iColor              - Color to search for.
;                  $Pos                 - Position to seach around.
;                  $iOffset             - Position Offset to create Rectangles
; Return values .: True if Marker Exist Else False
; ===============================================================================================================================
Func _MiniMapMarkerExist($iColor, $Pos, $iOffset, $iShade)
	; Exception
	If Not IsArray($Pos) Then
		_MsgBox("_MiniMapMarkerExist: $Pos non Array")
		Exit
	EndIf
	Local $posTemp
	; Build Top Rectangle
	Local $posX1_up = $Pos[0] - $iOffset
	Local $posY1_up = $Pos[1] - $iOffset
	Local $posX2_up = $Pos[0] + $iOffset
	Local $posY2_up = $Pos[1]
	; Build Bottom Rectangle
	Local $posX1_down = $Pos[0] - $iOffset
	Local $posY1_down = $Pos[1]
	Local $posX2_down = $Pos[0] + $iOffset
	Local $posY2_down = $Pos[1] + $iOffset
	; Check Top Rectangle
	$posTemp = PixelSearch($posX1_up, $posY1_up, $posX2_up, $posY2_up, $iColor, $iShade)
	If IsArray($posTemp) Then
		Return True
	EndIf
	; Check Bottom Rectangle
	$posTemp = PixelSearch($posX1_down, $posY1_down, $posX2_down, $posY2_down, $iColor, $iShade)
	If IsArray($posTemp) Then
		Return True
	EndIf
	Return False
EndFunc   ;==>_MiniMapMarkerExist

; #FUNCTION# ====================================================================================================================
; Name ..........: _findPlayerColor
; Description ...: Find the color the player is currently playing
; Syntax ........: _findPlayerColor($arrColors)
; Parameters ....: $arrColors           - Array with all possible player colors.
; Return values .: Color of Player Unit; 0 if not found
; ===============================================================================================================================
Func _findPlayerColor($arrColors,$iColor)
	Local $iColorCurrent
	Local $posCurrentColor
	Local $posTemp
	; Iterate Player Colors
	For $i = 0 To UBound($arrColors) - 1
		; Grab Player Colors
		$iColorCurrent = $arrColors[$i]
		; Get current color minimap position
		$posCurrentColor = _findPlayerPosition($iColorCurrent)
		; If found, search in offset range for white circle around player
		If IsArray($posCurrentColor) Then
			$posTemp = _pointPixelsearch($posCurrentColor, 10, 10, $iColorPlayerCircle, 5,1)
			If IsArray($posTemp) Then
				Return $iColorCurrent
			EndIf
		EndIf
	Next
	; Exception
	If Not IsArray($posTemp) Then
		Return 0
	EndIf
EndFunc   ;==>_findPlayerColor

; #FUNCTION# ====================================================================================================================
; Name ..........: _findPlayerPosition
; Description ...: Finds given color on minimap and returns position.
; Syntax ........: _findPlayerPosition($iColor)
; Parameters ....: $iColor              - Player color
; Return values .: Player Position or false
; ===============================================================================================================================
Func _findPlayerPosition($iColor)
	; Search for Player
	Local $posUnit
	$posUnit = PixelSearch($arrMiniMap[0], $arrMiniMap[1], $arrMiniMap[2], $arrMiniMap[3], $iColor, 4)
	If IsArray($posUnit) Then
		$posBackup = $posUnit
		Return $posUnit
	Else
		Return False
	EndIf
EndFunc   ;==>_findUnitPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _findUnitPosition
; Description ...: 	Find Unit position of a given color on minimap
; Syntax ........: _findUnitPosition($arrSearchRange, $iColor)
; Parameters ....: $arrSearchRange      - An array of TOPLEFT XY and BOTTOMRIGHT XY.
;                  $iColor              - Color value of Unit
; Return values .: Unit Position on Minimap / False
; ===============================================================================================================================
Func _findUnitPosition($arrSearchRange, $iColor)
	; Exception Handling
	If IsArray($arrSearchRange) Then
		; Search for Unit
		Local $posUnit
		$posUnit = PixelSearch($arrSearchRange[0], $arrSearchRange[1], $arrSearchRange[2], $arrSearchRange[3], $iColor, 4)
		If IsArray($posUnit) Then
			Return $posUnit
		EndIf
		Return False
	Else
		_MsgBox("_findUnitPosition: Wrong Search Range")
		Exit
	EndIf
EndFunc   ;==>_findUnitPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _findNextBounty
; Description ...: Finds nearest position of a bounty rune
; Syntax ........: _findNextBounty($posPlayer)
; Parameters ....: $posPlayer 				- 	Current Player Positions
; Return values .: $arrBountyPositions[$i] 	-	Position of the nearest visible bounty
; Remarks .......: Determines and returns the position of the next bounty rune
; ===============================================================================================================================
Func _findNextBounty($posPlayer)
	_TT("Find nearest Bounty")
	; Allocate GLobal variables
	Local $arrX = $arrBountyrunes_X
	Local $arrY = $arrBountyrunes_Y
	Local $arrSortResults
	; Variables
	Local $iLength = UBound($arrX)
	Local $arrDistances[$iLength]
	Local $arrBountyPositions[$iLength]
	Local $posTemp
	Local $iDistanceTemp
	; Generate Bounty Rune position array
	$arrBountyPositions = _buildPointArray($arrX, $arrY)
	; Calculate distances for returned Arrays
	For $i = 0 To $iLength - 1
		$posTemp = $arrBountyPositions[$i]
		If _MiniMapMarkerExist($iColorBountyMinimap, $posTemp, 10, 4) Then
			$iDistanceTemp = _calculatePointDistance($posPlayer, $posTemp)
			$arrDistances[$i] = $iDistanceTemp
		Else
			$arrDistances[$i] = 0
		EndIf
	Next
	; Sort Distance Array / Swap Position Array and write back to unsorted/swaped arrays
	$arrSortResults = _sortArrays($arrDistances, $arrBountyPositions)
	$arrDistance = $arrSortResults[0]
	$arrBountyPositions = $arrSortResults[1]
	; Iterate over all Positions until Bounty position is found
	For $i = 0 To $iLength - 1
		; When not at Bounty and Bounty exist, then return cordinates
		If Not _checkPointProximity($posPlayer, $arrBountyPositions[$i]) And (_MiniMapMarkerExist($iColorBountyMinimap, $arrBountyPositions[$i], 4, 4) Or _MiniMapMarkerExist($iColorBountyMinimap, $arrBountyPositions[$i], 4, 4)) Then
			$posBackup = $arrBountyPositions[$i]
			Return $arrBountyPositions[$i]
		EndIf
	Next
	_tt("No Bounty Up")
	Return False
EndFunc   ;==>_findNextBounty

; #FUNCTION# ====================================================================================================================
; Name ..........: _findNextWave
; Description ...: Finds nearest position of a creep wave
; Syntax ........: _findNextWave($posPlayer)
; Parameters ....: $posPlayer 			- 	Current Player Positions
; Return values .: $arrPositions[$i] 	-	Position of the nearest visible wave
; Remarks .......: Determines and returns the position of the next visible wavw
; ===============================================================================================================================
Func _findNextWave($posPlayer)

	_exceptionPosition($posPlayer,"_findNextWave")

	; Variables
	; Local Static $posLastSeenWave
	Local $arrSortResults
	Local $arrDistances[3]
	Local $arrEquilibriumPositions[3]
	Local $posSafe
	Local $posMid
	Local $posOff
	; Scan Safe Lane
	$posSafe = _scanLaneEquilibrium($arrCorridorDireSafe)
	If IsArray($posSafe) Then
		$arrEquilibriumPositions[0] = $posSafe
	ElseIf Not IsArray($posSafe) Then
		$posSafe = _scanLaneEquilibrium($arrCorridorRadOff)
		$arrEquilibriumPositions[0] = $posSafe
	EndIf
	; Scan Mid Lane
	$posMid = _scanLaneEquilibrium($arrCorridorMid)
	If IsArray($posMid) Then
		$arrEquilibriumPositions[1] = $posMid
	EndIf
	; Scan Off Lane
	$posOff = _scanLaneEquilibrium($arrCorridorDireOff)
	If IsArray($posOff) Then
		$arrEquilibriumPositions[2] = $posOff
	ElseIf Not IsArray($posOff) Then
		$posOff = _scanLaneEquilibrium($arrCorridorRadSafe)
		$arrEquilibriumPositions[2] = $posOff
	EndIf
	; Calculate distances for returned Arrays and set non positions 0
	For $i = 0 To UBound($arrEquilibriumPositions) - 1
		Local $posTemp = $arrEquilibriumPositions[$i]
		If IsArray($posTemp) Then
			Local $iDistanceTemp = _calculatePointDistance($posPlayer, $posTemp)
			$arrDistances[$i] = $iDistanceTemp
		Else
			$arrDistances[$i] = 0
		EndIf
	Next
	; Sort Distance Array / Swap Position Array and write back to unsorted/swaped arrays
	$arrSortResults = _sortArrays($arrDistances, $arrEquilibriumPositions)
	$arrDistances = $arrSortResults[0]
	$arrEquilibriumPositions = $arrSortResults[1]
	; Return Lowest Index that is not 0
	For $i = 0 To UBound($arrEquilibriumPositions) - 1
		If IsArray($arrEquilibriumPositions[$i]) Then
			$posLastSeenWave = $arrEquilibriumPositions[$i]
			Return ($arrEquilibriumPositions[$i])
		EndIf
	Next
	; No Wave Found
	Return False

EndFunc   ;==>_findNextWave

; #FUNCTION# ====================================================================================================================
; Name ..........: _findNextCamp
; Description ...: Returns nearest unfarmed creep camp
; Syntax ........: _findNextCamp($posPlayer,$arrCampsX,$arrCampsY)
; Parameters ....: $posPlayer 			- 	Current Player Position
;				   $arrCampsX 			- 	Array with X coordinates
;				   $arrCampsY 			- 	Array with Y coordinates
; Return values .: $arrPositions[$i] 	-	Position of the nearest farmable camp
; Remarks .......: Determines and returns the position of the next free camp of given creep camps
; ===============================================================================================================================
Func _findNextCamp($posPlayer, $arrCampsX, $arrCampsY)

	_exceptionPosition($posPlayer,"_findNextCamp")
	; Dummy or Backup Return
	Local Static $posBackup
	Local $arrPositions[UBound($arrCampsX)]
	Local $posTemp
	Local $iLength = UBound($arrCampsX)
	; Temp to Hold Sort return
	Local $arrSortReturn
	; Array for Distances
	Local $arrDistances[UBound($arrPositions)]
	Local $iDistanceTemp
	; Build array with all point positions
	$arrPositions = _buildPointArray($arrCampsX, $arrCampsY)
	$posBackup = $arrPositions[0]
	; Calculate all distances
	For $i = 0 To UBound($arrPositions) - 1
		$posTemp = _buildPoint($arrCampsX[$i], $arrCampsY[$i])
		$iDistanceTemp = _calculatePointDistance($posPlayer, $posTemp)
		$arrDistances[$i] = $iDistanceTemp
	Next
	$arrSortReturn = _sortArrays($arrDistances, $arrPositions)
	$arrDistances = $arrSortReturn[0]
	$arrPositions = $arrSortReturn[1]
	; Iterate over all Positions until farmable position is found
	For $i = 0 To $iLength - 1
		; When not at camp and camp exist, then return cordinates
		If Not _checkPointProximity($posPlayer, $arrPositions[$i]) And (_MiniMapMarkerExist($iColorNeutralCamp, $arrPositions[$i], 2, 2) Or _MiniMapMarkerExist($iColorNeutralUnit, $arrPositions[$i], 2, 2)) Then
			$posBackup = $arrPositions[$i]
			Return $arrPositions[$i]
		EndIf
	Next
	Return False
EndFunc   ;==>_findNextCamp

; #FUNCTION# ====================================================================================================================
; Name ..........: _findNextTower
; Description ...: Returns position of next tower
; Syntax ........: _findNextTower($posPlayer, $arrTowersX, $arrTowersY, $towerStates)
; Parameters ....: $posPlayer           - player position
;                  $arrTowersX          - Tower array x
;                  $arrTowersY          - Tower array y
;                  $towerStates         - Tower state array
; Return values .: Tower Position / False
; ===============================================================================================================================
Func _findNextTower($posPlayer, $arrTowersX, $arrTowersY, $towerStates)
	_exceptionPosition($posPlayer,"_findNextTower")
	; Dummy or Backup Return
	Local $arrPositions[UBound($arrTowersX)]
	Local $posTemp
	Local $iLength = UBound($arrTowersX)
	; Temp to Hold Sort return
	Local $arrSortReturn
	; Array for Distances
	Local $arrDistances[UBound($arrPositions)]
	Local $iDistanceTemp
	; Build array with all point positions
	$arrPositions = _buildPointArray($arrTowersX, $arrTowersY)
	$posBackup = $arrPositions[0]
	; Calculate all distances
	For $i = 0 To UBound($arrPositions) - 1
		$posTemp = _buildPoint($arrTowersX[$i], $arrTowersY[$i])
		$iDistanceTemp = _calculatePointDistance($posPlayer, $posTemp)
		$arrDistances[$i] = $iDistanceTemp
	Next
	$arrSortReturn = _sortArrays($arrDistances, $arrPositions)
	$arrDistances = $arrSortReturn[0]
	$arrPositions = $arrSortReturn[1]
	; Iterate over all Positions until farmable position is found
	For $i = 0 To $iLength - 1
		If $towerStates[$i] = 1 Then
			Return $arrPositions[$i]
		EndIf
	Next
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _findEnemyHealthBar
; Description ...: Returns position of enemy health bars or if healthbars are on screen
; Syntax ........: _findEnemyHealthBar($iColor, $mode)
; Parameters ....: $iColor              - Enemy healthbar color
;                  $mode                - 0 = True or False / 1 = Position or False
; Return values .: Position or False; True or False
; ===============================================================================================================================
Func _findEnemyHealthBar($iColorTempEnemy,$mode)

	Local $TopLeft_X = 159
	Local $TopLeft_Y = 110
	Local $BottomRight_X = 1646
	Local $BottomRight_Y = 814
	Local $posColorTemp
	Local $colorTemp
	Local $colorCount = 0

	$posColorTemp  = PixelSearch($TopLeft_X,$TopLeft_Y,$BottomRight_X,$BottomRight_Y,$iColorTempEnemy,2,4)
	If IsArray($posColorTemp) Then
		; Search for same pixel color to the right
		For $i = 0 to 10 
			Local $tempPos = PixelSearch($posColorTemp[0]+$i,$posColorTemp[1], $posColorTemp[0]+$i,$posColorTemp[1],$iColorTempEnemy,3)
			If IsArray($tempPos) Then
				$colorCount = $colorcount + 1
			EndIf
			If $colorCount > 3 Then
				If $mode = 1 Then
					Return $posColorTemp
				ElseIf $mode = 0 Then
					Return True
				EndIF
			EndIf
		Next
		; Search for same pixel color to the left
		For $i = 0 to 10 
			Local $tempPos = PixelSearch($posColorTemp[0]-$i,$posColorTemp[1], $posColorTemp[0]-$i,$posColorTemp[1],$iColorTempEnemy,3)
			If IsArray($tempPos) Then
				$colorCount = $colorcount + 1
			EndIf
			If $colorCount > 3 Then
				If $mode = 1 Then
					Return $posColorTemp
				ElseIf $mode = 0 Then
					Return True
				EndIF
			EndIf
		Next
	EndIf
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _scanForHeroes
; Description ...: Scans a given creep wave position for heroes.
; Syntax ........: _scanForHeroes($posWave, $arrColorHeroes)
; Parameters ....: $posWave             - Wave Position.
;                  $arrColorHeroes      - Hero colors to check near wave.
; Return values .: Color Found = True; Not Found = False
; ===============================================================================================================================
Func _scanForHeroes($Pos,$arrColorHeroes)
	_exceptionPosition($Pos,"_scanForHeroes")
	Local $bHeroExist
	; Checks entire hero color array
	For $i = 0 to UBound($arrColorHeroes) - 1
		$bHeroExist = _MiniMapMarkerExist($arrColorHeroes[$i],$Pos,25,4)
		If $bHeroExist Then
			Return True
		EndIF
	Next
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _scanLaneEquilibrium
; Description ...:  Scans a given lane corridor for creep eqilibrium
; Syntax ........: _scanLaneEquilibrium($arrLane)
; Parameters ....: $arrLane             - Top and bottom Pos of rectangle
; Return values .: Equilibrium Position or 0
; ===============================================================================================================================
Func _scanLaneEquilibrium($arrLane)
	If Not IsArray($arrLane) Then
		_MsgBox("_scanLaneEquilibrium): Called with non Array Parameter")
		Exit
	EndIf
	Local $posEquilibrium
	; Searches lane corridor for enemy creeps
	$posEquilibrium = _findUnitPosition($arrLane, $iColor_Enemy_Unit)
	; Checks if Unit position is returned and frindly Creeps are around
	If IsArray($posEquilibrium) Then
		If _MiniMapMarkerExist($iColor_Frindly_Creep, $posEquilibrium, 15, 3) = True Then
			Return $posEquilibrium
		Else
			Return 0
		EndIf
	EndIf
EndFunc   ;==>_scanLaneEquilibrium

; #FUNCTION# ====================================================================================================================
; Name ..........: _useTP
; Description ...: Teleports to to the next building of a given position
; Syntax ........: _useTP($posWave)
; Parameters ....: $pos             - position to TP to
; Return values .: None
; ===============================================================================================================================
Func _useTP($pos)
	_exceptionPosition($pos,"_useTP")
	MouseMove($pos[0],$pos[1])
	Sleep(Random(180,200,1))
	Send("w")
	Mouseclick("Left")
	Sleep(Random(3500,3680,1))
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _unitShare
; Description ...:  Gives unit share to team
; Syntax ........: _unitShare()
; ===============================================================================================================================
Func _unitShare($bSide)

	If $bSide = True Then
		MouseClick("LEFT", 122,29)
		Sleep(Random(400,750))
		MouseClick("LEFT",798,711)
		Sleep(Random(400,750))
		MouseClick("LEFT",962,171)
		Sleep(Random(400,750))
		MouseClick("LEFT",961,226)
		Sleep(Random(400,750))
		MouseClick("LEFT",961,284)
		Sleep(Random(400,750))
		MouseClick("LEFT",963,341)
		Sleep(Random(400,750))
		Send("{ESC}")
		Sleep(Random(400,750))
		Send("{ENTER}")
		Sleep(Random(400,750))
		Send("Unit control shared / Blok upravleniya podelilsya | Use my hero / Ispol'zovat' moy geroy")
		Sleep(Random(400,750))
		Send("{ENTER}")
		Sleep(Random(400,750))
	EndIF

	If $bSide = False Then
		MouseClick("LEFT", 122,29)
		Sleep(Random(400,750))
		MouseClick("LEFT",798,711)
		Sleep(Random(400,750))
		MouseClick("LEFT",961,488)
		Sleep(Random(400,750))
		MouseClick("LEFT",962,544)
		Sleep(Random(400,750))
		MouseClick("LEFT",962,600)
		Sleep(Random(400,750))
		MouseClick("LEFT",962,658)
		Sleep(Random(400,750))
		Send("{ESC}")
		Sleep(Random(400,750))
		Send("{ENTER}")
		Sleep(Random(400,750))
		Send("Unit control shared / Blok upravleniya podelilsya | Use my hero / Ispol'zovat' moy geroy")
		Sleep(Random(400,750))
		Send("{ENTER}")
		Sleep(Random(400,750))
	EndIF
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkInventoryItem
; Description ...: Checks if items exist in inventory
; Syntax ........: _checkInventoryItem($item_color, $string_Item)
; Parameters ....: $item_color          - Color to search for.
;                  $string_Item         - Item Name.
; Return values .: Found = Position; Not Found = False
; ===============================================================================================================================
Func _checkInventoryItem($item_color, $string_Item)
	Local $cord_color = PixelSearch(1108,938, 1298,1036, $item_color, 2)
	If IsArray($cord_color) Then
		Return $cord_color
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _queueItem
; Description ...: Queues Items to buy
; Syntax ........: _queueItem($itemBasic, $cord_item, $itemname)
; Parameters ....: $itemBasic           - Basic = 0; Upgrade = 1
;                  $cord_item           - Item Pos in shop tab
;                  $itemname            - String of Itemname
; Return values .: None
; ===============================================================================================================================
Func _queueItem($itemBasic,$cord_item, $itemname)
	;Open Shop
	Send("{F2}")
	Sleep(250)
	;Switch Tab
	If $itemBasic = True Then
		MouseClick("left", $arr_shopBasic[0],$arr_shopBasic[1])
	Elseif $itemBasic = False Then
		MouseClick("left", $arr_shopUpgrade[0],$arr_shopUpgrade[1])
	EndIf
	Sleep(250)
	;Queue Item
	Send("{SHIFTDOWN}")
	MouseClick("left", $cord_item[0], $cord_item[1])
	Send("{SHIFTUP}")

	;Close Shop
	Sleep(250)
	Send("{F2}")
	Sleep(250)
	Send("{ESC}")
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _buyItems
; Description ...: Buy hardcoded item list
; Syntax ........: _buyItems()
; Return values .: None
; ===============================================================================================================================
Func _buyItems()
	If _checkIngame() Then
		If Not IsArray(_checkInventoryItem($color_Vanguard, "Vanguard")) Then
			_queueItem(0,$arr_Vanguard,"Vanguard")
			Send("t")
			Sleep(Random(250,500))
			Send("{F3}")
		ElseIf Not IsArray(_checkInventoryItem($color_Boots, "Boots")) Then
			_queueItem(1,$arr_Boots,"Boots")
			Send("t")
			Sleep(Random(250,500))
			Send("{F3}")
		ElseIf Not IsArray(_checkInventoryItem($color_Heart, "Heart")) Then
			_queueItem(0,$arr_Heart,"Heart")
			Send("t")
			Sleep(Random(250,500))
			Send("{F3}")
		ElseIf Not IsArray(_checkInventoryItem($color_AC, "Assault Cuirass")) Then
			_queueItem(0,$arr_AC,"Assault Cuirass")
			Send("t")
			Sleep(Random(250,500))
			Send("{F3}")
		EndIf
	EndIf
EndFunc   ;==>_buyItems

; #FUNCTION# ====================================================================================================================
; Name ..........: _buySalve
; Description ...:
; Syntax ........: _buySalve()
; Return values .: True = Salve Bought; False = Salve already in inventory
; ===============================================================================================================================
Func _buySalve()
	Local $current_color = PixelSearch(1108,938, 1298,1036, $color_Salve, 2)
	If Not IsArray($current_color) Then
		; Buy Salve
		Send("{F2}")
		Sleep(250)
		MouseClick("Left",1618,127)
		Sleep(250)
		MouseClick("Right",1628,376)
		Sleep(250)
		Send("{F2}")
		Sleep(250)
		Send("{ESC}")
		Sleep(250)
		Send("{F3}")
		Return True
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _useSalve
; Description ...: Uses Salve if found in inventory
; Syntax ........: _useSalve()
; Returnvalues	 : True = Used; False = Not Found
; ===============================================================================================================================
Func _useSalve()
	$item_cord = _checkInventoryItem($color_Salve, "Check Salve")
	If IsArray($item_cord) Then
		MouseClick("left",$item_cord[0],$item_cord[1],2)
		Return True
	Else
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _skillHero
; Description ...: Skills hero; V -> C -> Y -> D -> Y
; Syntax ........: _skillHero()
; ===============================================================================================================================
Func _skillHero($lvl)
	If _checkLevelUp() = True Then
        ; Take Talent First
        ; Needs to be level 9 cuz updated to 10 
        ; after function exits
        If $lvl = 9 OR $lvl = 14 OR $lvl = 19 OR $lvl = 24 Then
            Sleep(Random(100,150))
            Send("{n}") ; open talent panel
            Sleep(Random(100,150))
            Send(Random(1,2,1)) ; Randoms Talent Choice
            Sleep(Random(100,150))
        EndIf
		Send("^{v}")
        Sleep(Random(100,150))
		Send("^{c}")
		Sleep(Random(100,150))
		Send("^{y}")
        Sleep(Random(100,150))
		Send("^{d}")
		Sleep(Random(100,150))
		Send("^{x}")
		Sleep(Random(100,150))
		Send("{ESC}")
		Return True
	EndIf
    Return False
EndFunc   ;==>_skillHero