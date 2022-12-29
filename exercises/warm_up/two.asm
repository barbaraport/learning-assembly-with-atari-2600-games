    processor 6502
    seg Code
    org $F000
    
Start:
    lda #$A
    ldx #%11111111
    
    sta $80
    stx $81
    
    jmp Start
    
    org $FFFC
    .word Start
    .word Start