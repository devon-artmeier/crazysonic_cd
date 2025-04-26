; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		lea	Pal_GHZCyc(pc),a0
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycGHZ_Skip	; if time remains, branch

		move.w	#5,(v_pcyc_time).w ; reset timer to 5 frames
		move.w	(v_pcyc_num).w,d0 ; get cycle number
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(v_pal_dry+$50).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)	; copy palette data to RAM

PCycGHZ_Skip:
		rts	
; End of function PCycle_GHZ

; ---------------------------------------------------------------------------

Pal_GHZCyc:
		incbin	"src/sonic/palette/Cycle - GHZ.bin"
		even

; ---------------------------------------------------------------------------
