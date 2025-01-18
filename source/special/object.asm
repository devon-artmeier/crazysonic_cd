; -------------------------------------------------------------------------
; Initialize Z buffer
; -------------------------------------------------------------------------

InitZBuffer:
	lea	zBuffer,a6			; Get Z buffer
	moveq	#0,d5				; Fill with 0
	moveq	#ZBUF_SLOTS*2,d6			; Number of slots per level
	moveq	#ZBUF_LEVELS-1,d7		; Number of levels

.Clear:
	move.w	d5,(a6)				; Reset level
	adda.w	d6,a6				; Next level
	dbf	d7,.Clear			; Loop until Z buffer is initialized
	rts

; -------------------------------------------------------------------------
; Set an object for drawing in a 3D space
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to object slot
; -------------------------------------------------------------------------

Set3DObjectDraw:
	lea	playerObject,a6			; Get angle from player
	move.w	oX(a6),d4
	move.w	oY(a6),d5
	move.w	oX(a0),d0
	move.w	oY(a0),d1
	bsr.w	GetAngle

	move.w	oX(a6),d5			; Get distance from player
	move.w	oY(a6),d6
	move.w	oX(a0),d3
	move.w	oY(a0),d4
	bsr.w	GetDistance

	move.l	d0,-(sp)			; Save d0

	cmpi.l	#ZBUF_LEVELS*$40,d0		; Is the Z buffer level too high?
	bcs.s	.GotLevel			; If not, branch
	move.l	#(ZBUF_LEVELS*$40)-1,d0		; If so, cap it

.GotLevel:
	lsr.w	#2,d0				; Get proper Z buffer level
	andi.w	#$3F0,d0

	lea	zBuffer,a6			; Get Z buffer level
	lea	(a6,d0.w),a6

	move.w	d7,-(sp)
	moveq	#ZBUF_SLOTS-1-1,d7		; Start searching for free slot

.FindSlot:
	tst.w	(a6)+				; Is this slot free?
	beq.s	.Set				; If so, branch
	dbf	d7,.FindSlot			; If not, loop

.Set:
	move.w	(sp)+,d7
	
	move.w	a0,-2(a6)			; Set object in slot
	move.w	#0,(a6)				; Set termination

	move.l	(sp)+,d0			; Restore d0
	rts

; -------------------------------------------------------------------------
; Draw 3D object
; -------------------------------------------------------------------------

DrawObject3D:
	move.l	a1,-(sp)
	bsr.w	Set3DObjectDraw
	movea.l	(sp)+,a1

	cmpi.l	#$500,d0
	bcs.s	.SetFrame
	move.l	#$500,d0

.SetFrame:
	lsr.w	#4,d0
	move.b	(a1,d0.w),oFrame(a0)
	
; -------------------------------------------------------------------------
; Map 3D position to sprite position
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to object slot
; -------------------------------------------------------------------------

Set3DSpritePos:
	lea	playerObject,a5			; Player object
	lea	gfxVars,a6			; Graphics operations variables
	
	move.w	oX(a5),d0			; Get distance from Sonic
	sub.w	oX(a0),d0
	move.w	oY(a5),d1
	sub.w	oY(a0),d1
	
	moveq	#8,d5				; 8 bit shifts
	
	moveq	#0,d2				; Z point
	move.w	gfxFOV(a6),d2
	add.w	gfxCenter(a6),d2
	move.w	gfxYawSin(a6),d3
	muls.w	d0,d3
	asr.l	d5,d3
	sub.l	d3,d2
	move.w	gfxYawCos(a6),d3
	muls.w	d1,d3
	asr.l	d5,d3
	add.l	d3,d2
	bne.s	.NotZero
	moveq	#1,d2

