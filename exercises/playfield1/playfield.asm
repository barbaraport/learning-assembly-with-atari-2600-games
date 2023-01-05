    processor 6502
    
    include "vcs.h"
    include "macro.h"
    
    seg Code
    org $f000

Reset:
    CLEAN_START

    ldx #$80
    stx COLUBK

    lda #$1C
    sta COLUPF

StartFrame:
    lda #02
    sta VBLANK
    sta VSYNC
    
    ; vsync three lines
    repeat 3
        sta WSYNC
    repend
    lda #0
    sta VSYNC
    ;
    
    ; vblank thirty seven lines
    repeat 37
       sta WSYNC
    repend
    lda #0
    sta VBLANK
    ;
    
    ; set up playfield reflection
    ldx #%00000001
    stx CTRLPF
    ;
    
    ;;; playfield code
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    
    repeat 7
        sta WSYNC
    repend
    
    ldx #%11100000
    stx PF0
    
    ldx #%11111111
    stx PF1
    stx PF2
    
    repeat 7
        sta WSYNC
    repend
    
    ldx #%00100000
    stx PF0
    ldx #0
    stx PF1
    stx PF2
    
    repeat 164
        sta WSYNC
    repend
    
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    repeat 7
        sta WSYNC
    repend
    
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    repeat 7
        sta WSYNC
    repend
    
    ;;;
    
    lda #2
    sta VBLANK
    repeat 30
        sta WSYNC
    repend
    lda #0
    sta VBLANK
    
    
    jmp StartFrame
        


    org $fffc
    .word Reset
    .word Reset