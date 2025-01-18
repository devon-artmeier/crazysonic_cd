; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

CollapseLedge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ledge_Index(pc,d0.w),d1
		jmp	Ledge_Index(pc,d1.w)
; ===========================================================================
Ledge_Index:	dc.w Ledge_Main-Ledge_Index, Ledge_Touch-Ledge_Index
		dc.w Ledge_Collapse-Ledge_Index, Ledge_Display-Ledge_Index
		dc.w Ledge_Delete-Ledge_Index, Ledge_WalkOff-Ledge_Index

ledge_timedelay:	equ $38		; time between touching the ledge and it collapsing
ledge_collapse_flag:	equ $3A		; collapse flag
; ===========================================================================

Ledge_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Ledge,obMap(a0)
		move.w	#$4000,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.w	#v_spritequeue+$200,obPriority(a0)
		move.b	#7,ledge_timedelay(a0) ; set time delay for collapse
		move.b	#$64,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)
		move.b	#$38,obHeight(a0)
		bset	#4,obRender(a0)

Ledge_Touch:	; Routine 2
		tst.b	ledge_collapse_flag(a0)	; is ledge collapsing?
		beq.s	.slope		; if not, branch
		tst.b	ledge_timedelay(a0)	; has time reached zero?
		beq.w	Ledge_Fragment	; if yes, branch
		subq.b	#1,ledge_timedelay(a0) ; subtract 1 from time

	.slope:
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		jsr	SlopeObject
		jmp	RememberState
; ===========================================================================

Ledge_Collapse:	; Routine 4
		tst.b	ledge_timedelay(a0)
		beq.w	loc_847A
		move.b	#1,ledge_collapse_flag(a0)	; set collapse flag
		subq.b	#1,ledge_timedelay(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Ledge_WalkOff:	; Routine $A
		move.w	#$30,d1
		jsr	ExitPlatform
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		move.w	obX(a0),d2
		jsr	SlopeObject2
		jmp	RememberState
; End of function Ledge_WalkOff

; ===========================================================================

Ledge_Display:	; Routine 6
		tst.b	ledge_timedelay(a0)	; has time delay reached zero?
		beq.s	Ledge_TimeZero	; if yes, branch
		tst.b	ledge_collapse_flag(a0)	; is ledge collapsing?
		bne.w	loc_82D0	; if yes, branch
		subq.b	#1,ledge_timedelay(a0) ; subtract 1 from time
		jmp	DisplaySprite
; ===========================================================================

loc_82D0:
		subq.b	#1,ledge_timedelay(a0)
		bsr.w	Ledge_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_82FC
		tst.b	ledge_timedelay(a0)
		bne.s	locret_8308
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#1,obNextAni(a1)

loc_82FC:
		move.b	#0,ledge_collapse_flag(a0)
		move.b	#6,obRoutine(a0) ; run "Ledge_Display" routine

locret_8308:
		rts	
; ===========================================================================

Ledge_TimeZero:
		jsr	ObjectFall
		tst.b	obRender(a0)
		bpl.s	Ledge_Delete
		jmp	DisplaySprite
; ===========================================================================

Ledge_Delete:	; Routine 8
		jmp	DeleteObject
