; ---------------------------------------------------------------------------
; Subroutine to react to obColType(a0)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReactToItem:
		jsr	Touch_Rings

		move.w	obX(a0),d2	; load Sonic's x-axis position
		move.w	obY(a0),d3	; load Sonic's y-axis position
		
		moveq	#SONIC_WIDTH-1,d4
		sub.w	d4,d2
		add.w	d4,d4
		
		moveq	#SONIC_HEIGHT-3,d5
		sub.w	d5,d3
		add.w	d5,d5
		
		lea	(v_objspace+$800).w,a1 ; set object RAM start address
		move.w	#$5F,d6

.loop:
		tst.b	obRender(a1)
		bpl.s	.next
		move.b	obColType(a1),d0 ; load collision type
		bne.s	.proximity	; if nonzero, branch

	.next:
		lea	$40(a1),a1	; next object RAM
		dbf	d6,.loop	; repeat $5F more times

		moveq	#0,d0
		rts	
; ===========================================================================
.sizes:		;   width, height
		dc.b  $14, $14		; $01
		dc.b   $C, $14		; $02
		dc.b  $14,  $C		; $03
		dc.b	4, $10		; $04
		dc.b   $C, $12		; $05
		dc.b  $10, $10		; $06
		dc.b	6,   6		; $07
		dc.b  $18,  $C		; $08
		dc.b   $C, $10		; $09
		dc.b  $10,  $C		; $0A
		dc.b	8,   8		; $0B
		dc.b  $14, $10		; $0C
		dc.b  $14,   8		; $0D
		dc.b   $E,  $E		; $0E
		dc.b  $18, $18		; $0F
		dc.b  $28, $10		; $10
		dc.b  $10, $18		; $11
		dc.b	8, $10		; $12
		dc.b  $20, $70		; $13
		dc.b  $40, $20		; $14
		dc.b  $80, $20		; $15
		dc.b  $20, $20		; $16
		dc.b	8,   8		; $17
		dc.b	4,   4		; $18
		dc.b  $20,   8		; $19
		dc.b   $C,  $C		; $1A
		dc.b	8,   4		; $1B
		dc.b  $18,   4		; $1C
		dc.b  $28,   4		; $1D
		dc.b	4,   8		; $1E
		dc.b	4, $18		; $1F
		dc.b	4, $28		; $20
		dc.b	4, $20		; $21
		dc.b  $18, $18		; $22
		dc.b   $C, $18		; $23
		dc.b  $48,   8		; $24
; ===========================================================================

