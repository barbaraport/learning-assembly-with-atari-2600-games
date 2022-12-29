    processor 6502

    include "vcs.h"
    include "macro.h"

    seg Code
    org $F000

START:
    CLEAN_START ; macro to safely clear the memory

    lda #$1E ; load the color into A ($1E is NTSC yellow)
    sta COLUBK ; store A to background color address $09

    jmp START

    org $FFFC
    .word START
    .word START