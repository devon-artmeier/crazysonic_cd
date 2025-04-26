; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevel:

.size:		equ 12	; number of tiles per frame

		tst.b	(v_lani2_frame).w
		beq.s	.smokepuff	; branch if counter hits 0
		
		subq.b	#1,(v_lani2_frame).w ; decrement counter
		bra.s	.chk_smokepuff2
; ===========================================================================

.smokepuff:
		subq.b	#1,(v_lani0_time).w ; decrement timer
		bpl.s	.chk_smokepuff2 ; branch if not 0
		
		move.b	#7,(v_lani0_time).w ; time to display each frame
		lea	(Art_SbzSmoke).l,a1 ; load smoke patterns
		VDP_CMD move.l,$8900,VRAM,WRITE,VDP_CTRL
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,(v_lani0_frame).w ; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff	; branch if frame 0
		subq.w	#1,d0
		mulu.w	#.size*$20,d0
		lea	(a1,d0.w),a1
		move.w	#.size-1,d1
		jmp	LoadTiles
; ===========================================================================

.untilnextpuff:
		move.b	#180,(v_lani2_frame).w ; time between smoke puffs (3 seconds)

.clearsky:
		move.w	#(.size/2)-1,d1
		jsr	LoadTiles
		lea	(Art_SbzSmoke).l,a1
		move.w	#(.size/2)-1,d1
		jmp	LoadTiles	; load blank tiles for no smoke puff
; ===========================================================================

.chk_smokepuff2:
		tst.b	(v_lani2_time).w
		beq.s	.smokepuff2	; branch if counter hits 0
		
		subq.b	#1,(v_lani2_time).w ; decrement counter
		bra.s	.end
; ===========================================================================

.smokepuff2:
		subq.b	#1,(v_lani1_time).w ; decrement timer
		bpl.s	.end		; branch if not 0
		
		move.b	#7,(v_lani1_time).w ; time to display each frame
		lea	(Art_SbzSmoke).l,a1 ; load smoke patterns
		VDP_CMD move.l,$8A80,VRAM,WRITE,VDP_CTRL
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w ; increment frame counter
		andi.w	#7,d0
		beq.s	.untilnextpuff2	; branch if frame 0
		subq.w	#1,d0
		mulu.w	#.size*$20,d0
		lea	(a1,d0.w),a1
		move.w	#.size-1,d1
		jmp	LoadTiles
; ===========================================================================

.untilnextpuff2:
		move.b	#120,(v_lani2_time).w ; time between smoke puffs (2 seconds)
		bra.s	.clearsky
; ===========================================================================

.end:
		rts	
