
; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Ugly Red 1 actor
; -------------------------------------------------------------------------

UG1_FREQ	EQU	$08					; Shoot frequency

; -------------------------------------------------------------------------

ActorUglyRed1:
								; Set shoot timer
	move.w	#$200+(UG1_FREQ*8),aEnemyShot(a0)
	move.w	#1,aEnemyHealth(a0)				; Set health
	move.l	#33,aEnemyScore(a0)				; Set score

	move.b	#7,aEnemyRadX(a0)				; Set collision box
	move.b	#15,aEnemyRadY(a0)
	st	aCollideable(a0)

	move.l	#.Main,aAddr(a0)				; Update code address

; -------------------------------------------------------------------------

.Main:
	bsr.w	Enemy_CheckBulletHit				; Check collision with player bullets
	addi.l	#$18000,aY(a0)					; Move down

; -------------------------------------------------------------------------

	tst.b	aEnemyShot(a0)					; Have we already shot?
	beq.s	.CheckDespawn					; If so, branch

	subi.w	#UG1_FREQ,aEnemyShot(a0)			; Decrement shoot timer
	tst.b	aEnemyShot+1(a0)				; Should we shoot?
	bne.s	.CheckDespawn					; If not, branch

	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	.CheckDespawn					; If so, branch

	bsr.w	FindFreeEnemyBullet				; Find free bullet slot
	bcs.s	.CheckDespawn					; If none were found, branch
	moveq	#7-1,d3						; Number of bullets
	moveq	#-24,d2						; Initial angle

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)

	move.b	d2,d0						; Set bullet velocity
	bsr.w	CalcSine
	move.w	d0,d4
	add.w	d0,d0
	add.w	d4,d0
	move.w	d1,d4
	add.w	d1,d1
	add.w	d4,d1
	move.w	d0,bXVel(a6)
	move.w	d1,bYVel(a6)

	addq.w	#8,d2						; Increment angle
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
	move.w	#(($DE80+$1660)/$20)+$4000,d0
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