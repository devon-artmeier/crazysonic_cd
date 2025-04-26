; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

	include	"src/include/sub_cpu.inc"
	include	"src/include/sub_program.inc"
	include	"src/hk97/field.inc"

	org	PRG_START+$10000

; -------------------------------------------------------------------------
; Constants
; -------------------------------------------------------------------------

GRAZE_RADIUS		EQU	6				; Graze radius
BOMB_DUR		EQU	75				; Bomb time duration
LEVEL_DUR		EQU	60*60				; Level time duration
LIFE_COUNT		EQU	3				; Number of lives
	
; -------------------------------------------------------------------------
; Shared memory
; -------------------------------------------------------------------------

	rsset	WORD_START_1M+$10000
	include	"src/hk97/shared.inc"
	
; -------------------------------------------------------------------------
; Actor structure
; -------------------------------------------------------------------------

	rsreset
aAddr		rs.l	1					; Actor code address
aX		rs.l	1					; X
aY		rs.l	1					; Y
aXVel		rs.w	1					; X velocity
aYVel		rs.w	1					; Y velocity
aAnimTime	rs.w	1					; Animation timer
aShootDelay	rs.b	1					; Shoot delay
aCollideable	rs.b	1					; Collideable flag
aVar0		rs.b	1					; Misc. variables
aVar1		rs.b	1
aVar2		rs.b	1
aVar3		rs.b	1
aVar4		rs.b	1
aVar5		rs.b	1
aVar6		rs.b	1
aVar7		rs.b	1
aVar8		rs.b	1
aVar9		rs.b	1
aVar10		rs.b	1
aVar11		rs.b	1
aVar12		rs.b	1
aVar13		rs.b	1
aVar14		rs.b	1
aVar15		rs.b	1
aSize		rs.b	0					; Structure size
	
; -------------------------------------------------------------------------
; Enemy flags
; -------------------------------------------------------------------------

aEnemyShot	EQU	aVar0					; Shoot timer/flag
aEnemyHealth	EQU	aVar2					; Health
aEnemyRadX	EQU	aVar4					; X radius
aEnemyRadY	EQU	aVar5					; Y radius
aEnemyScore	EQU	aVar6					; Score

; -------------------------------------------------------------------------
; Bullet structure
; -------------------------------------------------------------------------

	rsreset
bActive		rs.b	1					; Active flag
bGrazed		rs.b	1					; Grazed flag
bX		rs.l	1					; X
bY		rs.l	1					; Y
bXVel		rs.w	1					; X velocity
bYVel		rs.w	1					; Y velocity
bSize		rs.b	0					; Structure size

; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

HongKong97:
	moveq	#0,d1						; Clear communication statues
	move.l	d1,COMM_STAT_0.w
	move.l	d1,COMM_STAT_2.w
	move.l	d1,COMM_STAT_4.w
	move.l	d1,COMM_STAT_6.w

	lea	WORD_START_2M,a0				; Clear Word RAM
	move.w	#WORD_SIZE_2M/16-1,d0

.ClearWordRAM:
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbf	d0,.ClearWordRAM

	SET_1M_MODE						; Set to 1M/1M mode

	jsr	StopAllPCM					; Stop all PCM channels

	lea	PCM_PlayerShoot(pc),a0				; Load PCM samples
	move.w	#PCM_PlayerShoot_End-PCM_PlayerShoot,d0
	moveq	#0,d1
	jsr	LoadPCMSample

	lea	PCM_EnemyDie(pc),a0
	move.w	#PCM_EnemyDie_End-PCM_EnemyDie,d0
	move.w	#$400,d1
	jsr	LoadPCMSample

	lea	PCM_PlayerDie(pc),a0
	move.w	#PCM_PlayerDie_End-PCM_PlayerDie,d0
	move.w	#$2500,d1
	jsr	LoadPCMSample

	lea	PCM_Bomb,a0
	move.w	#PCM_Bomb_End-PCM_Bomb,d0
	move.w	#$4300,d1
	jsr	LoadPCMSample
	
	lea	PCM_Blank,a0
	move.w	#PCM_Blank_End-PCM_Blank,d0
	move.w	#$F000,d1
	jsr	LoadPCMSample
	
	moveq	#0,d0						; Set up PCM1
	moveq	#$FFFFFF90,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#0>>8,d1
	jsr	SetPCMStart
	move.w	#$F000,d1
	jsr	SetPCMLoop
	
	moveq	#1,d0						; Set up PCM2
	moveq	#$FFFFFF90,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#$400>>8,d1
	jsr	SetPCMStart
	move.w	#$F000,d1
	jsr	SetPCMLoop
	
	moveq	#2,d0						; Set up PCM3
	moveq	#$FFFFFF90,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#$2500>>8,d1
	jsr	SetPCMStart
	move.w	#$F000,d1
	jsr	SetPCMLoop
	
	moveq	#3,d0						; Set up PCM4
	moveq	#$FFFFFF90,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#$4300>>8,d1
	jsr	SetPCMStart
	move.w	#$F000,d1
	jsr	SetPCMLoop
	
	lea	cddaParam(pc),a0				; Play music
	BIOS_MSCPLAYR

