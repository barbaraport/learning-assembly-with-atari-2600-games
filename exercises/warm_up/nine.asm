    processor 6502
    seg Code
    org $F000
Start:
    lda #1
Loop:
    inc a
    cmp a, #10
    jnz Loop
    
    bne Loop

    org $FFFC
    .word Start
    .word Start