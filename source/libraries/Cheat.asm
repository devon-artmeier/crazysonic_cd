; -------------------------------------------------------------------------
; Check cheat
; -------------------------------------------------------------------------

CheckCheat:
	move.b	v_jpadpress1.w,d0
	beq.s	.End

	moveq	#0,d1
	move.b	(a2),d1
	adda.w	d1,a1
	
	and.b	(a1)+,d0
	beq.s	.Reset

	addq.b	#1,(a2)
	tst.b	(a1)
	bne.s	.End

	moveq	#$FFFFFF00|sfx_Ring,d0
	jmp	PlaySound_Special

.Reset:
	clr.b	(a2)

.End:
	moveq	#0,d0
	rts

; -------------------------------------------------------------------------
