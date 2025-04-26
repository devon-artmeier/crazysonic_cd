; ---------------------------------------------------------------------------
; Object 3A - "SONIC GOT THROUGH" title	card
; ---------------------------------------------------------------------------

GotThroughCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Got_Index(pc,d0.w),d1
		jmp	Got_Index(pc,d1.w)
; ===========================================================================
Got_Index:	dc.w Got_ChkPLC-Got_Index
		dc.w Got_Move-Got_Index
		dc.w Got_Wait-Got_Index
		dc.w Got_TimeBonus-Got_Index
		dc.w Got_Wait-Got_Index
		dc.w Got_NextLevel-Got_Index
		dc.w Got_Wait-Got_Index
		dc.w Got_Move2-Got_Index
		dc.w loc_C766-Got_Index

got_mainX:	equ $30		; position for card to display on
got_finalX:	equ $32		; position for card to finish on
; ===========================================================================

Got_ChkPLC:	; Routine 0
		jsr	CheckCDDA
		beq.s	.End
		tst.l	(v_plc_buffer).w ; are the pattern load cues empty?
		beq.s	Got_Main	; if yes, branch

.End:
		rts	
; ===========================================================================

Got_Main:
		lea	CBPCM_Stop,a1
		jsr	CallSubFunction
	
		movea.l	a0,a1
		lea	(Got_Config).l,a2
		moveq	#5,d1

Got_Loop:
		move.b	#id_GotThroughCard,0(a1)
		move.w	(a2),obX(a1)	; load start x-position
		move.w	(a2)+,got_finalX(a1) ; load finish x-position (same as start)
		move.w	(a2)+,got_mainX(a1) ; load main x-position
		move.w	(a2)+,obScreenY(a1) ; load y-position
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_C5CA
		add.b	(v_act).w,d0	; add act number to frame number

	loc_C5CA:
		move.b	d0,obFrame(a1)
		move.l	#Map_Got,obMap(a1)
		move.w	#$8580,obGfx(a1)
		move.b	#0,obRender(a1)
		move.w	#v_spritequeue,obPriority(a1)
		lea	$40(a1),a1
		dbf	d1,Got_Loop	; repeat 6 times

Got_Move:	; Routine 2
		moveq	#$10,d1		; set horizontal speed
		move.w	got_mainX(a0),d0
		cmp.w	obX(a0),d0	; has item reached its target position?
		beq.s	loc_C61A	; if yes, branch
		bge.s	Got_ChgPos
		neg.w	d1

	Got_ChgPos:
		add.w	d1,obX(a0)	; change item's position

	loc_C5FE:
		move.w	obX(a0),d0
		bmi.s	locret_C60E
		cmpi.w	#$200,d0	; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C60E	; if yes, branch
		jmp	DisplaySprite
; ===========================================================================

locret_C60E:
		rts	
; ===========================================================================

loc_C610:
		moveq	#CBID_BUS,d0
		lea	CBPCM_Play,a1
		jsr	CallSubFunction
		
		move.b	#$E,obRoutine(a0)
		bra.w	Got_Move2
; ===========================================================================

loc_C61A:
		cmpi.b	#$E,(v_objspace+$6C0+obRoutine).w
		beq.s	loc_C610
		cmpi.b	#4,obFrame(a0)
		bne.s	loc_C5FE
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0) ; set time delay to 3 seconds

Got_Wait:	; Routine 4, 8, $C
		subq.w	#1,obTimeFrame(a0) ; subtract 1 from time delay
		bne.s	Got_Display
		addq.b	#2,obRoutine(a0)

Got_Display:
		jmp	DisplaySprite
; ===========================================================================

Got_TimeBonus:	; Routine 6
		jsr	DisplaySprite
		move.b	#1,(f_endactbonus).w ; set time/ring bonus update flag
		moveq	#0,d0
		tst.w	(v_ringbonus).w	; is ring bonus	= zero?
		beq.s	Got_ChkBonus	; if yes, branch
		addi.w	#10,d0		; add 10 to score
		subi.w	#10,(v_ringbonus).w ; subtract 10 from ring bonus

Got_ChkBonus:
		tst.w	d0		; is there any bonus?
		bne.s	Got_AddBonus	; if yes, branch
		move.w	#sfx_Cash,d0
		jsr	(PlaySound_Special).l	; play "ker-ching" sound
		addq.b	#2,obRoutine(a0)
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w
		bne.s	Got_SetDelay
		addq.b	#4,obRoutine(a0)

Got_SetDelay:
		move.w	#180,obTimeFrame(a0) ; set time delay to 3 seconds

locret_C692:
		rts	
; ===========================================================================

