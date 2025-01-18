; ---------------------------------------------------------------------------
; Defeated boss	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossDefeated:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_178A2
		jsr	(FindFreeObj).l
		bne.s	locret_178A2
		move.b	#id_ExplosionBomb,0(a1)	; load explosion object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_178A2:
		rts	
; End of function BossDefeated

; ---------------------------------------------------------------------------
; Subroutine to	move a boss
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossMove:
		movem.w	obVelX(a0),d0-d1
		asl.l	#8,d0
		asl.l	#8,d1
		add.l	d0,$30(a0)
		add.l	d1,$38(a0)
		rts	
; End of function BossMove