	processor 6502

	seg code
	org $F000 ; define the code origin at $F000

Start:
	sei ; disable interrupts
	cld ; disable the BCD decimal math mode
	ldx #$FF ; loads the X register with #$FF
	txs ; transfer the X register to the stack pointer

; clear the page zero region ($00 to $FF)
; meaning the entire ram and also the entire TIA registers

	lda #0 ; A register = 0
	ldx #$FF ; X register = #$FF

MemLoop:
	sta $0,X ; store the value of A register inside memory address $0 + X
	dex ; X--
	bne MemLoop ; Loop until X register is equal to zero (z-flag is set)

; close the rom and size it to exactly 4KB

	org $FFFC
	.word Start ; reset vector at $FFFC (loads where the program starts)
	.word Start ; interrupt vector at $FFFE (unused in the VCS)

