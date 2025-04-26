; -------------------------------------------------------------------------
; Play stage music
; -------------------------------------------------------------------------

PlayStageMusic:
	tst.b	effectFlags.w
	bne.s	.End

	moveq	#16,d0
	tst.b	bossFlag.w
	bne.s	.Play

	moveq	#19,d0
	tst.b	superFlag.w
	bne.s	.Play
	
	moveq	#0,d0
	move.w	v_zone.w,d0
	ror.b	#2,d0
	lsr.w	#6,d0
	move.b	.Tracks(pc,d0.w),d0
	beq.s	.Stop

.Play:
	jmp	LoopCDDA

.Stop:
	jmp	StopCDDA

.End:
	rts

; -------------------------------------------------------------------------

.Tracks:
	dc.b	9, 9, 9, 9
	dc.b	12, 12, 12, 14
	dc.b	10, 10, 10, 10
	dc.b	13, 13, 13, 13
	dc.b	11, 11, 11, 11
	dc.b	14, 14, 15, 14
	dc.b	0, 0, 0, 0
	dc.b	20, 20, 20, 20

; -------------------------------------------------------------------------