.NotZero:
	; Z point    = (FOV + center) - (X distance * sin(yaw)) + (Y distance * cos(yaw))
	; X position = ((FOV * cos(yaw) * X distance) + (FOV * sin(yaw) * Y distance)) / Z point
	; Y position = (FOV * Z position) / Z point

	move.w	gfxYcFOV(a6),d3			; Set sprite X position
	muls.w	d0,d3
	move.w	gfxYsFOV(a6),d4
	muls.w	d1,d4
	add.l	d4,d3
	divs.w	d2,d3
	addi.w	#128,d3
	move.w	d3,oSprX(a0)
	
	move.w	gfxFOV(a6),d3			; Set sprite Y position
	muls.w	oZ(a0),d3
	asr.l	#3,d3
	divs.w	d2,d3
	addi.w	#128,d3
	move.w	d3,oSprY(a0)
	
	bclr	#2,oFlags(a0)			; Enable drawing

	move.w	oSprX(a0),d0			; Is the object onscreen horizontally?
	cmpi.w	#-128,d0
	blt.s	.OffScreen			; If not, branch
	cmpi.w	#256+128,d0
	bgt.s	.OffScreen			; If not, branch

	move.w	oSprY(a0),d0			; Is the object onscreen vertically?
	cmpi.w	#128,d0
	blt.s	.OffScreen			; If not, branch
	cmpi.w	#320,d0
	blt.s	.End				; If not, branch

.OffScreen:
	bset	#2,oFlags(a0)			; Disable drawing

.End:
	rts

; -------------------------------------------------------------------------
; Draw 3D objects
; -------------------------------------------------------------------------

Draw3DObjects:
	move.l	#zBuffer,d4			; Get Z buffer
	move.l	#PRG_START+$30000,d5		; Use data from 3D sprite mappings section
	moveq	#ZBUF_SLOTS*2,d6		; Number of slots per level
	moveq	#ZBUF_LEVELS-1,d7		; Number of levels

.Draw:
	movea.l	d4,a6				; Draw objects in Z buffer level
	bsr.s	DrawZBufObjLevel
	add.l	d6,d4				; Next level
	dbf	d7,.Draw			; Loop until objects are drawn
	rts

; -------------------------------------------------------------------------
; Draw objects in Z buffer level
; -------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Pointer to Z buffer level
; -------------------------------------------------------------------------

DrawZBufObjLevel:
	rept	ZBUF_SLOTS
		bsr.s	Draw3DObject
	endr
	rts

; -------------------------------------------------------------------------
; Draw 3D object queued in Z buffer
; -------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Pointer to Z buffer slot
; -------------------------------------------------------------------------

Draw3DObject:
	move.w	(a6)+,d5			; Is this slot occupied?
	beq.s	.NoObject			; If not, branch

	movea.l	d5,a0				; Draw object
	movem.l	d4-d7,-(sp)
	bsr.w	DrawObject
	movem.l	(sp)+,d4-d7
	rts

.NoObject:
	move.l	(sp)+,d0			; Force out of Z buffer level
	rts

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
	
	bsr.s	DrawObject_Normal
	
	move.b	d5,spriteCount
	move.l	a2,curSpriteSlot
	
.End:
	rts

; -------------------------------------------------------------------------
		
.Draw:
	btst	#0,d4
	bne.s	DrawObject_FlipX
	btst	#1,d4
	bne.w	DrawObject_FlipY

; -------------------------------------------------------------------------

DrawObject_Normal:
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
	dbf	d1,DrawObject_Normal	; process next sprite piece
	
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

DrawObject_FlipX:
	btst	#1,d4			; is object also y-flipped?
	bne.w	DrawObject_FlipXY	; if yes, branch
	
