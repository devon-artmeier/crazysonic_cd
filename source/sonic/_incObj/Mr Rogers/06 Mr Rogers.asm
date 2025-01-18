; ---------------------------------------------------------------------------
; Mr. Rogers boss
; ---------------------------------------------------------------------------

ROGERS_X	EQU	$2900
ROGERS_Y	EQU	$2A8

ROGERS_JUMP	EQU	$280
ROGERS_RAD_X	EQU	128
ROGERS_ORG_Y	EQU	ROGERS_Y-48

obRogCount	EQU	$30
obRogTimer	EQU	$32
obRogAngleInc	EQU	$34
obRogFlash	EQU	$36
obRogCollide	EQU	$37
obRogParent	EQU	$3E

obRogFireDist	EQU	$30
obRogFireX	EQU	$32
obRogFireY	EQU	$36

; ---------------------------------------------------------------------------

MrRogers:
	moveq	#0,d0
	move.b	obSubtype(a0),d0
	movea.l	.Types(pc,d0.w),a1
	jmp	(a1)

; ---------------------------------------------------------------------------

.Types:
	dc.l	MrRogersCtrl
	dc.l	MrRogersFire
	dc.l	MrRogersFist

; ---------------------------------------------------------------------------
; Controller
; ---------------------------------------------------------------------------

MrRogersCtrl:
	moveq	#0,d0
	move.b	obRoutine(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)

	move.w	obX(a0),d0
	subi.w	#ROGERS_X,d0
	move.w	d0,v_bgscreenposx.w

	move.w	obY(a0),d0
	subi.w	#ROGERS_Y,d0
	neg.w	d0
	move.w	d0,v_bgscreenposy.w
	rts

; ---------------------------------------------------------------------------

.Index:
	dc.w	MrRogers_Init-.Index
	dc.w	MrRogers_Rise-.Index
	dc.w	MrRogers_Main-.Index
	dc.w	MrRogers_Defeated-.Index
	dc.w	MrRogers_Gone-.Index

; ---------------------------------------------------------------------------

MrRogers_Init:
	tst.l	v_plc_buffer.w
	beq.s	.Start
	rts

.Start:
	addq.b	#2,obRoutine(a0)

	move.b	#$80,obRender(a0)
	move.w	#ROGERS_X,obX(a0)
	move.w	#ROGERS_Y+136,obY(a0)
	
	move.b	#24,obColProp(a0)
	tst.b	(f_debugmode).w
	beq.s	.notdebug
	move.b	#1,obColProp(a0)

.notdebug:
	lea	Pal_MrRogers(pc),a1
	lea	v_pal_dry+$60.w,a2
	moveq	#$20/4-1,d0

.LoadPal:
	move.l	(a1)+,(a2)+
	dbf	d0,.LoadPal

	moveq	#21,d0
	jsr	LoopCDDA

; ---------------------------------------------------------------------------

MrRogers_Rise:
	subq.w	#1,obY(a0)
	cmpi.w	#ROGERS_ORG_Y,obY(a0)
	bgt.s	.End
	move.w	#ROGERS_ORG_Y,obY(a0)
	addq.b	#2,obRoutine(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogers_Main:
	moveq	#0,d0
	move.b	ob2ndRout(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)

	tst.b	obStatus(a0)
	bmi.s	.Defeated

	tst.b	obRogFlash(a0)
	bne.s	.HandleFlash
	tst.b	obRogCollide(a0)
	beq.s	.End
	tst.b	obColType(a0)
	bne.s	.End
	move.b	#$20,obRogFlash(a0)
	moveq	#$FFFFFF00|sfx_HitBoss,d0
	jmp	PlaySound_Special

.HandleFlash:
	subq.b	#1,obRogFlash(a0)
	bne.s	.ApplyFlashPal
	move.b	obRogCollide(a0),obColType(a0)

.ApplyFlashPal:
	lea	Pal_MrRogers(pc),a1
	btst	#0,obRogFlash(a0)
	beq.s	.FlashPal
	lea	$20(a1),a1

.FlashPal:
	lea	v_pal_dry+$60.w,a2
	moveq	#$20/4-1,d0

.FlashPalLoop:
	move.l	(a1)+,(a2)+
	dbf	d0,.FlashPalLoop

.End:
	rts

.Defeated:
	move.w	#3*60,obRogTimer(a0)
	addq.b	#2,obRoutine(a0)
	rts
	
; ---------------------------------------------------------------------------