Got_AddBonus:
		jsr	(AddPoints).l
		move.b	(v_vbla_byte).w,d0
		andi.b	#3,d0
		bne.s	locret_C692
		move.w	#sfx_Switch,d0
		jmp	(PlaySound_Special).l	; play "blip" sound
; ===========================================================================

Got_NextLevel:	; Routine $A
		move.b	(v_zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(v_act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		moveq	#1,d1
		move.b	LevelOrder(pc,d0.w),d2 ; load level from level order array
		cmp.b	(v_zone).w,d2
		beq.s	.SetZone
		moveq	#-1,d1

.SetZone:
		move.w	LevelOrder(pc,d0.w),d0
		move.w	d0,(v_zone).w	; set level number
		bne.s	Got_ChkSS
		move.b	#id_Title,(v_gamemode).w
		bra.s	Got_Display2
; ===========================================================================

Got_ChkSS:
		clr.b	(v_lastlamp).w	; clear	lamppost counter
		tst.b	(f_bigring).w	; has Sonic jumped into	a giant	ring?
		beq.s	VBla_08A	; if not, branch
		move.b	#id_Special,(v_gamemode).w ; set game mode to Special Stage (10)
		bra.s	Got_Display2
; ===========================================================================

VBla_08A:
		move.w	d1,(f_restart).w ; restart level

Got_Display2:
		jmp	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Level	order array
; ---------------------------------------------------------------------------
LevelOrder:
		; Green Hill Zone
		dc.b id_GHZ, 1	; Act 1
		dc.b id_GHZ, 2	; Act 2
		dc.b id_MZ, 0	; Act 3
		dc.b 0, 0

		; Labyrinth Zone
		dc.b id_LZ, 1	; Act 1
		dc.b id_LZ, 2	; Act 2
		dc.b id_SLZ, 0	; Act 3
		dc.b id_SBZ, 2	; Scrap Brain Zone Act 3

		; Marble Zone
		dc.b id_MZ, 1	; Act 1
		dc.b id_MZ, 2	; Act 2
		dc.b id_SYZ, 0	; Act 3
		dc.b 0, 0

		; Star Light Zone
		dc.b id_SLZ, 1	; Act 1
		dc.b id_SLZ, 2	; Act 2
		dc.b id_SBZ, 0	; Act 3
		dc.b 0, 0

		; Spring Yard Zone
		dc.b id_SYZ, 1	; Act 1
		dc.b id_SYZ, 2	; Act 2
		dc.b id_LZ, 0	; Act 3
		dc.b 0, 0

		; Scrap Brain Zone
		dc.b id_SBZ, 1	; Act 1
		dc.b id_LZ, 3	; Act 2
		dc.b 0, 0	; Final Zone
		dc.b 0, 0
		
		; Ending
		dc.b 0, 0
		dc.b 0, 0
		dc.b 0, 0
		dc.b 0, 0
		
		; Secret Zone
		dc.b 0, 0
		dc.b 0, 0
		dc.b 0, 0
		dc.b 0, 0
		even
; ===========================================================================

Got_Move2:	; Routine $E
		moveq	#$20,d1		; set horizontal speed
		move.w	got_finalX(a0),d0
		cmp.w	obX(a0),d0	; has item reached its finish position?
		beq.s	Got_SBZ2	; if yes, branch
		bge.s	Got_ChgPos2
		neg.w	d1

	Got_ChgPos2:
		add.w	d1,obX(a0)	; change item's position
		move.w	obX(a0),d0
		bmi.s	locret_C748
		cmpi.w	#$200,d0	; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C748	; if yes, branch
		jmp	DisplaySprite
; ===========================================================================

locret_C748:
		rts	
; ===========================================================================

Got_SBZ2:
		cmpi.b	#4,obFrame(a0)
		bne.s	Got_Delete
		addq.b	#2,obRoutine(a0)
		clr.b	(f_lockctrl).w	; unlock controls
		
		moveq	#15,d0
		jmp	LoopCDDA
; ===========================================================================

loc_C766:	; Routine $10
		addq.w	#2,(v_limitright2).w
		cmpi.w	#$2100,(v_limitright2).w
		beq.s	Got_Delete
		rts	

Got_Delete:
		jmp	DeleteObject
; ===========================================================================
		;    x-start,	x-main,	y-main,
		;				routine, frame number

Got_Config:	dc.w 4,		$124,	$BC			; "SONIC HAS"
		dc.b 				2,	0

		dc.w -$120,	$120,	$D0			; "PASSED"
		dc.b 				2,	1

		dc.w $40C,	$14C,	$D6			; "ACT" 1/2/3
		dc.b 				2,	6

		dc.w $520,	$120,	$FC			; score
		dc.b 				2,	2

		dc.w $560,	$120,	$10C			; ring bonus
		dc.b 				2,	4

		dc.w $20C,	$14C,	$CC			; oval
		dc.b 				2,	5