.loop:
	cmpi.b	#$40,d5		; check sprite limit
	beq.s	.return
	
	move.b	(a1)+,d0	; y position
	ext.w	d0
	add.w	d2,d0
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.skipSprite	; If so, branch
	cmpi.w	#224+128,d0
	bge.s	.skipSprite	; If so, branch
	
	move.w	d0,(a2)+
	move.b	(a1)+,d4	; size
	move.b	d4,(a2)+	
	addq.b	#1,d5		; link
	move.b	d5,(a2)+
	move.b	(a1)+,-(sp)	; get art tile
	move.w	(sp)+,d0
	move.b	(a1)+,d0	
	add.w	d6,d0
	eori.w	#$800,d0	; toggle flip-x in VDP
	move.w	d0,(a2)+	; write to buffer
	
	move.b	(a1)+,d0	; get x-offset
	ext.w	d0
	neg.w	d0			; negate it
	add.b	d4,d4		; calculate flipped position by size
	andi.w	#$18,d4
	addq.w	#8,d4
	sub.w	d4,d0
	add.w	d3,d0
	
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
	dbf	d1,.loop		; process next sprite piece
	
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

DrawObject_FlipY:
	cmpi.b	#$40,d5		; check sprite limit
	beq.s	.return
	move.b	(a1)+,d0	; get y-offset
	move.b	(a1),d4		; get size
	ext.w	d0
	neg.w	d0		; negate y-offset
	lsl.b	#3,d4	; calculate flip offset
	andi.w	#$18,d4
	addq.w	#8,d4
	sub.w	d4,d0
	add.w	d2,d0	; add y-position
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.skipSprite	; If so, branch
	cmpi.w	#256+128,d0
	bge.s	.skipSprite	; If so, branch
	
	move.w	d0,(a2)+	; write to buffer
	move.b	(a1)+,(a2)+	; size
	addq.b	#1,d5
	move.b	d5,(a2)+	; link
	move.b	(a1)+,-(sp)	; get art tile
	move.w	(sp)+,d0
	move.b	(a1)+,d0
	add.w	d6,d0
	eori.w	#$1000,d0	; toggle flip-y in VDP
	move.w	d0,(a2)+
	
	move.b	(a1)+,d0	; x-position
	ext.w	d0
	add.w	d3,d0
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.undo		; If so, branch
	cmpi.w	#256+128,d0
	bge.s	.undo		; If so, branch
	
	andi.w	#$1FF,d0
	bne.s	.writeX
	addq.w	#1,d0
	
.writeX:
	move.w	d0,(a2)+	; write to buffer

.next:
	dbf	d1,DrawObject_FlipY	; process next sprite piece
	
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

DrawObject_FlipXY:
	cmpi.b	#$40,d5		; check sprite limit
	beq.s	.return
	
	move.b	(a1)+,d0	; calculated flipped y
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	lsl.b	#3,d4
	andi.w	#$18,d4
	addq.w	#8,d4
	sub.w	d4,d0
	add.w	d2,d0
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.skipSprite	; If so, branch
	cmpi.w	#224+128,d0
	bge.s	.skipSprite	; If so, branch
	
	move.w	d0,(a2)+	; write to buffer
	move.b	(a1)+,d4	; size
	move.b	d4,(a2)+	; link
	addq.b	#1,d5
	move.b	d5,(a2)+	; art tile
	move.b	(a1)+,-(sp)	; get art tile
	move.w	(sp)+,d0
	move.b	(a1)+,d0
	add.w	d6,d0
	eori.w	#$1800,d0	; toggle flip-x/y in VDP
	move.w	d0,(a2)+
	
	move.b	(a1)+,d0	; calculate flipped x
	ext.w	d0
	neg.w	d0
	add.b	d4,d4
	andi.w	#$18,d4
	addq.w	#8,d4
	sub.w	d4,d0
	add.w	d3,d0
	
	cmpi.w	#-32+128,d0	; Is it offscreen?
	ble.s	.undo		; If so, branch
	cmpi.w	#256+128,d0
	bge.s	.undo		; If so, branch
	
	andi.w	#$1FF,d0
	bne.s	.writeX
	addq.w	#1,d0
	
.writeX:
	move.w	d0,(a2)+	; write to buffer

.next:
	dbf	d1,DrawObject_FlipXY	; process next sprite piece
	
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
; Run objects
; -------------------------------------------------------------------------