.Index:
	dc.w	MrRogers_StartBounce-.Index
	dc.w	MrRogers_Bounce-.Index
	dc.w	MrRogers_WaitFireAttack-.Index
	dc.w	MrRogers_FireAttack1-.Index
	dc.w	MrRogers_FireAttack2-.Index
	dc.w	MrRogers_FireAttackDone-.Index
	dc.w	MrRogers_StartBounce-.Index
	dc.w	MrRogers_Bounce-.Index
	dc.w	MrRogers_FistAttackL-.Index
	dc.w	MrRogers_FistAttackLWait-.Index
	dc.w	MrRogers_FistAttackR-.Index
	dc.w	MrRogers_FistAttackRWait-.Index
	dc.w	MrRogers_FistAttackL-.Index
	dc.w	MrRogers_FistAttackLWait-.Index
	dc.w	MrRogers_FistAttackR-.Index
	dc.w	MrRogers_FistAttackRWait-.Index
	dc.w	MrRogers_Restart-.Index

; ---------------------------------------------------------------------------
; Bounce left and right
; ---------------------------------------------------------------------------

MrRogers_StartBounce:
	addq.b	#2,ob2ndRout(a0)
	move.w	#-$200,obVelX(a0)
	move.b	#3,obRogCount(a0)

	move.b	#$F,obColType(a0)
	move.b	obColType(a0),obRogCollide(a0)

; ---------------------------------------------------------------------------

MrRogers_Bounce:
	jsr	ObjectFall

	tst.b	obVelY(a0)
	bmi.s	.MoveX
	cmpi.w	#ROGERS_ORG_Y,obY(a0)
	blt.s	.MoveX
	move.w	#ROGERS_ORG_Y,obY(a0)
	move.w	#-ROGERS_JUMP,obVelY(a0)

.MoveX:
	tst.w	obVelX(a0)
	bpl.s	.Right
	
	tst.b	obRogCount(a0)
	bne.s	.CheckLeft
	cmpi.w	#ROGERS_X,obX(a0)
	bgt.s	.End

.Attack:
	move.w	#ROGERS_X,obX(a0)
	clr.w	obVelX(a0)
	clr.b	obColType(a0)
	clr.b	obRogCollide(a0)
	move.w	#90-1,obRogTimer(a0)
	addq.b	#2,ob2ndRout(a0)
	rts

.CheckLeft:
	cmpi.w	#ROGERS_X-ROGERS_RAD_X,obX(a0)
	bgt.s	.End
	move.w	#ROGERS_X-ROGERS_RAD_X,obX(a0)
	neg.w	obVelX(a0)
	subq.b	#1,obRogCount(a0)
	rts

.Right:
	tst.b	obRogCount(a0)
	bne.s	.CheckRight
	cmpi.w	#ROGERS_X,obX(a0)
	bge.s	.Attack
	rts

.CheckRight:
	cmpi.w	#ROGERS_X+ROGERS_RAD_X,obX(a0)
	blt.s	.End
	move.w	#ROGERS_X+ROGERS_RAD_X,obX(a0)
	neg.w	obVelX(a0)
	subq.b	#1,obRogCount(a0)

.End:
	rts

; ---------------------------------------------------------------------------
; Fire attack
; ---------------------------------------------------------------------------

MrRogers_WaitFireAttack:
	cmpi.w	#ROGERS_ORG_Y,obY(a0)
	beq.s	.Delay
	jsr	ObjectFall

	tst.b	obVelY(a0)
	bmi.s	.End
	cmpi.w	#ROGERS_ORG_Y,obY(a0)
	blt.s	.End
	move.w	#ROGERS_ORG_Y,obY(a0)
	clr.w	obVelY(a0)

.Delay:
	subq.w	#1,obRogTimer(a0)
	bpl.s	.End

	move.w	#$A0,obRogCount(a0)
	move.w	#6-1,obRogTimer(a0)
	move.w	#$C000,obAngle(a0)

	addq.b	#2,ob2ndRout(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogers_FireAttack1:
	subq.w	#1,obRogTimer(a0)
	bpl.s	.End
	move.w	#6-1,obRogTimer(a0)

	move.b	obAngle(a0),d6
	subi.w	#$400,obAngle(a0)
	cmpi.b	#$A0,d6
	bcc.s	MrRogers_SpawnFire
	move.b	#$4E,obAngle(a0)
	
	addq.b	#2,ob2ndRout(a0)
	move.w	#$280,obRogAngleInc(a0)
	bra.s	MrRogers_SpawnFire

.End:
	rts

; ---------------------------------------------------------------------------

