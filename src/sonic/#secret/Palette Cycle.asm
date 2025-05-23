; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteCycle:
	lea	PalCycle1(pc),a0
	subq.w	#1,v_pcyc_time.w
	bpl.s	.Cycle2
	move.w	#5-1,v_pcyc_time.w
	
	move.w	v_pcyc_num.w,d0
	addq.w	#2,v_pcyc_num.w
	cmpi.w	#PalCycle1End-PalCycle1,v_pcyc_num.w
	bcs.s	.SetColors1
	clr.w	v_pcyc_num.w
	moveq	#0,d0
	
.SetColors1:
	lea	(a0,d0.w),a0

	lea	v_pal_dry+$4C.w,a1
	tst.b	levelStarted.w
	bne.s	.DoSetColors1
	lea	v_pal_dry_dup+$4C.w,a1

.DoSetColors1:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

.Cycle2:
	tst.b	secretboss.w
	bne.w	.End

	lea	PalCycle2(pc),a0
	subq.w	#1,v_pcyc_time2.w
	bpl.s	.End
	move.w	#3-1,v_pcyc_time2.w
	
	move.w	v_pcyc_num2.w,d0
	addi.w	#15,v_pcyc_num2.w
	cmpi.w	#PalCycle2End-PalCycle2,v_pcyc_num2.w
	bcs.s	.SetColors2
	clr.w	v_pcyc_num2.w
	moveq	#0,d0
	
.SetColors2:
	lea	(a0,d0.w),a0
	
	lea	v_pal_dry+$62.w,a1
	tst.b	levelStarted.w
	bne.s	.DoSetColors2
	lea	v_pal_dry_dup+$62.w,a1

.DoSetColors2:
	moveq	#15-1,d0
	
.SetColors2Loop:
	moveq	#0,d1
	move.b	(a0)+,d1
	cmpi.b	#$10,d1
	bcs.s	.SetColor2
	lsl.w	#4,d1
	
.SetColor2:
	move.w	d1,(a1)+
	dbf	d0,.SetColors2Loop
	
.End:
	rts
	
; ---------------------------------------------------------------------------

PalCycle1:
	dc.w	$00E, $00C, $00A, $008, $006, $004, $002, $000
	dc.w	$000, $002, $024, $026, $048, $04A, $06C, $08E
	dc.w	$08E, $06C, $04A, $048, $026, $024, $002, $000
	dc.w	$000, $022, $044, $066, $088, $0AA, $0CC, $0EE
	dc.w	$0EE, $0CC, $0AA, $088, $066, $044, $022, $000
	dc.w	$000, $020, $040, $060, $080, $0A0, $0C0, $0E0
	dc.w	$0E0, $0C0, $0A0, $080, $060, $040, $020, $000
	dc.w	$000, $220, $440, $660, $880, $AA0, $CC0, $EE0
	dc.w	$EE0, $CC0, $AA0, $880, $660, $440, $220, $000
	dc.w	$000, $200, $400, $600, $800, $A00, $C00, $E00
	dc.w	$E00, $C00, $A00, $800, $600, $400, $200, $000
	dc.w	$000, $200, $402, $602, $804, $A04, $C06, $E08
	dc.w	$E08, $C06, $A04, $804, $602, $402, $200, $000
	dc.w	$000, $202, $404, $606, $808, $A0A, $C0C, $E0E
	dc.w	$E0E, $C0C, $A0A, $808, $606, $404, $202, $000
	dc.w	$000, $002, $004, $006, $008, $00A, $00C, $00E
PalCycle1End:
	dc.w	$00E, $00C, $00A, $008, $006, $004, $002, $000

