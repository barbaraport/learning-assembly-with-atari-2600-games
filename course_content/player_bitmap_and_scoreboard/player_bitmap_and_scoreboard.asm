    processor 6502
    
    include "vcs.h"
    include "macro.h"
    
; segment to declare variables
    seg.u Variables
    
    org $80
    
P0Height ds 1 ; 1 byte for player 0 height
P1Height ds 1 ; 1 byte for player 1 height

;;;;;;;;
    
    seg Code
    
    org $F000
    
Start:
    CLEAN_START
    
    ldx #$80
    stx COLUBK
    
    lda #%1111
    sta COLUPF
    
    lda #$48
    sta COLUP0
    
    lda #$C6
    sta COLUP1

    lda #%00000010
    sta CTRLPF
    
    lda #10 ; A = 10
    sta P0Height ; P0Height = 10
    sta P1Height ; P1Height = 10

Frame:

    lda #2 ; turning on v-sync and v-blank
    sta VBLANK
    sta VSYNC
    
    repeat 3
    	sta WSYNC ; v-sync scanlines
    repend
    
    lda #0
    sta VSYNC ; turning off v-sync
    
    repeat 37
        sta WSYNC
    repend
    
    lda #0
    sta VBLANK ; turning off v-blank
    
    ; --------------------------------------------
    
VisibleScanlines:
    repeat 10
        sta WSYNC
    repend
    
    ldy #0
ScoreboardLoop:
    lda NumberBitmap,y
    sta PF1
    sta WSYNC
    iny ; increment y register
    cpy #10 ; compare y register
    bne ScoreboardLoop
    
    lda #0
    sta PF1 ; disable playfield
    
    repeat 50
        sta WSYNC
    repend
    
    ldy #0
Player0Loop:
    lda PlayerBitmap,y
    sta GRP0
    sta WSYNC
    iny
    cpy P0Height
    bne Player0Loop
    
    lda #0
    sta GRP0 ; disable player 0 graphics
    
    ldy #0
Player1Loop:
    lda PlayerBitmap,y
    sta GRP1
    sta WSYNC
    iny
    cpy P0Height
    bne Player1Loop
    
    lda #0
    sta GRP1 ; disable player 1 graphics
    
    repeat 102
        sta WSYNC
    repend
    
    ; --------------------------------------------
    sta VBLANK
    repeat 30
        sta WSYNC
    repend
    
    
    jmp Frame
    
    org $FFE8
PlayerBitmap:
    .byte #%01111110
    .byte #%11111111
    .byte #%10011001
    .byte #%11111111
    .byte #%11111111
    .byte #%11111111
    .byte #%10111101
    .byte #%11000011
    .byte #%11111111
    .byte #%01111110
    
    org $FFF2
NumberBitmap:
    .byte #%00001110
    .byte #%00001110
    .byte #%00000010
    .byte #%00000010
    .byte #%00001110
    .byte #%00001110
    .byte #%00001000
    .byte #%00001000
    .byte #%00001110
    .byte #%00001110
    
    org $FFFC
    .word Start
    .word Start