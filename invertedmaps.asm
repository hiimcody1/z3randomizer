Overworld_LoadNewTiles:
{
    ; add sign to EDM for OWG people to read
    LDA $040A : AND #$00FF : CMP #$0005 : BNE +
        LDA #$0101 : STA $7E2E18 ; #$0101 is the sign tile16 id, $7E2D98 is the position of the tile16 on map
    +

    ; GT sign
    LDA InvertedMode : AND #$00FF : BNE +
    LDA $040A : AND #$00FF : CMP #$0043 : BNE +
        LDA #$0101 : STA $7E2550
    +

    ; Pyramid sign
    LDA InvertedMode : AND #$00FF : BNE +
    LDA $040A : AND #$00FF : CMP #$005B : BNE +
        LDA #$0101 : STA $7E27B6 ;Moved sign near statue
        LDA #$05C2 : STA $7E27B4 ;added a pyramid peg on the left of the sign
    +

    SEP #$30
    LDA InvertedMode : BEQ .notInverted
    PHB

    ; Set the data bank to $7E.
    LDA.b #$7E : PHA : PLB
    REP #$30
    ; Use it as an index into a jump table.
    LDA $8A : CMP #$0080 : !BGE .noData
    ASL A : TAX

    JSR (Overworld_NewTilesTable, X)
    .noData
    PLB
    .notInverted
    REP #$30
    LDX #$001E : LDA #$0DBE

    RTL
}


