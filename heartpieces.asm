;================================================================================
; Randomize Heart Pieces
;--------------------------------------------------------------------------------
HeartPieceGet:
        PHX : PHY
        LDY.w $0E80, X ; load item value into Y register
        BNE +
                ; if for any reason the item value is 0 reload it, just in case
                JSL.l LoadHeartPieceRoomValue : TAY
        +
        JSL.l MaybeMarkDigSpotCollected

        .skipLoad

        STZ.w $02E9 ; 0 = Receiving item from an NPC or message

        CPY.b #$26 : BNE .notHeart ; don't add a 1/4 heart if it's not a heart piece
        LDA.l HeartPieceQuarter : INC A : AND.b #$03 : STA.l HeartPieceQuarter : BNE .unfinished_heart ; add up heart quarters
        BRA .giveItem

        .notHeart
        .giveItem
        JSL.l $0791B3 ; Player_HaltDashAttackLong
        JSL.l Link_ReceiveItem
        CLC ; return false
        JMP .done ; finished

        .unfinished_heart
        SEC ; return true
        .done
        JSL MaybeUnlockTabletAnimation

        PLY : PLX
RTL
;--------------------------------------------------------------------------------
HeartContainerGet:
	PHX : PHY
	JSL.l AddInventory_incrementBossSwordLong
	LDY $0E80, X ; load item value into Y register
	BNE +
		; if for any reason the item value is 0 reload it, just in case
		JSL.l LoadHeartContainerRoomValue : TAY
	+

	BRA HeartPieceGet_skipLoad
;--------------------------------------------------------------------------------
DrawHeartPieceGFX:
	PHP
	JSL.l Sprite_IsOnscreen : BCC .offscreen
	
	PHA : PHY
	LDA.l RedrawFlag : BEQ .skipInit ; skip init if already ready
	JSL.l HeartPieceSpritePrep
	JMP .done ; don't draw on the init frame
	
	.skipInit
	LDA.w $0E80, X ; Retrieve stored item type

	.skipLoad
	
	PHA
		JSL.l IsNarrowSprite : BCC +
		LDA.w $0E60, X : ORA.b #$20 : STA.w $0E60, X
	+
    PLA
	
	JSL.l DrawDynamicTile
	JSL.l Sprite_DrawShadowLong 
	
	.done
	PLY : PLA
	.offscreen
	PLP
RTL
;--------------------------------------------------------------------------------
DrawHeartContainerGFX:
	PHP
	JSL.l Sprite_IsOnscreen : BCC DrawHeartPieceGFX_offscreen
	
	PHA : PHY
	LDA.l RedrawFlag : BEQ .skipInit ; skip init if already ready
	JSL.l HeartContainerSpritePrep
	BRA DrawHeartPieceGFX_done ; don't draw on the init frame
	
	.skipInit
	LDA.w $0E80, X ; Retrieve stored item type

	BRA DrawHeartPieceGFX_skipLoad
;--------------------------------------------------------------------------------
HeartContainerSound:
	CPY.b #$20 : BEQ + ; Skip for Crystal
	CPY.b #$37 : BEQ + ; Skip for Pendants
	CPY.b #$38 : BEQ +
	CPY.b #$39 : BEQ +
    JSL.l CheckIfBossRoom : BCC + ; Skip if not in a boss room
	        LDA.b #$2E
			SEC
		RTL
	+
	CLC
RTL
;--------------------------------------------------------------------------------
NormalItemSkipSound:
	LDA.w $0C5E, X ; thing we wrote over

	CPY.b #$20 : BEQ + ; Skip for Crystal
	CPY.b #$37 : BEQ + ; Skip for Pendants
	CPY.b #$38 : BEQ +
	CPY.b #$39 : BEQ +
	
	PHA
        JSL.l CheckIfBossRoom
	PLA
RTL
	+
	CLC
RTL
;--------------------------------------------------------------------------------
HeartPieceSpritePrep:
	PHA
	
	LDA.l ServerRequestMode : BEQ + :  : +
	
	LDA.b #$01 : STA.l RedrawFlag
	LDA.b $5D : CMP.b #$14 : BEQ .skip ; skip if we're mid-mirror

	LDA.b #$00 : STA.l RedrawFlag
	JSL.l LoadHeartPieceRoomValue ; load item type
	STA.w $0E80, X ; Store item type
	JSL.l PrepDynamicTile
	
	.skip
	PLA
RTL
;--------------------------------------------------------------------------------
HeartContainerSpritePrep:
	PHA
	
	LDA.b #$00 : STA.l RedrawFlag
	JSL.l LoadHeartContainerRoomValue ; load item type
	STA.w $0E80, X ; Store item type
	JSL.l PrepDynamicTile
	
	PLA
RTL
;--------------------------------------------------------------------------------
LoadHeartPieceRoomValue:
	LDA.b $1B : BEQ .outdoors ; check if we're indoors or outdoors
	.indoors
	JSL.l LoadIndoorValue
	JMP .done
	.outdoors
	JSL.l LoadOutdoorValue
	.done
RTL
;--------------------------------------------------------------------------------
HPItemReset:
	JSL $09AD58 ; GiveRupeeGift - thing we wrote over
	PHA : LDA.b #$01 : STA.l RedrawFlag : PLA
