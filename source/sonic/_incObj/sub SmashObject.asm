; ---------------------------------------------------------------------------
; Subroutine to	smash a	block (GHZ walls and MZ	blocks)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SmashObject:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,obRender(a0)
		move.b	0(a0),d4
		move.b	obRender(a0),d5
		movea.w	a0,a1
		bra.s	.loadfrag
; ===========================================================================

	.loop:
		bsr.w	FindFreeObj
		bne.s	.playsnd
		addq.w	#6,a3

.loadfrag:
		move.b	#4,obRoutine(a1)
		move.b	d4,(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.w	(a4)+,obVelX(a1)
		move.w	(a4)+,obVelY(a1)
		cmpa.w	a0,a1
		bcc.s	.loc_D268
		move.w	a0,-(sp)
		movea.w	a1,a0
		move.w	d1,-(sp)
		jsr	SpeedToPos
		move.w	(sp)+,d1
		add.w	d2,obVelY(a0)
		movea.w	(sp)+,a0
		jsr	DisplaySprite1

	.loc_D268:
		dbf	d1,.loop

	.playsnd:
		move.w	#sfx_WallSmash,d0
		jmp	(PlaySound_Special).l ; play smashing sound

; End of function SmashObject