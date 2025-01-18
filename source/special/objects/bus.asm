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
	
	jmp	DrawObject

; -------------------------------------------------------------------------
; Handle movement
; -------------------------------------------------------------------------

MOVE_ACC	EQU	($40*FPS_SRC)/FPS_DEST
MOVE_DEC	EQU	($100*FPS_SRC)/FPS_DEST
MOVE_MAX_F	EQU	($1400*FPS_SRC)/FPS_DEST
MOVE_MAX_B	EQU	($300*FPS_SRC)/FPS_DEST

; -------------------------------------------------------------------------

ObjBus_Move:
	clr.b	oFrame(a0)

	tst.b	oFlags(a0)
	bmi.s	.NoDown
	btst	#6,oFlags(a0)
	bne.s	.Down

	btst	#0,COMM_CMD_7
	beq.s	.NoUp
	
	addi.w	#MOVE_ACC,oPlayerMove(a0)
	cmpi.w	#MOVE_MAX_F,oPlayerMove(a0)
	blt.s	.UpdatePos
	move.w	#MOVE_MAX_F,oPlayerMove(a0)
	bra.s	.UpdatePos
	
; -------------------------------------------------------------------------

.NoUp:
	btst	#1,COMM_CMD_7
	beq.s	.NoDown

.Down:
	move.w	oPlayerMove(a0),d0
	subi.w	#MOVE_DEC,oPlayerMove(a0)
	btst	#6,oFlags(a0)
	bne.s	.Brake
	tst.w	d0
	beq.s	.BackUp
	bmi.s	.BackUp

.Brake:
	tst.w	oPlayerMove(a0)
	bpl.s	.UpdatePos
	clr.w	oPlayerMove(a0)
	bra.s	.UpdatePos

.BackUp:
	cmp.w	#-MOVE_MAX_B,oPlayerMove(a0)
	bgt.s	.UpdatePos
	move.w	#-MOVE_MAX_B,oPlayerMove(a0)
	bra.s	.UpdatePos
	
; -------------------------------------------------------------------------

.NoDown:
	tst.b	oPlayerMove(a0)
	bpl.s	.DecelBack

	addi.w	#MOVE_ACC,oPlayerMove(a0)
	bmi.s	.UpdatePos
	clr.w	oPlayerMove(a0)
	bra.s	.UpdatePos

.DecelBack:
	subi.w	#MOVE_ACC,oPlayerMove(a0)
	bpl.s	.UpdatePos
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

TURN_MIN	EQU	(($200<<8)*FPS_SRC)/FPS_DEST
TURN_MAX	EQU	(($800<<8)*FPS_SRC)/FPS_DEST
TURN_ACC	EQU	(($C0<<8)*FPS_SRC)/FPS_DEST

; -------------------------------------------------------------------------

ObjBus_Turning:
	move.b	oFlags(a0),d0
	andi.b	#$C0,d0
	bne.w	.NoRight

	btst	#2,COMM_CMD_7
	beq.s	.NoLeft
	
	tst.w	oPlayerMove(a0)
	beq.s	.NoLeftFrame
	move.b	#1,oFrame(a0)

.NoLeftFrame:
	cmpi.l	#TURN_MIN,oPlayerTurn(a0)
	bgt.s	.TurnLeft
	move.l	#TURN_MIN,oPlayerTurn(a0)

.TurnLeft:
	addi.l	#TURN_ACC,oPlayerTurn(a0)
	cmp.l	#TURN_MAX,oPlayerTurn(a0)
	blt.s	.UpdateAngle
	move.l	#TURN_MAX,oPlayerTurn(a0)
	bra.s	.UpdateAngle
	
; -------------------------------------------------------------------------

.NoLeft:
	btst	#3,COMM_CMD_7
	beq.s	.NoRight
	
	tst.w	oPlayerMove(a0)
	beq.s	.NoRightFrame
	move.b	#2,oFrame(a0)

.NoRightFrame:
	cmpi.l	#-TURN_MIN,oPlayerTurn(a0)
	blt.s	.TurnRight
	move.l	#-TURN_MIN,oPlayerTurn(a0)

.TurnRight:
	subi.l	#TURN_ACC,oPlayerTurn(a0)
	cmp.l	#-TURN_MAX,oPlayerTurn(a0)
	bgt.s	.UpdateAngle
	move.l	#-TURN_MAX,oPlayerTurn(a0)
	bra.s	.UpdateAngle
	
; -------------------------------------------------------------------------

.NoRight:
	tst.b	oPlayerTurn(a0)
	bpl.s	.DecelLeft
	add.l	#TURN_ACC,oPlayerTurn(a0)
	bmi.s	.End
	clr.l	oPlayerTurn(a0)
	bra.s	.UpdateAngle

.DecelLeft:
	sub.l	#TURN_ACC,oPlayerTurn(a0)
	bpl.s	.End
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
	lsr.w	#5,d4
	move.l	d3,d5
	swap	d5
	andi.w	#$FFE0,d5
	add.w	d5,d5
	add.w	d5,d5
	add.w	d5,d4
	add.w	d4,d4

	move.w	(a1,d4.w),d4
	andi.w	#$7FF,d4
	cmpi.w	#7*4,d4
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
	include	"source/special/objects/bus_mappings.asm"
	even
	
; -------------------------------------------------------------------------
