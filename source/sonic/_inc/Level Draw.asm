; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6886:
LoadTilesAsYouMove_BGOnly:
		lea	(VDP_CTRL).l,a5
		lea	(VDP_DATA).l,a6
		lea	(v_bg1_scroll_flags).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(levelLayout+2).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	DrawBGScrollBlock2
; End of function sub_6886

; ---------------------------------------------------------------------------
; Subroutine to	display	correct	tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesAsYouMove:
		lea	(VDP_CTRL).l,a5
		lea	(VDP_DATA).l,a6
		; First, update the background
		lea	(v_bg1_scroll_flags_dup).w,a2	; Scroll block 1 scroll flags
		lea	(v_bgscreenposx_dup).w,a3	; Scroll block 1 X coordinate
		lea	(levelLayout+2).w,a4		; Background layout data
		move.w	#$6000,d2			; VRAM thing for selecting Plane B
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags_dup).w,a2	; Scroll block 2 scroll flags
		lea	(v_bg2screenposx_dup).w,a3	; Scroll block 2 X coordinate
		bsr.w	DrawBGScrollBlock2
		; REV01 added a third scroll block, though, technically,
		; the RAM for it was already there in REV00
		lea	(v_bg3_scroll_flags_dup).w,a2	; Scroll block 3 scroll flags
		lea	(v_bg3screenposx_dup).w,a3	; Scroll block 3 X coordinate
		bsr.w	DrawBGScrollBlock3
		; Then, update the foreground
		lea	(v_fg_scroll_flags_dup).w,a2	; Foreground scroll flags
		lea	(v_screenposx_dup).w,a3		; Foreground X coordinate
		lea	(levelLayout).w,a4		; MJ: Load address of layout
		move.w	#$4000,d2			; VRAM thing for selecting Plane A
		; The FG's update function is inlined here
		tst.b	(a2)
		beq.s	locret_6952	; If there are no flags set, nothing needs updating
		bclr	#0,(a2)
		beq.s	loc_6908
		; Draw new tiles at the top
		moveq	#-16,d4	; Y coordinate. Note that 16 is the size of a block in pixels
		moveq	#-16,d5 ; X coordinate
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4 ; Y coordinate
		moveq	#-16,d5 ; X coordinate
		bsr.w	DrawBlocks_LR

loc_6908:
		bclr	#1,(a2)
		beq.s	loc_6922
		; Draw new tiles at the bottom
		move.w	#224,d4	; Start at bottom of the screen. Since this draws from top to bottom, we don't need 224+16
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6922:
		bclr	#2,(a2)
		beq.s	loc_6938
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB

loc_6938:
		bclr	#3,(a2)
		beq.s	locret_6952
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB

locret_6952:
		rts	
; End of function LoadTilesAsYouMove


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6954:
DrawBGScrollBlock1:
		tst.b	(a2)
		beq.w	locret_69F2
		bclr	#0,(a2)
		beq.s	loc_6972
		; Draw new tiles at the top
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6972:
		bclr	#1,(a2)
		beq.s	loc_698E
		; Draw new tiles at the top
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_698E:
		bclr	#2,(a2)
		beq.s	locj_6D56
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB
locj_6D56:
		bclr	#3,(a2)
		beq.s	locj_6D70
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB
locj_6D70:
		bclr	#4,(a2)
		beq.s	locj_6D88
		; Draw entire row at the top
		moveq	#-16,d4
		moveq	#0,d5
		bsr.w	Calc_VRAM_Pos_2
		moveq	#-16,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3
locj_6D88:
		bclr	#5,(a2)
		beq.s	locret_69F2
		; Draw entire row at the bottom
		move.w	#224,d4
		moveq	#0,d5
		bsr.w	Calc_VRAM_Pos_2
		move.w	#224,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3

locret_69F2:
		rts	
; End of function DrawBGScrollBlock1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Essentially, this draws everything that isn't scroll block 1
; sub_69F4:
DrawBGScrollBlock2:
		tst.b	(a2)
		beq.w	locj_6DF2
		cmpi.b	#id_SBZ,(v_zone).w
		beq.w	Draw_SBz
		bclr	#0,(a2)
		beq.s	locj_6DD2
		; Draw new tiles on the left
		move.w	#224/2,d4	; Draw the bottom half of the screen
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224/2,d4
		moveq	#-16,d5
		moveq	#3-1,d6		; Draw three rows... could this be a repurposed version of the above unused code?
		bsr.w	DrawBlocks_TB_2
locj_6DD2:
		bclr	#1,(a2)
		beq.s	locj_6DF2
		; Draw new tiles on the right
		move.w	#224/2,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224/2,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2
