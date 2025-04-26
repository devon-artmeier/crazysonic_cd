
; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Tong Shau Ping boss actor
; -------------------------------------------------------------------------

aBossShootFreq		EQU	aEnemyShot			; Shoot frequency
aBossDelay		EQU	aVar8				; Delay timer
aBossShootDelay		EQU	aVar9				; Shoot delay timer
aBossHoverAngle		EQU	aVar10				; Hover angle
aBossMoveAngle		EQU	aVar11				; Move angle
aBossMoveAcc		EQU	aVar12				; Move acceleration
aBossShootAngle		EQU	aVar12				; Shoot angle
aBossCounter		EQU	aVar14				; Counter
aBossFlag		EQU	aVar15				; Flag

; -------------------------------------------------------------------------

ActorBoss:
	move.w	#$1000,aEnemyHealth(a0)				; Set health

	cmpi.l	#ActorPlayer,actors+aAddr			; Is the player loaded?
	bne.s	.Exit						; If not, branch
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	.Exit						; If not, branch
	
	move.w	#144/2,aX(a0)					; Set position
	move.w	#32,aY(a0)

	move.l	#100000,aEnemyScore(a0)				; Set score
	clr.b	aBossHoverAngle(a0)				; Reset hover angle
	
	move.b	#19,aEnemyRadX(a0)				; Set collision box
	move.b	#17,aEnemyRadY(a0)
	st	aCollideable(a0)

	move.l	#ActorBoss_FadeToWhite,aAddr(a0)
	bra.s	ActorBoss_FadeToWhite

.Exit:
	rts

; -------------------------------------------------------------------------

ActorBoss_FadeToWhite:
	move.b	#2,palChange					; Fade to white
	move.l	#ActorBoss_FadeFromWhite,aAddr(a0)
	rts

; -------------------------------------------------------------------------

ActorBoss_FadeFromWhite:
	move.b	#15,aBossDelay(a0)				; Set delay
	move.b	#4,palChange					; Fade from white
	move.l	#ActorBoss_Cutscene,aAddr(a0)
	bra.w	ActorBoss_Draw2
	
; -------------------------------------------------------------------------

ActorBoss_Cutscene:
	subq.b	#1,aBossDelay(a0)				; Handle delay
	bpl.w	ActorBoss_Draw2
	
	movem.l	d5/d7/a0-a1,-(sp)				; Play boss music
	lea	cddaParam(pc),a0
	move.w	#7,(a0)
	BIOS_MSCPLAYR

.WaitCDDA:
	BIOS_CDBSTAT						; Get BIOS status
	move.w	(a0),d0
	bmi.s	.WaitCDDA					; If the CD isn't ready, wait
	andi.w	#$FF00,d0					; Is CDDA playing?
	cmpi.w	#$100,d0
	bne.s	.WaitCDDA					; If not, wait
	movem.l	(sp)+,d5/d7/a0-a1

	st	bossCutscene					; Set boss cutscene flag
	move.b	#15,aBossDelay(a0)				; Set delay
	move.l	#ActorBoss_FadeToWhite2,aAddr(a0)
	bra.w	ActorBoss_Draw2

; -------------------------------------------------------------------------

ActorBoss_FadeToWhite2:
	subq.b	#1,aBossDelay(a0)				; Handle delay
	bpl.w	ActorBoss_Draw2

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	move.b	#6,palChange					; Fade to white
	move.l	#ActorBoss_Start,aAddr(a0)
	bra.w	ActorBoss_Draw2

; -------------------------------------------------------------------------

ActorBoss_Start:
	move.b	#8,palChange					; Make background pink
	
	st	bossStarted					; Start the boss
	move.b	#30,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack2,aAddr(a0)
	bra.w	ActorBoss_DoAttack2

; -------------------------------------------------------------------------
; Attack 1
; -------------------------------------------------------------------------

