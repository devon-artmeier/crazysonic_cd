; ===========================================================================
; ---------------------------------------------------------------------------
; Secret Zone dynamic level events
; ---------------------------------------------------------------------------

LevelEvents:
		moveq	#0,d0
		move.b	v_dle_routine.w,d0
		move.w	.Index(pc,d0.w),d0
		jmp	.Index(pc,d0.w)

; ---------------------------------------------------------------------------

.Index:
		dc.w DLE_SecretMain-.Index
		dc.w DLE_SecretBoss-.Index
		dc.w DLE_SecretEnd-.Index
		
; ---------------------------------------------------------------------------

DLE_SecretMain:
		move.w	#$800,v_limitbtm1.w
		cmpi.w	#$2780,v_screenposx.w
		bcs.s	.End
		move.w	#$240,v_limitbtm1.w

.CheckBoss:
		move.w	#$2860,d0
		cmp.w	v_screenposx.w,d0
		bcc.s	.End

		move.b	#60,secretBoss.w
		move.w	#32,v_palchgspeed.w
		clr.b	effectTriggers.w
		
		move.b	#1,f_lockscreen.w
		addq.b	#2,v_dle_routine.w
		move.w	d0,v_limitleft2.w
		move.w	d0,v_limitright2.w

		moveq	#plcid_Boss,d0
		jmp	AddPLC

.End:
		rts	

; ---------------------------------------------------------------------------

DLE_SecretBoss:
		move.w	v_screenposy.w,v_limittop2.w
		subq.b	#1,secretBoss.w
		cmpi.b	#1,secretBoss.w
		bne.w	DLE_SecretEnd

		move.w	#-136,v_bgscreenposy.w
		move.w	#-136,v_bgscrposy_dup.w

		VDP_CMD move.l,vram_fg,VRAM,READ,VDP_CTRL
		lea	WORD_END_2M-$1000,a0
		lea	VDP_DATA,a1
		move.w	#$1000/16-1,d0

.ReadPlaneA:
		rept	16/2
			move.w	(a1),(a0)+
		endr
		dbf	d0,.ReadPlaneA

		VDP_CMD move.l,vram_fg,VRAM,WRITE,VDP_CTRL
		lea	WORD_END_2M-$1000,a0
		move.w	#$1000/16-1,d0
		move.l	#$80008000,d1

.WritePlaneA:
		rept	16/4
			move.l	(a0)+,d2
			or.l	d1,d2
			move.l	d2,(a1)
		endr
		dbf	d0,.WritePlaneA

		lea	Map_MrRogers,a0
		lea	WORD_END_2M-$1000,a1
		move.w	#$6300,d0
		jsr	EniDec

		VDP_CMD move.l,$E000,VRAM,WRITE,d0
		moveq	#$40-1,d1
		moveq	#$20-1,d2
		jsr	TilemapToVRAM

		jsr	FindFreeObj
		bne.s	.NoBoss
		move.b	#id_Obj06,(a1)
		clr.b	obSubtype(a1)

.NoBoss:
		addq.b	#2,v_dle_routine.w

; ---------------------------------------------------------------------------

DLE_SecretEnd:
		rts

; ---------------------------------------------------------------------------
