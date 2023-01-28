    processor 6502

    include "vcs.h"
    include "macro.h"

    seg.u Variables

    org $80

P0Height   byte
PlayerYPos byte

    seg Code

    org $F000

RESET:
    CLEAN_START

    ldx #$00   ; black bg color
    stx COLUBK

    lda #180
    sta PlayerYPos ; PlayerYPos = 180

    lda #9
    sta P0Height ; P0Height = 9

FRAME:
    lda #2
    sta VBLANK
    sta VSYNC

    repeat 3
        sta WSYNC
    repend

    lda #0
    sta VSYNC

    repeat 37
        sta WSYNC
    repend

    lda #0
    sta VBLANK

    ldx #192
SCANLINE:
    txa
    sec ; carry flag is set
    sbc PlayerYPos ; subtract sprite Y coordinate
    
    cmp P0Height
    bcc LOADBITMAP
    lda #0

LOADBITMAP:
    tay
    lda P0Bitmap,Y
    sta WSYNC
    sta GRP0
    lda P0Color,Y
    sta COLUP0

    dex
    bne SCANLINE

OVERSCAN:
    lda #2
    sta VBLANK

    repeat 30
        sta WSYNC
    repend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    dec PlayerYPos

    jmp FRAME

P0Bitmap:
    byte #%00000000
    byte #%00101000
    byte #%01110100
    byte #%11111010
    byte #%11111010
    byte #%11111010
    byte #%11111110
    byte #%01101100
    byte #%00110000


P0Color:
    byte #$00
    byte #$40
    byte #$40
    byte #$40
    byte #$40
    byte #$42
    byte #$42
    byte #$44
    byte #$D2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    word RESET
    word RESET
