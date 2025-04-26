; -------------------------------------------------------------------------
; Bus object
; -------------------------------------------------------------------------

oPlayerMove	EQU	oVar30			; Move speed
oPlayerTurn	EQU	oVar34			; Turn speed
oPlayerPitch	EQU	oVar38			; Pitch angle
oPlayerYaw	EQU	oVar3C			; Yaw angle

; -------------------------------------------------------------------------

ObjBus:
	move.l	#ObjBus_Main,oAddr(a0)
	move.w	#$2000|(VRAM_BUS/$20),oTile(a0)
	move.l	#Map_Bus,oMap(a0)
	move.w	#128,oSprX(a0)
	move.w	#168,oSprY(a0)

	move.w	#$8A0,oX(a0)
	move.w	#0,oY(a0)
	move.w	#$160,oZ(a0)
	move.w	#$80,oPlayerPitch(a0)
	move.w	#$100,oPlayerYaw(a0)

; -------------------------------------------------------------------------

ObjBus_Main:
	bsr.w	ObjBus_Move
	bsr.w	ObjBus_UpdatePos
	bsr.w	ObjBus_Turning

.Locked:
	bsr.w	ObjBus_Sound

	lea	gfxVars,a1
	move.w	oX(a0),gfxCamX(a1)
	move.w	oY(a0),gfxCamY(a1)
	move.w	oZ(a0),gfxCamZ(a1)
	move.w	oPlayerPitch(a0),gfxPitch(a1)
	move.w	oPlayerYaw(a0),gfxYaw(a1)

	move.w	oY(a0),recordSub
	
	jmp	DrawObject

; -------------------------------------------------------------------------
; Handle movement
; -------------------------------------------------------------------------

MOVE_SPEED	EQU	($600*FPS_SRC)/FPS_DEST

; -------------------------------------------------------------------------

ObjBus_Move:
	clr.b	oFrame(a0)

	btst	#0,COMM_CMD_7
	beq.s	.NoUp
	move.w	#MOVE_SPEED,oPlayerMove(a0)
	bra.s	.UpdatePos
	
; -------------------------------------------------------------------------

.NoUp:
	btst	#1,COMM_CMD_7
	beq.s	.NoDown
	move.w	#-MOVE_SPEED,oPlayerMove(a0)
	bra.s	.UpdatePos
	
; -------------------------------------------------------------------------

.NoDown:
	clr.w	oPlayerMove(a0)

; -------------------------------------------------------------------------

.UpdatePos:
	move.w	oPlayerYaw(a0),d0
	addi.w	#$180,d0

	move.w	d0,d3
	bsr.w	GetCosine
	muls.w	oPlayerMove(a0),d3
	move.l	d3,oXVel(a0)

	move.w	d0,d3
	bsr.w	GetSine
	muls.w	oPlayerMove(a0),d3
	move.l	d3,oYVel(a0)
	rts
	
; -------------------------------------------------------------------------
; Handle turning
; -------------------------------------------------------------------------

TURN_SPEED	EQU	$300<<8

; -------------------------------------------------------------------------

ObjBus_Turning:
	btst	#2,COMM_CMD_7
	beq.s	.NoLeft
	
	tst.w	oPlayerMove(a0)
	beq.s	.NoLeftFrame
	move.b	#1,oFrame(a0)

.NoLeftFrame:
	move.l	#TURN_SPEED,oPlayerTurn(a0)
	bra.s	.UpdateAngle
	
; -------------------------------------------------------------------------

.NoLeft:
	btst	#3,COMM_CMD_7
	beq.s	.NoRight
	
	tst.w	oPlayerMove(a0)
	beq.s	.NoRightFrame
	move.b	#2,oFrame(a0)

.NoRightFrame:
	move.l	#-TURN_SPEED,oPlayerTurn(a0)
	bra.s	.UpdateAngle
	
; -------------------------------------------------------------------------

.NoRight:
	clr.l	oPlayerTurn(a0)

.UpdateAngle:
	move.w	oPlayerTurn(a0),d0
	asr.w	#1,d0
	sub.w	d0,bgOffset

	move.l	oPlayerTurn(a0),d0
	add.l	d0,oPlayerYaw(a0)

.End:
	rts
	
; -------------------------------------------------------------------------
; Update position
; -------------------------------------------------------------------------

ObjBus_UpdatePos:
	lea	WORD_START_2M+STAMP_MAP,a1

	move.l	oX(a0),d2
	move.l	oY(a0),d3

	move.l	oXVel(a0),d0
	move.l	oYVel(a0),d1

	add.l	d0,d2
	bsr.s	.GetStamp
	bne.s	.CheckY
	sub.l	d0,d2
	moveq	#0,d0

.CheckY:
	add.l	d1,d3
	bsr.s	.GetStamp
	bne.s	.NewVelocity
	sub.l	d1,d3
	moveq	#0,d1

.NewVelocity:
	move.l	d0,oXVel(a0)
	move.l	d1,oYVel(a0)
	
	add.l	d0,oX(a0)
	add.l	d1,oY(a0)
	rts
	
; -------------------------------------------------------------------------

.GetStamp:
	move.l	d2,d4
	swap	d4
	andi.w	#$FFF,d4
	lsr.w	#5,d4
	move.l	d3,d5
	swap	d5
	andi.w	#$FE0,d5
	add.w	d5,d5
	add.w	d5,d5
	add.w	d5,d4
	add.w	d4,d4

	move.w	(a1,d4.w),d4
	andi.w	#$7FF,d4
	cmpi.w	#3*4,d4
	beq.s	.GotStamp
	cmpi.w	#9*4,d4

.GotStamp:
	rts
	
; -------------------------------------------------------------------------
; Handle sound
; -------------------------------------------------------------------------

ObjBus_Sound:
	move.b	#3,cbpcmMotorMode
	moveq	#0,d0
	move.w	oPlayerMove(a0),d0
	move.l	d0,d1
	or.l	oPlayerTurn(a0),d1
	beq.s	.CheckHonk
	move.b	#2,cbpcmMotorMode
	tst.w	d0
	bpl.s	.CheckHonk
	move.b	#1,cbpcmMotorMode

.CheckHonk:
	clr.b	cbpcmHonk
	btst	#6,COMM_CMD_7
	beq.s	.NoA
	st	cbpcmHonk
	
.NoA:
	rts

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Map_Bus:
	include	"src/crazybus3d/objects/bus_mappings.asm"
	even
	
; -------------------------------------------------------------------------
