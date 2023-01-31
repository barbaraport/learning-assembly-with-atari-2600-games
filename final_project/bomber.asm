	processor 6502
       	
        include "vcs.h"
        include "macro.h"
        
        seg.u Variables
        org $80

JetXPos byte
JetYPos byte
BomberXPos byte
BomberYPos byte
MissileXPos byte
MissileYPos byte
Score byte
Timer byte
Temp byte
OnesDigitOffset word
TensDigitOffset word
JetSpritePointer word
JetColorPointer word
BomberSpritePointer word
BomberColorPointer word
JetAnimationOffset byte
Random byte
ScoreSprite byte
TimerSprite byte
TerrainColor byte
RiverColor byte

JET_HEIGHT = 9
BOMBER_HEIGHT = 9
DIGITS_HEIGHT = 5

	seg Code
        org $F000
        
Reset:
	CLEAN_START

	lda #10
        sta JetYPos
        lda #68
        sta JetXPos
        lda #83
        sta BomberYPos
        lda #63
        sta BomberXPos
        lda #%11010100
        sta Random
        lda #0
        sta Score
        sta Timer
        
        MAC DRAW_MISSILE
        LDA #%00000000
        	cpx MissileYPos
                bne .SkipMissileDraw
.DrawMissile
	lda #%00000010
        inc MissileYPos
.SkipMissileDraw
	sta ENAM0
       	ENDM
        
        lda #<JetSprite
        sta JetSpritePointer
        lda #>JetSprite
        sta JetSpritePointer+1
        
        lda #<JetColor
        sta JetColorPointer
        lda #>JetColor
        sta JetColorPointer+1
        
        lda #<BomberSprite
        sta BomberSpritePointer
        lda #>BomberSprite
        sta BomberSpritePointer+1
        
        lda #<BomberColor
        sta BomberColorPointer
        lda #>BomberColor
        sta BomberColorPointer+1
        
StartFrame:    
	lda #2
        sta VBLANK
        sta VSYNC
        ldx #3
VSync:
        sta WSYNC
        dex
        bne VSync
        lda #0
        sta VSYNC
        
        ldx #31
VBlank:
        sta WSYNC
        dex
        bne VBlank
        
	lda JetXPos
        ldy #0
        jsr SetObjectXPos
        lda BomberXPos
        ldy #1
        jsr SetObjectXPos
        lda MissileXPos
        ldy #2
        jsr SetObjectXPos
        jsr CalculateDigitOffset
        jsr GenerateJetSound
        sta WSYNC
        sta HMOVE
        
        lda #0
        sta VBLANK
ScoreBoardLines:
	lda #0
        sta COLUBK
        sta PF0
        sta PF1
        sta PF2
        sta GRP0
        sta GRP1
        sta CTRLPF
        lda #$1E
        sta COLUPF
        ldx #DIGITS_HEIGHT
.ScoreBoard:
	ldy TensDigitOffset
        lda Digits,Y
        and #$F0
        sta ScoreSprite
        
        ldy OnesDigitOffset
        lda Digits,Y
        and #$0F
	ora ScoreSprite
        sta ScoreSprite
        sta WSYNC
        sta PF1
        
        ldy TensDigitOffset+1
        lda Digits,Y
        and #$F0
        sta TimerSprite
        
        ldy OnesDigitOffset+1
        lda Digits,Y
        and #$0F
        ora TimerSprite
        sta TimerSprite
        
        jsr SleepFor12Cycles
        sta PF1
        ldy ScoreSprite
        sta WSYNC
        sty PF1
        inc TensDigitOffset
        inc TensDigitOffset+1
        inc OnesDigitOffset
        inc OnesDigitOffset+1
        jsr SleepFor12Cycles
        dex
        sta PF1
        bne .ScoreBoard
        sta WSYNC
        lda #0
        sta PF0
        sta PF1
        sta PF2
        sta WSYNC
        sta WSYNC
        sta WSYNC
        
GameVisibleLines:
	lda TerrainColor
        sta COLUPF
        lda RiverColor
        sta COLUBK
        lda #%00000001
        sta CTRLPF
        lda #$F0
        sta PF0
        lda #$FC
        sta PF1
        lda #0
        sta PF2
        
        ldx #85
