    processor 6502
    seg Code
    org $F000
Start:
    lda #15
    mov a, x
    mov a, y
    mov x, a
    mov y, a

    ldx #6
    mov x, y

    org $FFFC
    .word Start
    .word Start