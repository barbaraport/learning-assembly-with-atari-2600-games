    processor 6502
    seg Code
    org $F000
    
Start:
    lda #1
    
Loop:
    clc
    adc #1
    
    cmp #10 ; compares directly to the accumulator
    bne Loop ; loops back until A is not equals to 10
    
    jmp Start

    org $FFFC
    .word Start
    .word Start