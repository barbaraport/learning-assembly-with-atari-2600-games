	processor 6502
       	
        include "vcs.h"
        include "macro.h"
        
        seg.u Variables
        org $80
P0XPos byte

	seg Code
        org $F000
        
Reset:
	CLEAN_START
        
        ldx #$80
        stx COLUBK
        
        ldx #$D0
        stx COLUPF
        
        lda #10
        sta P0XPos
        
StartFrame:
	lda #2
        sta VBLANK
        sta VSYNC
        
        repeat 3
        	sta WSYNC
        repend
        lda #0
        sta VSYNC
        
        lda P0XPos
        and #$7F
        sta WSYNC
        sta HMCLR
        
        sec

DivideLoop:
	sbc #15
        bcs DivideLoop
        
        eor #7
        
        asl
        asl
        asl
        asl
        
        sta HMP0
        sta RESP0
        sta WSYNC
        sta HMOVE
        
        repeat 35
        	sta WSYNC
        repend
        
        lda #0
        sta VBLANK
        
        repeat 160
        	sta WSYNC
        repend
        
        ldy #17
        
DrawBitmap:
	lda P0Bitmap,Y
        sta GRP0
        
        lda P0Color,Y
        sta COLUP0
        
        sta WSYNC
        
        dey
        bne DrawBitmap
        
        lda #0
        sta GRP0
        
        lda #$FF
        sta PF0
        sta PF1
        sta PF2
        
        repeat 15
        	sta WSYNC
       	repend
        
        lda #0
        sta PF0
        sta PF1
        sta PF2
        
Overscan:
	lda #2
        sta VBLANK
        
        repeat 30
        	sta WSYNC
        repend
        
        ;; P0 up/down/left/right
CheckP0Up:
	lda #%00010000
        bit SWCHA
        bne CheckP0Down
        inc P0XPos

CheckP0Down:
	lda #%00100000
        bit SWCHA
        bne CheckP0Left
        dec P0XPos
        
CheckP0Left:
	lda #%01000000
        bit SWCHA
        bne CheckP0Right
        dec P0XPos
        
CheckP0Right:
	lda #%10000000
        bit SWCHA
        bne NoInput
        inc P0XPos
        
NoInput:

        ;;
        
        jmp StartFrame

P0Bitmap:
	byte #%00000000
	byte #%00010100
	byte #%00010100
	byte #%00010100
	byte #%00010100
	byte #%00010100
	byte #%00011100
	byte #%01011101
	byte #%01011101
	byte #%01011101
	byte #%01011101
	byte #%01111111
	byte #%00111110
	byte #%00010000
	byte #%00011100
	byte #%00011100
	byte #%00011100
    
P0Color:
	byte #$00
	byte #$F6
	byte #$F2
	byte #$F2
	byte #$F2
	byte #$F2
	byte #$F2
	byte #$C2
	byte #$C2
	byte #$C2
	byte #$C2
	byte #$C2
	byte #$C2
	byte #$3E
	byte #$3E
	byte #$3E
	byte #$24
        
        
    org $FFFC
    .word Reset
    .word Reset