    processor 6502

    include "vcs.h"
    include "macro.h"

    seg Code
    org $F000

Start:

    CLEAN_START

NextFrame:

    lda #2
    sta VBLANK ; turn on VBLANK
    sta VSYNC ; turn on VSYNC

    sta WSYNC
    sta WSYNC
    sta WSYNC

    lda #0
    sta VSYNC ; turn off VSYNC

    ldx #37
LoopVBlank:
    sta WSYNC
    dex
    bne LoopVBlank ; loop while X != 0

    lda #0
    sta VBLANK ; turn off VBLANK

; draw 192 visible scanlines

    ldx #192
LoopVisibleLines:
    stx COLUBK ; TIA color for the background
    sta WSYNC
    dex
    bne LoopVisibleLines

; draw 30 VBLANK lines

    lda #2
    sta VBLANK

    ldx #30
LoopOverscan:
    sta WSYNC
    dex
    bne LoopOverscan

; go to next frame

    jmp NextFrame

    org $FFFC
    .word Start
    .word Start