ActorBoss_DoAttack1:
	move.l	#ActorBoss_Attack1,aAddr(a0)			; Set attack

	move.b	#10,aBossShootFreq(a0)				; Reset attack
	clr.b	aBossMoveAngle(a0)
	clr.w	aBossMoveAcc(a0)
	clr.b	aBossFlag(a0)
	clr.b	aBossShootDelay(a0)
	clr.b	aBossShootFreq(a0)
	move.b	#3,aBossCounter(a0)

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------

ActorBoss_Attack1:
	tst.b	aBossDelay(a0)					; Handle delay
	beq.s	.Do
	subq.b	#1,aBossDelay(a0)
	bpl.w	ActorBoss_Update

.Do:
	move.b	aBossMoveAngle(a0),d0				; Handle acceleration
	cmpi.b	#$80,d0
	bne.s	.NoSpeedUp
	eori.w	#1,aBossMoveAcc(a0)
	eori.b	#1,aBossShootFreq(a0)
	bne.s	.NoSpeedUp
	st	aBossFlag(a0)

.NoSpeedUp:
	tst.b	d0						; Check for next attack
	bne.s	.NoNextAttack
	tst.b	aBossFlag(a0)
	beq.s	.NoNextAttack
	move.b	#20,aBossDelay(a0)
	clr.b	aBossFlag(a0)
	subq.b	#1,aBossCounter(a0)
	bne.s	.NoNextAttack

	move.b	#45,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack3,aAddr(a0)

.NoNextAttack:
	addq.b	#4,aBossMoveAngle(a0)				; Move
	bsr.w	CalcSine
	moveq	#0,d1
	move.w	aBossMoveAcc(a0),d1
	ext.l	d0
	asl.l	#8,d0
	asl.l	#3,d0
	asl.l	d1,d0
	add.l	d0,aX(a0)
	
	tst.b	aBossFlag(a0)					; Check if we should shoot bullets
	bne.w	ActorBoss_Update

	subq.b	#1,aBossShootDelay(a0)				; Handle bullet delay
	bpl.w	ActorBoss_Update
	moveq	#8,d0
	moveq	#0,d1
	move.b	aBossShootFreq(a0),d1
	asr.w	d1,d0
	move.b	d0,aBossShootDelay(a0)
	
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.w	ActorBoss_Update				; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	moveq	#24-1,d3					; Number of bullets
	moveq	#-$5C,d2					; Initial angle

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.b	d2,d0						; Set bullet speed
	bsr.w	CalcSine
	add.w	d0,d0
	add.w	d1,d1
	move.w	d0,bXVel(a6)
	move.w	d1,bYVel(a6)

	addq.b	#8,d2						; Increase angle
	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------
; Attack 2
; -------------------------------------------------------------------------

ActorBoss_DoAttack2:
	move.l	#ActorBoss_Attack2,aAddr(a0)			; Set attack

	clr.b	aBossShootDelay(a0)				; Reset attack
	clr.w	aBossShootAngle(a0)

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------

ActorBoss_Attack2:
	tst.b	aBossDelay(a0)					; Handle delay
	beq.s	.Do
	subq.b	#1,aBossDelay(a0)
	bpl.w	ActorBoss_Update

.Do:
	subq.b	#1,aBossShootDelay(a0)				; Handle bullet delay
	bpl.w	ActorBoss_Update
	move.b	#20,aBossShootDelay(a0)

	lea	.Pattern(pc),a2					; Pattern data
	move.w	aBossShootAngle(a0),d0
	lea	(a2,d0.w),a2

	addi.w	#(44*4),aBossShootAngle(a0)			; Advance pattern angle
	cmpi.w	#(44*4)*16,aBossShootAngle(a0)			; Check for next attack
	bne.s	.NotDone

	move.b	#45,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack1,aAddr(a0)

.NotDone:
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.w	ActorBoss_Update				; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	moveq	#44-1,d3					; Number of bullets

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.w	(a2)+,bXVel(a6)					; Set bullet speed
	move.w	(a2)+,bYVel(a6)

	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------

.Pattern:
	incbin	"src/hk97/data/patterns/flower.bin"
	even

; -------------------------------------------------------------------------
; Attack 3
; -------------------------------------------------------------------------

