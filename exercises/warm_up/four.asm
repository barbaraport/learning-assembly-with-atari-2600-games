    processor 6502
    seg Code
    org $F000
Start:
    lda #100
    add #5
    sub #10

    org $FFFC
    .word Start
    .word Start