.WaitCDDA:
	BIOS_CDBSTAT						; Get BIOS status
	move.w	(a0),d0
	bmi.s	.WaitCDDA					; If the CD isn't ready, wait
	andi.w	#$FF00,d0					; Is CDDA playing?
	cmpi.w	#$100,d0
	bne.s	.WaitCDDA					; If not, wait

	moveq	#2-1,d1						; Initialize HUD

.InitHUD:
	move.l	curScore(pc),hudScore
	move.b	lives(pc),hudLives
	move.b	bombs(pc),hudBombs
	move.w	graze(pc),hudGraze
	st	hudFlags
	SWAP_WORD_BANKS
	dbf	d1,.InitHUD
	
	move.b	#"R",COMM_STAT_0.w				; Mark as ready
	
; -------------------------------------------------------------------------

.WaitCommand:
	moveq	#0,d0						; Wait for command
	move.b	COMM_CMD_0.w,d0
	beq.s	.WaitCommand

	move.b	#"B",COMM_STAT_0.w				; Mark as busy

	tst.b	d0						; Are we exiting?
	bmi.s	.Exit						; If so, branch
	add.w	d0,d0						; Go to command
	add.w	d0,d0
	jsr	.Commands-4(pc,d0.w)
	
.WaitMain:
	tst.b	COMM_CMD_0.w					; Is the Main CPU ready to send commands again?
	bne.s	.WaitMain					; If not, branch
	
	move.b	#"R",COMM_STAT_0.w				; Mark as ready
	bra.s	.WaitCommand					; Loop

.Exit:
	BIOS_MSCSTOP						; Stop music
	jsr	StopAllPCM					; Stop all PCM channels
	
	SET_2M_MODE						; Set to 2M mode
	rts

; -------------------------------------------------------------------------
; Commands
; -------------------------------------------------------------------------

.Commands:
	bra.w	DoUpdates					; Do updates
	bra.w	PauseMusic					; Pause music
	bra.w	UnpauseMusic					; Unpause music

; -------------------------------------------------------------------------
; Pause music
; -------------------------------------------------------------------------

PauseMusic:
	BIOS_MSCPAUSEON						; Pause CDDA
	jmp	PauseAllPCM					; Pause PCM

; -------------------------------------------------------------------------
; Unpause music
; -------------------------------------------------------------------------

UnpauseMusic:
	BIOS_MSCPAUSEOFF					; Unpause CDDA
	jmp	UnpauseAllPCM					; Unpause PCM

; -------------------------------------------------------------------------
; Do updates
; -------------------------------------------------------------------------

DoUpdates:
	clr.b	gameOver					; Clear flags
	clr.b	bossCutscene
	move.b	COMM_CMD_3.w,palChange				; Update palette change flag

	lea	WORD_START_1M,a0				; Clear buffer
	move.l	#$10000/(256*4)-1,d0
	moveq	#0,d1

.ClearBuffer:
	rept	256
		move.l	d1,(a0)+
	endr
	dbf	d0,.ClearBuffer

; -------------------------------------------------------------------------

.UpdateScore:
	move.l	curScore(pc),d0					; Update score
	cmp.l	score(pc),d0
	beq.s	.SpawnPlayer
	bcs.s	.IncScore
	move.l	score(pc),curScore
	bra.s	.UpdateHUDScore

.IncScore:
	sub.l	score(pc),d0
	neg.l	d0
	lsr.l	#3,d0
	bne.s	.DoIncScore
	moveq	#1,d0

.DoIncScore:
	add.l	d0,curScore
	move.l	curScore(pc),d0
	cmp.l	score(pc),d0
	bcs.s	.UpdateHUDScore
	move.l	score,curScore

.UpdateHUDScore:
	bset	#0,hudFlags					; Update HUD

; -------------------------------------------------------------------------

.SpawnPlayer:
	tst.b	COMM_CMD_2.w					; Are we respawning from a game over?
	beq.s	.NoGameOverRespawn				; If not, branch
	clr.b	respawnTimer					; Reset respawn timer
	move.b	#LIFE_COUNT,lives				; Reset lives
	bset	#1,hudFlags					; Update HUD

.NoGameOverRespawn:
	cmpi.l	#ActorPlayer,actors+aAddr			; Is the player loaded?
	beq.s	.CheckLevelTime					; If so, branch
	subq.b	#1,respawnTimer					; Handle respawn timer
	bpl.s	.CheckLevelTime
	move.b	#60,respawnTimer

	tst.b	lives						; Have we run out of lives?
	beq.s	.GameOver					; If so, branch
	bpl.s	.DoSpawnPlayer					; If not, branch
	
.GameOver:
	st	gameOver					; Set game over flag
	bra.w	.Exit

