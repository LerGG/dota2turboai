$iColorLevelUp = 6702341
$level = 0

sleep(2000)
while 1
    $bLevel = _skillHero($level)
    If $bLevel = True Then
        $level += 1
    EndIf
    _tt($level)
    sleep(1000)
WEnd

Func _tt($sToolTip)
	If UBound($sToolTip) = 2 Then
		ToolTip("X: " & $sToolTip[0] & "Y: " & $sToolTip[1], 0, 0)
	Else
		ToolTip($sToolTip, 0, 0)
	EndIf
EndFunc   ;==>_tt

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
		Send("^{c}")
		Sleep(Random(100,150))
		Send("^{y}")
        Sleep(Random(100,150))
		Send("^{d}")
		Sleep(Random(100,150))
		Send("^{x}")
		Sleep(Random(100,150))
		Send("^{v}")
        Sleep(Random(100,150))
		Send("{ESC}")
		Return True
	EndIf
    Return False
EndFunc   ;==>_skillHero