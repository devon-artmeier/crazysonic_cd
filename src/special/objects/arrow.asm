; -------------------------------------------------------------------------
; Arrow object
; -------------------------------------------------------------------------

oArrowZ		EQU	oVar30

; -------------------------------------------------------------------------

ObjArrow:
	lea	ObjArrow_Main(pc),a1
	move.w	#VRAM_ARROW/$20,oTile(a0)
	move.l	#Map_Arrow,oMap(a0)

	tst.b	oSubtype(a0)
	beq.s	.SetAddr

	lea	ObjArrow_3D(pc),a1
	move.w	#VRAM_ARROW_3D/$20,oTile(a0)
	move.l	#Map_Arrow3D,oMap(a0)

.SetAddr:
	move.l	a1,oAddr(a0)

	move.w	#128,oSprX(a0)
	move.w	#32,oSprY(a0)

	jmp	(a1)

; -------------------------------------------------------------------------

ObjArrow_Main:
	lea	playerObject,a5				; Get angle from target
	movea.l	curDestination,a6
	move.w	oX(a6),d4
	move.w	oY(a6),d5
	move.w	oX(a5),d0
	move.w	oY(a5),d1
	bsr.w	GetAngle
	bsr.w	GetLinearAngle

	subi.w	#$60,d1					; Set arrow frame
	sub.w	oPlayerYaw(a5),d1
	andi.w	#$1FF,d1
	lsr.w	#6,d1
	move.b	d1,oFrame(a0)

	jmp	DrawObject

; -------------------------------------------------------------------------

ObjArrow_3D:
	movea.l	curDestination,a1
	move.w	oX(a1),oX(a0)
	move.w	oY(a1),oY(a0)
	
	move.w	#0,oArrowZ(a0)

	move.w	playerObject+oZ,d0
	sub.w	oArrowZ(a0),d0
	move.w	d0,oZ(a0)

	lea	.Frames(pc),a1
	bra.w	DrawObject3D

; -------------------------------------------------------------------------

.Frames:
	dc.b	0, 0, 0, 0
	dc.b	1, 1, 1, 1
	dc.b	2, 2, 2, 2
	dc.b	3, 3, 3, 3
	dc.b	4, 4, 4, 4
	dc.b	5, 5, 5, 5
	dc.b	6, 6, 6, 6
	dc.b	7, 7, 7, 7
	dc.b	8, 8, 8, 8
	dc.b	8, 8, 8, 8
	dc.b	9, 9, 9, 9
	dc.b	9, 9, 9, 9
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A
	even

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Map_Arrow:
	include	"src/special/objects/arrow_mappings.asm"
	even
Map_Arrow3D:
	include	"src/special/objects/arrow_3d_mappings.asm"
	even
	
; -------------------------------------------------------------------------