.DoSpawnPlayer:
	move.l	#ActorPlayer,actors+aAddr			; Spawn player
	move.w	#IMG_WIDTH/2,actors+aX
	move.w	#$90,actors+aY

	move.b	#3,bombs					; Reset bombs
	bset	#2,hudFlags					; Update HUD

; -------------------------------------------------------------------------

.CheckLevelTime:
	tst.b	bossStarted					; Has the boss already started?
	bne.w	.RunActors					; If so, branch
	
	cmpi.w	#150,levelTime					; Is it about time for the boss to start?
	bcc.w	.SpawnReds					; If not, branch

	tst.w	levelTime					; Is it actually time for the boss to start?
	beq.s	.StartBoss					; If so, branch
	subq.w	#1,levelTime					; Decrement level time
	bra.w	.RunActors

.StartBoss:
	tst.l	actors+aSize+aAddr				; Spawn boss
	bne.w	.RunActors
	move.l	#ActorBoss,actors+aSize+aAddr
	bra.w	.RunActors

; -------------------------------------------------------------------------

.SpawnReds:
	tst.b	COMM_CMD_6.w					; Check skip cheat
	beq.s	.NoSkip
	move.w	#150-1,levelTime

.NoSkip:
	subq.w	#1,levelTime					; Decrement level time

	subq.b	#1,spawnDelay					; Handle delay
	bpl.w	.RunActors
	move.b	#45,spawnDelay					; If not, set the spawn delay and spawn more

	bsr.w	FindFreeActorSlot				; Find the first free actor slot
	bcs.s	.RunActors

.GetTypes:
	bsr.w	Random						; Get red types
	andi.w	#7,d0
	lsl.w	#3,d0
	lea	UglyRedActors(pc),a0
	lea	(a0,d0.w),a0

	move.w	#2-1,d2						; Spawn 2 reds
	move.w	#32,d3						; Red 1's X position base

.SpawnLoop:
	move.l	(a0)+,aAddr(a6)					; Spawn red

	bsr.w	Random						; Get random X position
	andi.w	#$1F,d0
	subi.w	#16,d0
	add.w	d3,d0

	move.w	d0,aX(a6)					; Set X position
	move.w	#-32,aY(a6)					; Set Y position

	bsr.w	FindNextFreeActorSlot				; Find next free actor slot
	bcs.s	.RunActors

	move.w	#IMG_WIDTH-32,d3				; Red 2's X position base
	dbf	d2,.SpawnLoop					; Loop until reds have been spawned

; -------------------------------------------------------------------------

.RunActors:
	lea	spritesExt,a1					; Sprite buffer
	moveq	#1,d5

	lea	actors(pc),a0					; Run actors
	move.w	#(actorsEnd-actors)/aSize-1,d7

.RunActorsLoop:
	move.l	aAddr(a0),d0					; Get code address
	beq.s	.NextActor					; If this actor isn't loaded, branch
	movea.l	d0,a2						; Run this actor
	jsr	(a2)

.NextActor:
	lea	aSize(a0),a0					; Get next actor
	dbf	d7,.RunActorsLoop				; Loop until all actors have been run

	lea	-8(a1),a1					; Mark last sprite
	cmpa.l	#spritesExt,a1
	bcc.s	.LastSprite
	lea	spritesExt,a1
	clr.w	(a1)

.LastSprite:
	clr.b	3(a1)

; -------------------------------------------------------------------------

.CheckBombing:
	tst.w	bombTime					; Are we bombing?
	beq.s	.CheckBossDefeat				; If not, branch

	subq.w	#1,bombTime					; Decrement bomb time
	cmpi.w	#15,bombTime					; Is the bomb ending?
	beq.s	.EndBomb					; If not, branch
	cmpi.w	#BOMB_DUR-1,bombTime				; Is the bomb starting?
	bne.s	.CheckBossDefeat				; If not, branch

.StartBomb:
	move.b	#$A,palChange					; Fade background to white

	lea	bullets(pc),a0
	move.w	#(bulletsEnd-bullets)/bSize-1,d0

.ClearBullets:
	rept	bSize/4
		clr.l	(a0)+
	endr
	if bSize&2
		clr.w	(a0)+
	endif
	dbf	d0,.ClearBullets

	bra.s	.CheckBossDefeat

.EndBomb:
	tst.b	bossDefeated					; Was the boss defeated?
	bne.s	.CheckBossDefeat				; If so, branch
	move.b	#$C,palChange					; Fade background from white

; -------------------------------------------------------------------------

.CheckBossDefeat:
	tst.b	bossDefeated					; Was the boss defeated?
	beq.s	.UpdateMainFlags				; If not, branch
	subq.b	#1,bossDefeated					; Handle boss defeated timer
	bne.s	.UpdateMainFlags
	st	gameWon						; Mark game as won

; -------------------------------------------------------------------------

