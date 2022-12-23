    processor 6502
    seg Code
    org $F000
Start:
    lda #$A
    ldx #%1010

    sta $80
    stx $81

    lda #10
    add a, $80
    add a, $81

    sta $82

    org $FFFC
    .word Start
    .word Start