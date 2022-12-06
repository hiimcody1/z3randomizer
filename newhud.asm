InfiniteTile = $2431
BlankTile = $207F
SlashTile = $2830
PTile = $296C
CTile = $295F

;===================================================================================================

NewDrawHud:
	PHB

	SEP #$30
	REP #$10

	LDA.b #$7E
	PHA
	PLB

;===================================================================================================

NewHUD_DrawBombs:
	LDA.l InfiniteBombs : BEQ .finite

.infinite
	LDY.w #InfiniteTile+0
	LDX.w #InfiniteTile+1

	BRA .draw

.finite
	LDA.w BombsEquipment
	JSR HUDHex2Digit

.draw
	STY.w HUDBombCount+0
	STX.w HUDBombCount+2

;===================================================================================================

NewHUD_DrawRupees:
	REP #$20

	LDA.w DisplayRupees
	JSR HUDHex4Digit

	LDA.b Scrap04 : TAX : STX.w HUDRupees+0 ; 1000s
	LDA.b Scrap05 : TAX : STX.w HUDRupees+2 ;  100s
	LDA.b Scrap06 : TAX : STX.w HUDRupees+4 ;   10s
	LDA.b Scrap07 : TAX : STX.w HUDRupees+6 ;    1s

;===================================================================================================

NewHUD_DrawArrows:
	SEP #$20

	LDA.l ArrowMode
	BNE NewHUD_DrawGoal

	LDA.l InfiniteArrows : BEQ .finite

.infinite
	LDY.w #InfiniteTile+0
	LDX.w #InfiniteTile+1

	BRA .draw

.finite
	LDA.w CurrentArrows
	JSR HUDHex2Digit

.draw
	STY.w HUDArrowCount+0
	STX.w HUDArrowCount+2

;===================================================================================================

NewHUD_DrawGoal:
	REP #$20

	LDA.l GoalItemRequirement
	BEQ .no_goal

	LDA.l GoalItemIcon
	STA.w HUDGoalIndicator

	LDA.w #SlashTile
	STA.w HUDGoalIndicator+8

	LDA.l GoalCounter
	JSR HUDHex4Digit

	LDA.b Scrap05 : TAX : STX.w HUDGoalIndicator+2 ; draw 100's digit
	LDA.b Scrap06 : TAX : STX.w HUDGoalIndicator+4 ; draw 10's digit
	LDA.b Scrap07 : TAX : STX.w HUDGoalIndicator+6 ; draw 1's digit


	REP #$20

	LDA.l GoalItemRequirement
	CMP.w #$FFFF
	BNE .real_goal

	LDX.w #BlankTile
	STX.w HUDGoalIndicator+10
	STX.w HUDGoalIndicator+12
	STX.w HUDGoalIndicator+14

.no_goal
	SEP #$20
	BRA NewHUD_DrawKeys

.real_goal
	JSR HUDHex4Digit

	LDA.b Scrap05 : TAX : STX.w HUDGoalIndicator+10 ; draw 100's digit
	LDA.b Scrap06 : TAX : STX.w HUDGoalIndicator+12 ; draw 10's digit
	LDA.b Scrap07 : TAX : STX.w HUDGoalIndicator+14 ; draw 1's digit

;===================================================================================================

NewHUD_DrawKeys:
	LDA.l CurrentSmallKeys
	CMP.b #$FF
	BNE .in_dungeon

	LDY.w #BlankTile
	STY.w HUDKeyIcon
	STY.w HUDKeyDigits+0
	STY.w HUDKeyDigits+2
	BRA NewHUD_DrawCompassCount

.in_dungeon
	JSR HUDHex2Digit
	CPY.w #$2490
	BNE .real_10s

	LDY.w #BlankTile

.real_10s
	STY.w HUDKeyDigits+0
	STX.w HUDKeyDigits+2

;===================================================================================================

NewHUD_DrawCompassCount:
	LDA.b IndoorsFlag
	BNE .indoors

	JMP NewHUD_DrawMagicMeter