.GameLineLoop:
	DRAW_MISSILE
.IsInsideJetSprite:
	txa
        sec
        sbc JetYPos
        cmp #JET_HEIGHT
        bcc .DrawSpriteP0
        lda #0
.DrawSpriteP0:
	clc
	adc JetAnimationOffset
	tay
        lda (JetSpritePointer),Y
        sta WSYNC
        sta GRP0
        lda (JetColorPointer),Y
        sta COLUP0
.IsInsideBomberSprite:
	txa
        sec
        sbc BomberYPos
        cmp #BOMBER_HEIGHT
        bcc .DrawSpriteP1
        lda #0
.DrawSpriteP1:
	tay
        lda #%00000101
        sta NUSIZ1
        lda (BomberSpritePointer),Y
        sta WSYNC
        sta GRP1
        lda (BomberColorPointer),Y
        sta COLUP1
        dex
        bne .GameLineLoop
        lda #0
        sta JetAnimationOffset

	lda #2
        sta VBLANK
        ldx #30
OverScan:
	sta WSYNC
        dex
        bne OverScan
        lda #0
        sta VBLANK
CheckP0Up:
	lda #%00010000
        bit SWCHA
        bne CheckP0Down
        lda JetYPos
        cmp #70
        bpl CheckP0Down
.P0UpPressed:
        inc JetYPos
        lda #0
        sta JetAnimationOffset
CheckP0Down:
	lda #%00100000
        bit SWCHA
        bne CheckP0Left
        lda JetYPos
        cmp #5
        bmi CheckP0Left
.P0DownPressed:
        dec JetYPos
        lda #0
        sta JetAnimationOffset
CheckP0Left:
	lda #%01000000
        bit SWCHA
        bne CheckP0Right
        lda JetXPos
        cmp #35
        bmi CheckP0Right
.P0LeftPressed:
        dec JetXPos
        lda #JET_HEIGHT
        sta JetAnimationOffset
CheckP0Right:
	lda #%10000000
        bit SWCHA
        bne CheckButtonPressed
        lda JetXPos
        cmp #100
        bpl CheckButtonPressed
.P0RightPressed:
        inc JetXPos
        lda #JET_HEIGHT
        sta JetAnimationOffset
CheckButtonPressed:
	lda #%10000000
        bit INPT4
        bne NoInput
.ButtonPressed:
        lda JetXPos
        clc
        adc #5
        sta MissileXPos
        lda JetYPos
        clc
        adc #5
        sta MissileYPos
        jsr GenerateMissileSound
NoInput:

UpdateBomberPosition:
	lda BomberYPos
        clc
        cmp #0
        bmi .ResetBomberPosition
	dec BomberYPos
        jmp EndPositionUpdate
.ResetBomberPosition:
        jsr GetRandomBomberPosition
.SetTimerValues:
	sed
        lda Timer
        clc
        adc #1
        sta Timer
        cld
        
EndPositionUpdate:

CheckCollisionP0P1:
	lda #%10000000
        bit CXPPMM
        bne .P0P1Collided
        jsr SetTerrainAndRiverColor
        jmp CheckCollisionM0P1
.P0P1Collided:
	jsr GenerateExplosionSound
	jsr GameOver
CheckCollisionM0P1:
	lda #%10000000
        bit CXM0P
        bne .MOP1Collided
        jmp EndCollisionCheck
.MOP1Collided:
	sed
        lda Score
        clc
        adc #1
        sta Score
        cld
        lda #0
        sta MissileYPos
EndCollisionCheck:
	sta CXCLR
        jmp StartFrame
GenerateJetSound subroutine
	lda #1
        sta AUDV0
        lda JetYPos
        lsr
        lsr
        sta Temp
        lda #31
        sec
        sbc Temp
        sta AUDF0
        lda #8
        sta AUDC0
	rts
GenerateMissileSound subroutine
	lda #7
        sta AUDV0
        lda #25
        sta AUDF0
        lda #6
        sta AUDC0
	rts