.UpdateMainFlags:
	move.l	curScore(pc),hudScore				; Update Main CPU variables
	move.b	lives(pc),hudLives
	move.b	bombs(pc),hudBombs
	move.w	graze(pc),hudGraze

; -------------------------------------------------------------------------

.UpdateBullets:
	tst.b	bossDefeated					; Was the boss defeated?
	bne.w	.Exit						; If so, branch

	lea	IMAGE_START,a0					; Update bullets
	lea	bullets(pc),a1
	lea	Art_PlayerBullet(pc),a2
	
	move.w	#(playerBulletsEnd-playerBullets)/bSize-1,d7
	moveq	#2-1,d6

.BulletsLoop:
	tst.b	bActive(a1)					; Is this bullet active?
	beq.w	.NextBullet					; If not, branch

	moveq	#0,d0						; Get X
	move.w	bX(a1),d0
	addq.w	#8-2,d0
	cmpi.w	#-32,d0
	blt.w	.DespawnBullet
	cmpi.w	#IMG_WIDTH+8+32,d0
	bgt.w	.DespawnBullet
	tst.w	d0
	bmi.w	.MoveBullet
	cmpi.w	#IMG_WIDTH+8,d0
	bgt.w	.MoveBullet

	moveq	#0,d1						; Get Y
	move.w	bY(a1),d1
	addq.w	#8-2,d1
	cmpi.w	#-32,d1
	blt.w	.DespawnBullet
	cmpi.w	#(IMG_HEIGHT+4)+8+32,d1
	bgt.w	.DespawnBullet
	tst.w	d1
	bmi.w	.MoveBullet
	cmpi.w	#(IMG_HEIGHT+4)+8,d1
	bgt.w	.MoveBullet
	lsl.l	#8,d1
	lsl.l	#1,d1

	btst	#0,d0						; Is the X position odd?
	bne.w	.BulletOddX

; -------------------------------------------------------------------------

.BulletEvenX:
	add.l	d1,d0						; Get buffer pointer
	lea	(a0,d0.l),a4

	movea.l	a2,a3						; Draw bullet
	rept	3
		move.l	(a3)+,d1
		and.l	d1,(a4)
		move.l	(a3)+,d1
		or.l	d1,(a4)
		lea	512(a4),a4
	endr
	move.l	(a3)+,d1
	and.l	d1,(a4)
	move.l	(a3)+,d1
	or.l	d1,(a4)
	
	bra.s	.MoveBullet					; Start moving the bullet

; -------------------------------------------------------------------------

.DespawnBullet:
	clr.b	bActive(a1)					; Mark bullet as inactive
	clr.b	bGrazed(a1)					; Mark bullet as not grazed
	bra.s	.NextBullet					; Start handling next bullet

; -------------------------------------------------------------------------

.BulletOddX:
	add.l	d1,d0						; Get buffer pointer
	lea	-1(a0,d0.l),a4

	lea	$20(a2),a3					; Draw bullet
	rept	3
		move.l	(a3)+,d1
		and.l	d1,(a4)
		move.l	(a3)+,d1
		or.l	d1,(a4)+
		move.w	(a3)+,d1
		and.w	d1,(a4)
		move.w	(a3)+,d1
		or.w	d1,(a4)
		lea	512-4(a4),a4
	endr
	move.l	(a3)+,d1
	and.l	d1,(a4)
	move.l	(a3)+,d1
	or.l	d1,(a4)+
	move.w	(a3)+,d1
	and.w	d1,(a4)
	move.w	(a3)+,d1
	or.w	d1,(a4)
	
; -------------------------------------------------------------------------

.MoveBullet:
	move.w	bXVel(a1),d0					; Apply velocity
	ext.l	d0
	asl.l	#8,d0
	move.w	bYVel(a1),d1
	ext.l	d1
	asl.l	#8,d1
	add.l	d0,bX(a1)
	add.l	d1,bY(a1)

; -------------------------------------------------------------------------

.NextBullet:
	lea	bSize(a1),a1					; Next bullet
	dbf	d7,.BulletsLoop					; Loop until all bullets are rendered
	
	lea	Art_EnemyBullet(pc),a2				; Do enemy bullets next
	move.w	#(enemyBulletsEnd-enemyBullets)/bSize-1,d7
	dbf	d6,.BulletsLoop

; -------------------------------------------------------------------------

.Exit:
.WaitMain:
	tst.b	COMM_CMD_0.w					; Is the Main CPU done?
	bne.s	.WaitMain					; If not, branch

	SWAP_WORD_BANKS						; Swap Word RAM banks
	rts

; -------------------------------------------------------------------------
; Calculate sine and cosine
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Angle
; RETURNS:
;	d0.w - Sine
;	d1.w - Cosine
; -------------------------------------------------------------------------

	include	"src/libraries/CalcSine.asm"

; -------------------------------------------------------------------------
; Get a random number
; -------------------------------------------------------------------------
; RETURNS:
;	d0.l - Random number
; -------------------------------------------------------------------------

