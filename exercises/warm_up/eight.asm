    processor 6502
    seg Code
    org $F000
Start:
    ldy #10
Loop:
    tya
    sta $80,lda
    dey
    bne Loop

    org $FFFC
    .word Start
    .word Start