#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTuBe

 Script Function:
				Non Game Core functions

#ce ----------------------------------------------------------------------------

#include <TurboAIConst.au3>
#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkMainMenu
; Description ...: Checks if in main menu
; Syntax ........: _checkMainMenu()
; Return values .: True = Main Menu Active ; False = Not Active
; ===============================================================================================================================
Func _checkMainMenu()
	Local $currentCheckSum_Menu = PixelChecksum(1230,1,1280,25)
	If $currentCheckSum_Menu = $cs_MainMenu Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkMainMenu

; #FUNCTION# ====================================================================================================================
; Name ..........: _acceptGame
; Description ...: Accepts Match
; Syntax ........: _acceptGame()
; ===============================================================================================================================
Func _acceptGame()
	Local $cs_current = PixelChecksum(725, 505, 735, 515)
	; Clicks accept game button.
	If $cs_current = $cs_gameFound Then
		MouseClick("left", "936", "541", 2)
        Sleep(Random(350, 1000))
        MouseMove(0,0)
        Sleep(Random(350, 1000))
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_acceptGame

; #FUNCTION# ====================================================================================================================
; Name ..........: _acceptReadyCheck
; Description ...: Accepts ready check
; Syntax ........: _acceptReadyCheck()
; ===============================================================================================================================
Func _acceptReadyCheck()
    Local $cs_current = PixelChecksum(799,420,1125,451)
    ; Clicks ready check button.
    If $cs_current = $cs_readyCheck Then
        MouseClick("left", "792", "632", 2)
        Sleep(Random(350, 1000))
        MouseMove(0,0)
        Sleep(Random(350, 1000))
		Return True
    Else
		Return False
	EndIf
EndFunc