.proximity:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	.sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	obX(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	.outsidex	; branch if not touching
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	.withinx	; branch if touching
		bra.w	.next
; ===========================================================================

.outsidex:
		cmp.w	d4,d0
		bhi.w	.next

.withinx:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	obY(a1),d0
		andi.w	#$7FF,d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	.outsidey	; branch if not touching
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	.withiny	; branch if touching
		bra.w	.next
; ===========================================================================

.outsidey:
		cmp.w	d5,d0
		bhi.w	.next

.withiny:
	.chktype:
		move.b	obColType(a1),d1 ; load collision type
		andi.b	#$C0,d1		; is obColType $40 or higher?
		beq.w	React_Enemy	; if not, branch
		cmpi.b	#$C0,d1		; is obColType $C0 or higher?
		beq.w	React_Special	; if yes, branch
		moveq	#1,d2
		tst.b	d1		; is obColType $80-$BF?
		bmi.w	HurtSonic	; if yes, branch

; obColType is $40-$7F (powerups)

		move.b	obColType(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0			; is collision type $46	?
		beq.s	React_Monitor		; if yes, branch
		cmpi.w	#90,flashtime(a0)	; is Sonic invincible?
		bcc.w	.invincible		; if yes, branch
		addq.b	#2,obRoutine(a1)	; advance the object's routine counter

	.invincible:
		rts	
; ===========================================================================

React_Monitor:
		move.w	obVelY(a0),d0

		btst	#1,obRender(a1)
		beq.s	.notupsidedown
		tst.w	d0
		beq.s	.movingdown
		bmi.s	.movingdown
		bra.s	.checkfall

.notupsidedown:
		tst.w	d0
		bpl.s	.movingdown

.checkfall:
		btst	#1,obStatus(a1)
		beq.s	.movingdown
		btst	#1,obRender(a1)
		bne.s	.upsidedown

		move.w	obY(a0),d0
		subi.w	#$10,d0
		cmp.w	obY(a1),d0
		bcs.s	.donothing
		bra.s	.monitorfall

.upsidedown:
		move.w	obY(a0),d0
		addi.w	#$10,d0
		cmp.w	obY(a1),d0
		bcc.s	.donothing

.monitorfall:
		neg.w	obVelY(a0)	; reverse Sonic's vertical speed
		move.w	#-$180,obVelY(a1)
		tst.b	ob2ndRout(a1)
		bne.s	.donothing
		addq.b	#4,ob2ndRout(a1) ; advance the monitor's routine counter
		rts	
; ===========================================================================

.movingdown:
		btst	#6,obStatus(a0)
		bne.s	.hit
		cmpi.b	#2,$3C(a0)
		bne.s	.negate
		move.b	#1,$3C(a0)
		
	.negate:
		neg.w	obVelY(a0)	; reverse Sonic's y-motion

	.hit:
		addq.b	#2,obRoutine(a1) ; advance the monitor's routine counter

	.donothing:
		rts	
; ===========================================================================

React_Enemy:
		tst.b	obColProp(a1)
		beq.s	.breakenemy

		neg.w	obVelX(a0)	; repel Sonic
		neg.w	obVelY(a0)
		asr	obVelX(a0)
		asr	obVelY(a0)
		clr.b	obColType(a1)
		subq.b	#1,obColProp(a1)
		bne.s	.flagnotclear
		bset	#7,obStatus(a1)

	.flagnotclear:
		rts	
; ===========================================================================

.breakenemy:
		bset	#7,obStatus(a1)
		
		moveq	#0,d0
		move.w	(v_itembonus).w,d0
		btst	#6,obStatus(a0)
		bne.s	.nobonusinc
		addq.w	#2,(v_itembonus).w ; add 2 to item bonus counter
		
	.nobonusinc:
		cmpi.w	#6,d0
		bcs.s	.bonusokay
		moveq	#6,d0		; max bonus is lvl6

	.bonusokay:
		move.w	d0,$3E(a1)
		move.w	.points(pc,d0.w),d0
		cmpi.w	#$20,(v_itembonus).w ; have 16 enemies been destroyed?
		bcs.s	.lessthan16	; if not, branch
		move.w	#1000,d0	; fix bonus to 10000
		move.w	#$A,$3E(a1)

	.lessthan16:
		bsr.w	AddPoints
		
		btst	#6,obStatus(a0)
		bne.s	.nobounce
		tst.w	obVelY(a0)
		bmi.s	.bouncedown
		move.w	obY(a0),d0
		cmp.w	obY(a1),d0
		bcc.s	.bounceup
		cmpi.b	#2,$3C(a0)
		bne.s	.negate
		move.b	#1,$3C(a0)
		
	.negate:
		neg.w	obVelY(a0)
		
	.nobounce:
		bra.s	React_EnemyKilled
; ===========================================================================

	.bouncedown:
		addi.w	#$100,obVelY(a0)
		bra.s	React_EnemyKilled

	.bounceup:
		subi.w	#$100,obVelY(a0)
		bra.s	React_EnemyKilled

.points:	dc.w 10, 20, 50, 100	; points awarded div 10

; ===========================================================================

React_EnemyKilled:
		move.b	obStatus(a0),d0
		andi.b	#%1000110,d0
		bne.s	.Explode
		cmpi.b	#id_Roll,obAnim(a0)
		beq.s	.Explode
		cmpi.b	#id_Spring,obAnim(a0)
		beq.s	.Explode
		moveq	#0,d2
		bsr.w	HurtSonic

.Explode:
		move.b	#id_ExplosionItem,(a1) ; change object to explosion
		clr.b	obRoutine(a1)
		rts
		
; ---------------------------------------------------------------------------

React_Caterkiller:
		bset	#7,obStatus(a1)
		moveq	#1,d2
		bra.w	HurtSonic

React_NoHurt:
		rts	
; End of function ReactToItem

; ---------------------------------------------------------------------------
; Subroutine to	kill Sonic
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


KillSonic:
		move.w	a1,-(sp)
		lea	CBPCM_Stop,a1
		jsr	CallSubFunction
		movea.w	(sp)+,a1
		
		clr.b	health.w
		clr.b	tireLeak.w
		bsr.w	Sonic_RevertSuper
		
		move.b	#6,obRoutine(a0)
		move.l	#Map_ExplodeBomb,obMap(a0)
		move.w	#$5A0,obGfx(a0)
		move.w	#v_spritequeue+$80,obPriority(a0)
		move.b	#$C,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		clr.b	obFrame(a0)
		
		moveq	#$FFFFFF00|sfx_Bomb,d0
		jsr	(PlaySound_Special).l

		bset	#7,obGfx(a0)

	.dontdie:
		rts	
; End of function KillSonic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


React_Special:
		move.b	obColType(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$B,d1		; is collision type $CB	?
		beq.s	.caterkiller	; if yes, branch
		cmpi.b	#$C,d1		; is collision type $CC	?
		beq.s	.yadrin		; if yes, branch
		cmpi.b	#$17,d1		; is collision type $D7	?
		beq.s	.D7orE1		; if yes, branch
		cmpi.b	#$21,d1		; is collision type $E1	?
		beq.s	.D7orE1		; if yes, branch
		rts	
; ===========================================================================

.caterkiller:
		bra.w	React_Caterkiller
; ===========================================================================

.yadrin:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	.normalenemy
		move.w	obX(a1),d0
		subq.w	#4,d0
		btst	#0,obStatus(a1)
		beq.s	.noflip
		subi.w	#$10,d0

	.noflip:
		sub.w	d2,d0
		bcc.s	.loc_1B13C
		addi.w	#$18,d0
		bcs.s	.loc_1B140
		bra.s	.normalenemy
; ===========================================================================

	.loc_1B13C:
		cmp.w	d4,d0
		bhi.s	.normalenemy

	.loc_1B140:
		moveq	#HAZARD_SPIKE,d0
		moveq	#$40,d1
		moveq	#1,d2
		bra.w	HurtSonic2
; ===========================================================================

	.normalenemy:
		bra.w	React_Enemy
; ===========================================================================

.D7orE1:
		addq.b	#1,obColProp(a1)
		rts	
; End of function React_Special

; ---------------------------------------------------------------------------
; Hurting Sonic	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HurtSonic:
		tst.b	superFlag.w
		bne.s	HurtTypeHandlers
		btst	#LSD_MODE,effectFlags.w
		bne.s	HurtTypeHandlers

		moveq	#0,d0
		move.b	(a1),d0
		add.w	d0,d0

		move.l	a2,-(sp)
		lea	HazardTypes-2(pc),a2
		move.b	1(a2,d0.w),d1
		move.b	(a2,d0.w),d0
		move.l	(sp)+,a2
		
HurtSonic2:
		andi.w	#$FF,d0
		add.b	d0,d0
		jmp	HurtTypeHandlers(pc,d0.w)
		
; ---------------------------------------------------------------------------

HurtTypeHandlers:
		rts
		bra.s	.Normal
		bra.s	.Spike
		bra.s	.Normal
		bra.w	.Orbinaut
		
; ---------------------------------------------------------------------------

.Normal:
		tst.w	flashtime(a0)
		bne.s	.NoDamage
		
.DoDamage:
		btst	#RAVE_MODE,effectFlags.w
		beq.s	.SubHealth
		lsr.b	#1,d1
		
.SubHealth:
		sub.b	d1,health.w
		bcs.w	KillSonic
		move.w	#120,flashtime(a0)
		
		tst.b	d2
		beq.s	.NoRepel

		move.w	#-$100,d1
		tst.w	obVelX(a1)
		beq.s	.CheckPos
		bmi.s	.SetXVel
		neg.w	d1
		bra.s	.SetXVel

.CheckPos:
		move.w	obX(a0),d0
		cmp.w	obX(a1),d0
		blo.s	.SetXVel
		neg.w	d1

.SetXVel:
		move.w	d1,obVelX(a0)
		move.w	#-$400,obVelY(a0)
		ori.b	#%110,obStatus(a0)
		move.b	#2,$3C(a0)
		bset	#4,obStatus(a0)

.NoRepel:
		cmpi.b	#sfx_BreakItem,(v_snddriver_ram+v_soundqueue1).w
		beq.s	.NoDamage
		moveq	#$FFFFFF00|sfx_Death,d0
		jmp	PlaySound_Special

.NoDamage:
		rts

; ---------------------------------------------------------------------------

.Spike:
		btst	#6,obStatus(a0)
		bne.w	.Normal
		
		bset	#0,tireLeak.w
		beq.s	.StartLeak
		tst.w	flashtime(a0)
		bne.s	.NoDamage
		
.StartLeak:
		subq.b	#8,tirePressure.w
		btst	#RAVE_MODE,effectFlags.w
		beq.s	.PlayPopSound
		addq.b	#4,tirePressure.w
		
.PlayPopSound:
		moveq	#$FFFFFF00|sfx_BreakItem,d0
		jsr	PlaySound_Special
		
		bra.w	.Normal
		
; ---------------------------------------------------------------------------

.Orbinaut:
		move.b	obColType(a0),d0
		andi.b	#$C0,d0
		beq.w	.Normal
		bra.s	.Spike

; ---------------------------------------------------------------------------
; Hazard types
; ---------------------------------------------------------------------------

HazardTypes:
		dc.b	HAZARD_NONE,    $00		; SonicPlayer
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; PathSwapper
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NORMAL,  $40		; MrRogers
		dc.b	HAZARD_NONE,    $00		; SecretWarp
		dc.b	HAZARD_NONE,    $00		; Splash
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; DrownCount
		dc.b	HAZARD_NONE,    $00		; Pole
		dc.b	HAZARD_NONE,    $00		; FlapDoor
		dc.b	HAZARD_NONE,    $00		; Signpost
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; Bridge
		dc.b	HAZARD_NONE,    $00		; SpinningLight
		dc.b	HAZARD_NONE,    $00		; LavaMaker
		dc.b	HAZARD_BURN,    $38		; LavaBall
		dc.b	HAZARD_SPIKE,   $50		; SwingingPlatform
		dc.b	HAZARD_SPIKE,   $38		; Harpoon
		dc.b	HAZARD_SPIKE,   $38		; Helix
		dc.b	HAZARD_NONE,    $00		; BasicPlatform
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; CollapseLedge
		dc.b	HAZARD_NONE,    $00		; WaterSurface
		dc.b	HAZARD_NONE,    $00		; Scenery
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NORMAL,  $38		; BallHog
		dc.b	HAZARD_NORMAL,  $38		; Crabmeat
		dc.b	HAZARD_NORMAL,  $38		; Cannonball
		dc.b	HAZARD_NONE,    $00		; HUD
		dc.b	HAZARD_NORMAL,  $38		; BuzzBomber
		dc.b	HAZARD_NORMAL,  $38		; Missile
		dc.b	HAZARD_NONE,    $00		; MissileDissolve
		dc.b	HAZARD_NONE,    $00		; Rings
		dc.b	HAZARD_NONE,    $00		; Monitor
		dc.b	HAZARD_NONE,    $00		; ExplosionItem
		dc.b	HAZARD_NONE,    $00		; Animals
		dc.b	HAZARD_NONE,    $00		; Points
		dc.b	HAZARD_NONE,    $00		; AutoDoor
		dc.b	HAZARD_NORMAL,  $38		; Chopper
		dc.b	HAZARD_NORMAL,  $38		; Jaws
		dc.b	HAZARD_NORMAL,  $38		; Burrobot
		dc.b	HAZARD_NONE,    $00		; PowerUp
		dc.b	HAZARD_NONE,    $00		; LargeGrass
		dc.b	HAZARD_NONE,    $00		; GlassBlock
		dc.b	HAZARD_SPIKE,   $38		; ChainStomp
		dc.b	HAZARD_NONE,    $00		; Button
		dc.b	HAZARD_NONE,    $00		; PushBlock
		dc.b	HAZARD_NONE,    $00		; TitleCard
		dc.b	HAZARD_BURN,    $38		; GrassFire
		dc.b	HAZARD_SPIKE,   $38		; Spikes
		dc.b	HAZARD_NONE,    $00		; RingLoss
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; GameOverCard
		dc.b	HAZARD_NONE,    $00		; GotThroughCard
		dc.b	HAZARD_NONE,    $00		; PurpleRock
		dc.b	HAZARD_NONE,    $00		; SmashWall
		dc.b	HAZARD_NONE,    $00		; BossGreenHill
		dc.b	HAZARD_NONE,    $00		; Prison
		dc.b	HAZARD_NONE,    $00		; ExplosionBomb
		dc.b	HAZARD_NORMAL,  $38		; MotoBug
		dc.b	HAZARD_NONE,    $00		; Springs
		dc.b	HAZARD_NORMAL,  $38		; Newtron
		dc.b	HAZARD_NORMAL,  $38		; Roller
		dc.b	HAZARD_NONE,    $00		; EdgeWalls
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; MarbleBrick
		dc.b	HAZARD_NONE,    $00		; Bumper
		dc.b	HAZARD_NORMAL,  $50		; BossBall
		dc.b	HAZARD_NONE,    $00		; WaterSound
		dc.b	HAZARD_NONE,    $00		; VanishSonic
		dc.b	HAZARD_NONE,    $00		; GiantRing
		dc.b	HAZARD_NONE,    $00		; GeyserMaker
		dc.b	HAZARD_BURN,    $38		; LavaGeyser
		dc.b	HAZARD_BURN,    $38		; LavaWall
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NORMAL,  $38		; Yadrin
		dc.b	HAZARD_NONE,    $00		; SmashBlock
		dc.b	HAZARD_NONE,    $00		; MovingBlock
		dc.b	HAZARD_NONE,    $00		; CollapseFloor
		dc.b	HAZARD_BURN,    $38		; LavaTag
		dc.b	HAZARD_NORMAL,  $38		; Basaran
		dc.b	HAZARD_NORMAL,  $38		; FloatingBlock
		dc.b	HAZARD_SPIKE,   $38		; SpikeBall
		dc.b	HAZARD_SPIKE,   $38		; BigSpikeBall
		dc.b	HAZARD_NONE,    $00		; Elevator
		dc.b	HAZARD_NONE,    $00		; CirclingPlatform
		dc.b	HAZARD_NONE,    $00		; Staircase
		dc.b	HAZARD_NONE,    $00		; Pylon
		dc.b	HAZARD_NONE,    $00		; Fan
		dc.b	HAZARD_SPECIAL, $38		; Seesaw
		dc.b	HAZARD_NORMAL,  $38		; Bomb
		dc.b	HAZARD_SPECIAL, $38		; Orbinaut
		dc.b	HAZARD_NONE,    $00		; LabyrinthBlock
		dc.b	HAZARD_BURN,    $38		; Gargoyle
		dc.b	HAZARD_NONE,    $00		; LabyrinthConvey
		dc.b	HAZARD_NONE,    $00		; Bubble
		dc.b	HAZARD_NONE,    $00		; Waterfall
		dc.b	HAZARD_NONE,    $00		; Junction
		dc.b	HAZARD_NONE,    $00		; RunningDisc
		dc.b	HAZARD_NONE,    $00		; Conveyor
		dc.b	HAZARD_NONE,    $00		; SpinPlatform
		dc.b	HAZARD_SPIKE,   $38		; Saws
		dc.b	HAZARD_NONE,    $00		; ScrapStomp
		dc.b	HAZARD_NONE,    $00		; VanishPlatform
		dc.b	HAZARD_BURN,    $38		; Flamethrower
		dc.b	HAZARD_NORMAL,  $38		; Electro
		dc.b	HAZARD_NONE,    $00		; SpinConvey
		dc.b	HAZARD_NONE,    $00		; Girder
		dc.b	HAZARD_NONE,    $00		; Invisibarrier
		dc.b	HAZARD_NONE,    $00		; Teleport
		dc.b	HAZARD_NONE,    $00		; BossMarble
		dc.b	HAZARD_BURN,    $38		; BossFire
		dc.b	HAZARD_SPECIAL, $00		; BossSpringYard
		dc.b	HAZARD_NONE,    $00		; BossBlock
		dc.b	HAZARD_NONE,    $00		; BossLabyrinth
		dc.b	HAZARD_NORMAL,  $38		; Caterkiller
		dc.b	HAZARD_NONE,    $00		; Lamppost
		dc.b	HAZARD_NONE,    $00		; BossStarLight
		dc.b	HAZARD_SPIKE,   $38		; BossSpikeball
		dc.b	HAZARD_NONE,    $00		; RingFlash
		dc.b	HAZARD_NONE,    $00		; HiddenBonus
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; NullObject
		dc.b	HAZARD_NONE,    $00		; ScrapEggman
		dc.b	HAZARD_NONE,    $00		; FalseFloor
		dc.b	HAZARD_NONE,    $00		; EggmanCylinder
		dc.b	HAZARD_NONE,    $00		; BossFinal
		dc.b	HAZARD_NORMAL,  $38		; BossPlasma
		dc.b	HAZARD_NONE,    $00		; EndSonic
		dc.b	HAZARD_NONE,    $00		; EndChaos
		dc.b	HAZARD_NONE,    $00		; EndSTH
		dc.b	HAZARD_NONE,    $00		; CreditsText
		dc.b	HAZARD_NONE,    $00		; EndEggman
		dc.b	HAZARD_NONE,    $00		; TryChaos
		even

; ---------------------------------------------------------------------------