; ---------------------------------------------------------------------------
; Object 53 - collapsing floors	(MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

CollapseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CFlo_Index(pc,d0.w),d1
		jmp	CFlo_Index(pc,d1.w)
; ===========================================================================
CFlo_Index:	dc.w CFlo_Main-CFlo_Index, CFlo_Touch-CFlo_Index
		dc.w CFlo_Collapse-CFlo_Index, CFlo_Display-CFlo_Index
		dc.w CFlo_Delete-CFlo_Index, CFlo_WalkOff-CFlo_Index

cflo_timedelay:		equ $38
cflo_collapse_flag:	equ $3A
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_CFlo,obMap(a0)
		move.w	#$42B8,obGfx(a0)
		
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ
		move.w	#$44E0,obGfx(a0) ; SLZ specific code
		addq.b	#2,obFrame(a0)

	.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.notSBZ
		move.w	#$43F5,obGfx(a0) ; SBZ specific code

	.notSBZ:
		cmpi.b	#id_SecretZ,(v_zone).w ; check if level is SBZ
		bne.s	.notSecret
		move.w	#$4398,obGfx(a0) ; SBZ specific code
		addq.b	#2,obFrame(a0)

	.notSecret:
		ori.b	#4,obRender(a0)
		move.w	#v_spritequeue+$200,obPriority(a0)
		move.b	#7,cflo_timedelay(a0)
		move.b	#$44,obActWid(a0)

CFlo_Touch:	; Routine 2
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the	object?
		beq.s	.solid		; if not, branch
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.w	CFlo_Fragment	; if yes, branch
		subq.b	#1,cflo_timedelay(a0) ; subtract 1 from time

	.solid:
		move.w	#$20,d1
		jsr	PlatformObject
		tst.b	obSubtype(a0)
		bpl.s	.remstate
		btst	#3,obStatus(a1)
		beq.s	.remstate
		bclr	#0,obRender(a0)
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		bcc.s	.remstate
		bset	#0,obRender(a0)

	.remstate:
		jmp	RememberState
; ===========================================================================

CFlo_Collapse:	; Routine 4
		tst.b	cflo_timedelay(a0)
		beq.w	loc_8458
		move.b	#1,cflo_collapse_flag(a0)	; set object as	"touched"
		subq.b	#1,cflo_timedelay(a0)

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CFlo_WalkOff:	; Routine $A
		move.w	#$20,d1
		jsr	ExitPlatform
		move.w	obX(a0),d2
		jsr	MvSonicOnPtfm2
		jmp	RememberState
; End of function CFlo_WalkOff

; ===========================================================================

CFlo_Display:	; Routine 6
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.s	CFlo_TimeZero	; if yes, branch
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the	object?
		bne.w	loc_8402	; if yes, branch
		subq.b	#1,cflo_timedelay(a0); subtract 1 from time
		jmp	DisplaySprite
; ===========================================================================

loc_8402:
		subq.b	#1,cflo_timedelay(a0)
		bsr.w	CFlo_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_842E
		tst.b	cflo_timedelay(a0)
		bne.s	locret_843A
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#1,obNextAni(a1)

loc_842E:
		move.b	#0,cflo_collapse_flag(a0)
		move.b	#6,obRoutine(a0) ; run "CFlo_Display" routine

locret_843A:
		rts	
; ===========================================================================

CFlo_TimeZero:
		jsr	ObjectFall
		tst.b	obRender(a0)
		bpl.s	CFlo_Delete
		jmp	DisplaySprite
; ===========================================================================

CFlo_Delete:	; Routine 8
		jmp	DeleteObject
; ===========================================================================

CFlo_Fragment:
		move.b	#0,cflo_collapse_flag(a0)

loc_8458:
		lea	(CFlo_Data2).l,a4
		btst	#0,obSubtype(a0)
		beq.s	loc_846C
		lea	(CFlo_Data3).l,a4

loc_846C:
		moveq	#7,d1
		addq.b	#1,obFrame(a0)
		bra.s	loc_8486
; ===========================================================================

Ledge_Fragment:
		move.b	#0,ledge_collapse_flag(a0)

loc_847A:
		lea	(CFlo_Data1).l,a4
		moveq	#$18,d1
		addq.b	#2,obFrame(a0)

loc_8486:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,obRender(a0)
		move.b	0(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_84B2
; ===========================================================================

loc_84AA:
		jsr	FindFreeObj
		bne.s	loc_84F2
		addq.w	#6,a3

loc_84B2:
		move.b	#6,obRoutine(a1)
		move.b	d4,0(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_84EE
		jsr	DisplaySprite1

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		jsr	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(PlaySound_Special).l	; play collapsing sound
; ===========================================================================
; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for GHZ collapsing ledge
; ---------------------------------------------------------------------------
Ledge_SlopeData:
		incbin	"source/sonic/misc/GHZ Collapsing Ledge Heightmap.bin"
		even
		