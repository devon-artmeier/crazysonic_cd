
; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Ugly Red 2 actor
; -------------------------------------------------------------------------

aUg2Angle	EQU	aVar10					; Angle
UG2_FREQ	EQU	$10					; Shoot frequency

; -------------------------------------------------------------------------

ActorUglyRed2:
	move.w	#$200+UG2_FREQ,aEnemyShot(a0)			; Set shoot timer
	move.w	#1,aEnemyHealth(a0)				; Set health
	move.l	#40,aEnemyScore(a0)				; Set score
	clr.b	aUg2Angle(a0)					; Set angle
	
	move.b	#7,aEnemyRadX(a0)				; Set collision box
	move.b	#15,aEnemyRadY(a0)
	st	aCollideable(a0)

	move.l	#.Main,aAddr(a0)				; Update code address

; -------------------------------------------------------------------------

.Main:
	bsr.w	Enemy_CheckBulletHit				; Check collision with player bullets

	move.b	aUg2Angle(a0),d0				; Update X velocity
	addi.b	#$A,aUg2Angle(a0)
	bsr.w	CalcSine
	add.w	d0,d0
	move.w	d0,aXVel(a0)

	move.w	aXVel(a0),d0					; Update X position
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,aX(a0)

	addi.l	#$28000,aY(a0)					; Move down

; -------------------------------------------------------------------------

.CheckShoot:
	tst.b	aEnemyShot(a0)					; Have we already shot?
	beq.s	.CheckDespawn					; If so, branch

	subi.w	#UG2_FREQ,aEnemyShot(a0)			; Decrement shoot timer
	tst.b	aEnemyShot+1(a0)				; Should we shoot?
	bne.s	.CheckDespawn					; If not, branch

	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	.CheckDespawn					; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.s	.CheckDespawn					; If none were found, branch
	moveq	#6-1,d3						; Number of bullets

	moveq	#64/6,d4					; Shoot direction
	moveq	#-$30,d2					; Initial angle
	cmpi.b	#1,aEnemyShot(a0)
	bne.s	.SpawnBullets
	neg.w	d4
	neg.b	d2

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.b	d2,d0						; Set bullet speed
	bsr.w	CalcSine
	move.w	d4,-(sp)
	move.w	d0,d4
	add.w	d0,d0
	add.w	d4,d0
	move.w	d1,d4
	add.w	d1,d1
	add.w	d4,d1
	move.w	d0,bXVel(a6)
	move.w	d1,bYVel(a6)
	move.w	(sp)+,d4

	add.w	d4,d2						; Shift angle
	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.s	.CheckDespawn					; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

; -------------------------------------------------------------------------

.CheckDespawn:
	cmpi.w	#176+8+16,aY(a0)				; Check despawn
	blt.s	.DrawSprite
	clr.l	aAddr(a0)
	clr.b	aCollideable(a0)
	rts

; -------------------------------------------------------------------------

.DrawSprite:
	move.w	aY(a0),d0					; Draw sprite
	addi.w	#128-16+24,d0
	move.w	d0,(a1)+

	move.b	#7,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1760)/$20)+$4000,d0
	tst.b	aAnimTime(a0)
	bpl.s	.NoFlip
	ori.w	#$800,d0

.NoFlip:
	move.w	d0,(a1)+

	move.w	aX(a0),d0
	addi.w	#128-8+16,d0
	move.w	d0,(a1)+

; -------------------------------------------------------------------------

.Animate:
	subq.b	#1,aAnimTime(a0)				; Decrement animation timer
	cmpi.b	#-3,aAnimTime(a0)				; Should it wrap?
	bge.s	.NoAnimReset					; If not, branch
	move.b	#3-1,aAnimTime(a0)				; Wrap the animation timer

.NoAnimReset:
	rts

; -------------------------------------------------------------------------