MrRogers_SpawnFire:
	jsr	FindNextFreeObj
	bne.s	.End
	move.b	#id_Obj06,(a1)

	move.w	obX(a0),d0
	subq.w	#8,d0
	move.w	d0,obX(a1)
	move.w	obY(a0),d0
	addi.w	#60,d0
	move.w	d0,obY(a1)

	move.b	#4,obSubtype(a1)
	move.b	d6,obAngle(a1)

	subq.w	#1,obRogCount(a0)
	bne.s	.End

	move.w	#30-1,obRogTimer(a0)
	addq.b	#2,ob2ndRout(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogers_FireAttack2:
	subq.w	#1,obRogTimer(a0)
	bpl.s	.End
	move.w	#6-1,obRogTimer(a0)

	move.b	obAngle(a0),d0
	move.b	d0,d2
	jsr	CalcSine
	
	addi.w	#$100,d0
	asr.w	#2,d0
	move.w	d0,d1
	asr.w	#1,d0
	add.w	d1,d0
	subi.b	#$20,d0
	move.b	d0,d6

	lea	obRogAngleInc(a0),a1
	move.w	(a1),d0
	add.w	d0,obAngle(a0)

	move.b	obAngle(a0),d0
	andi.b	#$80,d0
	andi.b	#$80,d2
	cmp.b	d0,d2
	beq.s	.Spawn

	addi.w	#$240,(a1)
	cmpi.w	#$7C0,(a1)
	bcs.s	.Spawn
	move.w	#$7C0,(a1)

.Spawn:
	bra.w	MrRogers_SpawnFire

.End:
	rts

; ---------------------------------------------------------------------------

MrRogers_FireAttackDone:
	subq.w	#1,obRogTimer(a0)
	bpl.s	.End
	addq.b	#2,ob2ndRout(a0)

.End:
	rts

; ---------------------------------------------------------------------------
; Fist attack
; ---------------------------------------------------------------------------

MrRogers_FistAttackL:
	jsr	FindNextFreeObj
	bne.s	.End
	move.b	#id_Obj06,(a1)

	move.w	obX(a0),d0
	addi.w	#112,d0
	move.w	d0,obX(a1)
	move.w	obY(a0),d0
	addi.w	#224,d0
	move.w	d0,obY(a1)

	move.b	#8,obSubtype(a1)
	move.w	a0,obRogParent(a1)

	addq.b	#2,ob2ndRout(a0)

.End
	rts

; ---------------------------------------------------------------------------

MrRogers_FistAttackLWait:
	rts

; ---------------------------------------------------------------------------

MrRogers_FistAttackR:
	jsr	FindNextFreeObj
	bne.s	.End
	move.b	#id_Obj06,(a1)

	move.w	obX(a0),d0
	subi.w	#112,d0
	move.w	d0,obX(a1)
	move.w	obY(a0),d0
	addi.w	#224,d0
	move.w	d0,obY(a1)
	
	move.b	#8,obSubtype(a1)
	move.b	#1,obRender(a1)
	move.w	a0,obRogParent(a1)

	addq.b	#2,ob2ndRout(a0)

.End
	rts

; ---------------------------------------------------------------------------

MrRogers_FistAttackRWait:
	rts

; ---------------------------------------------------------------------------

MrRogers_Restart:
	clr.b	ob2ndRout(a0)
	rts

; ---------------------------------------------------------------------------
; Defeated
; ---------------------------------------------------------------------------

MrRogers_Defeated:
	subq.w	#1,obRogTimer(a0)
	bmi.s	.Done
	jmp	BossDefeated

.Done:
	addq.b	#2,obRoutine(a0)
	st	secretBoss.w
	
MrRogers_Gone:
	rts

; ---------------------------------------------------------------------------
; Fire
; ---------------------------------------------------------------------------

MrRogersFire:
	moveq	#0,d0
	move.b	obRoutine(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)
	jmp	DisplaySprite

; ---------------------------------------------------------------------------

.Index:
	dc.w	MrRogersFire_Init-.Index
	dc.w	MrRogersFire_Main-.Index

; ---------------------------------------------------------------------------

MrRogersFire_Init:
	addq.b	#2,obRoutine(a0)
	
	move.b	#4,obRender(a0)
	move.w	#$420,obGfx(a0)
	move.l	#Map_MrRogersFire,obMap(a0)
	move.b	#16,obHeight(a0)
	move.b	#16,obWidth(a0)
	move.b	#16,obActWid(a0)
	move.w	#v_spritequeue+$80,obPriority(a0)
	move.b	#$89,obColType(a0)

	move.w	obX(a0),obRogFireX(a0)
	move.w	obY(a0),obRogFireY(a0)
	
	move.w	#sfx_Fireball,d0
	jmp	PlaySound_Special