locj_6DF2:
		rts
;===============================================================================
locj_6DF4:
		dc.b $00,$00,$00,$00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04
		dc.b $04,$04,$04,$04,$04,$04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$00						
;===============================================================================
Draw_SBz:
		moveq	#-16,d4
		bclr	#0,(a2)
		bne.s	locj_6E28
		bclr	#1,(a2)
		beq.s	locj_6E72
		move.w	#224,d4
locj_6E28:
		lea	(locj_6DF4+1).l,a0
		move.w	(v_bgscreenposy).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		lea	(locj_6FE4).l,a3
		movea.w	(a3,d0.w),a3
		beq.s	locj_6E5E
		moveq	#-16,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos
		movem.l	(sp)+,d4/d5
		bsr.w	DrawBlocks_LR
		bra.s	locj_6E72
;===============================================================================
locj_6E5E:
		moveq	#0,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos_2
		movem.l	(sp)+,d4/d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3
locj_6E72:
		tst.b	(a2)
		bne.s	locj_6E78
		rts
;===============================================================================			
locj_6E78:
		moveq	#-16,d4
		moveq	#-16,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	locj_6E8C
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#320,d5
locj_6E8C:
		lea	(locj_6DF4).l,a0
		move.w	(v_bgscreenposy).w,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	locj_6FEC						
;===============================================================================

; locj_6EA4:
DrawBGScrollBlock3:
		tst.b	(a2)
		beq.w	locj_6EF0
		cmpi.b	#id_MZ,(v_zone).w
		beq.w	Draw_Mz
		bclr	#0,(a2)
		beq.s	locj_6ED0
		; Draw new tiles on the left
		move.w	#$40,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#$40,d4
		moveq	#-16,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2
locj_6ED0:
		bclr	#1,(a2)
		beq.s	locj_6EF0
		; Draw new tiles on the right
		move.w	#$40,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#$40,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2
locj_6EF0:
		rts
locj_6EF2:
		dc.b $00,$00,$00,$00,$00,$00,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04
		dc.b $04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		dc.b $02,$00
;===============================================================================
Draw_Mz:
		moveq	#-16,d4
		bclr	#0,(a2)
		bne.s	locj_6F66
		bclr	#1,(a2)
		beq.s	locj_6FAE
		move.w	#224,d4
locj_6F66:
		lea	(locj_6EF2+1).l,a0
		move.w	(v_bgscreenposy).w,d0
		subi.w	#$200,d0
		add.w	d4,d0
		andi.w	#$7F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	locj_6FE4(pc,d0.w),a3
		beq.s	locj_6F9A
		moveq	#-16,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos
		movem.l	(sp)+,d4/d5
		bsr.w	DrawBlocks_LR
		bra.s	locj_6FAE
;===============================================================================
locj_6F9A:
		moveq	#0,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos_2
		movem.l	(sp)+,d4/d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3
locj_6FAE:
		tst.b	(a2)
		bne.s	locj_6FB4
		rts
;===============================================================================			
locj_6FB4:
		moveq	#-16,d4
		moveq	#-16,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	locj_6FC8
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#320,d5
locj_6FC8:
		lea	(locj_6EF2).l,a0
		move.w	(v_bgscreenposy).w,d0
		subi.w	#$200,d0
		andi.w	#$7F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	locj_6FEC
;===============================================================================			
locj_6FE4:
		dc.w v_bgscreenposx_dup, v_bgscreenposx_dup, v_bg2screenposx_dup, v_bg3screenposx_dup
locj_6FEC:
		moveq	#((224+16+16)/16)-1,d6
		move.l	#$800000,d7
locj_6FF4:			
		moveq	#0,d0
		move.b	(a0)+,d0
		btst	d0,(a2)
		beq.s	locj_701C
		movea.w	locj_6FE4(pc,d0.w),a3
		movem.l	d4/d5/a0,-(sp)
		movem.l	d4/d5,-(sp)
		bsr.w	GetBlockData
		movem.l	(sp)+,d4/d5
		bsr.w	Calc_VRAM_Pos
		bsr.w	DrawBlock
		movem.l	(sp)+,d4/d5/a0
locj_701C:
		addi.w	#16,d4
		dbf	d6,locj_6FF4
		clr.b	(a2)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down
; DrawTiles_LR:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6	; Draw the entire width of the screen + two extra columns
; DrawTiles_LR_2:
DrawBlocks_LR_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1		; Two tiles ahead
		andi.b	#$7F,d1		; Wrap around row
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts
; End of function DrawBlocks_LR