GenerateExplosionSound subroutine
	lda #15
        sta AUDV0
        lda #7
        sta AUDF0
        lda #9
        sta AUDC0
	rts
SetTerrainAndRiverColor subroutine
	lda #$C2
        sta TerrainColor
        lda #$84
        sta RiverColor
	rts
SetObjectXPos subroutine
	sta WSYNC
        sec
.Div15Loop:
	sbc #15
        bcs .Div15Loop
        eor #7
        asl
        asl
        asl
        asl
        sta HMP0,Y
        sta RESP0,Y
        rts
GameOver subroutine
	lda #$30
        sta TerrainColor
        sta RiverColor
        lda #0
        sta Score
	rts
GetRandomBomberPosition subroutine
        lda Random
        asl
        eor Random
        asl
        eor Random
        asl
        asl
        eor Random
        asl
        rol Random
        lsr
        lsr
        sta BomberXPos
        lda #30
        adc BomberXPos
        sta BomberXPos
        lda #96
        sta BomberYPos
        rts
CalculateDigitOffset subroutine
	ldx #1
.PrepareScoreLoop
	lda Score,X
        and #$0F
        sta Temp
        asl
        asl
        adc Temp
        sta OnesDigitOffset,X
        lda Score,X
        and #$F0
        lsr
        lsr
        sta Temp
        lsr
        lsr
        adc Temp
        sta TensDigitOffset,X
	dex
        bpl .PrepareScoreLoop
	rts
SleepFor12Cycles subroutine
	rts
Digits:
	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###

	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #

	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %00110011          ;  ##  ##
	.byte %00010001          ;   #   #
	.byte %01110111          ; ### ###

	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #

	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #
	.byte %00010001          ;   #   #

	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###
	.byte %00010001          ;   #   #
	.byte %01110111          ; ### ###

	.byte %00100010          ;  #   #
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #

	.byte %01110111          ; ### ###
	.byte %01010101          ; # # # #
	.byte %01100110          ; ##  ##
	.byte %01010101          ; # # # #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01000100          ; #   #
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###

	.byte %01100110          ; ##  ##
	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #
	.byte %01010101          ; # # # #
	.byte %01100110          ; ##  ##

	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01110111          ; ### ###

	.byte %01110111          ; ### ###
	.byte %01000100          ; #   #
	.byte %01100110          ; ##  ##
	.byte %01000100          ; #   #
	.byte %01000100          ; #   #
        
JetSprite:
        .byte #%00000000         ;
        .byte #%00010100         ;   # #
        .byte #%01111111         ; #######
        .byte #%00111110         ;  #####
        .byte #%00011100         ;   ###
        .byte #%00011100         ;   ###
        .byte #%00001000         ;    #
        .byte #%00001000         ;    #
        .byte #%00001000         ;    #

JetSpriteTurn:
        .byte #%00000000         ;
        .byte #%00001000         ;    #
        .byte #%00111110         ;  #####
        .byte #%00011100         ;   ###
        .byte #%00011100         ;   ###
        .byte #%00011100         ;   ###
        .byte #%00001000         ;    #
        .byte #%00001000         ;    #
        .byte #%00001000         ;    #

BomberSprite:
        .byte #%00000000         ;
        .byte #%00001000         ;    #
        .byte #%00001000         ;    #
        .byte #%00101010         ;  # # #
        .byte #%00111110         ;  #####
        .byte #%01111111         ; #######
        .byte #%00101010         ;  # # #
        .byte #%00001000         ;    #
        .byte #%00011100         ;   ###

JetColor:
        .byte #$00
        .byte #$FE
        .byte #$0C
        .byte #$0E
        .byte #$0E
        .byte #$04
        .byte #$BA
        .byte #$0E
        .byte #$08

JetColorTurn:
        .byte #$00
        .byte #$FE
        .byte #$0C
        .byte #$0E
        .byte #$0E
        .byte #$04
        .byte #$0E
        .byte #$0E
        .byte #$08

BomberColor:
        .byte #$00
        .byte #$32
        .byte #$32
        .byte #$0E
        .byte #$40
        .byte #$40
        .byte #$40
        .byte #$40
        .byte #$40
        
        org $FFFC
        .word Reset
        .word Reset