Random:
	move.l	rngSeed(pc),d1					; Get seed
	bne.s	.RNG
	move.l	#$2A6D365A,d1

.RNG:
	move.l	d1,d0						; Get random number
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1
	move.l	d0,-(sp)
	move.l	4(sp),d0
	eor.l	d0,d1
	move.l	(sp)+,d0
	move.l	d1,rngSeed
	rts

; -------------------------------------------------------------------------
; Bullet art
; -------------------------------------------------------------------------

Art_PlayerBullet:
	dc.l	$FF0000FF, $000D0F00
	dc.l	$00000000, $0D0F0D0F
	dc.l	$00000000, $0F0D0F0D
	dc.l	$FF0000FF, $000F0D00
	
	dc.l	$FFFF0000, $00000D0F
	dc.w	$FFFF,     $0000
	dc.l	$FF000000, $000D0F0D
	dc.w	$00FF,     $0F00
	dc.l	$FF000000, $000F0D0F
	dc.w	$00FF,     $0D00
	dc.l	$FFFF0000, $00000F0D
	dc.w	$FFFF,     $0000
	
Art_EnemyBullet:
	dc.l	$FF0000FF, $000D0D00
	dc.l	$00000000, $0D0D0D0D
	dc.l	$00000000, $0D0D0D0D
	dc.l	$FF0000FF, $000D0D00
	
	dc.l	$FFFF0000, $00000D0D
	dc.w	$FFFF,     $0000
	dc.l	$FF000000, $000D0D0D
	dc.w	$00FF,     $0D00
	dc.l	$FF000000, $000D0D0D
	dc.w	$00FF,     $0D00
	dc.l	$FFFF0000, $00000D0D
	dc.w	$FFFF,     $0000

; -------------------------------------------------------------------------
; Ugly reds
; -------------------------------------------------------------------------

UglyRedActors:
	dc.l	ActorUglyRed1, ActorUglyRed3
	dc.l	ActorUglyRed2, ActorUglyRed1
	dc.l	ActorUglyRed3, ActorUglyRed2
	dc.l	ActorUglyRed2, ActorUglyRed2
	dc.l	ActorUglyRed3, ActorUglyRed1
	dc.l	ActorUglyRed1, ActorUglyRed2
	dc.l	ActorUglyRed2, ActorUglyRed3
	dc.l	ActorUglyRed3, ActorUglyRed3

; -------------------------------------------------------------------------
; Find free actor slot
; -------------------------------------------------------------------------
; PARAMETERS:
;	d6.w	- Number of actors that can be checked further
;	a6.l	- Pointer to actor bullet slot
; RETURNS:
;	cs/cc	- No slots available/Slot available
; -------------------------------------------------------------------------

FindFreeActorSlot:
	lea	actors+(aSize*2)(pc),a6				; Find a free slot
	move.w	#(actorsEnd-actors)/aSize-3,d6

; -------------------------------------------------------------------------

FindNextFreeActorSlot:
	tst.b	d6						; Have we run out of slots to check
	bmi.s	.NotFound					; If so, branch

.FindSlot:
	tst.l	aAddr(a6)					; Is this slot available?
	beq.s	.Found						; If so, branch
	lea	aSize(a6),a6					; Next bullet
	dbf	d6,.FindSlot					; Keep finding slots

.NotFound:
	ori	#1,sr						; No slot found
	rts

.Found:
	andi	#~1,sr						; Found a slot
	rts

; -------------------------------------------------------------------------
; Find free bullet slot
; -------------------------------------------------------------------------
; PARAMETERS:
;	d6.w	- Number of bullets that can be checked further
;	a6.l	- Pointer to free bullet slot
; RETURNS:
;	cs/cc	- No slots available/Slot available
; -------------------------------------------------------------------------

FindFreePlayerBullet:
	lea	playerBullets(pc),a6				; Find a free slot for player bullets
	move.w	#(playerbulletsEnd-playerBullets)/bSize-1,d6
	bra.s	FindNextFreeBullet

; -------------------------------------------------------------------------

FindFreeEnemyBullet:
	lea	enemyBullets(pc),a6				; Find a free slot for enemy bullets
	move.w	#(enemybulletsEnd-enemyBullets)/bSize-1,d6

; -------------------------------------------------------------------------

FindNextFreeBullet:
	tst.w	d6						; Have we run out of slots to check
	bmi.s	.NotFound					; If so, branch

.FindSlot:
	tst.b	bActive(a6)					; Is this slot available?
	beq.s	.Found						; If so, branch
	lea	bSize(a6),a6					; Next bullet
	dbf	d6,.FindSlot					; Keep finding slots

.NotFound:
	ori	#1,sr						; No slot found
	rts

.Found:
	andi	#~1,sr						; Found a slot
	rts

; -------------------------------------------------------------------------
; Explosion actor
; -------------------------------------------------------------------------

