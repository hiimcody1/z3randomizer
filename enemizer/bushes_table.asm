sprite_bush_spawn_table:
{
    ; SPRITE DATA TABLE GENERATED BY ENEMIZER
    .overworld
    ; Skip 0x128(overworld [way overkill]) + 0x128 (dungeons)
    skip $128
    .dungeons
    skip $128

    ;Old sprite table - Could be changed as well (for the item id 04)
    .random_sprites ; if item == 04
    db  #$00, #$D8, #$E3, #$D8
}

warnpc $B68374
; the drop table has $E1 at B6837D which needs to be #$DA with retro bow
item_drop_table_override:
db #$00, #$D9, #$3E, #$79, #$D9, #$DC, #$D8, #$DA, #$E4, #$E1, #$DC
db #$D8, #$DF, #$E0, #$0B, #$42, #$D3, #$41, #$D4, #$D9, #$E3, #$D8


