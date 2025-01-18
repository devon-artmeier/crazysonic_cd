; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevel:

AniArt_GHZ_Waterfall:

.size:		equ 8	; number of tiles per frame

		subq.b	#1,(v_lani0_time).w ; decrement timer
		bpl.s	AniArt_GHZ_Bigflower ; branch if not 0

		move.b	#5,(v_lani0_time).w ; time to display each frame
		lea	(Art_GhzWater).l,a1 ; load waterfall patterns
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,(v_lani0_frame).w ; increment frame counter
		andi.w	#1,d0		; there are only 2 frames
		beq.s	.isframe0	; branch if frame 0
		lea	.size*$20(a1),a1 ; use graphics for frame 1

	.isframe0:
		VDP_CMD move.l,$6F00,VRAM,WRITE,VDP_CTRL
		move.w	#.size-1,d1	; number of 8x8	tiles
		jmp	LoadTiles
; ===========================================================================

AniArt_GHZ_Bigflower:

.size:		equ 16	; number of tiles per frame

		subq.b	#1,(v_lani1_time).w
		bpl.s	AniArt_GHZ_Smallflower

		move.b	#$F,(v_lani1_time).w
		lea	(Art_GhzFlower1).l,a1 ;	load big flower	patterns
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w
		andi.w	#1,d0
		beq.s	.isframe0
		lea	.size*$20(a1),a1

	.isframe0:
		VDP_CMD move.l,$6B80,VRAM,WRITE,VDP_CTRL
		move.w	#.size-1,d1
		jmp	LoadTiles
; ===========================================================================

AniArt_GHZ_Smallflower:

.size:		equ 12	; number of tiles per frame

		subq.b	#1,(v_lani2_time).w
		bpl.s	.end

		move.b	#7,(v_lani2_time).w
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,(v_lani2_frame).w ; increment frame counter
		andi.w	#3,d0		; there are 4 frames
		move.b	.sequence(pc,d0.w),d0
		btst	#0,d0		; is frame 0 or 2? (actual frame, not frame counter)
		bne.s	.isframe1	; if not, branch
		move.b	#$7F,(v_lani2_time).w ; set longer duration for frames 0 and 2

	.isframe1:
		lsl.w	#7,d0		; multiply frame num by $80
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0		; multiply that by 3 (i.e. frame num times 12 * $20)
		VDP_CMD move.l,$6D80,VRAM,WRITE,VDP_CTRL
		lea	(Art_GhzFlower2).l,a1 ;	load small flower patterns
		lea	(a1,d0.w),a1	; jump to appropriate tile
		move.w	#.size-1,d1
		jmp	LoadTiles

.end:
		rts	

.sequence:	dc.b 0,	1, 2, 1
