#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         TeTube

 Script Function:
	All Constant Variables
	Include only

#ce ----------------------------------------------------------------------------

#include-once

;-------------------------------------------
; @@@@@@@ CHECKSUMS @@@@@@@@@@@@@@@@@@@@@@@@
;-------------------------------------------
Global Const $cs_gameFound = 2836413501 ; Accept Match Button
Global Const $cs_MainMenu = 191222980 ; Main Menu Boarder after last button
Global Const $cs_readyCheck = 1862865057 ; Ready Check Button
Global Const $cs_ingame = 487072004 ; Minimap Top Boarder
Global Const $cs_ingame_simpleBG = 4267838993  ; Minimap Top Boarder

; Minimap
Global Const $arrMiniMap[4] = ["8", "808", "269", "1067"] ; Minimap Rectangle
Global Const $iDistanceMax = 368 ; Max Minimap Distance
Global Const $iDistanceMaxHalf = 184 ; Max Minimap Distance Half

; Lane Rectangles
Global Const $arrCorridorRadSafe[4] = ["61", "1039", "256", "1057"] ; XY TopLeft XY BotRight
Global Const $arrCorridorDireOff[4] = ["239", "881", "258", "1054"] ; XY TopLeft XY BotRight
Global Const $arrCorridorDireSafe[4] = ["9", "809", "194", "848"] ; XY TopLeft XY BotRight
Global Const $arrCorridorRadOff[4] = ["9", "809", "44", "1006"] ; XY TopLeft XY BotRight
Global Const $arrCorridorMid[4] = ["53", "865", "213", "1029"] ; XY TopLeft XY BotRight

;9000704 dark brown | 9149500 bright brown | 5750232 teal | 14381991 pink
; Player Colors
Global Const $arrColorPlayersRadiant[5] = ["2777816", "5824422", "11206827", "13881608", "14572544"]
Global Const $arrColorPlayersDire[5] = ["5618388", "14513320", "9346622", "28699", "9132032"]
Global Const $iColorPlayerCircle = 15921906
Global Const $iColorLevelUp = 6702341
Global Const $iColorHealth = 4227109
Global Const $color_lowHealth = 2042385

; Healthbar Colors
Global Const $iColor_EnemyCreepHpBar = 8997944
Global Const $iColor_EnemyCreepMissingHP = 1706502
Global Const $iColor_EnemyHeroHP = 14759680

; Neutral Colors
Global Const $iColorNeutralCamp = 7884288
Global Const $iColorNeutralUnit = 11184810

; Rune Colors
Global Const $iColorBountyMinimap = 10179584
Global Const $iColorBountyScreen = 16775514

; Bounty Rune Positions
Global Const $arrBountyrunes_X[4] = ["206", "213", "60", "83"]
Global Const $arrBountyrunes_Y[4] = ["1004", "970", "910", "872"]

; Radiant Camp Positions
Global Const $arrRadiantCamps_X[8] = ["96", "70", "105", "139", "156", "187", "203", "222"]
Global Const $arrRadiantCamps_Y[8] = ["951", "918", "1014", "1018", "983", "1012", "1018", "1000"]

; Dire Camp Positions
Global Const $arrDireCamps_X[8] = ["176", "201", "162", "140", "113", "104", "85", "61"]
Global Const $arrDireCamps_Y[8] = ["945", "963", "877", "878", "878", "855", "852", "876"]

; All camp positions
Global Const $arrCamps_X[16] = ["96", "70", "105", "139", "156", "187", "203", "222","176", "201", "162", "140", "113", "104", "85", "61"]
Global Const $arrCamps_Y[16] = ["951", "918", "1014", "1018", "983", "1012", "1018", "1000","945", "963", "877", "878", "878", "855", "852", "876"]

; Building colors
Global Const $iColor_Frindly_Building = 8450560; 65280
Global Const $iColor_Enemy_Building_Fog = 16711680
Global Const $iColor_Enemy_Building = 16711680

; Thrones
Global Const $arrRadiantThrone[2] = ["27","1041"]
Global Const $arrDireThrone[2] = ["246","841"]

; Radiant T1 T2 T3 Offlane Mid Safelane
Global Const $arrRadiant_Tower_PosX[9] = ["27","27","21","112","79","56","229","134","69"]
Global Const $arrRadiant_Tower_PosY[9] = ["906","955","1000","963","988","1012","1049","1052","1049"]

; Dire T1 T2 T3 Offlane Mid Safelane
Global Const $arrDire_Tower_PosX[9] = ["253", "255", "255", "149", "185", "217", "56", "138", "204"]
Global Const $arrDire_Tower_PosY[9] = ["970", "932", "885", "925", "899", "870", "830", "827", "834"]

; Units
Global Const $iColor_Frindly_Creep = 5415168
Global Const $iColor_Enemy_Unit = 8209715

; Shop
Global Const $arr_shopBasic[2] = ["1616","129"]
Global Const $arr_shopUpgrade[2] = ["1735","130"]

; Draft
Global Const $arr_pickHeroButton[2] = ["1426","808"]
Global Const $color_DraftTime = 16777215
Global Const $color_RandomButton = 16777215

; Items - Colors
Global Const $color_Salve = 444688
Global Const $color_Boots = 8674617
Global Const $color_Vanguard = 5058411
Global Const $color_Heart = 15892228
Global Const $color_AC = 2116624
Global Const $color_WardObs = 1590018
Global Const $color_Smoke = 7841246
Global Const $color_TPScrollReady = 9602160

; Items - Shop Cords
Global Const $arr_Vanguard[2] = ["1763","189"]
Global Const $arr_Boots[2] = ["1790","346"]
Global Const $arr_Heart[2] = ["1762","566"]
Global Const $arr_AC[2] = ["1763","593"]
Global Const $arr_WardObs[2] = ["1634","284"]
Global Const $arr_Smoke[2] = ["1633","251"]

; Timings
Global Const $iPreGametime = 60-3 ; 3 = load time
Global Const $iCreepSpawntime = 120