; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

LevelEvents:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SLZx(pc,d0.w),d0
		jmp	DLE_SLZx(pc,d0.w)
; ===========================================================================
DLE_SLZx:	dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ12-DLE_SLZx
		dc.w DLE_SLZ3-DLE_SLZx
; ===========================================================================

DLE_SLZ12:
		rts	
; ===========================================================================

DLE_SLZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7118(pc,d0.w),d0
		jmp	off_7118(pc,d0.w)
; ===========================================================================
off_7118:	dc.w DLE_SLZ3main-off_7118
		dc.w DLE_SLZ3boss-off_7118
		dc.w DLE_SLZ3end-off_7118
; ===========================================================================

DLE_SLZ3main:
		cmpi.w	#$1E70,(v_screenposx).w
		bcs.s	locret_7130
		move.w	#$210,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w

locret_7130:
		rts	
; ===========================================================================

DLE_SLZ3boss:
		cmpi.w	#$2000,(v_screenposx).w
		bcs.s	locret_715C
		jsr	FindFreeObj
		bne.s	loc_7144
		move.b	#id_BossStarLight,(a1) ; load SLZ boss object

loc_7144:
		tst.b	(effectFlags).w
		bne.s	.NoPlay
		moveq	#16,d0
		jsr	LoopCDDA

.NoPlay:
		move.b	#1,(f_lockscreen).w ; lock screen
		st	(bossFlag).w
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		jmp	AddPLC		; load boss patterns
; ===========================================================================

locret_715C:
		rts	
; ===========================================================================

DLE_SLZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts
; ===========================================================================