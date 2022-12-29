    processor 6502
    seg Code
    org $F000
    
Start:
    lda #1
    ldx #2
    ldy #3

    inx
    iny
    
    clc
    adc #1
    
    ; there's no increment A in 6502

    dex
    dey
    
    sec
    sbc #1
    
    ; there's no decrement A in 6502
    
    jmp Start

    org $FFFC
    .word Start
    .word Start