ActorBoss_DoAttack3:
	move.l	#ActorBoss_Attack3,aAddr(a0)			; Set attack

	move.b	#6,aBossCounter(a0)				; Reset attack
	move.b	#-4,aBossMoveAngle(a0)
	clr.b	aBossShootDelay(a0)

	bra.w	ActorBoss_UpdateNoHover

; -------------------------------------------------------------------------

ActorBoss_Attack3:
	tst.b	aBossDelay(a0)					; Handle delay
	beq.s	.Do
	subq.b	#1,aBossDelay(a0)
	bpl.w	ActorBoss_UpdateNoHover

.Do:
	addq.b	#4,aBossMoveAngle(a0)				; Move
	bne.s	.NoCounterDec
	subq.b	#1,aBossCounter(a0)				; Check for next attack
	bne.s	.NoCounterDec
	
	move.b	#104,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack5,aAddr(a0)
	bra.s	.NoMove

.NoCounterDec:
	move.b	aBossMoveAngle(a0),d0
	bsr.w	CalcSine
	ext.l	d0
	ext.l	d1
	asl.l	#8,d0
	asl.l	#8,d1
	asl.l	#3,d0
	asl.l	#3,d1
	add.l	d1,aX(a0)
	add.l	d0,aY(a0)

.NoMove:
	subq.b	#1,aBossShootDelay(a0)				; Handle bullet delay
	bpl.w	ActorBoss_UpdateNoHover
	move.b	#12,aBossShootDelay(a0)
	
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.w	ActorBoss_UpdateNoHover				; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.w	ActorBoss_UpdateNoHover				; If none were found, branch

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	move.b	aBossMoveAngle(a0),d2				; Initial angle
	subi.b	#36,d2
	moveq	#7-1,d3						; Number of bullets

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.b	d2,d0						; Set bullet speed
	bsr.w	CalcSine
	neg.w	d0
	move.w	d0,bXVel(a6)
	move.w	d1,bYVel(a6)

	addi.b	#12,d2						; Increase angle
	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.w	ActorBoss_UpdateNoHover				; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

	bra.w	ActorBoss_UpdateNoHover

; -------------------------------------------------------------------------
; Attack 4
; -------------------------------------------------------------------------

ActorBoss_DoAttack4:
	move.l	#ActorBoss_Attack4,aAddr(a0)			; Set attack

	move.w	#32,aBossCounter(a0)				; Reset attack
	clr.b	aBossShootAngle(a0)

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------

ActorBoss_Attack4:
	tst.b	aBossDelay(a0)					; Handle delay
	beq.s	.Do
	subq.b	#1,aBossDelay(a0)
	bpl.w	ActorBoss_Update

.Do:
	subq.b	#1,aBossShootDelay(a0)				; Handle bullet delay
	bpl.w	ActorBoss_Update
	move.b	#7,aBossShootDelay(a0)
	
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.w	ActorBoss_Update				; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	moveq	#(256/8)-1,d3					; Number of bullets

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.b	aBossShootAngle(a0),d0				; Set bullet speed
	addq.b	#8,aBossShootAngle(a0)
	bsr.w	CalcSine
	move.w	d0,d2
	add.w	d0,d0
	add.w	d2,d0
	move.w	d1,d2
	add.w	d1,d1
	add.w	d2,d1
	move.w	d1,bXVel(a6)
	move.w	d0,bYVel(a6)

	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.w	.Done						; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

.Done:
	addq.b	#2,aBossShootAngle(a0)				; Offset angle

	subq.w	#1,aBossCounter(a0)				; Decrement number of bullets to shoot
	bne.s	.NotOver					; Also check for next attack

	move.b	#80,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack2,aAddr(a0)
	bra.w	ActorBoss_Update

.NotOver:
	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------
; Attack 5
; -------------------------------------------------------------------------

ActorBoss_DoAttack5:
	move.l	#ActorBoss_Attack5,aAddr(a0)			; Set attack

	move.w	#64,aBossCounter(a0)				; Reset attack
	clr.b	aBossMoveAngle(a0)

	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------