RunObjects:
	lea	objects,a0
	move.w	#(objectsEnd-objects)/oSize-1,d7
	
.Run:
	move.l	oAddr(a0),d0
	beq.s	.Next
	movea.l	d0,a1
	jsr	(a1)
	
.Next:
	lea	oSize(a0),a0
	dbf	d7,.Run
	rts
	
; -------------------------------------------------------------------------
; Check run over
; -------------------------------------------------------------------------

CheckRunOver:
	bsr.w	CheckBusCollision
	bcs.s	.End
	move.l	#ObjRunOver,oAddr(a0)

	jsr	Random
	andi.l	#$1FFFFF,d0
	subi.l	#$100000,d0
	move.l	d0,oXVel(a0)

	move.w	oPlayerMove(a6),d0
	bmi.s	.SetYVel
	neg.w	d0

.SetYVel:
	ext.l	d0
	asl.l	#8,d0
	move.l	d0,oYVel(a0)

.End:
	rts
	
; -------------------------------------------------------------------------

ObjRunOver:
	move.l	oXVel(a0),d0
	add.l	d0,oSprX(a0)
	move.l	oYVel(a0),d0
	add.l	d0,oSprY(a0)
	addi.l	#($20000*FPS_SRC)/FPS_DEST,oYVel(a0)

	cmpi.w	#-32,oSprX(a0)
	blt.s	.Delete
	cmpi.w	#256+32,oSprX(a0)
	bge.s	.Delete
	cmpi.w	#-8,oSprY(a0)
	blt.s	.Delete
	cmpi.w	#224+32,oSprY(a0)
	bge.s	.Delete

	bra.w	DrawObject

.Delete:
	clr.l	oAddr(a0)
	rts

; -------------------------------------------------------------------------
; Check collision with bus
; -------------------------------------------------------------------------

CheckBusCollision:
	lea	playerObject,a6		; Player object

	moveq	#24,d2			; Size of bus
	moveq	#24,d3

CheckCollision:
	move.w	oX(a6),d0		; Player X2
	add.w	d2,d0
	cmp.w	oX(a0),d0
	blt.s	.NoCollision

	add.w	d2,d2			; Player X1
	sub.w	d2,d0
	cmp.w	oX(a0),d0
	bgt.s	.NoCollision

	move.w	oY(a6),d0		; Player Y2
	add.w	d3,d0
	cmp.w	oY(a0),d0
	blt.s	.NoCollision

	add.w	d3,d3			; Player Y1
	sub.w	d3,d0
	cmp.w	oY(a0),d0
	bgt.s	.NoCollision

	andi.b	#~1,ccr
	rts

.NoCollision:
	ori.b	#1,ccr
	rts
	
; -------------------------------------------------------------------------
; Update objects
; -------------------------------------------------------------------------

UpdateObjects:
	move.l	#sprites,curSpriteSlot				; Initialize sprite drawing
	clr.l	sprites
	clr.b	spriteCount
	bsr.w	Init3DSpritePos
	bsr.w	InitZBuffer
	
	bsr.w	RunObjects					; Run objects
	bsr.w	Draw3DObjects					; Draw 3D objects
	
	movea.l	curSpriteSlot,a0				; Have any sprites been draw?
	tst.b	spriteCount					; Is the sprite buffer full?
	beq.s	.End						; If so, branch
	clr.b	-5(a0)						; Set last sprite

.End:
	rts
	
; -------------------------------------------------------------------------
; Load object map
; -------------------------------------------------------------------------

LoadObjectMap:
	lea	playerObject,a0					; Spawn bus
	move.l	#ObjBus,oAddr(a0)
	move.w	#$8A0,oX(a0)
	move.w	#$740,oY(a0)
	move.w	#$160,oZ(a0)
	move.w	#$80,oPlayerPitch(a0)
	move.w	#$100,oPlayerYaw(a0)

	move.l	#ObjArrow,arrowObject				; Spawn arrow
	move.l	#ObjArrow,destArrowObject			; Spawn 3D arrow
	st	destArrowObject+oSubtype

	lea	ObjectMap(pc),a0				; Object map
	lea	mapObjects,a1					; Map objects
	lea	customerObjects,a2				; Customer objects
	lea	destObjects,a3					; Destination objects

