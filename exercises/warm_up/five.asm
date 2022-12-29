    processor 6502
    seg Code
    org $F000
    
Start:
    lda #$A
    ldx #%1010

    sta $80
    stx $81

    lda #10
    
    clc
    adc $80
    adc $81

    sta $82
    
    jmp Start

    org $FFFC
    .word Start
    .word Start