; ---------------------------------------------------------------------------
; Object 0B - pole that	breaks (LZ)
; ---------------------------------------------------------------------------

Pole:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pole_Index(pc,d0.w),d1
		jmp	Pole_Index(pc,d1.w)
; ===========================================================================
Pole_Index:	dc.w Pole_Main-Pole_Index
		dc.w Pole_Action-Pole_Index
		dc.w Pole_Display-Pole_Index

pole_time:	equ $30		; time between grabbing the pole & breaking
pole_grabbed:	equ $32		; flag set when Sonic grabs the pole
; ===========================================================================

Pole_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Pole,obMap(a0)
		move.w	#$43DE,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#8,obActWid(a0)
		move.w	#v_spritequeue+$200,obPriority(a0)
		move.b	#$E1,obColType(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object type
		mulu.w	#60,d0		; multiply by 60 (1 second)
		move.w	d0,pole_time(a0) ; set breakage time

Pole_Action:	; Routine 2
		tst.b	obColProp(a0)	; has Sonic touched the	pole?
		beq.s	Pole_Display	; if not, branch
		clr.b	obColProp(a0)
		move.b	#1,obFrame(a0)	; break	the pole
		clr.b	obColType(a0)
		addq.b	#2,obRoutine(a0) ; goto Pole_Display next
; ===========================================================================

Pole_Display:	; Routine 4
		jmp	RememberState