.Load:
	move.w	(a0)+,d0					; Get type
	bmi.s	.End						; Branch if done

	move.w	(a0)+,d1					; Get position
	move.w	(a0)+,d2

	move.w	d0,d3						; Load type
	add.w	d3,d3
	add.w	d3,d3
	jsr	.LoadTypes(pc,d3.w)

	bra.s	.Load						; Loop

.End:
	move.l	#customerObject0,curCustomer			; Set up for pickup
	move.l	curCustomer,curDestination
	move.b	COMM_CMD_6.w,customerCount

	bra.w	UpdateObjects					; Initialize objects
	
; -------------------------------------------------------------------------

.LoadTypes
	bra.w	.Person
	bra.w	.Person
	bra.w	.Person
	rts
	nop
	rts
	nop
	rts
	nop
	bra.w	.Sign
	bra.w	.Tree
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Destination
	bra.w	.Customer
	bra.w	.Customer
	bra.w	.Customer
	bra.w	.Customer
	bra.w	.Customer
	bra.w	.Customer
	bra.w	.Customer
	
; -------------------------------------------------------------------------

.Person:
	move.l	#ObjPerson,oAddr(a1)				; Load person
	move.b	d0,oSubtype(a1)

.SetMapObject:
	move.w	d1,oX(a1)					; Set position
	move.w	d2,oY(a1)
	lea	oSize(a1),a1
	rts
	
; -------------------------------------------------------------------------

.Destination:
	subq.w	#8,d0						; Load desination
	lsl.w	#6,d0

	move.l	#ObjDestination,oAddr(a3,d0.w)
	move.w	d1,oX(a3,d0.w)
	move.w	d2,oY(a3,d0.w)
	rts

; -------------------------------------------------------------------------

.Customer:
	subi.w	#15,d0						; Load customer
	move.w	d0,d3
	lsl.w	#6,d3
	bset	#7,d0

	move.l	#ObjPerson,oAddr(a2,d3.w)
	move.b	d0,oSubtype(a2,d3.w)
	move.w	d1,oX(a2,d3.w)
	move.w	d2,oY(a2,d3.w)
	rts

; -------------------------------------------------------------------------

.Sign:
	move.l	#ObjSign,oAddr(a1)				; Load sign
	bra.s	.SetMapObject

; -------------------------------------------------------------------------

.Tree:
	move.l	#ObjTree,oAddr(a1)				; Load tree
	bra.s	.SetMapObject

; -------------------------------------------------------------------------
; Check if in customer area (drop off/pick up)
; -------------------------------------------------------------------------

AREA_RANGE	EQU	192

; -------------------------------------------------------------------------

CheckCustomerArea:
	lea	playerObject,a6					; Check if in range

	tst.b	gameOverSub
	bne.s	.End

	move.w	#AREA_RANGE,d2
	move.w	oX(a0),d0
	add.w	d2,d0
	cmp.w	oX(a6),d0
	blt.s	.End

	add.w	d2,d2
	sub.w	d2,d0
	cmp.w	oX(a6),d0
	bgt.s	.End

	move.w	#AREA_RANGE,d2
	move.w	oY(a0),d0
	add.w	d2,d0
	cmp.w	oY(a6),d0
	blt.s	.End

	add.w	d2,d2
	sub.w	d2,d0
	cmp.w	oY(a6),d0
	bgt.s	.End

	tst.w	oPlayerMove(a6)					; Wait til stopped
	bne.s	.End
	tst.l	oPlayerTurn(a6)
	bne.s	.End
	
	andi	#~1,ccr
	rts

.End:
	ori	#1,ccr
	rts

; -------------------------------------------------------------------------