ActorExplosion:
	clr.b	aCollideable(a0)				; Not collideable
	move.w	#30,aAnimTime(a0)				; Set animation timer
	move.l	#.Main,aAddr(a0)				; Update code address

; -------------------------------------------------------------------------

.Main:
	move.w	aY(a0),d0					; Draw sprite
	addi.w	#128-12+24,d0
	move.w	d0,(a1)+

	move.b	#$A,(a1)+
	move.b	d5,(a1)+
	addq.b	#1,d5
	move.w	#(($DE80+$1C00)/$20)+$4000,d0
	btst	#1,aAnimTime+1(a0)
	beq.s	.NoFlip
	ori.w	#$800,d0

.NoFlip:
	move.w	d0,(a1)+

	move.w	aX(a0),d0
	addi.w	#128-12+16,d0
	move.w	d0,(a1)+

; -------------------------------------------------------------------------

.Animate:
	subq.w	#1,aAnimTime(a0)				; Decrement animation timer
	bpl.s	.NoDelete					; If it hasn't run out, branch
	clr.l	aAddr(a0)					; Delete ourselves
	move.b	#90,aRespawnInv(a0)				; Set player's respawn invincibility timer

.NoDelete:
	rts

; -------------------------------------------------------------------------
; Check collision with enemy bullets (for player)
; -------------------------------------------------------------------------

Player_CheckBulletHit:
	tst.b	aRespawnInv(a0)					; Are we invincible?
	bne.w	.End						; If so, branch

	lea	enemyBullets(pc),a6				; Check each enemy bullet
	move.w	#(enemyBulletsEnd-enemyBullets)/bSize-1,d6

.CheckBullet:
	tst.b	bActive(a6)					; Is this bullet active?
	beq.w	.NextBullet					; If not, branch

; -------------------------------------------------------------------------

	moveq	#0,d4						; Collision flags

	move.w	aX(a0),d1					; Get left sides
	move.w	bX(a6),d0
	subi.w	#GRAZE_RADIUS,d0
	sub.w	d1,d0						; Get distance between the 2 left sides
	bcc.s	.PastLeftX					; If the bullet is past the left side of the players, branch

.NotPastLeftX:
	addi.w	#GRAZE_RADIUS*2,d0				; Is the bullet's right side past the players's left side?
	bcs.s	.WithinX					; If so, branch
	bra.w	.NoCollide					; If not, check the next bullet

.PastLeftX:
	cmpi.w	#1,d0						; Is the bullet's left side past the players's right side?
	bhi.w	.NoCollide					; If so, check the next bullet

; -------------------------------------------------------------------------

.WithinX:			
	move.w	bX(a6),d0					; Get left sides
	sub.w	aX(a0),d0					; Get distance between the 2 left sides
	bcc.s	.PastLeftX2					; If the bullet is past the left side of the players, branch

.NotPastLeftX2:
	addq.w	#2,d0						; Is the bullet's right side past the players's left side?
	bcs.s	.HitX						; If so, branch
	bra.s	.WithinX2

.PastLeftX2:
	cmpi.w	#1,d0						; Is the bullet's left side past the players's right side?
	bhi.s	.WithinX2					; If so, branch

.HitX:
	bset	#0,d4						; Set hit X flag

; -------------------------------------------------------------------------

.WithinX2:
	move.w	aY(a0),d1					; Get top sides
	move.w	bY(a6),d0
	subi.w	#GRAZE_RADIUS,d0
	sub.w	d1,d0						; Get distance between the 2 top sides
	bcc.s	.PastTopY					; If the bullet is past the top side of the players, branch

.NotPastTopY:
	addi.w	#GRAZE_RADIUS*2,d0				; Is the bullet's bottom side past the players's top side?
	bcs.s	.WithinY					; If so, branch
	bra.s	.NoCollide					; If not, check the next bullet

.PastTopY:
	cmpi.w	#1,d0						; Is the bullet's top side past the players's bottom side?
	bhi.s	.NoCollide					; If so, check the next bullet

; -------------------------------------------------------------------------

.WithinY:
	move.w	bY(a6),d0					; Get top sides
	subq.w	#1,d0
	sub.w	aY(a0),d0					; Get distance between the 2 top sides
	bcc.s	.PastTopY2					; If the bullet is past the top side of the players, branch

.NotPastTopY2:
	addq.w	#2,d0						; Is the bullet's bottom side past the players's top side?
	bcs.s	.HitY						; If so, branch
	bra.s	.WithinY2					; If not, we've hit the bullet

.PastTopY2:
	cmpi.w	#1,d0						; Is the bullet's top side past the players's bottom side?
	bhi.s	.WithinY2					; If so, branch

.HitY:
	bset	#1,d4						; Set hit Y flag

; -------------------------------------------------------------------------

.WithinY2:
	cmpi.b	#3,d4						; Are we grazing?
	bne.s	.Graze						; If so, branch
	clr.b	bActive(a6)					; Make bullet disappear
	bra.w	PlayerDie					; Die

