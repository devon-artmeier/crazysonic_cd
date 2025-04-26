; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

LevelEvents:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SBZx(pc,d0.w),d0
		jmp	DLE_SBZx(pc,d0.w)
; ===========================================================================
DLE_SBZx:	dc.w DLE_SBZ1-DLE_SBZx
		dc.w DLE_SBZ2-DLE_SBZx
		dc.w DLE_FZ-DLE_SBZx
; ===========================================================================

DLE_SBZ1:
		move.w	#$720,(v_limitbtm1).w
		cmpi.w	#$1880,(v_screenposx).w
		bcs.s	locret_7242
		move.w	#$620,(v_limitbtm1).w
		cmpi.w	#$2000,(v_screenposx).w
		bcs.s	locret_7242
		move.w	#$2A0,(v_limitbtm1).w

locret_7242:
		rts	
; ===========================================================================

DLE_SBZ2:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_7252(pc,d0.w),d0
		jmp	off_7252(pc,d0.w)
; ===========================================================================
off_7252:	dc.w DLE_SBZ2main-off_7252
		dc.w DLE_SBZ2boss-off_7252
		dc.w DLE_SBZ2boss2-off_7252
		dc.w DLE_SBZ2end-off_7252
; ===========================================================================

DLE_SBZ2main:
		move.w	#$800,(v_limitbtm1).w
		cmpi.w	#$1800,(v_screenposx).w
		bcs.s	locret_727A
		move.w	#$510,(v_limitbtm1).w
		cmpi.w	#$1E00,(v_screenposx).w
		bcs.s	locret_727A
		addq.b	#2,(v_dle_routine).w

locret_727A:
		rts	
; ===========================================================================

DLE_SBZ2boss:
		cmpi.w	#$1EB0,(v_screenposx).w
		bcs.s	locret_7298
		jsr	FindFreeObj
		bne.s	locret_7298
		move.b	#id_FalseFloor,(a1) ; load collapsing block object
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_EggmanSBZ2,d0
		jmp	AddPLC		; load SBZ2 Eggman patterns
; ===========================================================================

locret_7298:
		rts	
; ===========================================================================

DLE_SBZ2boss2:
		cmpi.w	#$1F60,(v_screenposx).w
		bcs.s	loc_72B6
		jsr	FindFreeObj
		bne.s	loc_72B0
		move.b	#id_ScrapEggman,(a1) ; load SBZ2 Eggman object
		addq.b	#2,(v_dle_routine).w

loc_72B0:
		move.b	#1,(f_lockscreen).w ; lock screen

loc_72B6:
		bra.s	loc_72C2
; ===========================================================================

DLE_SBZ2end:
		cmpi.w	#$2050,(v_screenposx).w
		bcs.s	loc_72C2
		rts	
; ===========================================================================

loc_72C2:
		move.w	(v_screenposx).w,(v_limitleft2).w
		rts	
; ===========================================================================

DLE_FZ:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_72D8(pc,d0.w),d0
		jmp	off_72D8(pc,d0.w)
; ===========================================================================
off_72D8:	dc.w DLE_FZmain-off_72D8, DLE_FZboss-off_72D8
		dc.w DLE_FZend-off_72D8, locret_7322-off_72D8
		dc.w DLE_FZend2-off_72D8
; ===========================================================================

DLE_FZmain:
		cmpi.w	#$2148,(v_screenposx).w
		bcs.s	loc_72F4
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_FZBoss,d0
		jsr	AddPLC		; load FZ boss patterns

loc_72F4:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZboss:
		cmpi.w	#$2300,(v_screenposx).w
		bcs.s	loc_7312
		jsr	FindFreeObj
		bne.s	loc_7312
		move.b	#id_BossFinal,(a1) ; load FZ boss object
		addq.b	#2,(v_dle_routine).w
		move.b	#1,(f_lockscreen).w ; lock screen

loc_7312:
		bra.s	loc_72C2
; ===========================================================================

DLE_FZend:
		cmpi.w	#$2450,(v_screenposx).w
		bcs.s	loc_7320
		addq.b	#2,(v_dle_routine).w

loc_7320:
		bra.s	loc_72C2
; ===========================================================================

locret_7322:
		rts	
; ===========================================================================

DLE_FZend2:
		bra.s	loc_72C2
; ===========================================================================