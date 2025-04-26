; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevelGfx:
		tst.w	(f_pause).w	; is the game paused?
		bne.s	.ispaused	; if yes, branch
		lea	(VDP_DATA).l,a6
		bsr.w	AniArt_GiantRing
		jmp	AnimateLevel

	.ispaused:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	transfer graphics to VRAM

; input:
;	a1 = source address
;	a6 = VDP_DATA ($C00000)
;	d1 = number of tiles to load (minus one)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTiles:
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		dbf	d1,LoadTiles
		rts	
; End of function LoadTiles

; ---------------------------------------------------------------------------
; Animated pattern routine - giant ring
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AniArt_GiantRing:

.size:		equ 14

		tst.w	(v_gfxbigring).w	; Is there any of the art left to load?
		bne.s	.loadTiles		; If so, get to work
		rts	
; ===========================================================================
; loc_1C518:
.loadTiles:
		subi.w	#.size*$20,(v_gfxbigring).w	; Count-down the 14 tiles we're going to load now
		lea	(Art_BigRing).l,a1 ; load giant	ring patterns
		moveq	#0,d0
		move.w	(v_gfxbigring).w,d0
		lea	(a1,d0.w),a1
		; Turn VRAM address into VDP command
		addi.w	#$8000,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		; Send VDP command (write to VRAM at address contained in v_gfxbigring)
		move.l	d0,4(a6)

		move.w	#.size-1,d1
		bra.w	LoadTiles

; End of function AniArt_GiantRing
