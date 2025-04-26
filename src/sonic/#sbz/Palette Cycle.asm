; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		lea	(Pal_SBZCycList1).l,a2
		tst.b	(v_act).w
		beq.s	loc_1ADA
		lea	(Pal_SBZCycList2).l,a2

loc_1ADA:
		lea	(v_pal_buffer).w,a1
		move.w	(a2)+,d1

loc_1AE0:
		subq.b	#1,(a1)
		bmi.s	loc_1AEA
		addq.l	#2,a1
		addq.l	#8,a2
		bra.s	loc_1B06
; ===========================================================================

loc_1AEA:
		move.b	(a2)+,(a1)+
		move.b	(a1),d0
		addq.b	#1,d0
		cmp.b	(a2)+,d0
		bcs.s	loc_1AF6
		moveq	#0,d0

loc_1AF6:
		move.b	d0,(a1)+
		andi.w	#$F,d0
		add.w	d0,d0
		movea.l	(a2)+,a0
		movea.w	(a2)+,a3
		move.w	(a0,d0.w),(a3)

loc_1B06:
		dbf	d1,loc_1AE0
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1B64
		lea	(Pal_SBZCyc4).l,a0
		move.w	#1,(v_pcyc_time).w
		tst.b	(v_act).w
		beq.s	loc_1B2E
		lea	(Pal_SBZCyc10).l,a0
		move.w	#0,(v_pcyc_time).w

loc_1B2E:
		moveq	#-1,d1
		tst.b	(f_conveyrev).w
		beq.s	loc_1B38
		neg.w	d1

loc_1B38:
		move.w	(v_pcyc_num).w,d0
		andi.w	#3,d0
		add.w	d1,d0
		cmpi.w	#3,d0
		bcs.s	loc_1B52
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	loc_1B52
		moveq	#2,d0

loc_1B52:
		move.w	d0,(v_pcyc_num).w
		add.w	d0,d0
		lea	(v_pal_dry+$58).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

locret_1B64:
		rts	
; ---------------------------------------------------------------------------

		include	"src/sonic/_inc/SBZ Palette Scripts.asm"

Pal_SBZCyc1:	incbin	"src/sonic/palette/Cycle - SBZ 1.bin"
Pal_SBZCyc2:	incbin	"src/sonic/palette/Cycle - SBZ 2.bin"
Pal_SBZCyc3:	incbin	"src/sonic/palette/Cycle - SBZ 3.bin"
Pal_SBZCyc4:	incbin	"src/sonic/palette/Cycle - SBZ 4.bin"
Pal_SBZCyc5:	incbin	"src/sonic/palette/Cycle - SBZ 5.bin"
Pal_SBZCyc6:	incbin	"src/sonic/palette/Cycle - SBZ 6.bin"
Pal_SBZCyc7:	incbin	"src/sonic/palette/Cycle - SBZ 7.bin"
Pal_SBZCyc8:	incbin	"src/sonic/palette/Cycle - SBZ 8.bin"
Pal_SBZCyc9:	incbin	"src/sonic/palette/Cycle - SBZ 9.bin"
Pal_SBZCyc10:	incbin	"src/sonic/palette/Cycle - SBZ 10.bin"

; ---------------------------------------------------------------------------