PalCycle2:
	dc.b	$20, $40, $60, $80, $A0, $C0, $E0, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $20, $40, $60, $80, $A0, $C0, $00, $00, $00, $00, $00, $00, $00, $20
	dc.b	$00, $00, $20, $40, $60, $80, $A0, $00, $00, $00, $00, $00, $00, $20, $40
	dc.b	$00, $00, $00, $20, $40, $60, $80, $00, $00, $00, $00, $00, $20, $40, $60
	dc.b	$00, $00, $00, $00, $20, $40, $60, $00, $00, $00, $00, $20, $40, $60, $80
	dc.b	$00, $00, $00, $00, $00, $20, $40, $00, $00, $00, $20, $40, $60, $80, $A0
	dc.b	$00, $00, $00, $00, $00, $00, $20, $00, $00, $20, $40, $60, $80, $A0, $C0
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $20, $40, $60, $80, $A0, $C0, $E0
	dc.b	$00, $00, $00, $00, $00, $00, $00, $20, $40, $60, $80, $A0, $C0, $E0, $C0
	dc.b	$20, $00, $00, $00, $00, $00, $00, $40, $60, $80, $A0, $C0, $E0, $C0, $A0
	dc.b	$40, $20, $00, $00, $00, $00, $00, $60, $80, $A0, $C0, $E0, $C0, $A0, $80
	dc.b	$60, $40, $20, $00, $00, $00, $00, $80, $A0, $C0, $E0, $C0, $A0, $80, $60
	dc.b	$80, $60, $40, $20, $00, $00, $00, $A0, $C0, $E0, $C0, $A0, $80, $60, $40
	dc.b	$A0, $80, $60, $40, $20, $00, $00, $C0, $E0, $C0, $A0, $80, $60, $40, $20
	dc.b	$C0, $A0, $80, $60, $40, $20, $00, $E0, $C0, $A0, $80, $60, $40, $20, $00
	dc.b	$E0, $C0, $A0, $80, $60, $40, $20, $C0, $A0, $80, $60, $40, $20, $00, $00
	dc.b	$C0, $E0, $C0, $A0, $80, $60, $40, $A0, $80, $60, $40, $20, $00, $00, $00
	dc.b	$A0, $C0, $E0, $C0, $A0, $80, $60, $80, $60, $40, $20, $00, $00, $00, $00
	dc.b	$80, $A0, $C0, $E0, $C0, $A0, $80, $60, $40, $20, $00, $00, $00, $00, $00
	dc.b	$60, $80, $A0, $C0, $E0, $C0, $A0, $40, $20, $00, $00, $00, $00, $00, $00
	dc.b	$40, $60, $80, $A0, $C0, $E0, $C0, $20, $00, $00, $00, $00, $00, $00, $00
	dc.b	$20, $40, $60, $80, $A0, $C0, $E0, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $20, $40, $60, $80, $A0, $C0, $00, $00, $00, $00, $00, $00, $00, $02
	dc.b	$00, $00, $20, $40, $60, $80, $A0, $00, $00, $00, $00, $00, $00, $02, $04
	dc.b	$00, $00, $00, $20, $40, $60, $80, $00, $00, $00, $00, $00, $02, $04, $06
	dc.b	$00, $00, $00, $00, $20, $40, $60, $00, $00, $00, $00, $02, $04, $06, $08
	dc.b	$00, $00, $00, $00, $00, $20, $40, $00, $00, $00, $02, $04, $06, $08, $0A
	dc.b	$00, $00, $00, $00, $00, $00, $20, $00, $00, $02, $04, $06, $08, $0A, $0C
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $02, $04, $06, $08, $0A, $0C, $0E
	dc.b	$00, $00, $00, $00, $00, $00, $00, $02, $04, $06, $08, $0A, $0C, $0E, $0C
	dc.b	$02, $00, $00, $00, $00, $00, $00, $04, $06, $08, $0A, $0C, $0E, $0C, $0A
	dc.b	$04, $02, $00, $00, $00, $00, $00, $06, $08, $0A, $0C, $0E, $0C, $0A, $08
	dc.b	$06, $04, $02, $00, $00, $00, $00, $08, $0A, $0C, $0E, $0C, $0A, $08, $06
	dc.b	$08, $06, $04, $02, $00, $00, $00, $0A, $0C, $0E, $0C, $0A, $08, $06, $04
	dc.b	$0A, $08, $06, $04, $02, $00, $00, $0C, $0E, $0C, $0A, $08, $06, $04, $02
	dc.b	$0C, $0A, $08, $06, $04, $02, $00, $0E, $0C, $0A, $08, $06, $04, $02, $00
	dc.b	$0E, $0C, $0A, $08, $06, $04, $02, $0C, $0A, $08, $06, $04, $02, $00, $00
	dc.b	$0C, $0E, $0C, $0A, $08, $06, $04, $0A, $08, $06, $04, $02, $00, $00, $00
	dc.b	$0A, $0C, $0E, $0C, $0A, $08, $06, $08, $06, $04, $02, $00, $00, $00, $00
	dc.b	$08, $0A, $0C, $0E, $0C, $0A, $08, $06, $04, $02, $00, $00, $00, $00, $00
	dc.b	$06, $08, $0A, $0C, $0E, $0C, $0A, $04, $02, $00, $00, $00, $00, $00, $00
	dc.b	$04, $06, $08, $0A, $0C, $0E, $0C, $02, $00, $00, $00, $00, $00, $00, $00
	dc.b	$02, $04, $06, $08, $0A, $0C, $0E, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $02, $04, $06, $08, $0A, $0C, $00, $00, $00, $00, $00, $00, $00, $20
	dc.b	$00, $00, $02, $04, $06, $08, $0A, $00, $00, $00, $00, $00, $00, $20, $40
	dc.b	$00, $00, $00, $02, $04, $06, $08, $00, $00, $00, $00, $00, $20, $40, $60
	dc.b	$00, $00, $00, $00, $02, $04, $06, $00, $00, $00, $00, $20, $40, $60, $80
	dc.b	$00, $00, $00, $00, $00, $02, $04, $00, $00, $00, $20, $40, $60, $80, $A0
	dc.b	$00, $00, $00, $00, $00, $00, $02, $00, $00, $20, $40, $60, $80, $A0, $C0
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $20, $40, $60, $80, $A0, $C0, $E0
	dc.b	$00, $00, $00, $00, $00, $00, $00, $20, $40, $60, $80, $A0, $C0, $E0, $C0
	dc.b	$20, $00, $00, $00, $00, $00, $00, $40, $60, $80, $A0, $C0, $E0, $C0, $A0
	dc.b	$40, $20, $00, $00, $00, $00, $00, $60, $80, $A0, $C0, $E0, $C0, $A0, $80
	dc.b	$60, $40, $20, $00, $00, $00, $00, $80, $A0, $C0, $E0, $C0, $A0, $80, $60
	dc.b	$80, $60, $40, $20, $00, $00, $00, $A0, $C0, $E0, $C0, $A0, $80, $60, $40
	dc.b	$A0, $80, $60, $40, $20, $00, $00, $C0, $E0, $C0, $A0, $80, $60, $40, $20
	dc.b	$C0, $A0, $80, $60, $40, $20, $00, $E0, $C0, $A0, $80, $60, $40, $20, $00
	dc.b	$E0, $C0, $A0, $80, $60, $40, $20, $C0, $A0, $80, $60, $40, $20, $00, $00
	dc.b	$C0, $E0, $C0, $A0, $80, $60, $40, $A0, $80, $60, $40, $20, $00, $00, $00
	dc.b	$A0, $C0, $E0, $C0, $A0, $80, $60, $80, $60, $40, $20, $00, $00, $00, $00
	dc.b	$80, $A0, $C0, $E0, $C0, $A0, $80, $60, $40, $20, $00, $00, $00, $00, $00
	dc.b	$60, $80, $A0, $C0, $E0, $C0, $A0, $40, $20, $00, $00, $00, $00, $00, $00
	dc.b	$40, $60, $80, $A0, $C0, $E0, $C0, $20, $00, $00, $00, $00, $00, $00, $00
PalCycle2End:
	even

; ---------------------------------------------------------------------------
