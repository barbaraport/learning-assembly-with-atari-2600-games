    processor 6502
    seg Code
    org $F000
Start:
    lda #10
    sta $80

    inc $80
    dec $80

    org $FFFC
    .word Start
    .word Start