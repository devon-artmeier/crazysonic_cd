; ---------------------------------------------------------------------------
; Subroutine to	convert	mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSprites:
		lea	(v_spritetablebuffer).w,a2 ; set address for sprite table
		moveq	#0,d5
		moveq	#0,d4
		
		move.l	(v_buildhud).w,d0
		beq.s	.nohud
		movea.l	d0,a0
		jsr	(a0)
		
	.nohud:
		lea	(v_spritequeue).w,a4
		moveq	#8-1,d7

BuildSprites_LevelLoop:
		cmpi.b	#4,d7
		bne.s	.norings
		move.l	(v_buildrings).w,d0
		beq.s	.norings
		movea.l	d0,a0
		movem.w	d7/a4,-(sp)
		jsr	(a0)
		movem.w	(sp)+,d7/a4
		
	.norings:
		tst.w	(a4)				; are there objects left to draw?
		beq.w	BuildSprites_NextLevel		; if not, branch
		moveq	#2,d6

BuildSprites_ObjLoop:
		movea.w	(a4,d6.w),a0	; load object ID
		tst.b	(a0)		; if null, branch
		beq.w	BuildSprites_NextObj
		
		andi.b	#$7F,obRender(a0)		; set as not visible
		move.b	obRender(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	BuildSprites_MultiDraw
		andi.w	#$C,d0
		beq.s	BuildSprites_ScreenSpaceObj
		lea	(v_screenposx).w,a1
		
	; check object bounds
		moveq	#0,d0
		move.b	obActWid(a0),d0
		move.w	obX(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	BuildSprites_NextObj	; left edge out of bounds
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	BuildSprites_NextObj	; right edge out of bounds
		addi.w	#128,d3		; VDP sprites start at 128px

		btst	#4,d4		; is assume height flag on?
		beq.s	BuildSprites_ApproxYCheck	; if yes, branch
		moveq	#0,d0
		move.b	obHeight(a0),d0
		move.w	obY(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	BuildSprites_NextObj	; top edge out of bounds
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	BuildSprites_NextObj
		addi.w	#128,d2		; VDP sprites start at 128px
		bra.s	BuildSprites_DrawSprite
; ===========================================================================

BuildSprites_ScreenSpaceObj:
		move.w	$A(a0),d2	; special variable for screen Y
		move.w	obX(a0),d3
		bra.s	BuildSprites_DrawSprite
; ===========================================================================

BuildSprites_ApproxYCheck:
		move.w	obY(a0),d2
		sub.w	4(a1),d2
		addi.w	#128,d2
		andi.w	#$7FF,d2
		cmpi.w	#-32+128,d2
		blo.s	BuildSprites_NextObj
		cmpi.w	#32+128+224,d2
		bhs.s	BuildSprites_NextObj

BuildSprites_DrawSprite:
		move.l	obMap(a0),d1
		beq.s	BuildSprites_NextObj
		movea.l	d1,a1
		moveq	#0,d1
		btst	#5,d4		; is static mappings flag on?
		bne.s	.drawFrame	; if yes, branch
		move.b	obFrame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1	; get mappings frame address
		move.w	(a1)+,d1	; number of sprite pieces
		subq.w	#1,d1
		bmi.s	.setVisible

	.drawFrame:
		bsr.w	BuildSpr_Draw	; write data from sprite pieces to buffer

	.setVisible:
		ori.b	#$80,obRender(a0)	; set object as visible

BuildSprites_NextObj:
		addq.w	#2,d6
		subq.w	#2,(a4)			; number of objects left
		bne.w	BuildSprites_ObjLoop

BuildSprites_NextLevel:
		lea	$80(a4),a4
		dbf	d7,BuildSprites_LevelLoop

		move.b	d5,(v_spritecount).w
		cmpi.b	#80,d5
		beq.s	.spriteLimit
		move.l	#0,(a2)
		rts	
; ===========================================================================

	.spriteLimit:
		move.b	#0,-5(a2)	; set last sprite link
		rts	
; End of function BuildSprites

; ===========================================================================

BuildSprites_MultiDraw:
		move.l	a4,-(sp)
		lea	(v_screenposx).w,a4
		movea.w	obGfx(a0),a3
		movea.l	obMap(a0),a5
		moveq	#0,d0

		; check if object is within X bounds
		move.b	mainspr_width(a0),d0		; load pixel width
		move.w	obX(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	BuildSprites_MultiDraw_NextObj
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.w	BuildSprites_MultiDraw_NextObj
		addi.w	#128,d3

		; check if object is within Y bounds
		btst	#4,d4
		beq.s	.approxY
		moveq	#0,d0
		move.b	mainspr_height(a0),d0		; load pixel height
		move.w	obY(a0),d2
		sub.w	4(a4),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.w	BuildSprites_MultiDraw_NextObj
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.w	BuildSprites_MultiDraw_NextObj
		addi.w	#128,d2
		bra.s	.draw

	.approxY:
		move.w	obY(a0),d2
		sub.w	4(a4),d2
		addi.w	#128,d2
		andi.w	#$7FF,d2
		cmpi.w	#-32+128,d2
		blo.s	BuildSprites_MultiDraw_NextObj
		cmpi.w	#32+128+224,d2
		bhs.s	BuildSprites_MultiDraw_NextObj

	.draw:
		moveq	#0,d1
		move.b	mainspr_mapframe(a0),d1		; get current frame
		beq.s	.nomain
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	.nomain
		move.w	d4,-(sp)
		bsr.w	ChkDrawSprite			; draw the sprite
		move.w	(sp)+,d4

	.nomain:
		ori.b	#$80,obRender(a0)		; set onscreen flag
		lea	sub2_x_pos(a0),a6
		moveq	#0,d0
		move.b	mainspr_childsprites(a0),d0	; get child sprite count
		subq.w	#1,d0				; if there are 0, go to next object
		bmi.s	BuildSprites_MultiDraw_NextObj

	.drawloop:
		swap	d0
		move.w	(a6)+,d3			; get X pos
		sub.w	(a4),d3
		addi.w	#128,d3
		move.w	(a6)+,d2			; get Y pos
		sub.w	4(a4),d2
		addi.w	#128,d2
		andi.w	#$7FF,d2
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1			; get mapping frame
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	.nextSprite
		move.w	d4,-(sp)
		bsr.w	ChkDrawSprite
		move.w	(sp)+,d4

.nextSprite:
		swap	d0
		dbf	d0,.drawloop			; repeat for number of child sprites

BuildSprites_MultiDraw_NextObj:
		movea.l	(sp)+,a4
		bra.w	BuildSprites_NextObj

; ===========================================================================

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSpr_Draw:
		movea.w	obGfx(a0),a3

ChkDrawSprite:
		btst	#0,d4
		bne.s	BuildSpr_FlipX
		btst	#1,d4
		bne.w	BuildSpr_FlipY
; End of function BuildSpr_Draw


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BuildSpr_Normal:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		
		move.b	(a1)+,d0	; get y-offset
		ext.w	d0
		add.w	d2,d0		; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; write sprite size
		addq.b	#1,d5		; increase sprite counter
		move.b	d5,(a2)+	; set as sprite link
		move.w	(a1)+,d0	; get art tile
		add.w	a3,d0		; add art tile offset
		move.w	d0,(a2)+	; write to buffer
		move.w	(a1)+,d0	; get x-offset
		add.w	d3,d0		; add x-position
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d0

	.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_Normal	; process next sprite piece

	.return:
		rts	
; End of function BuildSpr_Normal

; ===========================================================================

BuildSpr_FlipX:
		btst	#1,d4		; is object also y-flipped?
		bne.w	BuildSpr_FlipXY	; if yes, branch

	.loop:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		
		move.b	(a1)+,d0	; y position
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+	
		addq.b	#1,d5		; link
		move.b	d5,(a2)+
		move.w	(a1)+,d0	; get art tile
		add.w	a3,d0
		eori.w	#$800,d0	; toggle flip-x in VDP
		move.w	d0,(a2)+	; write to buffer
		move.w	(a1)+,d0	; get x-offset
		neg.w	d0			; negate it
		move.b	CellOffsets_XFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d0

	.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,.loop		; process next sprite piece

	.return:
		rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
		dc.b   8,  8,  8,  8	; 4
		dc.b $10,$10,$10,$10	; 8
		dc.b $18,$18,$18,$18	; 12
		dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
		dc.b   8,$10,$18,$20	; 16	
; ===========================================================================

BuildSpr_FlipY:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		
		move.b	(a1)+,d0	; get y-offset
		move.b	(a1),d4		; get size
		ext.w	d0
		neg.w	d0		; negate y-offset
		move.b	CellOffsets_YFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0	; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; size
		addq.b	#1,d5
		move.b	d5,(a2)+	; link
		move.w	(a1)+,d0	; get art tile
		add.w	a3,d0
		eori.w	#$1000,d0	; toggle flip-y in VDP
		move.w	d0,(a2)+
		move.w	(a1)+,d0	; x-position
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.writeX
		addq.w	#1,d0

	.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipY	; process next sprite piece

	.return:
		rts	
; ===========================================================================

BuildSpr_FlipXY:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		
		move.b	(a1)+,d0	; calculated flipped y
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	CellOffsets_YFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+
		addq.b	#1,d5		; link
		move.b	d5,(a2)+	; art tile
		move.w	(a1)+,d0	; get art tile
		add.w	a3,d0
		eori.w	#$1800,d0	; toggle flip-x/y in VDP
		move.w	d0,(a2)+
		move.w	(a1)+,d0	; calculate flipped x
		neg.w	d0
		move.b	CellOffsets_XFlip2(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.writeX
		addq.w	#1,d0

	.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipXY	; process next sprite piece

	.return:
		rts	
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
		dc.b   8,  8,  8,  8	; 4
		dc.b $10,$10,$10,$10	; 8
		dc.b $18,$18,$18,$18	; 12
		dc.b $20,$20,$20,$20	; 16
; ===========================================================================