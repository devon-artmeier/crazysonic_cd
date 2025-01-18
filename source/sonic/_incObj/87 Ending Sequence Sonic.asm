; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence
; ---------------------------------------------------------------------------

obESPosX	EQU	$32
obESPosY	EQU	$34

; ---------------------------------------------------------------------------

EndSonic:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	dc.w ESon_Main-ESon_Index, ESon_MakeEmeralds-ESon_Index
		dc.w Obj87_Animate-ESon_Index,	Obj87_LookUp-ESon_Index
		dc.w Obj87_ClrObjRam-ESon_Index, Obj87_Animate-ESon_Index
		dc.w Obj87_MakeLogo-ESon_Index, Obj87_Animate2-ESon_Index
		dc.w Obj87_Leap-ESon_Index, Obj87_Animate2-ESon_Index

eson_time:	equ $30	; time to wait between events
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#7,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	ESon_Main2	; if yes, branch
		addi.b	#$10,ob2ndRout(a0) ; else, skip emerald sequence
		move.w	#216,eson_time(a0)
		rts	
; ===========================================================================

ESon_Main2:
		addq.b	#2,ob2ndRout(a0)
		move.w	#v_spritequeue+$100,obPriority(a0)
		move.b	#1,obFrame(a0)
		move.w	#80,eson_time(a0) ; set duration for Sonic to pause

ESon_MakeEmeralds:
		subq.w	#1,eson_time(a0) ; subtract 1 from duration
		bne.s	ESon_Wait
		addq.b	#2,ob2ndRout(a0)
		move.w	#1,obAnim(a0)
		st	(f_nobgscroll).w
		move.b	#id_EndChaos,(v_objspace+$400).w ; load chaos emeralds objects

	ESon_Wait:
		rts	
; ===========================================================================

Obj87_LookUp:	; Routine 6
		cmpi.w	#$2000,(v_objspace+$400+$3C).w
		bne.s	locret_5480
		move.w	#1,(f_restart).w ; set level to	restart	(causes	flash)
		move.w	#90,eson_time(a0)
		addq.b	#2,ob2ndRout(a0)

locret_5480:
		rts	
; ===========================================================================

Obj87_ClrObjRam:
		; Routine 8
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait2
		lea	(v_objspace+$400).w,a1
		move.w	#$FF,d1

Obj87_ClrLoop:
		clr.l	(a1)+
		dbf	d1,Obj87_ClrLoop ; clear the object RAM
		move.w	#1,(f_restart).w
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.w	#60,eson_time(a0)

ESon_Wait2:
		rts	
; ===========================================================================

Obj87_MakeLogo:	; Routine $C
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait3
		addq.b	#2,ob2ndRout(a0)
		move.w	#180,eson_time(a0)
		subi.w	#$30,obY(a0)
		move.w	obX(a0),obESPosX(a0)
		move.w	obY(a0),obESPosY(a0)
		move.b	#2,obAnim(a0)
		move.b	#id_EndSTH,(v_objspace+$400).w ; load "SONIC THE HEDGEHOG" object

ESon_Wait3:
		rts	
; ===========================================================================

Obj87_Animate2:
		move.b	obAngle(a0),d0
		move.w	obESPosX(a0),d3
		move.w	obESPosY(a0),d4
		jsr	(CalcSine).l
		asr.w	#2,d0
		asr.w	#2,d1
		move.w	d0,d5
		asr.w	#1,d5
		add.w	d5,d0
		move.w	d1,d5
		asr.w	#1,d5
		add.w	d5,d1
		add.w	d0,d3
		add.w	d1,d4
		move.w	d3,obX(a0)
		move.w	d4,obY(a0)
		addq.b	#6,obAngle(a0)
; ===========================================================================

Obj87_Animate:	; Rountine 4, $A, $E, $12
		lea	(AniScript_ESon).l,a1
		jsr	(AnimateSprite).l
		jmp	Sonic_LoadGfx
; ===========================================================================

Obj87_Leap:	; Routine $10
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait4
		addq.b	#2,ob2ndRout(a0)
		move.b	#4,obRender(a0)
		clr.b	obStatus(a0)
		move.w	#v_spritequeue+$100,obPriority(a0)
		move.b	#1,obFrame(a0)
		subi.w	#$30,obY(a0)
		move.w	obX(a0),obESPosX(a0)
		move.w	obY(a0),obESPosY(a0)
		st	(f_nobgscroll).w
		move.b	#2,obAnim(a0)	; use "leaping"	animation
		move.b	#id_EndSTH,(v_objspace+$400).w ; load "SONIC THE HEDGEHOG" object
		bra.w	Obj87_Animate2
; ===========================================================================

ESon_Wait4:
		rts	
