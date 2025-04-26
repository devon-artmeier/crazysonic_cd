; ---------------------------------------------------------------------------
; Object 2E - contents of monitors
; ---------------------------------------------------------------------------

PowerUp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pow_Index(pc,d0.w),d1
		jsr	Pow_Index(pc,d1.w)
		jmp	DisplaySprite
; ===========================================================================
Pow_Index:	dc.w Pow_Main-Pow_Index
		dc.w Pow_Move-Pow_Index
		dc.w Pow_Delete-Pow_Index
; ===========================================================================

Pow_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$680,obGfx(a0)
		move.b	#$24,obRender(a0)
		move.w	#v_spritequeue+$180,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)
		moveq	#0,d0
		move.b	obAnim(a0),d0	; get subtype
		addq.b	#2,d0
		move.b	d0,obFrame(a0)	; use correct frame
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#2,a1
		move.l	a1,obMap(a0)

Pow_Move:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.w	Pow_Checks	; if not, branch
		jsr	SpeedToPos
		addi.w	#$18,obVelY(a0)	; reduce object	speed
		rts	
; ===========================================================================

Pow_Checks:
		addq.b	#2,obRoutine(a0)
		move.w	#29,obTimeFrame(a0) ; display icon for half a second

Pow_ChkEggman:
		move.b	obAnim(a0),d0
		cmpi.b	#1,d0		; does monitor contain Eggman?
		bne.s	Pow_ChkSonic
		rts			; Eggman monitor does nothing
; ===========================================================================

Pow_ChkSonic:
		cmpi.b	#2,d0		; does monitor contain Sonic?
		bne.s	Pow_ChkShoes

	ExtraLife:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		move.w	#sfx_Cash,d0
		jmp	(PlaySound).l	; play extra life music
; ===========================================================================

Pow_ChkShoes:
		cmpi.b	#3,d0		; does monitor contain speed shoes?
		bne.s	Pow_ChkShield

		move.b	#1,(v_shoes).w	; speed up the BG music
		move.w	#$4B0,(v_player+$34).w	; time limit for the power-up
		rts
; ===========================================================================

Pow_ChkShield:
		cmpi.b	#4,d0		; does monitor contain a shield?
		bne.s	Pow_ChkInvinc
		bset	#RAVE_MODE,effectTriggers.w
		rts
; ===========================================================================

Pow_ChkInvinc:
		cmpi.b	#5,d0		; does monitor contain invincibility?
		bne.s	Pow_ChkRings
		bset	#LSD_MODE,effectTriggers.w
		rts	
; ===========================================================================

Pow_ChkRings:
		cmpi.b	#6,d0		; does monitor contain 10 rings?
		bne.s	Pow_ChkS

		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		ori.b	#1,(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		bcs.s	Pow_RingSound
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		bcs.s	Pow_RingSound
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife

	Pow_RingSound:
		move.w	#sfx_Ring,d0
		jmp	(PlaySound).l	; play ring sound
; ===========================================================================

Pow_ChkS:
		cmpi.b	#7,d0		; does monitor contain 'S'?
		bne.s	Pow_ChkEnd
		addi.b	#$60,health.w
		bcc.s	.End
		st	health.w
		
	.End:
		rts

Pow_ChkEnd:
		move.w	#$FFFF,tirePressure.w
		clr.b	tireLeak.w
		rts			; 'S' and goggles monitors do nothing
; ===========================================================================

Pow_Delete:	; Routine 4
		subq.w	#1,obTimeFrame(a0)
		bpl.s	.End		; delete after half a second
		addq.w	#4,sp
		jmp	DeleteObject

.End:
		rts
