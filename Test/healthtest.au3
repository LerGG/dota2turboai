Global Const $iColorHealth = 4227109
Global Const $color_lowHealth = 2042385




while 1
    _checkLowHealth()
    sleep(100)
Wend 


;MAX 1100,1020;4226598
;MIN 736,1030;5289782

;811,1028;4621610

Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

Func _checkLowHealth()
	If IsArray(PixelSearch(736,1020, 830,1022, $color_lowHealth, 2)) Then
		Return True
	Else
		Return False
	EndIf
EndFunc