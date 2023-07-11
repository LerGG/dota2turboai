#include <Array.au3>

$enemyHpColor_damaged = 1706502
$enemyHpColor_full = 8997944

$enemyHeroHPColor = 0;14104064
$NeutralItemColor = 2501681
global $enemyVisiblePos 

while 1
	_attackVisibleCreeps($enemyHpColor_full,$enemyHpColor_damaged)
Wend

Func _MsgBox($sMsgbox)
	MsgBox(0, "Debug", $sMsgbox)
EndFunc   ;==>_MsgBox


Func _attackVisibleCreeps($colorFullHP,$colorDamagedHP)
	$enemyVisiblePos = _findEnemyHealthBar($colorFullHP, 1) 
	If IsArray($enemyVisiblePos) Then
		Local $tempPosAttack_1 = 0
		Local $tempPosAttack_2 = 0
		Local $colorCount_1 = 0
		Local $colorCount_2 = 0

		do 
			$tempPosAttack_1 = _pointPixelsearch($enemyVisiblePos,150,100,$colorFullHP,3,2) 
			$tempPosAttack_2 = _pointPixelsearch($enemyVisiblePos,150,100,$colorDamagedHP,3,2)

			if IsArray ($tempPosAttack_1) Then
				For $i = 0 to 7 
					Local $tempPos = PixelSearch($tempPosAttack_1[0]+$i,$tempPosAttack_1[1], $tempPosAttack_1[0]+$i,$tempPosAttack_1[1],$colorFullHP,3)
					If IsArray($tempPos) Then
						$colorCount_1 = $colorcount_1 + 1
					EndIf
					If $colorCount_1 > 3 Then
						_MouseMove($tempPosAttack_1)
						Send("a")
						ExitLoop
					EndIf
				Next
			EndIf
		
			If IsArray ($tempPosAttack_2) Then
				For $i = 0 to 7 
					Local $tempPos = PixelSearch($tempPosAttack_2[0]+$i,$tempPosAttack_2[1], $tempPosAttack_2[0]+$i,$tempPosAttack_2[1],$colorDamagedHP,3)
					If IsArray($tempPos) Then
						$colorCount_1 = $colorcount_1 + 1
					EndIf
					If $colorCount_1 > 3 Then
						_MouseMove($tempPosAttack_2)
						Send("a")
						ExitLoop
					EndIf
				Next
			EndIf

		Until $tempPosAttack_1 = False AND $tempPosAttack_2 = False
	EndIf
EndFunc


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
		For $i = 0 to 7 
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
		For $i = 0 to 7 
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

Func _MouseMove($Pos)
	If IsArray($Pos) And UBound($Pos) = 2 Then
		MouseMove($Pos[0], $Pos[1],30)
	Else
		_MsgBox("_MouseMove: Wrong Array Constraints")
	EndIf
EndFunc   ;==>_MouseMove

Func _buildPoint($iX, $iY)
	Local $posPoint[2]
	$posPoint[0] = $iX
	$posPoint[1] = $iY
	Return $posPoint
EndFunc   ;==>_buildPoint

Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

Func _pointPixelsearch($Pos, $OffsetX, $OffsetY, $iColor, $iShade, $iSteps)
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
	$posUp = PixelSearch($posX1_up, $posY1_up, $posX2_up, $posY2_up, $iColor, $iShade, $iSteps)
	If IsArray($Pos_Up) Then
		Return $Pos_Up
	EndIf
	; Check Bottom Rectangle of given Point
	$Pos_Down = PixelSearch($posX1_down, $posY1_down, $posX2_down, $posY2_down, $iColor, $iShade, $iSteps)
	If IsArray($Pos_Down) Then
		Return $Pos_Down
	EndIf
	; Color not found
	Return False
EndFunc   ;==>_pointPixelsearch