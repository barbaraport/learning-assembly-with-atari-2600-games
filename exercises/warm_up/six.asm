    processor 6502
    seg Code
    org $F000
Start:
    lda #1
    ldx #2
    ldy #3

    inc x
    inc y
    inc a

    dec x
    dec y
    dec a

    org $FFFC
    .word Start
    .word Start
