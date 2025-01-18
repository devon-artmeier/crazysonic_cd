; -------------------------------------------------------------------------
; Draw object
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to object slot
; -------------------------------------------------------------------------

DrawObject:
	btst	#2,oFlags(a0)
	bne.s	.End
	
	movea.l	oMap(a0),a1
	moveq	#0,d1
	move.b	oFrame(a0),d1
	add.b	d1,d1
	adda.w	(a1,d1.w),a1
	move.b	(a1)+,d1
	subq.b	#1,d1
	bmi.s	.End
	
	movea.l	curSpriteSlot,a2
	move.w	oSprY(a0),d2
	move.w	oSprX(a0),d3
	addi.w	#128,d2
	addi.w	#128,d3
	move.b	oFlags(a0),d4
	move.b	spriteCount,d5
	move.w	oTile(a0),d6
	
	bsr.s	.Draw
	
	move.b	d5,spriteCount
	move.l	a2,curSpriteSlot
	
.End:
	rts

; -------------------------------------------------------------------------
		
.Draw:
	cmpi.b	#$40,d5		; check sprite limit
	beq.s	.return
	
	move.b	(a1)+,d0	; get y-offset
	ext.w	d0
	add.w	d2,d0		; add y-position
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.skipSprite	; If so, branch
	cmpi.w	#224+128,d0
	bge.s	.skipSprite	; If so, branch
	
	move.w	d0,(a2)+	; write to buffer
	move.b	(a1)+,(a2)+	; write sprite size
	addq.b	#1,d5		; increase sprite counter
	move.b	d5,(a2)+	; set as sprite link
	move.b	(a1)+,-(sp)	; get art tile
	move.w	(sp)+,d0
	move.b	(a1)+,d0
	add.w	d6,d0		; add art tile offset
	move.w	d0,(a2)+	; write to buffer
	
	move.b	(a1)+,d0	; get x-offset
	ext.w	d0
	add.w	d3,d0		; add x-position
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.undo		; If so, branch
	cmpi.w	#256+128,d0
	bge.s	.undo		; If so, branch
	
	andi.w	#$1FF,d0	; keep within 512px
	bne.s	.writeX
	addq.w	#1,d0
	
.writeX:
	move.w	d0,(a2)+	; write to buffer

.next:
	dbf	d1,.Draw	; process next sprite piece
	
.return:
	rts	
	
.skipSprite:
	addq.w	#4,a1
	bra.s	.next
	
.undo:
	subq.w	#6,a2
	subq.b	#1,d5
	bra.s	.next

; -------------------------------------------------------------------------
; Update objects
; -------------------------------------------------------------------------

UpdateObjects:
	move.l	#sprites,curSpriteSlot				; Initialize sprite drawing
	clr.l	sprites
	clr.b	spriteCount
	
	lea	playerObject,a0					; Run bus object
	movea.l	oAddr(a0),a1
	jsr	(a1)
	
	movea.l	curSpriteSlot,a0				; Have any sprites been draw?
	tst.b	spriteCount					; Is the sprite buffer full?
	beq.s	.End						; If so, branch
	clr.b	-5(a0)						; Set last sprite

.End:
	rts

; -------------------------------------------------------------------------