; DrawTiles_LR_3:
DrawBlocks_LR_3:
		move.l	#$800000,d7
		move.l	d0,d1

	.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData_2
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5
		dbf	d6,.loop
		rts	
; End of function DrawBlocks_LR_3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right
; DrawTiles_TB:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6	; Draw the entire height of the screen + two extra rows
; DrawTiles_TB_2:
DrawBlocks_TB_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	.loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addi.w	#$100,d1	; Two rows ahead
		andi.w	#$FFF,d1	; Wrap around plane
		movem.l	(sp)+,d4-d5
		addi.w	#16,d4		; Move X coordinate one block ahead
		dbf	d6,.loop
		rts	
; End of function DrawBlocks_TB_2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Draws a block's worth of tiles
; Parameters:
; a0 = Pointer to block metadata (block index and X/Y flip)
; a1 = Pointer to block
; a5 = Pointer to VDP command port
; a6 = Pointer to VDP data port
; d0 = VRAM command to access plane
; d2 = VRAM plane A/B specifier
; d7 = Plane row delta
; DrawTiles:
DrawBlock:
		or.w	d2,d0	; OR in that plane A/B specifier to the VRAM command
		swap	d0
		btst	#3,(a0)	; Check Y-flip bit	; MJ: checking bit 3 not 4 (Flip)
		bne.s	DrawFlipY
		btst	#2,(a0)	; Check X-flip bit	; MJ: checking bit 2 not 3 (Flip)
		bne.s	DrawFlipX
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipX:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4	; Invert X-flip bits of each tile
		swap	d4		; Swap the tiles around
		move.l	d4,(a6)		; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)		; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipY:
		btst	#2,(a0)		; MJ: checking bit 2 not 3 (Flip)
		bne.s	DrawFlipXY
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts	
; ===========================================================================

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts	
; End of function DrawBlocks


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Gets address of block at a certain coordinate
; Parameters:
; a4 = Pointer to level layout
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns:
; a0 = Address of block metadata
; a1 = Address of block
; DrawBlocks:
GetBlockData:
		add.w	(a3),d5			; X offset
GetBlockData_2:
		add.w	4(a3),d4		; Y offset
		lea	(v_16x16).w,a1		; Block data
		
		move.w	d4,d3			; Get row address
		lsr.w	#5,d3
		andi.w	#$3C,d3
		movea.w	(a4,d3.w),a0
		
		lsr.w	#3,d5			; Chunk X offset
		move.w	d5,d0
		lsr.w	#4,d0			; Layout X offset
		
		moveq	#0,d3			; Get block address
		move.b	(a0,d0.w),d3
		add.w	d3,d3
		move.w	ChunkDrawAddrs(pc,d3.w),d3
		andi.w	#$70,d4
		andi.w	#$E,d5
		add.w	d4,d3
		add.w	d5,d3
		add.l	v_levelchunks.w,d3	; Add base chunk data address
		
		movea.l	d3,a0			; Get block
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_6C1E:
		rts	
; End of function GetBlockData

; ---------------------------------------------------------------------------

