; ---------------------------------------------------------------------------
; Subroutine to	clear the screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ClearScreen:
		lea	VDP_CTRL,a5
		move.w	#$8F01,(a5)
		VRAM_FILL 0,vram_fg,$1000,(a5),-4(a5)
		VRAM_FILL 0,vram_bg,$1000,(a5),-4(a5)
		VRAM_FILL 0,vram_sprites,$280,(a5),-4(a5)
		VRAM_FILL 0,vram_hscroll,$380,(a5),-4(a5)
		move.w	#$8F02,(a5)

		move.l	#$40000010,(a5)
		moveq	#$50/4-1,d0

	.clearvsram:
		move.l	#0,-4(a5)
		dbf	d0,.clearvsram

		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w

		lea	(v_spritetablebuffer).w,a1
		moveq	#0,d0
		move.w	#($280/4),d1	; This should be ($280/4)-1, leading to a slight bug (first bit of v_pal_water is cleared)

	.clearsprites:
		move.l	d0,(a1)+
		dbf	d1,.clearsprites ; clear sprite table (in RAM)

		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#($400/4),d1	; This should be ($400/4)-1, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

	.clearhscroll:
		move.l	d0,(a1)+
		dbf	d1,.clearhscroll ; clear hscroll table (in RAM)
		rts	
; End of function ClearScreen