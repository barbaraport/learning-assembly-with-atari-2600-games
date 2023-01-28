	processor 6502
       	
        include "vcs.h"
        include "macro.h"
        
        seg.u Variables
        org $80
P0XPos byte

	seg Code
        org $F000
        
Reset:
	CLEAN_START

	ldx #$FF
        txs
        
        lda #$AA
        
        pha
        pha
        pha
        pha
        
        pla
        pla
        pla
        pla
        
        org $FFFC
        .word Reset
        .word Reset