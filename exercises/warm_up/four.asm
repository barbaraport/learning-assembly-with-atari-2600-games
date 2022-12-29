    processor 6502
    seg Code
    org $F000

Start:
    lda #100

    clc ; always clear the carry flag before adc
    adc #5
    
    sec ; always set the carry flag before sbc
    sbc #10

    jmp Start

    org $FFFC
    .word Start
    .word Start