RTL
;--------------------------------------------------------------------------------
MaybeMarkDigSpotCollected:
	PHA : PHP
		LDA.b $1B : BNE +
		REP #$20 ; set 16-bit accumulator
		LDA.b $8A
		CMP.w #$2A : BNE +
			LDA.l HasGroveItem : ORA.w #$0001 : STA.l HasGroveItem
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
macro GetPossiblyEncryptedItem(ItemLabel,TableLabel)
	LDA.l IsEncrypted : BNE ?encrypted
		LDA.l <ItemLabel>
		BRA ?done
	?encrypted:
	PHX : PHP
		REP #$30 ; set 16-bit accumulator & index registers
		LDA.b Scrap00 : PHA : LDA.b Scrap02 : PHA

		LDA.w #<TableLabel> : STA.b Scrap00
		LDA.w #<TableLabel>>>16 : STA.b Scrap02
		LDA.w #<ItemLabel>-<TableLabel>
		JSL RetrieveValueFromEncryptedTable

		PLX : STX.b Scrap02 : PLX : STX.b Scrap01
	PLP : PLX
	?done:
endmacro

LoadIndoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #225 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Forest_Thieves, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #226 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lumberjack_Tree, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #234 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Spectacle_Cave, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #283 : BNE +
		LDA.b $22 : XBA : AND.w #$0001 ; figure out where link is
		BNE ++
			%GetPossiblyEncryptedItem(HeartPiece_Circle_Bushes, HeartPieceIndoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Graveyard_Warp, HeartPieceIndoorValues)
			JMP .done
	+ CMP.w #294 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Mire_Warp, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #295 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Smith_Pegs, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #135 : BNE +
		LDA.l StandingKey_Hera
		JMP .done
	+
	LDA.w #$0017 ; default to a normal hp
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;225 - HeartPiece_Forest_Thieves
;226 - HeartPiece_Lumberjack_Tree
;234 - HeartPiece_Spectacle_Cave
;283 - HeartPiece_Circle_Bushes
;283 - HeartPiece_Graveyard_Warp
;294 - HeartPiece_Mire_Warp
;295 - HeartPiece_Smith_Pegs
;--------------------------------------------------------------------------------
LoadOutdoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b $8A
	CMP.w #$03 : BNE +
		LDA.b $22 : CMP.w #1890 : !BLT ++
			%GetPossiblyEncryptedItem(HeartPiece_Spectacle, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(EtherItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$05 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Mountain_Warp, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$28 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Maze, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$2A : BNE +
		%GetPossiblyEncryptedItem(HauntedGroveItem, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$30 : BNE +
		LDA.b $22 : CMP.w #512 : !BGE ++
			%GetPossiblyEncryptedItem(HeartPiece_Desert, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(BombosItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$35 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lake, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$3B : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Swamp, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$42 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$4A : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$5B : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Pyramid, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$68 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Digging, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$81 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Zora, HeartPieceOutdoorValues)
		JMP .done
	+
	LDA.w #$0017 ; default to a normal hp
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;$03 - HeartPiece_Spectacle
;$05 - HeartPiece_Mountain_Warp
;$28 - HeartPiece_Maze
;$30 - HeartPiece_Desert
;$35 - HeartPiece_Lake
;$3B - HeartPiece_Swamp
;$42 - HeartPiece_Cliffside - not really but the gfx load weird otherwise
;$4A - HeartPiece_Cliffside
;$5B - HeartPiece_Pyramid
;$68 - HeartPiece_Digging
;$81 - HeartPiece_Zora
;--------------------------------------------------------------------------------
LoadHeartContainerRoomValue:
LoadBossValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #200 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_ArmosKnights, HeartContainerBossValues)
		JMP .done
	+ CMP.w #51 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Lanmolas, HeartContainerBossValues)
		JMP .done
	+ CMP.w #7 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Moldorm, HeartContainerBossValues)
		JMP .done
	+ CMP.w #90 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_HelmasaurKing, HeartContainerBossValues)
		JMP .done
	+ CMP.w #6 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Arrghus, HeartContainerBossValues)
		JMP .done
	+ CMP.w #41 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Mothula, HeartContainerBossValues)
		JMP .done
	+ CMP.w #172 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Blind, HeartContainerBossValues)
		JMP .done
	+ CMP.w #222 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Kholdstare, HeartContainerBossValues)
		JMP .done
	+ CMP.w #144 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Vitreous, HeartContainerBossValues)
		JMP .done
	+ CMP.w #164 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Trinexx, HeartContainerBossValues)
		JMP .done
	+
	LDA.w #$003E ; default to a normal boss heart
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
CheckIfBossRoom:
;--------------------------------------------------------------------------------
; Carry set if we're in a boss room, unset otherwise.
;--------------------------------------------------------------------------------
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #200 : BEQ .done
	CMP.w #51 : BEQ .done
	CMP.w #7 : BEQ .done
	CMP.w #90 : BEQ .done
	CMP.w #6 : BEQ .done
	CMP.w #41 : BEQ .done
	CMP.w #172 : BEQ .done
	CMP.w #222 : BEQ .done
	CMP.w #144 : BEQ .done
	CMP.w #164 : BEQ .done
	CLC
	.done
+	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
;#200 - Eastern Palace - Armos Knights
;#51 - Desert Palace - Lanmolas
;#7 - Tower of Hera - Moldorm
;#32 - Agahnim's Tower - Agahnim I
;#90 - Palace of Darkness - Helmasaur King
;#6 - Swamp Palace - Arrghus
;#41 - Skull Woods - Mothula
;#172 - Thieves' Town - Blind
;#222 - Ice Palace - Kholdstare
;#144 - Misery Mire - Vitreous
;#164 - Turtle Rock - Trinexx
;#13 - Ganon's Tower - Agahnim II
;#0 - Pyramid of Power - Ganon
;--------------------------------------------------------------------------------
;JSL $06DD40 ; DashKey_Draw
;JSL $06DBF8 ; Sprite_PrepAndDrawSingleLargeLong
;JSL $06DC00 ; Sprite_PrepAndDrawSingleSmallLong ; draw first cell correctly
;JSL $00D51B ; GetAnimatedSpriteTile
;JSL $00D52D ; GetAnimatedSpriteTile.variable
;================================================================================