.Graze:
	tst.b	bGrazed(a6)					; Was this bullet already grazed?
	bne.s	.NextBullet					; If so, branch
	st	bGrazed(a6)					; Set grazed flag
	addq.w	#1,graze					; Increment graze counter
	addi.l	#80,score					; Increment score
	bset	#3,hudFlags					; Update HUD
	bra.s	.NextBullet					; Check next bullet

; -------------------------------------------------------------------------

.NoCollide:
	clr.b	bGrazed(a6)					; Mark bullet as not grazed

; -------------------------------------------------------------------------

.NextBullet:
	lea	bSize(a6),a6					; Next bullet
	dbf	d6,.CheckBullet					; Loop until it's done checking

.End:
	rts

; -------------------------------------------------------------------------
; Check collision with enemy actors (for player)
; -------------------------------------------------------------------------

Player_CheckEnemyHit:
	lea	actors+aSize(pc),a6				; Check each enemy actor
	move.w	#(actorsEnd-actors)/aSize-2,d6

.CheckActor:
	tst.l	aAddr(a6)					; Is this actor loaded?
	beq.s	.NextActor					; If not, branch
	tst.b	aCollideable(a6)				; Is this actor collideable?
	beq.s	.NextActor					; If not, branch

; -------------------------------------------------------------------------

	move.w	aX(a0),d1					; Get left sides
	subq.w	#3,d1
	move.w	aX(a6),d0
	moveq	#0,d2
	move.b	aEnemyRadX(a6),d2
	sub.w	d2,d0
	sub.w	d1,d0						; Get distance between the 2 left sides
	bcc.s	.PastLeftX					; If the enemy is past the left side of the players, branch

.NotPastLeftX:
	add.w	d2,d2						; Is the enemy's right side past the players's left side?
	add.w	d2,d0
	bcs.s	.WithinX					; If so, branch
	bra.s	.NextActor					; If not, check the next enemy

.PastLeftX:
	cmpi.w	#6,d0						; Is the enemy's left side past the players's right side?
	bhi.s	.NextActor					; If so, check the next enemy

; -------------------------------------------------------------------------

.WithinX:
	move.w	aY(a0),d1					; Get top sides
	subi.w	#9,d1
	move.w	aY(a6),d0
	moveq	#0,d2
	move.b	aEnemyRadY(a6),d2
	sub.w	d2,d0
	sub.w	d1,d0						; Get distance between the 2 top sides
	bcc.s	.PastTopY					; If the enemy is past the top side of the players, branch

.NotPastTopY:
	add.w	d2,d2						; Is the enemy's bottom side past the players's top side?
	add.w	d2,d0
	bcs.s	.CheckDie					; If so, branch
	bra.s	.NextActor					; If not, check the next enemy

.PastTopY:
	cmpi.w	#18,d0						; Is the enemy's top side past the players's bottom side?
	bhi.s	.NextActor					; If so, check the next enemy
	bra.s	.CheckDie					; Die

; -------------------------------------------------------------------------

.NextActor:
	lea	aSize(a6),a6					; Next actor
	dbf	d6,.CheckActor					; Loop until it's done checking

.End:
	rts

; -------------------------------------------------------------------------

.CheckDie:
	movem.l	d6/a0,-(sp)					; Kill enemy
	moveq	#-1,d6
	movea.l	a6,a0
	bsr.w	KillEnemy
	movem.l	(sp)+,d6/a0
	
	tst.b	aRespawnInv(a0)					; Are we invincible?
	bne.s	.NextActor					; If so, branch

; -------------------------------------------------------------------------
; Make the player die
; -------------------------------------------------------------------------

PlayerDie:
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	.End						; If so, branch

	tst.b	aDeathTimer(a0)					; Is the death timer active?
	bne.s	.End						; If so, branch
	move.b	#5,aDeathTimer(a0)				; Set death timer
	
	moveq	#2,d0						; Play death sound
	jmp	PlayPCM

.End:
	rts

; -------------------------------------------------------------------------
; Check collision with player bullets (for enemies)
; -------------------------------------------------------------------------

Enemy_CheckBulletHit:
	cmpi.w	#8,aY(a0)					; Don't detect collision if we are too far up
	blt.w	Enemy_CheckEnd

	lea	playerBullets(pc),a6				; Check each player bullet
	move.w	#(playerBulletsEnd-playerBullets)/bSize-1,d6

Enemy_CheckBullet:
	tst.b	bActive(a6)					; Is this bullet active?
	beq.w	Enemy_NextBullet				; If not, branch

; -------------------------------------------------------------------------

	moveq	#0,d2						; Get left sides
	move.b	aEnemyRadX(a0),d2
	move.w	aX(a0),d1
	sub.w	d2,d1
	move.w	bX(a6),d0
	subq.w	#2,d0
	sub.w	d1,d0						; Get distance between the 2 left sides
	bcc.s	.PastLeftX					; If the bullet is past the left side of the enemy, branch

