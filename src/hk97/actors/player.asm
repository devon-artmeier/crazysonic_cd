
; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Player actor
; -------------------------------------------------------------------------

aRespawnInv	EQU	aVar0					; Respawn invincibility timer
aDeathTimer	EQU	aVar1					; Death timer

; -------------------------------------------------------------------------

ActorPlayer:
	move.w	COMM_CMD_7.w,d0					; Get controller data

	tst.b	aDeathTimer(a0)					; Is the death timer active?
	beq.s	.NoDeath					; If so, branch
	subq.b	#1,aDeathTimer(a0)				; Decrement death timer
	bne.w	.NotRight					; If it hasn't run out, branch

	move.l	#ActorExplosion,aAddr(a0)			; Explode
	subq.b	#1,lives					; Decrement lives
	bset	#1,hudFlags					; Update HUD
	bra.w	ActorExplosion					; Run explosion code

.NoDeath:
	subq.b	#1,aRespawnInv(a0)				; Do we have invincibility frames?
	bpl.s	.NoHurt						; If so, branch
	clr.b	aRespawnInv(a0)					; Cap it at 0

.NoHurt:
	tst.b	bossDefeated					; Was the boss defeated?
	bne.s	.Move						; If so, branch

	move.w	d0,-(sp)
	bsr.w	Player_CheckBulletHit				; Check enemy bullet collision
	bsr.w	Player_CheckEnemyHit				; Check enemy collision
	move.w	(sp)+,d0

; -------------------------------------------------------------------------

.Move:
	move.l	#$30000,d1					; Normal speed
	move.w	#$120,d2
	btst	#6+8,d0						; Is A being held?
	beq.s	.NoA						; If not, branch
	move.l	#$18000,d1					; If so, use focused speed
	move.w	#$C0,d2

.NoA:
	tst.b	bossStarted					; Has the boss started?
	bne.s	.CheckMove					; If so, branch
	tst.w	levelTime					; Is the boss starting?
	beq.s	.NoMove						; If so, branch

.CheckMove:
	move.w	d0,d3						; Are we moving?
	andi.w	#$F00,d3
	bne.s	.IsMoving					; If so, branch

.NoMove:
	moveq	#0,d2						; If not, don't animate
	bra.s	.NotRight

.IsMoving:
	btst	#0+8,d0						; Is up being held?
	beq.s	.NotUp						; If not, branch
	sub.l	d1,aY(a0)					; Move up
	cmpi.w	#16,aY(a0)
	bgt.s	.NotUp
	move.w	#16,aY(a0)

.NotUp:
	btst	#1+8,d0						; Is down being held?
	beq.s	.NotDown					; If not, branch
	add.l	d1,aY(a0)					; Move down
	cmpi.w	#176-16,aY(a0)
	blt.s	.NotDown
	move.w	#176-16,aY(a0)

.NotDown:
	btst	#2+8,d0						; Is left being held?
	beq.s	.NotLeft					; If not, branch
	sub.l	d1,aX(a0)					; Move left
	cmpi.w	#8,aX(a0)
	bgt.s	.NotLeft
	move.w	#8,aX(a0)

.NotLeft:
	btst	#3+8,d0						; Is right being held?
	beq.s	.NotRight					; If not, branch
	add.l	d1,aX(a0)					; Move right
	cmpi.w	#144-8,aX(a0)
	blt.s	.NotRight
	move.w	#144-8,aX(a0)

; -------------------------------------------------------------------------

.NotRight:
	movem.l	d1-d2,-(sp)

	tst.b	bossDefeated					; Was the boss defeated?
	bne.w	.DrawSprite					; If so, branch
	tst.b	bossStarted					; Has the boss started?
	bne.s	.CheckBomb					; If so, branch
	cmpi.w	#60,levelTime					; Is the boss starting?
	bcs.w	.DrawSprite					; If so, branch

.CheckBomb:
	tst.w	bombTime					; Are we bombing?
	bne.s	.CheckShoot					; If so, branch
	btst	#5,d0						; Was C pressed?
	beq.s	.CheckShoot					; If not, branch
	tst.b	bombs						; Are there any bombs left?
	beq.s	.CheckShoot					; If not, branch

	subq.b	#1,bombs					; Decrement bomb count
	bset	#2,hudFlags					; Update HUD
	clr.b	aDeathTimer(a0)					; Reset death timer
	move.w	#BOMB_DUR,bombTime				; Start bombing

	move.w	d0,-(sp)					; Play bomb sound
	moveq	#3,d0
	jsr	PlayPCM
	move.w	(sp)+,d0

.CheckShoot:
	btst	#4+8,d0						; Is B being held?
	beq.s	.NotB						; If not, branch
	
	subq.b	#1,aShootDelay(a0)				; Decrement shoot delay timer
	bpl.s	.DrawSprite					; If it hasn't run out, branch
	move.b	#2,aShootDelay(a0)				; Reset shoot delay timer

	bsr.w	FindFreePlayerBullet				; Find free bullet slot
	bcs.s	.DrawSprite					; If none were found, branch

	moveq	#0,d0						; Play shoot sound
	jsr	PlayPCM
	
	moveq	#5-1,d3						; Number of bullets
	moveq	#-8,d2						; Initial angle

.SpawnBullets:
	st	bActive(a6)					; Mark bullet as active
	move.w	aX(a0),bX(a6)					; Set bullet position
	move.w	aY(a0),bY(a6)
	subi.w	#16,bY(a6)

	move.b	d2,d0						; Set bullet velocity
	bsr.w	CalcSine
	asl.w	#3,d0
	asl.w	#3,d1
	neg.w	d1
	move.w	d0,bXVel(a6)
	move.w	d1,bYVel(a6)

	addq.w	#4,d2						; Increment angle
	bsr.w	FindNextFreeBullet				; Find free bullet slot
	bcs.s	.DrawSprite					; If none were found, branch
	dbf	d3,.SpawnBullets				; Loop until all bullets are spawned

	bra.s	.DrawSprite					; Go draw the player sprite

.NotB:
	clr.b	aShootDelay(a0)					; Reset shoot delay timer

; -------------------------------------------------------------------------

.DrawSprite:
	movem.l	(sp)+,d1-d2

.DrawSprite2:
	btst	#0,aRespawnInv(a0)				; Should we flash?
	bne.s	.Animate					; If so, branch

	tst.b	bossStarted					; Has the boss started?
	bne.s	.DrawHitbox					; If so, branch
	tst.w	levelTime					; Is the boss starting?
	beq.w	.DrawChin					; If so, branch

.DrawHitbox:
	cmpi.l	#$18000,d1					; Are we focused?
	bne.s	.DrawChin					; If not, branch

	move.w	aY(a0),d0					; Draw hitbox
	addi.w	#128-4+24,d0
	move.w	d0,(a1)+

	clr.b	(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1960)/$20)+$0000,(a1)+

	move.w	aX(a0),d0
	addi.w	#128-4+16,d0
	move.w	d0,(a1)+

.DrawChin:
	move.w	aY(a0),d0					; Draw sprite
	addi.w	#128-16+24,d0
	move.w	d0,(a1)+

	move.b	#7,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1560)/$20)+$4000,d0
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
	sub.w	d2,aAnimTime(a0)				; Decrement animation timer
	cmpi.b	#-3,aAnimTime(a0)				; Should it wrap?
	bge.s	.NoAnimReset					; If not, branch
	move.b	#3-1,aAnimTime(a0)				; Wrap the animation timer

.NoAnimReset:
	rts

; -------------------------------------------------------------------------