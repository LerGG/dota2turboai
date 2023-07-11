#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTube

 Script Function:
	All Help Functions.
	Include only

#ce ----------------------------------------------------------------------------

#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _tt
; Description ...: Displays Tooltip
; Syntax ........: _tt($sToolTip)
; Parameters ....: $sToolTip            - A string value.
; Return values .: None
; Remarks .......: If 2 dimensional array, coordinates will be displayed.
; ===============================================================================================================================
Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

; #FUNCTION# ====================================================================================================================
; Name ..........: _buildPoint
; Description ...: Builds point array out of two points.
; Syntax ........: _buildPoint($iX, $iY)
; Parameters ....: $iX                  - An integer value.
;                  $iY                  - An integer value.
; Return values .: Array with X Y
; ===============================================================================================================================
Func _buildPoint($iX, $iY)
	Local $posPoint[2]
	$posPoint[0] = $iX
	$posPoint[1] = $iY
	Return $posPoint
EndFunc   ;==>_buildPoint

; #FUNCTION# ====================================================================================================================
; Name ..........: _buildPointArray
; Description ...: Builds one array out of X and Y array
; Syntax ........: _buildPointArray($arrX, $arrY)
; Parameters ....: $arrX                - X Coordinates
;                  $arrY                - Y Coordinates
; Return values .: Returns an array with Points
; ===============================================================================================================================
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

; #FUNCTION# ====================================================================================================================
; Name ..........: _calculatePointDistance
; Syntax ........: _calculatePointDistance($pos_1, $pos_2)
; Parameters ....: $pos_1
;                  $pos_2
; Return values .: Distance between points (Pixel)
; ===============================================================================================================================
Func _calculatePointDistance($pos_1, $pos_2)
	; Exception Handling
	If IsArray($pos_1) And IsArray($pos_2) Then
		; Point 1
		Local $pos_x1 = $pos_1[0]
		Local $pos_y1 = $pos_1[1]
		; Point 2
		Local $pos_x2 = $pos_2[0]
		Local $pos_y2 = $pos_2[1]
		; Calculate Distance and make it Integer
		Local $iDistance = Sqrt((($pos_x2 - $pos_x1) * ($pos_x2 - $pos_x1)) + (($pos_y2 - $pos_y1) * ($pos_y2 - $pos_y1)))
		$iDistance = Int($iDistance)
		Return $iDistance
	Else
		_MsgBox("_calculatePointDistance: Non Array Parameters")
		Return 0
	EndIf
EndFunc   ;==>_calculatePointDistance

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkPointProximity
; Description ...: Checks if current postition close to target position.
; Syntax ........: _checkPointProximity($posCurrent, $posTarget)
; Parameters ....: $posCurrent          - Current position
;                  $posTarget           - Target Position
; Return values .: True = Close to target point; False = Not Close
; ===============================================================================================================================
Func _checkPointProximity($posCurrent, $posTarget)

	If Not IsArray($posCurrent) Or Not IsArray($posTarget) Then
		_MsgBox("_checkPointProximity: Called with Wrong Parameter")
		Return 0
	EndIf

	Local $iDistance = 9999
	$iDistance = _calculatePointDistance($posCurrent, $posTarget)
	If $iDistance <= 5 Then
		Return True
	ElseIf $iDistance > 6 Then
		Return False
	EndIf
EndFunc   ;==>_checkPointProximity

; #FUNCTION# ====================================================================================================================
; Name ..........: _calculateScreenMiddle
; Description ...:  Calculates Middle of the Screen
; Syntax ........: _calculateScreenMiddle()
; Return values .:  Position
; ===============================================================================================================================
Func _calculateScreenMiddle()
	;Variables
	Local $posMiddle
	Local $posX = 1920 / 2
	Local $posY = 1080 / 2
	$posMiddle = _buildPoint($posX, $posY)
	Return $posMiddle
EndFunc   ;==>_calculateScreenMiddle

; #FUNCTION# ====================================================================================================================
; Name ..........: _MsgBox
; Description ...: Debug Function
; Syntax ........: _MsgBox($sMsgbox)
; Parameters ....: $sMsgbox             - A string value.
; Return values .: None
; ===============================================================================================================================
Func _MsgBox($sMsgbox)
	MsgBox(0, "Debug", $sMsgbox)