Overworld_NewTilesTable:
{
;LW
    ;00      01      02      03      04      05      06      07
dw return, return, return, map003, return, map005, return, map007
    ;08      09      10      11      12      13      14      15
dw return, return, return, return, return, return, return, return
    ;16      17      18      19      20      21      22      23
dw map016, return, return, return, map020, return, return, return
    ;24      25      26      27      28      29      30      31
dw return, return, return, map027, return, return, return, return
    ;32      33      34      35      36      37      38      39
dw return, return, return, return, return, return, return, return
    ;40      41      42      43      44      45      46      47
dw return, map041, return, return, return, return, return, return
    ;48      49      50      51      52      53      54      55
dw map049, return, map050, map051, return, map053, return, return
    ;56      57      58      59      60      61      62      63
dw return, return, map058, return, map060, return, return, return
;DW
    ;64      65      66      67      68      69      70      71
dw return, return, return, map068, return, map078, return, map071
    ;72      73      74      75      76      77      78      79
dw return, return, return, return, return, return, return, return
    ;80      81      82      83      84      85      86      87
dw map080, return, return, return, map084, return, return, return
    ;88      89      90      91      92      93      94      95
dw return, return, return, map091, return, return, return, return
    ;96      97      98      99     100     101     102     103
dw return, return, return, return, return, return, return, return
    ;104     105    106     107     108     109     110     111
dw return, return, return, return, return, return, return, map111
    ;112     113    114     115     116     117     118     119
dw map120, return, return, map115, return, map117, return, return
    ;120     121    122     123     124     125     126     127
dw return, return, return, return, return, return, return, return

return:
RTS

map003:
{
LDA #$021A : STA $29B6
LDA #$01F3 : STA $29B8
LDA #$00A0 : STA $29BA
LDA #$0104 : STA $29BC
LDA #$00C6 : STA $2A34
STA $2A38
STA $2A3A
LDA #$0034 : STA $2BE0
RTS
}

map005:
{
LDA #$0111 : STA $206E
STA $20EC
LDA #$0113 : STA $2070
STA $2072
LDA #$0112 : STA $2074
STA $20EE
STA $216C
LDA #$0116 : STA $20F0
STA $216E
LDA #$0117 : STA $20F2
LDA #$0118 : STA $20F4
LDA #$011C : STA $2170
LDA #$011D : STA $2172
LDA #$011E : STA $2174
LDA #$0130 : STA $21E2
STA $21F0
STA $22E2
STA $22F0
LDA #$0123 : STA $21EC
LDA #$0124 : STA $21EE
LDA #$0034 : STA $21F2
LDA #$0126 : STA $21F4
LDA #$0135 : STA $2262
STA $2270
STA $2362
STA $2370
LDA #$0136 : STA $2264
STA $2266
STA $226C
STA $226E
LDA #$0137 : STA $2268
STA $226A
LDA #$013C : STA $22E4
STA $22E6
STA $22EC
STA $22EE
LDA #$013D : STA $22E8
STA $22EA
LDA #$0144 : STA $2364
LDA #$0145 : STA $2366
LDA #$0146 : STA $2368
LDA #$0147 : STA $236A
LDA #$01B3 : STA $236C
LDA #$01B4 : STA $236E
LDA #$0139 : STA $2970
STA $2C6C
LDA #$014B : STA $2972
STA $2C6E
LDA #$016B : STA $29F0
STA $2CEC
LDA #$0182 : STA $29F2
STA $2CEE

.map014
LDA #$0034 : STA $3D4A

RTS
}

map007:
{
LDA #$021B : STA $259E
STA $25A2
STA $25A4
STA $261C
STA $2626
STA $269A
STA $26A8
STA $271A
STA $2728
STA $279A
STA $27A8
STA $281E
STA $2820
STA $2822
STA $2824
STA $2828
STA $289C
STA $28A6
STA $291E
STA $2924
LDA #$0134 : STA $269E
STA $26A4
LDA #$0034 : STA $2826
RTS
}

map016:
{
LDA #$0034 : STA $2B2E
RTS
}

map020:
{
LDA #$02F1 : STA $2422
LDA #$02F2 : STA $2424
LDA #$0184 : STA $24A2
STA $2522
LDA #$0185 : STA $24A4
STA $2524
RTS
}

map027: ;Castle map
{

LDA #$0485 : STA $2424
STA $2426
LDA #$0454 : STA $24A4
STA $24A6
LDA #$0476 : STA $2522
LDA #$0460 : STA $2524
STA $2526
LDA #$04D7 : STA $2528
LDA #$04DD : STA $2624
LDA #$04DE : STA $2626
LDA #$04E0 : STA $26A4
LDA #$04E1 : STA $26A6
LDA #$04E4 : STA $2724
LDA #$04E5 : STA $2726
LDA #$0034 : STA $27A4
STA $27A6

;Eye removed
LDA #$046D : STA $243E
STA $24BC
STA $24BE
STA $253E
STA $2440
STA $24C0
STA $24C2
STA $2540

;new trees
LDA #$0035 : STA $2C28
STA $2FAE
LDA #$0034 : STA $2C2C
STA $2C2E
STA $2CB6
STA $2D36
STA $2DB6
STA $2EB6
STA $2F30
STA $2F36
STA $2FAA
STA $2FB0
STA $2FB4
STA $2FB6
LDA #$00E2 : STA $2C36
STA $2FA8
LDA #$00AE : STA $2CAC
LDA #$00AF : STA $2CAE
LDA #$007E : STA $2CB0
LDA #$007F : STA $2CB2
LDA #$04BA : STA $2CB4
STA $2DB4
STA $2EB4
LDA #$00B0 : STA $2D2C
LDA #$0014 : STA $2D2E
LDA #$0015 : STA $2D30
LDA #$00A8 : STA $2D32
LDA #$04BB : STA $2D34
STA $2E34
STA $2F34
LDA #$0089 : STA $2DAC
LDA #$001C : STA $2DAE
LDA #$001D : STA $2DB0
LDA #$0076 : STA $2DB2
LDA #$00F1 : STA $2E2C
LDA #$004E : STA $2E2E
LDA #$004F : STA $2E30
LDA #$00D9 : STA $2E32
LDA #$009A : STA $2EAC
LDA #$009B : STA $2EAE
LDA #$009C : STA $2EB0
LDA #$0095 : STA $2EB2

LDA #$0034
STA $3028
STA $302C
LDA #$0035 : STA $302A
STA $3032
LDA #$00DA : STA $302E
LDA #$00E2 : STA $3030



LDA #$0485 : STA $2424
STA $2426
LDA #$0454 : STA $24A4
STA $24A6
LDA #$0476 : STA $2522
LDA #$0460 : STA $2524
STA $2526
LDA #$04D7 : STA $2528
LDA #$04DD : STA $2624
LDA #$04DE : STA $2626
LDA #$04E0 : STA $26A4
LDA #$04E1 : STA $26A6
LDA #$04E4 : STA $2724
LDA #$04E5 : STA $2726
LDA #$0034 : STA $27A4
STA $27A6

LDA #$0486 : STA $26B0
LDA #$0487 : STA $26B2
LDA #$0454 : STA $272C
STA $272E
LDA #$048E : STA $2730
LDA #$048F : STA $2732
LDA #$04CA : STA $27AC
LDA #$045E : STA $27AE
LDA #$0494 : STA $27B0
LDA #$0495 : STA $27B2
LDA #$049E : STA $27B4
LDA #$0499 : STA $282C
LDA #$0451 : STA $2830
LDA #$0034 : STA $28AC
STA $28AE
STA $28B0
LDA #$0454 : STA $274E
STA $2750
LDA #$0608 : STA $2752
LDA #$0459 : STA $27CE
STA $27D0
LDA #$045E : STA $27D2
LDA #$0451 : STA $284E
STA $2850
STA $2852
STA $282E
LDA #$0034 : STA $28CE
STA $28D0
STA $28D2


; CHECK IF AGAHNIM 2 IS DEAD AND WE HAVE ALREADY LANDED
LDA OverworldEventDataWRAM+$5B : AND #$0020 : BEQ .agahnim2Alive
LDA #$046D : STA $243E
LDA #$0E3A : STA $24BC
LDA #$0E3B : STA $24BE
LDA #$0E3E : STA $253C
LDA #$0E3F : STA $253E
LDA #$0490 : STA $25BE
LDA #$0E39 : STA $2440
LDA #$0E3C : STA $24C0
LDA #$0E3D : STA $24C2
LDA #$0E40 : STA $2540
LDA #$0E41 : STA $2542
LDA #$0491 : STA $25C0
.agahnim2Alive

; add sign for Tower Entry
LDA #$0101 : STA $7E222C
LDA #$0101 : STA $7E2252

RTS
}

map041:
{
LDA #$0034 : STA $2288
STA $2308
STA $2388
STA $2408
STA $2488
STA $248A
LDA #$0036 : STA $2386
RTS
}

map049:
{
LDA #$017E : STA $2050
STA $20CE
LDA #$00D1 : STA $2052
STA $2054
STA $2056
STA $2058
STA $205A
STA $205C
STA $205E
STA $21E6
STA $21E8
STA $21EA
STA $21EC
STA $21EE
STA $21F0
LDA #$00D2 : STA $2060
STA $20E2
STA $2164
LDA #$0183 : STA $20D0
STA $214E
LDA #$00C9 : STA $20D2
STA $20D4
STA $20D6
STA $20D8
STA $20DA
STA $20DC
STA $20DE
STA $2152
STA $2154
STA $2156
STA $2158
STA $215A
STA $215C
STA $215E
STA $2266
STA $2268
STA $226A
STA $226C
STA $226E
STA $2270
STA $22CC
LDA #$00D0 : STA $20E0
STA $2162
STA $21E4
LDA #$0153 : STA $2150
STA $21CE
STA $21D0
STA $2250
STA $22CE
LDA #$00C8 : STA $2160
STA $21E2
STA $2264
STA $28DA
STA $295C
LDA #$00DC : STA $21D2
STA $21D4
STA $21D6
STA $21D8
STA $21DA
STA $21DC
STA $21DE
STA $224C
LDA #$00CA : STA $21E0
STA $2262
STA $285A
STA $28DC
LDA #$0178 : STA $224E
LDA #$00E3 : STA $2252
STA $2254
LDA #$0186 : STA $22D0
STA $234E
LDA #$0034 : STA $22D2
STA $22D4
STA $22D6
STA $2350
STA $2352
STA $2354
STA $2356
STA $23D0
STA $23D2
STA $23D4
STA $23D6
STA $2452
STA $2454
STA $2456
STA $2458
STA $24D4
STA $24D6
STA $2554
STA $2556
STA $25D4
STA $25D6
STA $2656
LDA #$00D3 : STA $22E2
LDA #$0302 : STA $22E4
LDA #$00CC : STA $22E6
STA $22E8
STA $22EA
STA $22EC
STA $22EE
STA $22F0
STA $234C
LDA #$00CE : STA $2362
STA $23E2
STA $25D8
STA $2658
STA $26D8
STA $2758
LDA #$00C5 : STA $2364
STA $23E4
STA $25DC
STA $265C
STA $26DC
STA $275C
LDA #$06AB : STA $2366
STA $23E6
STA $2466
STA $24E4
STA $24E6
STA $2760
LDA #$00AA : STA $2368
LDA #$0384 : STA $236A
STA $236E
STA $23EC
STA $246A
STA $24E8
STA $24EA
STA $24EC
STA $24EE
LDA #$00AB : STA $236C
LDA #$0759 : STA $23C8
STA $244A
STA $24CC
STA $254E
STA $26D0
STA $2752
STA $27D4
LDA #$0757 : STA $23CA
STA $244C
STA $24CE
STA $2550
STA $26D2
STA $2754
LDA #$01FF : STA $23CC
STA $244E
STA $24D0
STA $2652
STA $26D4
STA $2756
LDA #$017C : STA $23CE
STA $2450
STA $24D2
STA $2654
STA $26D6
LDA #$015C : STA $23E0
LDA #$0100 : STA $245A
STA $24D8
LDA #$01C2 : STA $245C
LDA #$0218 : STA $245E
LDA #$0162 : STA $2460
LDA #$0106 : STA $2462
STA $24E0
STA $255C
LDA #$0107 : STA $2464
STA $24E2
LDA #$0104 : STA $24DA
STA $2558
LDA #$01D4 : STA $24DC
LDA #$0219 : STA $24DE
LDA #$0179 : STA $2552
STA $25D2
LDA #$0105 : STA $255A
LDA #$0166 : STA $255E
LDA #$0766 : STA $2560
LDA #$06B4 : STA $2562
STA $2564
STA $2566
STA $2568
STA $256A
STA $256C
STA $256E
STA $2570
LDA #$06E5 : STA $25D0
STA $2650
LDA #$00C4 : STA $25DA
STA $265A
STA $26DA
STA $275A
LDA #$0171 : STA $25DE
LDA #$0165 : STA $25E4
STA $25E6
STA $25E8
STA $25EA
STA $25EC
STA $25EE
STA $25F0
LDA #$06E4 : STA $27D2
STA $2852
STA $2854
STA $2856
STA $28D4
STA $28D6
STA $2956
STA $2958
STA $29D8
STA $29DA
LDA #$06E1 : STA $27D6
LDA #$02FD : STA $27D8
STA $2858
LDA #$00CF : STA $27DA
LDA #$06E7 : STA $28D8
STA $295A
STA $29DC


LDA #$0769 : STA $38F8
LDA #$06E1 : STA $38FA
STA $38FC
STA $38FE
LDA #$06E3 : STA $3978
LDA #$02E5 : STA $397A
STA $397E
LDA #$02EC : STA $397C
LDA #$02F0 : STA $39F8
LDA #$02F3 : STA $39FA
STA $39FC
STA $39FE


.map056
LDA #$0034 : STA $3D94

RTS
}

map060:
{
LDA #$02E5 : STA $27AE
STA $282C
STA $282E
STA $2832
STA $28AC
STA $28AE
STA $2928
STA $292C
STA $29A8
STA $29B0
STA $2A28
STA $2A30
STA $2AAC
STA $2AB2
LDA #$078A : STA $28AA
STA $28B0
STA $2AAA
STA $2B2A
STA $2B30
STA $2BAE
LDA #$02EB : STA $28B4
STA $2930
STA $29AE
STA $2A2C
STA $2A32
STA $2AAE
LDA #$02EC : STA $2934
STA $2B28
STA $2B2C
STA $2B2E
STA $2B32
RTS
}

map050:
{
LDA #$01D5 : STA $2486
LDA #$0165 : STA $2506
LDA #$0166 : STA $2508
STA $258A
LDA #$00C6 : STA $2586
STA $2608
STA $2688
STA $2708
STA $2788
STA $2806
STA $2808
LDA #$0171 : STA $2588
LDA #$021C : STA $260A
STA $268A
STA $270A
STA $278A
LDA #$0034 : STA $270E
STA $278E
STA $2790
STA $280E
STA $2810
STA $2812
STA $2814
STA $2816
STA $2818
STA $281A
STA $281C
STA $288E
STA $2892
STA $2894
STA $2896
STA $2898
STA $289A
STA $289C
STA $289E
STA $290E
STA $2910
STA $2912
STA $2918
STA $291A
STA $291C
STA $291E
STA $2920
STA $298C
STA $298E
STA $2990
STA $2992
STA $2998
STA $299A
STA $299E
STA $29A0
STA $2A06
STA $2A08
STA $2A0A
STA $2A0C
STA $2A10
STA $2A12
STA $2A14
STA $2A16
STA $2A18
STA $2A1C
STA $2A1E
STA $2A84
STA $2A86
STA $2A88
STA $2A8C
STA $2A8E
STA $2A90
STA $2A92
STA $2A94
STA $2A96
STA $2A98
STA $2A9A
STA $2A9C
STA $2B06
STA $2B0A
STA $2B0E
STA $2B12
STA $2B1A
STA $2B84
STA $2B86
STA $2B88
STA $2B8A
STA $2B8E
STA $2B92
STA $2B94
STA $2B98
STA $2B9A
STA $2C04
STA $2C08
STA $2C0A
STA $2C0E
STA $2C12
STA $2C14
STA $2C18
STA $2C86
STA $2C88
STA $2C8A
STA $2C90
STA $2C92
STA $2C94
STA $2C98
STA $2D0A
STA $2D0C
STA $2D10
STA $2D14
STA $2D16
STA $2D8A
STA $2D8C
STA $2D8E
STA $2D94
LDA #$016A : STA $278C
STA $280C
STA $2A82
STA $2B02
STA $2B82
STA $2C02
STA $2C82
LDA #$01FA : STA $288C
LDA #$00DA : STA $2890
STA $299C
STA $2B14
STA $2B16
STA $2B18
STA $2B96
STA $2C16
STA $2C96
STA $2D08
STA $2D92
LDA #$0186 : STA $290C
STA $298A
STA $2A04
LDA #$0036 : STA $2914
STA $2916
STA $2994
STA $2996
STA $2D12
LDA #$00E4 : STA $2986
LDA #$00E5 : STA $2988
LDA #$0100 : STA $29A2
LDA #$0071 : STA $2A0E
STA $2A1A
STA $2C8C
LDA #$015C : STA $2A20
STA $2A9E
STA $2B1C
STA $2C9A
STA $2D18
STA $2D96
LDA #$0104 : STA $2A22
LDA #$01D4 : STA $2A24
LDA #$0035 : STA $2A8A
STA $2B08
STA $2C06
STA $2D0E
STA $2D90
LDA #$0162 : STA $2AA0
STA $2B1E
STA $2B9C
STA $2D1A
STA $2D98
LDA #$00E2 : STA $2B04
STA $2B0C
STA $2B10
STA $2B8C
STA $2B90
STA $2C0C
STA $2C10
STA $2C8E
LDA #$00F8 : STA $2C1A
LDA #$00CE : STA $2C1C
STA $2C9C
LDA #$0160 : STA $2C84
STA $2D06
STA $2D88
LDA #$0167 : STA $2D04
STA $2D86
LDA #$0172 : STA $2E08
LDA #$015E : STA $2E0A
STA $2E0C
STA $2E0E
STA $2E10
STA $2E12
STA $2E14
LDA #$0174 : STA $2E16

RTS
}

map051:
{
LDA #$0034 : STA $22A8
RTS
}

map053:
{
LDA #$02F1 : STA $2BB0
LDA #$02F2 : STA $2BB2
LDA #$0184 : STA $2C30
LDA #$0185 : STA $2C32
LDA #$0392 : STA $2CB0
LDA #$0393 : STA $2CB2
LDA #$0394 : STA $2D30
LDA #$0395 : STA $2D32
LDA #$0034 : STA $2F56

RTS
}

map058:
{
LDA #$0774 : STA $2800
LDA #$06E1 : STA $2802
LDA #$0757 : STA $2804
STA $2886
LDA #$0779 : STA $2880
LDA #$02EC : STA $2882
LDA #$0759 : STA $2884
STA $2906
LDA #$02E5 : STA $2900
STA $2902
STA $2904
LDA #$076A : STA $2908
LDA #$02F3 : STA $2980
STA $2982
LDA #$02F1 : STA $2984
LDA #$02F2 : STA $2986
LDA #$038A : STA $2988
LDA #$0184 : STA $2A04
STA $2A84
STA $2B04
STA $2B84
LDA #$0185 : STA $2A06
STA $2A86
STA $2B06
STA $2B86

RTS
}

map068:
{
LDA #$0E96 : STA $235E
STA $23DE
STA $245E
STA $24DE
STA $255E
LDA #$0E97 : STA $2360
STA $23E0
STA $2460
STA $24E0
STA $2560
LDA #$0E94 : STA $25DE
LDA #$0E95 : STA $25E0
LDA #$0180 : STA $275E
LDA #$0181 : STA $2760
LDA #$0184 : STA $27DE
STA $285E
LDA #$0185 : STA $27E0
STA $2860
LDA #$0212 : STA $2BE0

RTS
}

map071:
{
LDA #$0398 : STA $25A0
LDA #$0522 : STA $25A2
LDA #$0125 : STA $2620
LDA #$0126 : STA $2622
LDA #$0239 : STA $269E
STA $26A4

RTS
}

map078:
{
LDA #$0239 : STA $3D4A
RTS
}

map080:
{
LDA #$020F : STA $2B2E
RTS
}

map084:
{
LDA #$02F3 : STA $2422
STA $2424
LDA #$00C9 : STA $24A2
STA $24A4
LDA #$00E3 : STA $2522
STA $2524
RTS
}

map091: ;Pyramid
{
LDA #$0323 : STA $39B6
LDA #$0324 : STA $39B8
STA $39BA
STA $39BC
STA $39BE
LDA #$02FE : STA $3A34
LDA #$02FF : STA $3A36
LDA #$0326 : STA $3A38
STA $3A3A
STA $3A3C
STA $3A3E
LDA #$039D : STA $3AB2
LDA #$0303 : STA $3AB4
LDA #$0232 : STA $3AB6
STA $3B34
LDA #$0233 : STA $3AB8
STA $3ABA
STA $3ABC
STA $3ABE
LDA #$03A2 : STA $3B32
LDA #$0235 : STA $3B36
STA $3BB4
LDA #$046A : STA $3B38
LDA #$0333 : STA $3B3A
STA $3B3C
STA $3B3E
LDA #$0034 : STA $3BB6
STA $3BBA
STA $3BBC
STA $3C3A
STA $3C3C
STA $3C3E

;Added Pegs on pyramid map
;{
STA $321C
STA $329C
STA $32A0

LDA #$0071 : STA $321E
LDA #$00DA : STA $3220
STA $329A
LDA #$00E1 : STA $329E
LDA #$0382 : STA $3318
LDA #$037C : STA $3322

LDA #$021B : STA $3218
STA $3222
STA $3298
STA $32A2
STA $331A
STA $331C
STA $331E
STA $3320
LDA #$00E2 : STA $321A
;}

LDA #$00F2 : STA $3BB8
LDA #$0108 : STA $3C38


;Warp Tile agah defeated
LDA #$0034 : STA $3BBE ;Tile when no warp
LDA ProgressIndicator : AND #$00FF : CMP #$0003 : BNE .agahnimAlive
LDA #$0212 : STA $3BBE ;warp
.agahnimAlive


LDA #$0324 : STA $39C0
STA $39C2
STA $39C4
LDA #$0325 : STA $39C6
LDA #$02D5 : STA $39C8
STA $39D2
LDA #$02CC : STA $39CC
STA $39D4
LDA #$0326 : STA $3A40
STA $3A42
STA $3A44
LDA #$0327 : STA $3A46
LDA #$02F7 : STA $3A48
LDA #$02E3 : STA $3A4C
STA $3A4E
LDA #$0233 : STA $3AC0
STA $3AC2
STA $3AC4
LDA #$0234 : STA $3AC6
STA $3B48
LDA #$02F6 : STA $3AC8
LDA #$0396 : STA $3ACA
LDA #$0333 : STA $3B40
STA $3B42
LDA #$03AA : STA $3B44
LDA #$03A3 : STA $3B46
STA $3BC8
LDA #$0397 : STA $3B4A
LDA #$0034 : STA $3BC0
STA $3BC2
STA $3BC6
STA $3C40
STA $3C42
LDA #$029C : STA $3BC4
LDA #$010A : STA $3C44
LDA #$010B : STA $3C46
STA $3C48
STA $3C4A
STA $3C4C
STA $3C4E
STA $3C50
STA $3C52
STA $3C54
STA $3C56
STA $3C58
STA $3C5A
STA $3C5C
STA $3C5E
STA $3C60
STA $3C62
STA $3C64
STA $3C66

RTS
}

map111:
{
LDA #$020F : STA $2BB2
RTS
}

map115:
{
LDA #$020F : STA $22A8
RTS
}

map120:
{
LDA #$0239 : STA $3D94
RTS
}

map117:
{
;118
LDA #$0239 : STA $2F50
LDA #$0BA3 : STA $2F52
STA $2FCE
STA $2FD0

;126

LDA #$0BA3 : STA $3054
STA $3056
STA $3058
STA $305A
STA $3254
STA $3256
STA $3258
STA $325A
LDA #$0BAC : STA $30D4
LDA #$0BAD : STA $30D6
STA $3156
STA $31D6
LDA #$0BA9 : STA $30D8
STA $3158
STA $31D8
LDA #$0BAA : STA $30DA
LDA #$0BC5 : STA $3154
LDA #$0BC8 : STA $315A
LDA #$0BCA : STA $31D4
LDA #$0BCD : STA $31DA
RTS
}