; ---------------------------------------------------------------------------

MrRogersFire_Main:
	tst.b	obRender(a0)
	bpl.s	.Delete

	moveq	#0,d0
	move.b	obAngle(a0),d0
	jsr	CalcSine

	move.w	obRogFireDist(a0),d2
	muls.w	d2,d0
	muls.w	d2,d1
	asr.l	#8,d0
	asr.l	#8,d1
	add.w	obRogFireX(a0),d1
	move.w	d1,obX(a0)
	add.w	obRogFireY(a0),d0
	move.w	d0,obY(a0)
	
	addq.w	#4,obRogFireDist(a0)

	lea	Ani_MrRogersFire(pc),a1
	jmp	AnimateSprite

.Delete:
	jmp	DeleteObject

; ---------------------------------------------------------------------------
; Fist
; ---------------------------------------------------------------------------

MrRogersFist:
	moveq	#0,d0
	move.b	obRoutine(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)
	jmp	DisplaySprite

; ---------------------------------------------------------------------------

.Index:
	dc.w	MrRogersFist_Init-.Index
	dc.w	MrRogersFist_Main-.Index
	dc.w	MrRogersFist_Aim-.Index
	dc.w	MrRogersFist_Locked-.Index
	dc.w	MrRogersFist_Slam-.Index
	dc.w	MrRogersFist_Retreat-.Index

; ---------------------------------------------------------------------------

MrRogersFist_Init:
	addq.b	#2,obRoutine(a0)
	
	ori.b	#4,obRender(a0)
	move.w	#$6434,obGfx(a0)
	move.l	#Map_MrRogersFist,obMap(a0)
	move.b	#32,obHeight(a0)
	move.b	#32,obWidth(a0)
	move.b	#32,obActWid(a0)
	move.w	#v_spritequeue+$80,obPriority(a0)
	move.w	#-$E00,obVelY(a0)

; ---------------------------------------------------------------------------

MrRogersFist_Main:
	jsr	SpeedToPos
	addi.w	#$6C,obVelY(a0)
	tst.w	obVelY(a0)
	bmi.s	.End
	clr.w	obVelY(a0)

	addq.b	#2,obRoutine(a0)
	move.w	#120,obRogTimer(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogersFist_Aim:
	jsr	SpeedToPos

	lea	v_player.w,a1
	move.w	obX(a1),d0
	sub.w	obX(a0),d0
	asl.w	#4,d0
	move.w	d0,obVelX(a0)

	subq.w	#1,obRogTimer(a0)
	bpl.s	.End
	move.w	#15-1,obRogTimer(a0)
	addq.b	#2,obRoutine(a0)
	clr.w	obVelX(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogersFist_Locked:
	subq.w	#1,obRogTimer(a0)
	bpl.s	.End
	addq.b	#2,obRoutine(a0)
	move.w	#-$600,obVelY(a0)
	move.b	#$8F,obColType(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogersFist_Slam:
	jsr	SpeedToPos
	addi.w	#$C0,obVelY(a0)
	
	jsr	ObjFloorDist
	tst.w	d1
	bpl.s	.End
	add.w	d1,obY(a0)
	
	moveq	#$FFFFFF00|sfx_ChainStomp,d0
	jsr	PlaySound_Special

	addq.b	#2,obRoutine(a0)
	move.w	#-$500,obVelY(a0)
	clr.b	obColType(a0)

.End:
	rts

; ---------------------------------------------------------------------------

MrRogersFist_Retreat:
	jsr	SpeedToPos
	addi.w	#$60,obVelY(a0)
	tst.b	obRender(a0)
	bpl.s	.Delete
	rts

.Delete:
	movea.w	obRogParent(a0),a1
	addq.b	#2,ob2ndRout(a1)
	jmp	DeleteObject

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------

Ani_MrRogersFire:
	dc.w	.0-Ani_MrRogersFire
.0:
	dc.b	6, 0, 1, 2, $FE, 1
	even
Map_MrRogersFire:
	include	"source/sonic/_incObj/Mr Rogers/Fire Mappings.asm"
	even
Map_MrRogersFist:
	include	"source/sonic/_incObj/Mr Rogers/Fist Mappings.asm"
	even
Pal_MrRogers:
	incbin	"source/sonic/_incObj/Mr Rogers/Palette.bin"
	even

; ---------------------------------------------------------------------------
