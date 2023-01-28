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
    
    ldx #$00
    stx COLUBK ; black background
    
    lda #40
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
    and #$7F ; forces A to be always positive
    
    sta WSYNC
    sta HMCLR ; clears old horizontal positions
    
    sec ; set carry flag before subtraction
    
DivideLoop:
   sbc #15
   bcs DivideLoop
   
   eor #7
   
   asl ; shift left by 4
   asl
   asl
   asl
   
   sta HMP0 ; set fine position
   sta RESP0 ; reset brute position
   sta WSYNC
   sta HMOVE ; apply fine position
   
   repeat 35 ; i already used 2 lines above
       sta WSYNC
   repend
   
   lda #0
   sta VBLANK
   
   repeat 60
       sta WSYNC
   repend
   
   ldy 8
DrawBitmap:
    lda P0Bitmap,Y
    sta GRP0
    
    lda P0Color,Y
    sta COLUP0
    
    sta WSYNC
    
    dey
    bne DrawBitmap
    
    lda #0
    sta GRP0 ; disable player 0 graphics
    
    repeat 124
        sta WSYNC
    repend
    
Overscan:
    lda #2
    sta VBLANK
    repeat 30
        sta WSYNC
    repend
    
    lda P0XPos
    cmp #80
    bpl ResetPosition
    jmp Increment
    
ResetPosition:
    lda #40
    sta P0XPos
Increment:
    inc P0XPos
    
    jmp StartFrame
    
P0Bitmap:
    byte #%00000000
    byte #%00010000
    byte #%00001000
    byte #%00011100
    byte #%00110110
    byte #%00101110
    byte #%00101110
    byte #%00111110
    byte #%00011100

P0Color:
    byte #$00
    byte #$02
    byte #$02
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52

    org $FFFC
    word Reset
    word Reset