ChunkDrawAddrs:
	dc.w     0,  $80, $100, $180, $200, $280, $300, $380, $400, $480, $500, $580, $600, $680, $700, $780
	dc.w  $800, $880, $900, $980, $A00, $A80, $B00, $B80, $C00, $C80, $D00, $D80, $E00, $E80, $F00, $F80
	dc.w $1000,$1080,$1100,$1180,$1200,$1280,$1300,$1380,$1400,$1480,$1500,$1580,$1600,$1680,$1700,$1780
	dc.w $1800,$1880,$1900,$1980,$1A00,$1A80,$1B00,$1B80,$1C00,$1C80,$1D00,$1D80,$1E00,$1E80,$1F00,$1F80
	dc.w $2000,$2080,$2100,$2180,$2200,$2280,$2300,$2380,$2400,$2480,$2500,$2580,$2600,$2680,$2700,$2780
	dc.w $2800,$2880,$2900,$2980,$2A00,$2A80,$2B00,$2B80,$2C00,$2C80,$2D00,$2D80,$2E00,$2E80,$2F00,$2F80
	dc.w $3000,$3080,$3100,$3180,$3200,$3280,$3300,$3380,$3400,$3480,$3500,$3580,$3600,$3680,$3700,$3780
	dc.w $3800,$3880,$3900,$3980,$3A00,$3A80,$3B00,$3B80,$3C00,$3C80,$3D00,$3D80,$3E00,$3E80,$3F00,$3F80
	dc.w $4000,$4080,$4100,$4180,$4200,$4280,$4300,$4380,$4400,$4480,$4500,$4580,$4600,$4680,$4700,$4780
	dc.w $4800,$4880,$4900,$4980,$4A00,$4A80,$4B00,$4B80,$4C00,$4C80,$4D00,$4D80,$4E00,$4E80,$4F00,$4F80
	dc.w $5000,$5080,$5100,$5180,$5200,$5280,$5300,$5380,$5400,$5480,$5500,$5580,$5600,$5680,$5700,$5780
	dc.w $5800,$5880,$5900,$5980,$5A00,$5A80,$5B00,$5B80,$5C00,$5C80,$5D00,$5D80,$5E00,$5E80,$5F00,$5F80
	dc.w $6000,$6080,$6100,$6180,$6200,$6280,$6300,$6380,$6400,$6480,$6500,$6580,$6600,$6680,$6700,$6780
	dc.w $6800,$6880,$6900,$6980,$6A00,$6A80,$6B00,$6B80,$6C00,$6C80,$6D00,$6D80,$6E00,$6E80,$6F00,$6F80
	dc.w $7000,$7080,$7100,$7180,$7200,$7280,$7300,$7380,$7400,$7480,$7500,$7580,$7600,$7680,$7700,$7780
	dc.w $7800,$7880,$7900,$7980,$7A00,$7A80,$7B00,$7B80,$7C00,$7C80,$7D00,$7D80,$7E00,$7E80,$7F00,$7F80


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Produces a VRAM plane access command from coordinates
; Parameters:
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns VDP command in d0
Calc_VRAM_Pos:
		add.w	(a3),d5
Calc_VRAM_Pos_2:
		add.w	4(a3),d4
		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0	; Highest bits of plane VRAM address
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(VDP_CTRL).l,a5
		lea	(VDP_DATA).l,a6
		lea	(v_screenposx).w,a3
		lea	(levelLayout).w,a4	; MJ: Load address of layout
		move.w	#$4000,d2
		bsr.s	DrawChunks
		lea	(v_bgscreenposx).w,a3
		lea	(levelLayout+2).w,a4	; MJ: Load address of layout BG
		move.w	#$6000,d2
		tst.b	(v_zone).w
		beq.w	Draw_GHz_Bg
		cmpi.b	#id_MZ,(v_zone).w
		beq.w	Draw_Mz_Bg
		cmpi.w	#(id_SBZ<<8)+0,(v_zone).w
		beq.w	Draw_SBz_Bg
		cmpi.b	#id_EndZ,(v_zone).w
		beq.w	Draw_GHz_Bg
; End of function LoadTilesFromStart


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DrawChunks:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6

	.loop:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,.loop
		rts	
; End of function DrawChunks

Draw_GHz_Bg:
		moveq	#0,d4
		moveq	#((224+16+16)/16)-1,d6
locj_7224:			
		movem.l	d4-d6,-(sp)
		lea	(locj_724a),a0
		move.w	(v_bgscreenposy).w,d0
		add.w	d4,d0
		andi.w	#$F0,d0
		bsr.w	locj_72Ba
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,locj_7224
		rts
locj_724a:
		dc.b $00,$00,$00,$00,$06,$06,$06,$04,$04,$04,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------------------------------
Draw_Mz_Bg:;locj_725a:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6
locj_725E:			
		movem.l	d4-d6,-(sp)
		lea	(locj_6EF2+1),a0
		move.w	(v_bgscreenposy).w,d0
		subi.w	#$200,d0
		add.w	d4,d0
		andi.w	#$7F0,d0
		bsr.w	locj_72Ba
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,locj_725E
		rts
;-------------------------------------------------------------------------------
Draw_SBz_Bg:;locj_7288:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6
locj_728C:			
		movem.l	d4-d6,-(sp)
		lea	(locj_6DF4+1),a0
		move.w	(v_bgscreenposy).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		bsr.w	locj_72Ba
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,locj_728C
		rts
;-------------------------------------------------------------------------------
locj_72B2:
		dc.w v_bgscreenposx, v_bgscreenposx, v_bg2screenposx, v_bg3screenposx
locj_72Ba:
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	locj_72B2(pc,d0.w),a3
		beq.s	locj_72da
		moveq	#-16,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos
		movem.l	(sp)+,d4/d5
		bsr.w	DrawBlocks_LR
		bra.s	locj_72EE
locj_72da:
		moveq	#0,d5
		movem.l	d4/d5,-(sp)
		bsr.w	Calc_VRAM_Pos_2
		movem.l	(sp)+,d4/d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_3
locj_72EE:
		rts