    processor 6502
    seg Code
    org $F000
    
Start:
    ldy #10
    
Loop:
    tya
    sta $80,y
    dey
    bpl Loop ; branches back to Loop if the result from the last instruction was positive

    jmp Start

    org $FFFC
    .word Start
    .word Start