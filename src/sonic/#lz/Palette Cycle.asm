; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
		; Waterfalls
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycLZ_Skip1	; if time remains, branch

		move.w	#2,(v_pcyc_time).w ; reset timer to 2 frames
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(Pal_LZCyc1).l,a0
		cmpi.b	#3,(v_act).w	; check if level is SBZ3
		bne.s	PCycLZ_NotSBZ3
		lea	(Pal_SBZ3Cyc1).l,a0 ; load SBZ3	palette instead

	PCycLZ_NotSBZ3:
		lea	(v_pal_dry+$56).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		lea	(v_pal_water+$56).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

PCycLZ_Skip1:
; Conveyor belts
		move.w	(v_framecount).w,d0
		andi.w	#7,d0
		move.b	PCycLZ_Seq(pc,d0.w),d0 ; get byte from palette sequence
		beq.s	PCycLZ_Skip2	; if byte is 0, branch
		moveq	#1,d1
		tst.b	(f_conveyrev).w	; have conveyor belts been reversed?
		beq.s	PCycLZ_NoRev	; if not, branch
		neg.w	d1

	PCycLZ_NoRev:
		move.w	(v_pal_buffer).w,d0
		andi.w	#3,d0
		add.w	d1,d0
		cmpi.w	#3,d0
		bcs.s	loc_1A0A
		move.w	d0,d1
		moveq	#0,d0
		tst.w	d1
		bpl.s	loc_1A0A
		moveq	#2,d0

loc_1A0A:
		move.w	d0,(v_pal_buffer).w
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	(Pal_LZCyc2).l,a0
		lea	(v_pal_dry+$76).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)
		lea	(Pal_LZCyc3).l,a0
		lea	(v_pal_water+$76).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

PCycLZ_Skip2:
		rts	
; End of function PCycle_LZ

; ===========================================================================
PCycLZ_Seq:	dc.b 1,	0, 0, 1, 0, 0, 1, 0
; ---------------------------------------------------------------------------

Pal_LZCyc1:	incbin	"src/sonic/palette/Cycle - LZ Waterfall.bin"
Pal_LZCyc2:	incbin	"src/sonic/palette/Cycle - LZ Conveyor Belt.bin"
Pal_LZCyc3:	incbin	"src/sonic/palette/Cycle - LZ Conveyor Belt Underwater.bin"
Pal_SBZ3Cyc1:	incbin	"src/sonic/palette/Cycle - SBZ3 Waterfall.bin"

; ---------------------------------------------------------------------------
