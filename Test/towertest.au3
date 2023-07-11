#include <Array.au3>

Global Const $iColor_Frindly_Building = 8450560 ;65280
Global Const $iColor_Enemy_Building_Fog = 16711680
Global Const $iColor_Enemy_Building = 16711680

; Radiant T1 T2 T3 Offlane Mid Safelane
Global Const $arrRadiant_Tower_PosX[9] = ["27","27","21","112","79","56","229","134","69"]
Global Const $arrRadiant_Tower_PosY[9] = ["906","955","1000","963","988","1012","1049","1052","1049"]
; Dire Offlane Mid Safelane
Global Const $arrDire_Tower_PosX[9] = ["253", "255", "255", "149", "185", "217", "56", "138", "204"]
Global Const $arrDire_Tower_PosY[9] = ["970", "932", "885", "925", "899", "870", "830", "827", "834"]

Global $arrTowersEnemy_X = 0
Global $arrTowersEnemy_Y = 0
Global $arrTowersEnemy = -1
Global $arrTowersFrindly_X = 0
Global $arrTowersFrindly_Y = 0
Global $arrTowersFrindly = -1
Global $arrTowerStateEnemy = -1
Global $arrTowerStateFrindly = -1

Global $bStateFaction = -1

;_MsgBox (_checkBuildingState(1,_buildPoint(27,906)))

$arrtest = _buildPointArray($arrRadiant_Tower_PosX, $arrRadiant_Tower_PosY)


For $i = 0 To 8 
	_mouseMove($arrtest[$i])
	sleep(500)
Next

#cs
 sleep(1000)
_setFaction()
_setBuildings()
_setBuildingStates()
_ArrayDisplay($arrTowerStateEnemy)
_ArrayDisplay($arrTowerStateFrindly) 
#ce


Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

Func _setBuildingStates()
	$arrTowerStateEnemy = _generateBuildingState(0,$arrTowersEnemy_X,$arrTowersEnemy_Y)
	$arrTowerStateFrindly = _generateBuildingState(1,$arrTowersFrindly_X,$arrTowersFrindly_Y)
EndFunc

Func _generateBuildingState($bIsFrindly, $arrX, $arrY)
	; Exception Handling
	If IsArray($arrX) And IsArray($arrY) And UBound($arrX) = UBound($arrY) Then
		Local $iArrLength = UBound($arrX)
		; Initialize Array Range
		Local $aBuildingStates[$iArrLength]
		; Check building state for every Index
		For $i = 0 To $iArrLength - 1
			Local $pos_current = _buildPoint($arrX[$i], $arrY[$i])
			$aBuildingStates[$i] = _checkBuildingState($bIsFrindly, $pos_current)
		Next
		Return $aBuildingStates
	Else
		_tt(" _generateBuildingState: Wrong Data Type or Array Length not Matching")
		Return 0
	EndIf
EndFunc   ;==>_generateBuildingState

Func _checkBuildingState($bIsFrindly, $Pos)

	; Check Exceptions
	If IsArray($Pos) And ($bIsFrindly = 0 Or $bIsFrindly = 1) Then
		; Frindly Building
		If $bIsFrindly = 1 Then
			Local $posTemp
			$posTemp = _pointPixelsearch($Pos, 10, 10, $iColor_Frindly_Building, 2)
			If IsArray($posTemp) Then
				_tt("Frindly Building Up")
				Return 1
			Else
				_tt("Frindly Building Down")
				Return 0
			EndIf
			; Enemy Building
		ElseIf $bIsFrindly = 0 Then
			Local $posTemp
			$posTemp = _pointPixelsearch($Pos, 5, 5, $iColor_Enemy_Building, 1)
			If IsArray($posTemp) Then
				_tt("Enemy Building Up")
				Return 1
			Else
				_tt("Enemy Building Down")
				Return 0
			EndIf
		EndIf
	Else
		; Exception
		_MsgBox("_checkBuildingState Wrong Parameters")
		Exit
	EndIf
EndFunc   ;==>_checkBuildingState

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
EndFunc

Func _MsgBox($sMsgbox)
	MsgBox(0, "Debug", $sMsgbox)
EndFunc   ;==>_MsgBox

Func _pointPixelsearch($Pos, $OffsetX, $OffsetY, $iColor, $iShade)
	Local $Pos_Up
	Local $Pos_Down
	; Build Top Rectangle
	Local $posX1_up = $Pos[0] - $OffsetX
	Local $posY1_up = $Pos[1] - $OffsetY
	Local $posX2_up = $Pos[0] + $OffsetX
	Local $posY2_up = $Pos[1]
	; Build Bottom Rectangle
	Local $posX1_down = $Pos[0] - $OffsetX
	Local $posY1_down = $Pos[1]
	Local $posX2_down = $Pos[0] + $OffsetX
	Local $posY2_down = $Pos[1] + $OffsetY
	; Check Top Rectangle of given Point
	$posUp = PixelSearch($posX1_up, $posY1_up, $posX2_up, $posY2_up, $iColor, $iShade)
	If IsArray($Pos_Up) Then
		Return $Pos_Up
	EndIf
	; Check Bottom Rectangle of given Point
	$Pos_Down = PixelSearch($posX1_down, $posY1_down, $posX2_down, $posY2_down, $iColor, $iShade)
	If IsArray($Pos_Down) Then
		Return $Pos_Down
	EndIf
	; Color not found
	Return False
EndFunc   ;==>_pointPixelsearch

Func _buildPoint($iX, $iY)
	Local $posPoint[2]
	$posPoint[0] = $iX
	$posPoint[1] = $iY
	Return $posPoint
EndFunc   ;==>_buildPoint

Func _buildPointArray($arrX, $arrY)
	; Exception
	If Not UBound($arrX) = UBound($arrY) Then
		_MsgBox("_buildPointArray: Wrong Array Constraints")
		Exit
	EndIf
	Local $arrPositions[UBound($arrX)]
	For $i = 0 To UBound($arrX) - 1
		$arrPositions[$i] = _buildPoint($arrX[$i], $arrY[$i])
	Next
	Return $arrPositions
EndFunc   ;==>_buildPointArray

Func _setFaction()
	If _checkRadiant() = True Then
		$bStateFaction = True ; True = Radiant
		_tt("Radiant Set")
        sleep(500)
	ElseIf _checkDire() = True Then
		$bStateFaction = False ; False = Dire
		_tt("Dire Set")
        sleep(500)
	EndIf
EndFunc

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

Func _MouseMove($Pos)
	If IsArray($Pos) And UBound($Pos) = 2 Then
		MouseMove($Pos[0], $Pos[1],30)
	Else
		_MsgBox("_MouseMove: Wrong Array Constraints")
	EndIf
EndFunc   ;==>_MouseMove