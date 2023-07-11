#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTuBe

 Script Function:
	Draft related functions

#ce ----------------------------------------------------------------------------

#include <TurboAIConst.au3>
#include <TurboAiHelpFunctions.au3>
#include <TurboAiFunctions.au3>
#include <TurboAiGameFunctions.au3>
#include <TurboAIGUI.au3>
#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _pickHero
; Description ...: Selects hero at a given x y position
; Syntax ........: _pickHero($iX, $iY, $sHero)
; Parameters ....: $iX                  - X coordinate
;                  $iY                  - Y coordinate
;                  $sHero           	- Hero Name String
; ===============================================================================================================================
Func _pickHero($iX, $iY, $sHero)
	MouseClick("Left", $iX, $iY)
	Sleep(Random(250, 450))
	MouseClick("Left",$arr_pickHeroButton[0],$arr_pickHeroButton[1])
	Sleep(Random(250, 450))
	_addEntryGUILog("_pickHero: " & $sHero, 0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _draft
; Description ...:  Selects list of given heroes and buys starting items.
; Syntax ........: _draft()
; ===============================================================================================================================
Func _draft()
	If _checkDraft() = True Then
		_addEntryGUILog("_draft: Draft started", 0)
		; Randoms Hero
		Local $iRandomOrder = Random (1,4,1)
		
 		If $iRandomOrder = 1 Then 
			_pickHero(255,645, "Axe")
			_pickHero(972,645, "Legion")
			_pickHero(510,647, "Chaosknight")
			_pickHero(467,726, "Timber")
		EndIf

		If $iRandomOrder = 2 Then 
			_pickHero(972,645, "Legion")
			_pickHero(255,645, "Axe")
			_pickHero(467,726, "Timber")
			_pickHero(510,647, "Chaosknight")
		EndIf

		If $iRandomOrder = 3 Then 
			_pickHero(467,726, "Timber")
			_pickHero(972,645, "Legion")
			_pickHero(255,645, "Axe")
			_pickHero(510,647, "Chaosknight")
		EndIf

		If $iRandomOrder = 4 Then 
			_pickHero(510,647, "Chaosknight")
			_pickHero(467,726, "Timber")
			_pickHero(972,645, "Legion")
			_pickHero(255,645, "Axe")
		EndIf 

		_buyStartingItems()
		_addEntryGUILog("_draft: Wait Game Start", 0)
		; Sleep until game start
		For $i = 1 To 60
			If _checkIngame() = True OR _acceptGame() = True Then ExitLoop
			Sleep(100)
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
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_checkDraft

; #FUNCTION# ====================================================================================================================
; Name ..........: _buyStartingItems
; Description ...: Buys starting items
; Syntax ........: _buyStartingItems()
; ===============================================================================================================================
Func _buyStartingItems()
	Sleep(Random(350, 1000))
	MouseClick("Right", 1379,757) ; Bracer
	_addEntryGUILog("_buyStartingItems: Items bought", 0)
EndFunc   ;==>_buyStartingItems