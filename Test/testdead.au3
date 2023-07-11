Global Const $iColorHealth = 4227109
Global Const $color_lowHealth = 2042385

while 1
    _checkDead()
    sleep(100)
wend

Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

Func _checkDead()
	Local $Pos = PixelSearch(731, 1020, 736, 1041, $color_lowHealth, 5)
	If IsArray($Pos) Then
        _tt("Dead")
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkDead