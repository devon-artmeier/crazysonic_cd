; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevel:

AniArt_Ending_BigFlower:

.size:		equ 16	; number of tiles per frame

		subq.b	#1,(v_lani1_time).w ; decrement timer
		bpl.s	AniArt_Ending_SmallFlower ; branch if not 0
		
		move.b	#7,(v_lani1_time).w
		lea	(Art_GhzFlower1).l,a1 ;	load big flower	patterns
		lea	($FFFF9400).w,a2 ; load 2nd big flower from RAM
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w ; increment frame counter
		andi.w	#1,d0		; only 2 frames
		beq.s	.isframe0	; branch if frame 0
		lea	.size*$20(a1),a1
		lea	.size*$20(a2),a2

	.isframe0:
		VDP_CMD move.l,$6B80,VRAM,WRITE,VDP_CTRL
		move.w	#.size-1,d1
		bsr.w	LoadTiles
		movea.l	a2,a1
		VDP_CMD move.l,$7200,VRAM,WRITE,VDP_CTRL
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================

AniArt_Ending_SmallFlower:

.size:		equ 12	; number of tiles per frame

		subq.b	#1,(v_lani2_time).w ; decrement timer
		bpl.s	.end		; branch if not 0
		
		move.b	#7,(v_lani2_time).w
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,(v_lani2_frame).w ; increment frame counter
		andi.w	#7,d0		; max 8 frames
		move.b	.sequence(pc,d0.w),d0 ; get actual frame num from sequence data
		lsl.w	#7,d0		; multiply by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0		; multiply by 3
		VDP_CMD move.l,$6D80,VRAM,WRITE,VDP_CTRL
		lea	(Art_GhzFlower2).l,a1 ;	load small flower patterns
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		bra.w	LoadTiles
; ===========================================================================
.sequence:	dc.b 0,	0, 0, 1, 2, 2, 2, 1
; ===========================================================================

.end:
		rts	
