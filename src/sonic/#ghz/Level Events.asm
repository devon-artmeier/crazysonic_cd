; ===========================================================================
; ---------------------------------------------------------------------------
; Green	Hill Zone dynamic level events
; ---------------------------------------------------------------------------

LevelEvents:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_GHZx(pc,d0.w),d0
		jmp	DLE_GHZx(pc,d0.w)
; ===========================================================================
DLE_GHZx:	dc.w DLE_GHZ1-DLE_GHZx
		dc.w DLE_GHZ2-DLE_GHZx
		dc.w DLE_GHZ3-DLE_GHZx
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_limitbtm1).w ; set lower y-boundary
		cmpi.w	#$1780,(v_screenposx).w ; has the camera reached $1780 on x-axis?
		bcs.s	locret_6E08	; if not, branch
		move.w	#$400,(v_limitbtm1).w ; set lower y-boundary
		move.w	#$400,(v_limitbtm2).w

locret_6E08:
		rts	
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_screenposx).w
		bcs.s	locret_6E3A
		move.w	#$300,(v_limitbtm1).w

locret_6E3A:
		rts	
; ===========================================================================

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_6E4A(pc,d0.w),d0
		jmp	off_6E4A(pc,d0.w)
; ===========================================================================
off_6E4A:	dc.w DLE_GHZ3main-off_6E4A
		dc.w DLE_GHZ3boss-off_6E4A
		dc.w DLE_GHZ3end-off_6E4A
; ===========================================================================

DLE_GHZ3main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_screenposx).w
		bcs.s	locret_6E96
		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_screenposx).w
		bcs.s	locret_6E96
		cmpi.w	#$280,(v_screenposy).w
		bcs.s	loc_6E98
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_screenposx).w
		bcc.s	loc_6E8E
		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

loc_6E8E:
		cmpi.w	#$1700,(v_screenposx).w
		bcc.s	loc_6E98

locret_6E96:
		rts	
; ===========================================================================

loc_6E98:
		move.w	#$300,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w
		rts	
; ===========================================================================

DLE_GHZ3boss:
		cmpi.w	#$960,(v_screenposx).w
		bcc.s	loc_6EB0
		subq.b	#2,(v_dle_routine).w

loc_6EB0:
		cmpi.w	#$2960,(v_screenposx).w
		bcs.s	locret_6EE8
		jsr	FindFreeObj
		bne.s	loc_6ED0
		move.b	#id_BossGreenHill,0(a1) ; load GHZ boss	object
		move.w	#$2A60,obX(a1)
		move.w	#$280,obY(a1)

loc_6ED0:
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

locret_6EE8:
		rts	
; ===========================================================================

DLE_GHZ3end:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================