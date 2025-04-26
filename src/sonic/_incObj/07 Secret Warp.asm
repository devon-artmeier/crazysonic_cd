; -------------------------------------------------------------------------
; Warp in Secret Zone
; -------------------------------------------------------------------------

obWarpDelay	EQU	$30

; -------------------------------------------------------------------------

SecretWarp:
	moveq	#0,d0
	move.b	obRoutine(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)
	out_of_range.s .Delete
	rts

.Delete:
	jmp	DeleteObject

; -------------------------------------------------------------------------

.Index:
	dc.w	SecretWarp_Init-.Index
	dc.w	SecretWarp_Main-.Index
	dc.w	SecretWarp_Drag-.Index
	dc.w	SecretWarp_Delay-.Index
	dc.w	SecretWarp_Warp-.Index
	dc.w	SecretWarp_Done-.Index

; -------------------------------------------------------------------------

SecretWarp_Init:
	addq.b	#2,obRoutine(a0)

; -------------------------------------------------------------------------

SecretWarp_Main:
	tst.w	v_debuguse.w
	bne.s	.End

	move.b	obSubtype(a0),d0
	bmi.s	.End

	lea	v_player.w,a1

	moveq	#96,d2
	move.w	obX(a0),d0
	add.w	d2,d0
	cmp.w	obX(a1),d0
	blt.s	.End

	add.w	d2,d2
	sub.w	d2,d0
	cmp.w	obX(a1),d0
	bgt.s	.End

	moveq	#96,d2
	move.w	obY(a0),d0
	add.w	d2,d0
	cmp.w	obY(a1),d0
	blt.s	.End

	add.w	d2,d2
	sub.w	d2,d0
	cmp.w	obY(a1),d0
	bgt.s	.End

	addq.b	#2,obRoutine(a0)
	move.b	#$81,f_lockmulti.w
	move.b	#id_Roll,obAnim(a1)

	moveq	#0,d0
	lea	cbpcmMotorMode,a1
	jsr	WriteSubByte
	moveq	#0,d0
	lea	cbpcmHonk,a1
	jmp	WriteSubByte

.End:
	rts
	
; -------------------------------------------------------------------------

SecretWarp_Drag:
	lea	v_player.w,a1
	move.w	obX(a0),d1
	sub.w	obX(a1),d1
	move.w	obY(a0),d2
	sub.w	obY(a1),d2
	movem.w	d1-d2,-(sp)
	jsr	CalcAngle
	jsr	CalcSine
	movem.w	(sp)+,d2-d3

	tst.w	d2
	bpl.s	.AbsY
	neg.w	d2

.AbsY:
	tst.w	d3
	bpl.s	.Move
	neg.w	d3

.Move:
	movem.w	d2-d3,-(sp)
	asl.w	#5,d2
	asl.w	#5,d3
	muls.w	d3,d0
	muls.w	d2,d1

	add.l	d0,obY(a1)
	add.l	d1,obX(a1)

	movem.w	(sp)+,d2-d3
	cmpi.w	#4,d2
	bcc.s	.End
	cmpi.w	#4,d3
	bcc.s	.End

	addq.b	#2,obRoutine(a0)
	move.w	#30-1,obWarpDelay(a0)
	move.b	#id_Null,obAnim(a1)

.End:
	rts

; -------------------------------------------------------------------------

SecretWarp_Delay:
	subq.w	#1,obWarpDelay(a0)
	bpl.s	.End
	addq.b	#2,obRoutine(a0)

.End:
	rts

; -------------------------------------------------------------------------

SecretWarp_Warp:
	addq.b	#2,obRoutine(a0)

	move.b	obSubtype(a0),d4
	andi.b	#$F,d4
	
	moveq	#0,d0
	move.b	v_act.w,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	ObjPos_Index,a1
	movea.l	(a1,d0.w),a1

.FindWarp:
	move.w	(a1)+,d1
	bmi.w	SecretWarp_Done
	move.w	(a1)+,d0
	move.b	(a1)+,d2
	move.b	(a1)+,d3

	andi.b	#$7F,d2
	cmpi.b	#id_Obj07,d2
	bne.s	.FindWarp

	move.b	d3,d2
	bpl.s	.FindWarp

	andi.b	#$7F,d3
	cmp.b	d4,d3
	bne.s	.FindWarp
	
	andi.w	#$FFF,d0
	move.w	d0,warpY.w
	move.w	d1,warpX.w

SecretWarp_Done:
	rts

; -------------------------------------------------------------------------
