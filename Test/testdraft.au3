#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTuBe

 Script Function:
	Draft related functions

#ce ----------------------------------------------------------------------------

#include <../TurboAIConst.au3>
#include <../TurboAiHelpFunctions.au3>
#include <../TurboAiFunctions.au3>
#include <../TurboAiGameFunctions.au3>
#include-once

while 1
    _draft()
    sleep(100)
wend

; #FUNCTION# ====================================================================================================================
; Name ..........: _pickHero
; Description ...: Selects hero at a given x y position
; Syntax ........: _pickHero($iX, $iY, $sHero)
; Parameters ....: $iX                  - X coordinate
;                  $iY                  - Y coordinate
;                  $sHero           	- Hero Name String
; ===============================================================================================================================
Func _pickHero($iX, $iY, $sHero)
	_tt("Select Hero: " & $sHero)
	MouseClick("Left", $iX, $iY)
	Sleep(Random(250, 450))
	_tt("Pick Hero")
	MouseClick("Left",$arr_pickHeroButton[0],$arr_pickHeroButton[1])
	Sleep(Random(250, 450))
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _draft
; Description ...:  Selects list of given heroes and buys starting items.
; Syntax ........: _draft()
; ===============================================================================================================================
Func _draft()
	If _checkDraft() = True Then
		_pickHero(255,645, "Axe")
		_pickHero(972,645, "Legion")
		_pickHero(510,647, "Chaosknight")
		_pickHero(467,726, "Timber")
		_buyStartingItems()
		; Sleep until game start
		For $i = 1 To 60
			_tt("Wait Game Start")
			If _checkIngame() = True or _acceptGame() = True Then ExitLoop
			Sleep(1000)
		Next
	EndIf
EndFunc   ;==>_draft

; #FUNCTION# ====================================================================================================================
; Name ..........: _checkDraft
; Description ...: Checks if draft screen is active.
; Syntax ........: _checkDraft()
; Return values .: True = Draft Found; False = Draft not found
; ===============================================================================================================================
Func _checkDraft()
	Local $drafttime = PixelSearch(943,34,943,34, $color_DraftTime,0)
	Local $button = PixelGetColor(1688,795)
	If IsArray($drafttime) and $button = $color_RandomButton Then
		_tt("Draft Found")
		Return True
	Else
        _tt("Draft NOT Found")
		Return False
	EndIf
EndFunc   ;==>_checkDraft

; #FUNCTION# ====================================================================================================================
; Name ..........: _buyStartingItems
; Description ...: Buys starting items
; Syntax ........: _buyStartingItems()
; ===============================================================================================================================
Func _buyStartingItems()
	_tt("Buy Starting Items")
	Sleep(Random(350, 1000))
	MouseClick("Right", 1379,757) ; Bracer
EndFunc   ;==>_buyStartingItems