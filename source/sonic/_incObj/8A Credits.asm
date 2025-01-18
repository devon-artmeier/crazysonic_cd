; ---------------------------------------------------------------------------
; Object 8A - "SONIC TEAM PRESENTS" and	credits
; ---------------------------------------------------------------------------

CreditsText:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cred_Index(pc,d0.w),d1
		jmp	Cred_Index(pc,d1.w)
; ===========================================================================
Cred_Index:	dc.w Cred_Main-Cred_Index
		dc.w Cred_Display-Cred_Index
; ===========================================================================

Cred_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$120,obX(a0)
		move.w	#$F0,obScreenY(a0)
		move.l	#Map_Cred,obMap(a0)
		move.w	#$5A0,obGfx(a0)
		move.w	(v_creditsnum).w,d0 ; load credits index number
		move.b	d0,obFrame(a0)	; display appropriate sprite
		clr.b	obRender(a0)
		move.w	#v_spritequeue,obPriority(a0)
; ===========================================================================

Cred_Display:	; Routine 2
		jmp	DisplaySprite