.indoors
	LDA.l CompassMode
	BEQ NewHUD_DrawPrizeIcon

	SEP #$30
	; force dungeon ID to a multiple of 2
	LDA.w DungeonID
	CMP.b #$1B : BCS NewHUD_DrawPrizeIcon ; skip if invalid dungeon
	AND.b #$FE : TAX
	LSR : TAY ; save reduced ID in Y

	; no compass needed if this bit is set
	LDA.l CompassMode
	BIT.b #$02
	BNE .draw_compass_count

	LDA.l CompassField
	AND.l DungeonItemMasks,X
	BEQ NewHUD_DrawPrizeIcon

.draw_compass_count
	TYX
	BNE .not_sewers

	INX

.not_sewers
	LDA.l DungeonLocationsChecked, X
	PHA

	LDA.l CompassTotalsWRAM,X

	JSR HUDHex2Digit
	STY.w HUDTileMapBuffer+$9A
	STX.w HUDTileMapBuffer+$9C

	LDX.w #SlashTile
	STX.w HUDTileMapBuffer+$98 

	PLA
	JSR HUDHex2Digit
	STY.w HUDTileMapBuffer+$94
	STX.w HUDTileMapBuffer+$96

;===================================================================================================

NewHUD_DrawPrizeIcon:
	LDA.b GameMode
	CMP.b #$12
	BEQ .no_prize

	LDA.w DungeonID
	CMP.b #$1A : BCS .no_prize
	CMP.b #$04 : BCC .no_prize
	CMP.b #$08 : BNE .dungeon

.no_prize
	LDY.w #BlankTile
	BRA .draw_prize

.dungeon
	SEP #$30
	TAX
	LSR
	TAY
	LDA.l MapMode

	REP #$30

	LDA.l MapField
	AND.l DungeonItemMasks,X

	SEP #$20
	BEQ .no_prize

	TYX
	LDA.l CrystalPendantFlags_2,X
	AND.b #$40
	BNE .crystal

	LDY.w #PTile
	BRA .draw_prize

.crystal
	LDY.w #CTile

.draw_prize
	STY.w HUDPrizeIcon

;===================================================================================================

DrawMagicMeter_mp_tilemap = $0DFE0F

NewHUD_DrawMagicMeter:
	SEP #$31
	LDA.l CurrentMagic
	ADC.b #$06 ; carry set by above for +1 to get +7
	AND.b #$F8
	TAY

	LDA.l InfiniteMagic
	BEQ .set_index

.infinite_magic
	LDA.b #$80
	STA.l CurrentMagic
	TAY

	LDA.b FrameCounter
	AND.b #$0C
	LSR

.set_index ; this branch is always 0000 when taken
	TAX

	LDA.l MagicMeterColorMasks,X

	TYX
	TAY : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$046
	TYA : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$086
	TYA : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$0C6
	TYA : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$106

;===================================================================================================

NewHUD_DoneDrawing:
	PLB
	RTL

;===================================================================================================

MagicMeterColorMasks:
	dw $FFFF ; green - KEEP GREEN FIRST
	dw $EFFF ; blue
	dw $E7FF ; red
	dw $EBFF ; yellow
	dw $E3FF ; orange

;===================================================================================================
; Exits with:
;   X - ones place tile
;   Y - tens place tile
;===================================================================================================
NOP ; this nop makes HUDHex2Digit be at $B00B
HUDHex2Digit:
	SEP #$30 ; clear high byte of X and Y and make it so they don't get B
	ASL
	TAX

	REP #$10

	LDA.b #$24 ; tile props in high byte
	XBA

	LDA.l FastHexTable,X
	LSR
	LSR
	LSR
	LSR
	ORA.b #$90
	TAY

	LDA.l FastHexTable,X
	AND.b #$0F
	ORA.b #$90
	TAX

	RTS

;===================================================================================================

HUDHex4Digit:
	JSL HexToDec

	REP #$30

	LDA.l HexToDecDigit2
	ORA.w #$9090
	STA.b Scrap04

	LDA.l HexToDecDigit4
	ORA.w #$9090
	STA.b Scrap06

	LDA.w #$2400

	SEP #$20
	RTS

;===================================================================================================