EndFunc   ;==>_MsgBox

; #FUNCTION# ====================================================================================================================
; Name ..........: _convertTimer
; Description ...: Calculate Time in seconds
; Syntax ........: _convertTimer($timer)
; Parameters ....: $timer               - A dll struct value.
; Return values .: Timer in Seconds
; ===============================================================================================================================
Func _convertTimer($timer)
	Local $iConvertedTimer = Int(TimerDiff($timer) / 1000)
	Return $iConvertedTimer
EndFunc   ;==>_convertTimer

; #FUNCTION# ====================================================================================================================
; Name ..........: _MouseMove
; Description ...:  Easy Mouse Move
; Syntax ........: _MouseMove($Pos)
; Parameters ....: $Pos                 - Postion to Move Mouse To
; ===============================================================================================================================
Func _MouseMove($Pos)
	If IsArray($Pos) And UBound($Pos) = 2 Then
		MouseMove($Pos[0], $Pos[1])
	Else
		_MsgBox("_MouseMove: Wrong Array Constraints")
	EndIf
EndFunc   ;==>_MouseMove

; #FUNCTION# ====================================================================================================================
; Name ..........: _pointPixelsearch
; Description ...:  Pixel search around a position with given offset
; Syntax ........: _pointPixelsearch($Pos, $OffsetX, $OffsetY, $iColor, $iShade)
; Parameters ....: $Pos                 - Position to search around
;                  $OffsetX             - X offset
;                  $OffsetY             - Y Offset
;                  $iColor              - Color to search for
;                  $iShade              - shade variation
; Return values .: Position of the color or False
; ===============================================================================================================================
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

; #FUNCTION# ====================================================================================================================
; Name ..........: _exceptionPosition
; Description ...: Exception for 2 dimensional arrays.
; Syntax ........: _exceptionPosition($Pos, $sFunction)
; Parameters ....: $Pos                 - Two Dimensional Array
;                  $sFunction           - A string value.
; Return values .: Exit
; ===============================================================================================================================
Func _exceptionPosition($Pos, $sFunction)
	; Exception
	If Not IsArray($Pos) And UBound($Pos) = 2 Then
		_MsgBox($sFunction & " :No Array or Wrong Constraints")
		Exit
	EndIf
EndFunc   ;==>_exceptionPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _sortArrays
; Description ...: First array parameter and swaps second array parameter accordingly
; Syntax ........: _sortArrays($arrToSort, $arrToSwap)
; Parameters ....: $arrToSort           - Array To Sort
;                  $arrToSwap           - Array To Swap
; Return values .: Array that holds both sorted arrays
; Remarks .......: Sorts first array and swaps second accordingly
; Related .......: BubbleStort
; ===============================================================================================================================
Func _sortArrays($arrToSort, $arrToSwap)
	; Exception
	If Not UBound($arrToSort) = UBound($arrToSwap) Then
		_MsgBox("_sortArrays: Wrong array constraints")
		Exit
	EndIf
	; Single Return variable for both array parameters
	Local $iLength = UBound($arrToSort)
	Local $arrOrdered[2]
	Local $iTemp
	Local $bSwapped = True
	; Bubble Sort: Sort $arrayToSort and swap indexies of  $arrToSwap
	While $bSwapped
		$bSwapped = False
		For $i = 0 To $iLength - 2
			If $arrToSort[$i] > $arrToSort[$i + 1] Then
				; Swap
				$iTemp = $arrToSort[$i]
				$arrToSort[$i] = $arrToSort[$i + 1]
				$arrToSort[$i + 1] = $iTemp
				; Swap
				$posTemp = $arrToSwap[$i]
				$arrToSwap[$i] = $arrToSwap[$i + 1]
				$arrToSwap[$i + 1] = $posTemp
				$bSwapped = True
			EndIf
		Next
	WEnd
	; Build Single Return Value
	$arrOrdered[0] = $arrToSort
	$arrOrdered[1] = $arrToSwap
	Return $arrOrdered
EndFunc   ;==>_sortArrays

; #FUNCTION# ====================================================================================================================
; Name ..........: _exit
; Syntax ........: _exit()
; Return values .: None
; ===============================================================================================================================
Func _exit()
	Exit
EndFunc   ;==>_exit