ActorBoss_Attack5:
	tst.b	aBossDelay(a0)					; Handle delay
	beq.s	.Do
	subq.b	#1,aBossDelay(a0)
	bpl.w	ActorBoss_Update

.Do:
	move.b	aBossMoveAngle(a0),d0				; Move
	addq.b	#4,aBossMoveAngle(a0)
	bsr.w	CalcSine
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d0
	add.l	d0,aX(a0)

	subq.b	#1,aBossShootDelay(a0)				; Handle bullet delay
	bpl.w	ActorBoss_Update
	move.b	#6,aBossShootDelay(a0)
	
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.w	ActorBoss_Update				; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.w	ActorBoss_Update				; If none were found, branch

	moveq	#1,d0						; Play shoot sound
	jsr	PlayPCM

	moveq	#16-1,d3					; Number of bullets

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

.RNG:
	bsr.w	Random						; Set bullet speed
	bsr.w	CalcSine
	move.w	d0,d2
	add.w	d0,d0
	add.w	d2,d0
	move.w	d1,d2
	add.w	d1,d1
	add.w	d2,d1
	move.w	d1,bXVel(a6)
	move.w	d0,bYVel(a6)

	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.w	.Done						; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

.Done:
	subq.w	#1,aBossCounter(a0)				; Decrement number of bullets to shoot
	bne.s	.NotOver					; Also check for next attack

	move.b	#60,aBossDelay(a0)
	move.l	#ActorBoss_DoAttack4,aAddr(a0)
	bra.w	ActorBoss_Update

.NotOver:
	bra.w	ActorBoss_Update

; -------------------------------------------------------------------------
; General updates
; -------------------------------------------------------------------------

ActorBoss_Update:
	move.b	aBossHoverAngle(a0),d0				; Hover
	addi.b	#12,aBossHoverAngle(a0)
	bsr.w	CalcSine
	ext.l	d0
	asl.l	#7,d0
	add.l	d0,aY(a0)
	
ActorBoss_UpdateNoHover:
	bsr.w	Enemy_CheckBulletHit				; Check collision with player bullets
	tst.w	aEnemyHealth(a0)				; Are we dead?
	bne.s	ActorBoss_Draw					; If not, branch

	move.l	#ActorBoss_Defeated,aAddr(a0)			; Mark as defeated
	move.b	#2,aBossDelay(a0)				; Set delay
	move.b	#6,palChange					; Fade to white

; -------------------------------------------------------------------------

ActorBoss_Draw:
	move.w	aEnemyHealth(a0),hudBossHP			; Update HP bar
	bset	#4,hudFlags

ActorBoss_Draw2:
	move.w	aY(a0),d0					; Draw sprite
	addi.w	#128-20+24,d0
	move.w	d0,(a1)+
	move.b	#$F,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1DA0)/$20)+$4000,(a1)+
	move.w	aX(a0),d1
	addi.w	#128-20+16,d1
	move.w	d1,(a1)+

	move.w	d0,(a1)+
	move.b	#3,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1FA0)/$20)+$4000,(a1)+
	addi.w	#32,d1
	move.w	d1,(a1)+

	addi.w	#32,d0
	move.w	d0,(a1)+
	move.b	#$C,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$2020)/$20)+$4000,(a1)+
	subi.w	#32,d1
	move.w	d1,(a1)+

	move.w	d0,(a1)+
	clr.b	(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$20A0)/$20)+$4000,(a1)+
	addi.w	#32,d1
	move.w	d1,(a1)+
	rts

; -------------------------------------------------------------------------

ActorBoss_Defeated:
	move.b	#30,bossDefeated				; Set defeated timer

	tst.w	bombTime					; Are we bombing?
	bne.s	ActorBoss_Draw2					; If so, branch

	subq.b	#1,aBossDelay(a0)				; Handle delay
	bpl.s	.End

	clr.l	aAddr(a0)					; Delete ourselves
	move.b	#4,palChange					; Fade from white

.End:
	rts

; -------------------------------------------------------------------------