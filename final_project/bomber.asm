	processor 6502
       	
        include "vcs.h"
        include "macro.h"
        
        seg.u Variables
        org $80

JetXPos byte
JetYPos byte
BomberXPos byte
BomberYPos byte
JetSpritePointer word
JetColorPointer word
BomberSpritePointer word
BomberColorPointer word

JET_HEIGHT = 9
BOMBER_HEIGHT = 9

	seg Code
        org $F000
        
Reset:
	CLEAN_START

	lda #10
        sta JetYPos
        lda #60
        sta JetXPos
        lda #83
        sta BomberYPos
        lda #54
        sta BomberXPos
        
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
        
        ldx #37
VBlank:
        sta WSYNC
        dex
        bne VBlank
        sta VBLANK
        
GameVisibleLines:
	lda #$84
        sta COLUBK
        lda #$C2
        sta COLUPF
        lda #%00000001
        sta CTRLPF
        lda #$F0
        sta PF0
        lda #$FC
        sta PF1
        lda #0
        sta PF2
        
        ldx #96
.GameLineLoop:
.IsInsideJetSprite:
	txa
        sec
        sbc JetYPos
        cmp JET_HEIGHT
        bcc .DrawSpriteP0
        lda #0
.DrawSpriteP0:
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
        cmp BOMBER_HEIGHT
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
        
	lda #2
        sta VBLANK
        repeat 30
        	sta WSYNC
        repend
        lda #0
        sta VBLANK
     
        jmp StartFrame
        
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