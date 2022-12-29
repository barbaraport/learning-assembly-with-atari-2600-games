    processor 6502
    seg Code
    org $F000
Start:
    lda #15
    
    tax
    tay
    txa
    tya

    ldx #6
    
    txa
    tay
    
    ; there's no direct transfer between X and Y in 6502
    
    jmp Start

    org $FFFC
    .word Start
    .word Start