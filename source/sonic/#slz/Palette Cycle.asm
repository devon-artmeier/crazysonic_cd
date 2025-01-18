; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1A80
		move.w	#7,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		bcs.s	loc_1A60
		moveq	#0,d0

loc_1A60:
		move.w	d0,(v_pcyc_num).w
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0
		lea	(Pal_SLZCyc).l,a0
		lea	(v_pal_dry+$56).w,a1
		move.w	(a0,d0.w),(a1)
		move.l	2(a0,d0.w),4(a1)

locret_1A80:
		rts	
; ---------------------------------------------------------------------------

Pal_SLZCyc:	incbin	"source/sonic/palette/Cycle - SLZ.bin"

; ---------------------------------------------------------------------------
