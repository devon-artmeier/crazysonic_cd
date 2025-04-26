; -------------------------------------------------------------------------
; Person object
; -------------------------------------------------------------------------

oCustDestX		EQU	oVar30
oCustDestY		EQU	oVar34

; -------------------------------------------------------------------------

ObjPerson:
	lea	ObjPerson_Main(pc),a1
	move.b	oSubtype(a0),d0
	bpl.s	.SetTile
	lea	ObjCustomer_Main(pc),a1

.SetTile:
	move.l	a1,oAddr(a0)

	andi.w	#$7F,d0
	add.w	d0,d0
	move.w	.TileIDs(pc,d0.w),oTile(a0)
	move.l	#Map_Person,oMap(a0)
	move.w	playerObject+oZ,oZ(a0)

	jmp	(a1)
	
; -------------------------------------------------------------------------

.TileIDs:
	; Regular people
	dc.w	$6000|(VRAM_PERSON_1/$20)
	dc.w	$6000|(VRAM_PERSON_2/$20)
	dc.w	$6000|(VRAM_PERSON_3/$20)
	; Customers
	dc.w	$6000|(VRAM_PERSON_1/$20)
	dc.w	$6000|(VRAM_PERSON_2/$20)
	dc.w	$6000|(VRAM_PERSON_3/$20)
	dc.w	$6000|(VRAM_PERSON_1/$20)
	
; -------------------------------------------------------------------------

ObjCustomer_Main:
	cmpa.l	curCustomer,a0				; Check if current customer
	bne.w	ObjCustomer_End
	
	bsr.w	CheckRunOver
	cmpi.l	#ObjRunOver,oAddr(a0)
	bne.s	.NoRunOver
	
	moveq	#4,d0
	jsr	PlayPCM

	move.b	#1,gameOverSub
	bset	#6,oFlags(a6)
	clr.l	arrowObject
	clr.l	destArrowObject
	bra.s	ObjPerson_Draw

.NoRunOver:
	bsr.w	CheckCustomerArea			; Check pick up area
	bcs.s	ObjPerson_Draw

	bset	#7,oFlags(a6)				; Lock controls
	bset	#2,arrowObject+oFlags			; Hide arrow
	move.l	#ObjCustomer_Board,oAddr(a0)		; Start boarding
	st	timerPaused				; Pause timer

	move.w	oX(a6),oCustDestX(a0)
	move.w	oY(a6),oCustDestY(a0)

	move.l	a0,d0					; Point to destination
	subi.l	#customerObjects,d0
	addi.l	#destObject0,d0
	move.l	d0,curDestination
	bra.s	ObjPerson_Draw

; -------------------------------------------------------------------------

ObjPerson_Main:
	bsr.w	CheckRunOver
	cmpi.l	#ObjRunOver,oAddr(a0)
	bne.s	ObjPerson_Draw
	
	moveq	#4,d0
	jsr	PlayPCM

ObjPerson_Draw:
	lea	ObjPerson_Frames(pc),a1
	bra.w	DrawObject3D

ObjCustomer_End:
	rts

; -------------------------------------------------------------------------

ObjPerson_Frames:
	dc.b	0, 0, 0, 0
	dc.b	1, 1
	dc.b	2, 2, 2
	dc.b	3, 3, 3, 3
	dc.b	4, 4, 4, 4
	dc.b	5, 5, 5, 5
	dc.b	6, 6, 6, 6
	dc.b	7, 7, 7, 7
	dc.b	8, 8, 8, 8
	dc.b	9, 9, 9, 9
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A
	even

; -------------------------------------------------------------------------

ObjCustomer_Board:
	bsr.w	ObjPerson_MoveToDest	

	bsr.w	CheckBusCollision
	bcs.s	.NotBoarded

	lea	playerObject,a6
	
	bclr	#7,oFlags(a6)				; Unlock controls
	bclr	#2,arrowObject+oFlags			; Show arrow
	move.l	#ObjCustomer_Bus,oAddr(a0)		; Boarded
	move.b	#5,timerInc				; Increment timer
	clr.b	timerPaused				; Unpause timer

.NotBoarded:
	bra.w	ObjPerson_Draw

; -------------------------------------------------------------------------

ObjCustomer_Bus:
	lea	playerObject,a6
	move.w	oX(a6),oX(a0)
	move.w	oY(a6),oY(a0)
	rts
	
; -------------------------------------------------------------------------

ObjCustomer_GetOff:
	lea	oCustDestX-oX(a0),a6			; <-- LOVELY HACK!
	moveq	#8,d2
	moveq	#8,d3
	bsr.w	CheckCollision
	bcc.s	.Out

	cmpi.w	#-64,oSprX(a0)
	blt.s	.Out
	cmpi.w	#256+64,oSprX(a0)
	bge.s	.Out
	cmpi.w	#-64,oSprY(a0)
	blt.s	.Out
	cmpi.w	#224+64,oSprY(a0)
	bge.s	.Out

	bsr.w	ObjPerson_MoveToDest
	bra.w	ObjPerson_Draw

.Out:
	clr.l	oAddr(a0)				; Disappear into the void, ooooOOoooOOOoohhhh
	
	subq.b	#1,customerCount			; Decrement customer count
	bpl.s	.Next
	move.b	#2,gameOverSub				; Game done
	clr.l	arrowObject
	clr.l	destArrowObject
	bra.w	ObjPerson_Draw

.Next:
	move.l	a0,d0					; Next customer
	addi.l	#oSize,d0
	move.l	d0,curCustomer
	move.l	d0,curDestination

	bclr	#7,playerObject+oFlags			; Unlock controls
	bclr	#2,arrowObject+oFlags			; Show arrow
	clr.b	timerPaused				; Unpause timer
	bra.w	ObjPerson_Draw

; -------------------------------------------------------------------------
; Move to destination
; -------------------------------------------------------------------------

ObjPerson_MoveToDest:
	move.w	oCustDestX(a0),d4
	move.w	oCustDestY(a0),d5
	move.w	oX(a0),d0
	move.w	oY(a0),d1
	bsr.w	GetAngle
	
	move.w	#($300*FPS_SRC)/FPS_DEST,d3
	bsr.w	GetTrajectory

	sub.l	d0,oX(a0)
	sub.l	d1,oY(a0)
	rts

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Map_Person:
	include	"src/special/objects/person_mappings.asm"
	even
	
; -------------------------------------------------------------------------