.NotPastLeftX:
	addq.w	#4,d0						; Is the bullet's right side past the enemy's left side?
	bcs.s	.WithinX					; If so, branch
	bra.w	Enemy_NextBullet				; If not, check the next bullet

.PastLeftX:
	add.w	d2,d2						; Is the bullet's left side past the enemy's right side?
	cmp.w	d2,d0
	bhi.w	Enemy_NextBullet				; If so, check the next bullet

; -------------------------------------------------------------------------

.WithinX:
	moveq	#0,d2						; Get top sides
	move.b	aEnemyRadY(a0),d2
	move.w	aY(a0),d1
	sub.w	d2,d1
	move.w	bY(a6),d0
	subq.w	#2,d0
	sub.w	d1,d0						; Get distance between the 2 top sides
	bcc.s	.PastTopY					; If the bullet is past the top side of the enemy, branch

.NotPastTopY:
	addq.w	#4,d0						; Is the bullet's bottom side past the enemy's top side?
	bcs.s	.WithinY					; If so, branch
	bra.s	Enemy_NextBullet				; If not, check the next bullet

.PastTopY:
	add.w	d2,d2						; Is the bullet's top side past the enemy's bottom side?
	cmp.w	d2,d0
	bhi.s	Enemy_NextBullet				; If so, check the next bullet

; -------------------------------------------------------------------------

.WithinY:
	clr.b	bActive(a6)					; Make bullet disappear
	bra.s	KillEnemy					; Kill enemy

; -------------------------------------------------------------------------

Enemy_NextBullet:
	lea	bSize(a6),a6					; Next bullet
	dbf	d6,Enemy_CheckBullet				; Loop until it's done checking

	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	KillEnemy					; If so, branch

Enemy_CheckEnd:
	rts

; -------------------------------------------------------------------------
; Make an enemy die
; -------------------------------------------------------------------------

KillEnemy:
	subq.w	#2,aEnemyHealth(a0)				; Decrement health
	beq.s	.Explode					; If we should explode, branch
	bmi.s	.Explode
	addi.l	#$10,score					; Increment score
	bset	#0,hudFlags					; Update HUD
	tst.w	d6						; Are there still bullets leftover?
	bpl.s	Enemy_NextBullet				; If so, branch
	rts

.Explode:
	clr.w	aEnemyHealth(a0)				; Cap health at 0
	cmpi.w	#15,bombTime					; Are we bombing?
	bcc.s	.NoSFX						; If so, branch
	moveq	#1,d0						; Play death sound
	jsr	PlayPCM

.NoSFX:
	move.l	#ActorExplosion,aAddr(a0)			; Explode
	move.l	aEnemyScore(a0),d0				; Increment score
	add.l	d0,score
	bset	#0,hudFlags					; Update HUD
	rts

; -------------------------------------------------------------------------
; Actors
; -------------------------------------------------------------------------

	include	"src/hk97/actors/player.asm"
	include	"src/hk97/actors/red1.asm"
	include	"src/hk97/actors/red2.asm"
	include	"src/hk97/actors/red3.asm"
	include	"src/hk97/actors/boss.asm"

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

cddaParam:							; CDDA parameter
	dc.w	6
spawnDelay:							; Spawn delay timer
	dc.b	60
respawnTimer:							; Respawn timer
	dc.b	0
bossStarted:							; Boss stared flag
	dc.b	0
bossDefeated:							; Boss defeated timer
	dc.b	0
levelTime:							; Level time
	dc.w	LEVEL_DUR
bombTime:							; Bomb time
	dc.w	0
rngSeed:							; RNG seed
	dc.l	0
curScore:							; Currently displayed score
	dc.l	0
score:								; Score
	dc.l	0
lives:								; Lives
	dc.b	LIFE_COUNT
bombs:								; Bombs
	dc.b	3
graze:	
	dc.w	0						; Graze

actors:								; Actors
	dcb.b	16*aSize, 0
actorsEnd:

bullets:
playerBullets:							; Player bullets
	dcb.b	64*bSize, 0
playerBulletsEnd:

enemyBullets:							; Enemy bullets
	dcb.b	384*bSize, 0
enemyBulletsEnd:
bulletsEnd:

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

PCM_PlayerShoot:
	incbin	"src/hk97/sounds/player_shoot.pcm"
PCM_PlayerShoot_End:
	even
PCM_EnemyDie:
	incbin	"src/hk97/sounds/enemy_die.pcm"
PCM_EnemyDie_End:
	even
PCM_PlayerDie:
	incbin	"src/hk97/sounds/player_die.pcm"
PCM_PlayerDie_End:
	even
PCM_Bomb:
	incbin	"src/hk97/sounds/bomb.pcm"
PCM_Bomb_End:
	even
PCM_Blank:
	dcb.b	$20, 0
	dcb.b	$20, $FF
PCM_Blank_End:

; -------------------------------------------------------------------------
