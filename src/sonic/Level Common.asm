; -------------------------------------------------------------------------
; Common level stuff
; -------------------------------------------------------------------------

	include	"src/sound/crazybus_pcm.inc"
	include	"src/sound/crazybus_ids.inc"

; -------------------------------------------------------------------------

StartLevel:
	lea	CBPCM_Init,a1
	jsr	CallSubFunction

	move.l	#BuildRings,v_buildrings.w
	move.l	#BuildHUD,v_buildhud.w
	move.l	#LevelChunks,v_levelchunks.w
	move.l	#PalPointers,v_palindex.w
	move.l	#Obj_Index,v_objindex.w
	move.l	#ArtLoadCues,v_plcindex.w

	move.l	#Col_Level_1,v_colladdr1.w
	move.l	#Col_Level_2,v_colladdr2.w

	bra.s	GM_LevelStart
	
; -------------------------------------------------------------------------

GM_Level:
	move.b	#bgm_Fade,d0
	jsr	PlaySound_Special ; fade out music
	
	jsr	ClearPLC
	jsr	PaletteFadeOut
	
	move	#$2700,sr
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr

GM_LevelStart:
	moveq	#0,d0
	move.w	d0,(levelStarted).w
	move.b	d0,(secretBoss).w
	move.w	d0,(v_palchgspeed).w
	move.l	d0,(v_pcyc_num).w
	move.l	d0,(v_pcyc_num2).w
	move.l	d0,(v_cheatbutton).w
	move.b	d0,(superFlag).w
	move.b	d0,(gameOverFlag).w

	bset	#7,(v_gamemode).w ; add $80 to screen mode (for pre level sequence)
	
	lea	CBPCM_Stop,a1
	jsr	CallSubFunction
	
	VDP_CMD move.l,$B000,VRAM,WRITE,VDP_CTRL
	lea	(Nem_TitleCard).l,a0 ; load title card patterns
	jsr	NemDec
	moveq	#plcid_Main,d0
	jsr	QuickPLC

	move	#$2700,sr
	move.l	#VBlank,_LEVEL6+2.w
	move.l	#HBlank,_LEVEL4+2.w
	move	#$2300,sr

	lea	(LevelHeaders).l,a2
	moveq	#0,d0
	move.b	(a2),d0
	beq.s	loc_37FC
	jsr	AddPLC		; load level patterns

loc_37FC:
	moveq	#plcid_Main2,d0
	jsr	AddPLC		; load standard	patterns

Level_ClrRam:
	lea	(v_objspace).w,a1
	moveq	#0,d0
	move.w	#$7FF,d1

Level_ClrObjRam:
	move.l	d0,(a1)+
	dbf	d1,Level_ClrObjRam

	lea	($FFFF8628).w,a1
	moveq	#0,d0
	move.w	#$15,d1

Level_ClrVars1:
	move.l	d0,(a1)+
	dbf	d1,Level_ClrVars1 ; clear misc variables

	lea	(v_screenposx).w,a1
	moveq	#0,d0
	move.w	#$3F,d1

Level_ClrVars2:
	move.l	d0,(a1)+
	dbf	d1,Level_ClrVars2 ; clear misc variables

	lea	(v_oscillate+2).w,a1
	moveq	#0,d0
	move.w	#$47,d1

Level_ClrVars3:
	move.l	d0,(a1)+
	dbf	d1,Level_ClrVars3

	lea	(VDP_CTRL).l,a6
	move.w	#$8B03,(a6)	; line scroll mode
	move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
	move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
	move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
	move.w	#$9001,(a6)		; 64-cell hscroll size
	move.w	#$8004,(a6)		; 8-colour mode
	move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
	move.w	#$8A00+223,(v_hbla_hreg).w ; set palette change position (for water)
	move.w	(v_hbla_hreg).w,(a6)
	move.w	(v_vdp_buffer1).w,d0
	ori.b	#$40,d0
	move.w	d0,(a6)

	jsr	ClearScreen
	jsr	InitDMAQueue

	jsr	PlayStageMusic

	move.w	#$1000,d0
	move.w	d0,(v_waterpos1).w
	move.w	d0,(v_waterpos2).w
	move.w	d0,(v_waterpos3).w

	cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
	bne.s	Level_LoadPal	; if not, branch

	move.w	#$8014,(a6)	; enable H-interrupts
	moveq	#0,d0
	move.b	(v_act).w,d0
	add.w	d0,d0
	lea	(WaterHeight).l,a1 ; load water	height array
	move.w	(a1,d0.w),d0
	move.w	d0,(v_waterpos1).w ; set water heights
	move.w	d0,(v_waterpos2).w
	move.w	d0,(v_waterpos3).w
	clr.b	(v_wtr_routine).w ; clear water routine counter
	clr.b	(f_wtr_state).w	; clear	water state
	move.b	#1,(f_water).w	; enable water

Level_LoadPal:
	moveq	#palid_Sonic,d0
	jsr	PalLoad2	; load Sonic's palette
	cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
	bne.s	Level_GetBgm	; if not, branch
	moveq	#palid_LZSonWater,d0 ; palette number $F (LZ)
	cmpi.b	#3,(v_act).w	; is act number 3?
	bne.s	Level_WaterPal	; if not, branch
	moveq	#palid_SBZ3SonWat,d0 ; palette number $10 (SBZ3)

Level_WaterPal:
	jsr	PalLoad3_Water	; load underwater palette
	tst.b	(v_lastlamp).w
	beq.s	Level_GetBgm
	move.b	($FFFF8E53).w,(f_wtr_state).w

Level_GetBgm:
	jsr	CheckCDDA
	beq.s	Level_GetBgm

	move.b	#id_TitleCard,(v_objspace+$80).w ; load title card object

Level_TtlCardLoop:
	move.b	#$C,(v_vbla_routine).w
	jsr	WaitForVBla
	jsr	ExecuteObjects
	jsr	BuildSprites
	jsr	RunPLC
	move.w	(v_objspace+$108).w,d0
	cmp.w	(v_objspace+$130).w,d0 ; has title card sequence finished?
	bne.s	Level_TtlCardLoop ; if not, branch
	tst.l	(v_plc_buffer).w ; are there any items in the pattern load cue?
	bne.s	Level_TtlCardLoop ; if yes, branch
	jsr	(Hud_Base).l	; load basic HUD gfx

Level_SkipTtlCard:
	moveq	#palid_Sonic,d0
	jsr	PalLoad1	; load Sonic's palette
	bsr.w	LevelSizeLoad
	bsr.w	DeformLayers
	bset	#2,(v_fg_scroll_flags).w
	bsr.w	LevelDataLoad ; load block mappings and palettes
	bsr.w	LoadTilesFromStart
	bsr.w	LZWaterFeatures

	moveq	#-1,d0
	tst.b	(health).w
	bne.s	.ResetLeak
	move.b	d0,(health).w
	
.ResetLeak:
	clr.b	(tireLeak).w
	move.w	d0,(tirePressure).w

	move.b	#id_SonicPlayer,(v_player).w ; load Sonic object

Level_ChkDebug:
	tst.b	(f_debugcheat).w ; has debug cheat been entered?
	beq.s	Level_ChkWater	; if not, branch
	btst	#bitA,(v_jpadhold1).w ; is A button held?
	beq.s	Level_ChkWater	; if not, branch
	move.b	#1,(f_debugmode).w ; enable debug mode

Level_ChkWater:
	move.w	#0,(v_jpadhold2).w
	move.w	#0,(v_jpadhold1).w
	cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
	bne.s	Level_LoadObj	; if not, branch
	move.b	#id_WaterSurface,(v_objspace+$780).w ; load water surface object
	move.w	#$60,(v_objspace+$780+obX).w
	move.b	#id_WaterSurface,(v_objspace+$7C0).w
	move.w	#$120,(v_objspace+$7C0+obX).w

Level_LoadObj:
	moveq	#0,d0
	tst.b	(v_lastlamp).w	; are you starting from	a lamppost?
	bne.s	Level_SkipClr	; if yes, branch
	move.w	d0,(v_rings).w	; clear rings
	move.l	d0,(v_time).w	; clear time
	move.b	d0,(v_lifecount).w ; clear lives counter

Level_SkipClr:
	move.b	d0,(v_shoes).w	; clear speed shoes
	move.w	d0,(v_debuguse).w
	move.w	d0,(f_restart).w
	move.w	d0,(v_framecount).w
	bsr.w	OscillateNumInit
	move.b	#1,(f_scorecount).w ; update score counter
	move.w	#0,(v_btnpushtime1).w

Level_Demo:
	cmpi.b	#id_LZ,(v_zone).w ; is level LZ/SBZ3?
	bne.s	Level_Delay	; if not, branch
	moveq	#palid_LZWater,d0 ; palette $B (LZ underwater)
	cmpi.b	#3,(v_act).w	; is level SBZ3?
	bne.s	Level_WtrNotSbz	; if not, branch
	moveq	#palid_SBZ3Water,d0 ; palette $D (SBZ3 underwater)

Level_WtrNotSbz:
	jsr	PalLoad4_Water

Level_Delay:
	cmpi.b	#id_SecretZ,(v_zone).w
	bne.s	.NotSecret
	jsr	PaletteCycle

.NotSecret:
	st	levelStarted.w
	clr.b	Rings_manager_routine.w
	jsr	RingsManager
	jsr	ObjPosLoad
	jsr	ExecuteObjects
	jsr	BuildSprites

	move.w	#3,d1

Level_DelayLoop:
	move.b	#8,(v_vbla_routine).w
	jsr	WaitForVBla
	dbf	d1,Level_DelayLoop

	moveq	#CBID_BUS,d0
	lea	CBPCM_Play,a1
	jsr	CallSubFunction
	
	moveq	#3,d0
	lea	cbpcmMotorMode,a1
	jsr	WriteSubByte

	move.w	#$202F,(v_pfade_start).w ; fade in 2nd, 3rd & 4th palette lines
	jsr	PalFadeIn_Alt
	
	addq.b	#2,(v_objspace+$80+obRoutine).w ; make title card move
	addq.b	#4,(v_objspace+$C0+obRoutine).w
	addq.b	#4,(v_objspace+$100+obRoutine).w
	addq.b	#4,(v_objspace+$140+obRoutine).w

	bclr	#7,(v_gamemode).w ; subtract $80 from mode to end pre-level stuff

; -------------------------------------------------------------------------

Level_MainLoop:
	tst.l	warpX.w
	beq.w	.NoWarp

	lea	v_pal_dry.w,a0
	tst.b	effectFlags.w
	beq.s	.StartPalCopy
	lea	effectPalette.w,a0

.StartPalCopy:
	lea	v_pal_dry_dup.w,a1
	moveq	#$80/4-1,d0

.CopyPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.CopyPal

	lea	v_pal_water.w,a0
	tst.b	effectFlags.w
	beq.s	.StartWaterPalCopy
	lea	effectWaterPal.w,a0

.StartWaterPalCopy:
	lea	v_pal_water_dup.w,a1
	moveq	#$80/4-1,d0

.CopyWaterPal;
	move.l	(a0)+,(a1)+
	dbf	d0,.CopyWaterPal

	move.w	#sfx_EnterSS,d0
	jsr	PlaySound_Special
	jsr	PaletteWhiteOut

	move.w	warpX.w,d1
	move.w	warpY.w,d0

	lea	v_player.w,a0
	move.w	d1,obX(a0)
	move.w	d0,obY(a0)
	clr.l	obVelX(a0)
	clr.w	obInertia(a0)
	move.b	#id_Walk,obAnim(a0)
	move.b	#%10,obStatus(a0)
	clr.b	$3C(a0)

	clr.b	f_lockmulti.w

	move	#$2700,sr
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr
	
	jsr	LevSz_SkipStartPos
	bsr.w	DeformLayers
	bset	#2,v_fg_scroll_flags.w
	bsr.w	LoadTilesFromStart
	
	lea	v_objspace+$800.w,a0
	lea	v_objstate.w,a2
	move.w	#$1800/$40-1,d2

.ClearObjects:
	moveq	#0,d3
	move.b	obRespawnNo(a0),d3
	beq.s	.Delete
	bclr	#7,2(a2,d3.w)

.Delete:
	jsr	DeleteObject
	lea	$40(a0),a0
	dbf	d2,.ClearObjects

	jsr	RingsManager_Reset
	jsr	OPL_Reset
	jsr	ExecuteObjects
	jsr	BuildSprites
	jsr	PaletteCycle
	jsr	UpdateEffects

	move	#$2700,sr
	move.l	#VBlank,_LEVEL6+2.w
	move	#$2300,sr

	jsr	PaletteWhiteIn
	clr.l	warpX.w

; -------------------------------------------------------------------------

.NoWarp:
	tst.w	(v_palchgspeed).w
	beq.s	.NoBGFade
	subq.w	#1,(v_palchgspeed).w

	btst	#0,(v_palchgspeed+1).w
	beq.s	.NoBGFade
	move.w	#$600F,(v_pfade_start).w
	jsr	FadeOut_ToBlack

; -------------------------------------------------------------------------

.NoBGFade:
	jsr	PauseGame
	move.b	#8,(v_vbla_routine).w
	jsr	WaitForVBla
	addq.w	#1,(v_framecount).w ; add 1 to level timer
	bsr.w	LZWaterFeatures
	jsr	ExecuteObjects
	tst.w	(f_restart).w
	bmi.w	Level_Exit
	bne.w	GM_Level
	cmpi.b	#id_Level,(v_gamemode).w
	bne.w	Level_Exit	; if mode is not level, branch
	bsr.w	DeformLayers
	jsr	RingsManager
	jsr	BuildSprites
	jsr	ObjPosLoad
	jsr	PaletteCycle
	jsr	UpdateEffects
	jsr	RunPLC
	bsr.w	OscillateNumDo
	bsr.w	SynchroAnimate
	bsr.w	SignpostArtLoad
	
	tst.b	secretBoss.w
	bmi.w	SecretBossDone
	tst.b	gameOverFlag.w
	bne.s	Level_GameOver

	bra.w	Level_MainLoop

; -------------------------------------------------------------------------

Level_GameOver:
	move.b	#bgm_Fade,d0					; Fade out
	jsr	PlaySound_Special
	jsr	PaletteFadeOut

	move	#$2700,sr					; Only update sound
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr

	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	jsr	StopCDDA

	lea	VDP_DATA,a5
	lea	VDP_CTRL,a6
	
	moveq	#0,d0
	move.w	#$100,d1

	lea	VDP_GameOver,a0
	move.w	#$8000,d2
	moveq	#$12-1,d3

.WriteVDP:
	move.b	(a0)+,d2
	move.w	d2,(a6)
	add.w	d1,d2
	dbf	d3,.WriteVDP

	VDP_CMD move.l,0,VSRAM,WRITE,(a6)
	moveq	#$50/4-1,d2

.ClearVSRAM:
	move.l	d0,(a5)
	dbf	d2,.ClearVSRAM

	lea	Art_GameOver,a0
	VDP_CMD move.l,0,VRAM,WRITE,(a6)
	jsr	NemDec

	moveq	#18,d0
	jsr	PlayCDDA

	lea	Pal_GameOver,a0
	lea	v_pal_dry_dup.w,a1
	moveq	#(($80/$04)/$04)-1,d3

.WritePalette:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	dbf	d3,.WritePalette

.WaitCDPlay:
	jsr	CheckCDDA
	beq.s	.WaitCDPlay
	
	move	#$2700,sr
	move.l	#VInt_GameOver,_LEVEL6+2.w
	
	move.w	#$8174,(a6)
	jsr	PaletteFadeIn

	if REGION<>EUROPE
		move.w	#5*60,d0
	else
		move.w	#5*50,d0
	endif

.Wait:
	st	v_vbla_routine.w
	jsr	WaitForVBla
	dbf	d0,.Wait

	jsr	PaletteFadeOut

	move	#$2700,sr
	jsr	VDPSetupGame
	
	move.b	#id_title,(v_gamemode).w
	bra.w	LevelDone

; -------------------------------------------------------------------------

Level_Exit:
	clr.w	(f_restart).w
	
	cmpi.b	#id_Special,(v_gamemode).w
	beq.s	GoToSpecial

	clr.b	secretBoss.w
	move.b	#bgm_Fade,d0
	jsr	PlaySound_Special
	jsr	PaletteFadeOut
	bra.s	LevelDone

; -------------------------------------------------------------------------

SecretBossDone:
	move.b	#id_Ending,(v_gamemode).w
	jsr	PaletteWhiteOut
	bra.s	LevelDone

; -------------------------------------------------------------------------

GoToSpecial:
	clr.b	secretBoss.w
	move.w	#sfx_EnterSS,d0
	jsr	PlaySound_Special
	jsr	PaletteWhiteOut

; -------------------------------------------------------------------------

LevelDone:
	clr.l	v_buildrings.w					; Disable HUD and ring drawing
	clr.l	v_buildhud.w
	
	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	jsr	StopCDDA
	
	move	#$2700,sr					; Only update sound
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr

	lea	VDP_CTRL,a5					; Disable water
	move.l	#$80048ADF,(a5)
	rts

; -------------------------------------------------------------------------

VInt_GameOver:
	movem.l	d0-a6,-(sp)

	REQUEST_INT2
	clr.b	v_vbla_routine.w

	STOP_Z80
	lea	VDP_CTRL,a5
	move.w	(a5),d0
	DMA_68K v_pal_dry,0,$80,CRAM,(a5)
	START_Z80

	jsr	UpdateSound

	movem.l	(sp)+,d0-a6
	rte

; -------------------------------------------------------------------------
; Code
; -------------------------------------------------------------------------

	include	"src/sonic/_inc/Interrupts.asm"
	include	"src/sonic/_inc/Level Object Animate.asm"
	include	"src/sonic/_inc/Signpost Load.asm"
	include	"src/sonic/_inc/Oscillatory Routines.asm"
	include	"src/sonic/_inc/LZWaterFeatures.asm"
	include	"src/sonic/_inc/LevelSizeLoad & BgScrollSpeed (JP1).asm"
	include	"src/sonic/_inc/DeformLayers (JP1).asm"
	include	"src/sonic/_inc/Level Draw.asm"
	include	"src/sonic/_inc/Load Level Data.asm"
	include	"src/sonic/_inc/DynamicLevelEvents.asm"
	include	"src/sonic/_incObj/sub SmashObject.asm"
	include	"src/sonic/_inc/Object Manager.asm"
	include	"src/sonic/_inc/Ring Manager.asm"
	include	"src/sonic/_incObj/sub FindFreeObj.asm"
	include	"src/sonic/_incObj/sub SolidObject.asm"
	include	"src/sonic/_incObj/sub FindNearestTile.asm"
	include	"src/sonic/_incObj/sub FindFloor.asm"
	include	"src/sonic/_incObj/sub FindWall.asm"
	include	"src/sonic/_incObj/Sonic AnglePos.asm"
	include	"src/sonic/_incObj/Sonic Floor.asm"
	include	"src/sonic/_incObj/Sonic ResetOnFloor.asm"
	include	"src/sonic/_incObj/sub ReactToItem.asm"
	include	"src/sonic/_incObj/sub RememberState.asm"
	include	"src/sonic/_inc/HUD_Update.asm"
	include	"src/sonic/_inc/HUD (part 2).asm"
	include	"src/sonic/_incObj/sub AddPoints.asm"
	include	"src/sonic/_incObj/DebugMode.asm"
	include	"src/sonic/_inc/AnimateLevelGfx.asm"
	include	"src/sonic/_inc/Effects.asm"
	include	"src/sonic/_inc/Stage Music.asm"
	
; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"src/sonic/_incObj/01 Sonic.asm"
	include	"src/sonic/_incObj/03 Collision Switcher.asm"
Map_Bri:
	include	"src/sonic/_maps/Bridge.asm"
Map_Swing_GHZ:
	include	"src/sonic/_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:
	include	"src/sonic/_maps/Swinging Platforms (SLZ).asm"
	include	"src/sonic/_incObj/18 Platforms.asm"
Map_GBall:
	include	"src/sonic/_maps/GHZ Ball.asm"
Map_BBall:
	include	"src/sonic/_maps/Big Spiked Ball.asm"
Map_Plat_GHZ:
	include	"src/sonic/_maps/Platforms (GHZ).asm"
Map_Plat_SYZ:
	include	"src/sonic/_maps/Platforms (SYZ).asm"
Map_Plat_SLZ:
	include	"src/sonic/_maps/Platforms (SLZ).asm"
Map_Ledge:
	include	"src/sonic/_maps/Collapsing Ledge.asm"
Map_CFlo:
	include	"src/sonic/_maps/Collapsing Floors.asm"
Map_MBlock:
	include	"src/sonic/_maps/Moving Blocks (MZ and SBZ).asm"
Map_MBlockLZ:
	include	"src/sonic/_maps/Moving Blocks (LZ).asm"
	include	"src/sonic/_incObj/71 Invisible Barriers.asm"
Map_Invis:
	include	"src/sonic/_maps/Invisible Barriers.asm"
	include	"src/sonic/_incObj/1C Scenery.asm"
Map_Scen:
	include	"src/sonic/_maps/Scenery.asm"
	include	"src/sonic/_incObj/24, 27 & 3F Explosions.asm"
	include	"src/sonic/_maps/Explosions.asm"
Map_MisDissolve:
	include	"src/sonic/_maps/Buzz Bomber Missile Dissolve.asm"
	include	"src/sonic/_incObj/28 Animals.asm"
	include	"src/sonic/_incObj/29 Points.asm"
Map_Animal1:
	include	"src/sonic/_maps/Animals 1.asm"
Map_Animal2:
	include	"src/sonic/_maps/Animals 2.asm"
Map_Animal3:
	include	"src/sonic/_maps/Animals 3.asm"
Map_Poi:
	include	"src/sonic/_maps/Points.asm"
	include	"src/sonic/_incObj/36 Spikes.asm"
Map_Spike:
	include	"src/sonic/_maps/Spikes.asm"
	include	"src/sonic/_incObj/41 Springs.asm"
	include	"src/sonic/_anim/Springs.asm"
Map_Spring:
	include	"src/sonic/_maps/Springs.asm"
	include	"src/sonic/_incObj/26 Monitor.asm"
	include	"src/sonic/_incObj/2E Monitor Content Power-Up.asm"
	include	"src/sonic/_incObj/26 Monitor (SolidSides subroutine).asm"
	include	"src/sonic/_anim/Monitor.asm"
Map_Monitor:
	include	"src/sonic/_maps/Monitor.asm"
	include	"src/sonic/_incObj/25 & 37 Rings.asm"
	include	"src/sonic/_incObj/4B Giant Ring.asm"
	include	"src/sonic/_incObj/7C Ring Flash.asm"
	include	"src/sonic/_anim/Rings.asm"
Map_Ring:
	include	"src/sonic/_maps/Rings.asm"
Map_GRing:
	include	"src/sonic/_maps/Giant Ring.asm"
Map_Flash:
	include	"src/sonic/_maps/Ring Flash.asm"
	include	"src/sonic/_incObj/0D Signpost.asm"
	include	"src/sonic/_anim/Signpost.asm"
Map_Sign:
	include	"src/sonic/_maps/Signpost.asm"
	include	"src/sonic/_incObj/7D Hidden Bonuses.asm"
Map_Bonus:
	include	"src/sonic/_maps/Hidden Bonuses.asm"
	include	"src/sonic/_incObj/79 Lamppost.asm"
Map_Lamp:
	include	"src/sonic/_maps/Lamppost.asm"
	include	"src/sonic/_incObj/Boss Functions.asm"
	include	"src/sonic/_anim/Eggman.asm"
Map_Eggman:
	include	"src/sonic/_maps/Eggman.asm"
Map_BossItems:
	include	"src/sonic/_maps/Boss Items.asm"
	include	"src/sonic/_incObj/3E Prison Capsule.asm"
	include	"src/sonic/_anim/Prison Capsule.asm"
Map_Pri:
	include	"src/sonic/_maps/Prison Capsule.asm"
	include	"src/sonic/_incObj/34 Title Cards.asm"
Map_Over:
	include	"src/sonic/_maps/Game Over.asm"
	include	"src/sonic/_incObj/3A Got Through Card.asm"
Map_HUD:
	include	"src/sonic/_maps/HUD.asm"
Map_SBall:
	include	"src/sonic/_maps/Spiked Ball and Chain (SYZ).asm"
Map_SBall2:
	include	"src/sonic/_maps/Spiked Ball and Chain (LZ).asm"

; -------------------------------------------------------------------------
; Sprite mappings - zone title cards
; -------------------------------------------------------------------------

Map_Card:
	dc.w M_Card_GHZ-Map_Card
	dc.w M_Card_LZ-Map_Card
	dc.w M_Card_MZ-Map_Card
	dc.w M_Card_SLZ-Map_Card
	dc.w M_Card_SYZ-Map_Card
	dc.w M_Card_SBZ-Map_Card
	dc.w M_Card_Zone-Map_Card
	dc.w M_Card_Act1-Map_Card
	dc.w M_Card_Act2-Map_Card
	dc.w M_Card_Act3-Map_Card
	dc.w M_Card_Oval-Map_Card
	dc.w M_Card_FZ-Map_Card
M_Card_GHZ:
	dc.w 9 			; GREEN HILL
	dc.w $F805, $0018, $FFB4
	dc.w $F805, $003A, $FFC4
	dc.w $F805, $0010, $FFD4
	dc.w $F805, $0010, $FFE4
	dc.w $F805, $002E, $FFF4
	dc.w $F805, $001C, $0014
	dc.w $F801, $0020, $0024
	dc.w $F805, $0026, $002C
	dc.w $F805, $0026, $003C
	even
M_Card_LZ:
	dc.w 9			; LABYRINTH
	dc.w $F805, $0026, $FFBC
	dc.w $F805, $0000, $FFCC
	dc.w $F805, $0004, $FFDC
	dc.w $F805, $004A, $FFEC
	dc.w $F805, $003A, $FFFC
	dc.w $F801, $0020, $000C
	dc.w $F805, $002E, $0014
	dc.w $F805, $0042, $0024
	dc.w $F805, $001C, $0034
	even
M_Card_MZ:
	dc.w 6			; MARBLE
	dc.w $F805, $002A, $FFCF
	dc.w $F805, $0000, $FFE0
	dc.w $F805, $003A, $FFF0
	dc.w $F805, $0004, $0000
	dc.w $F805, $0026, $0010
	dc.w $F805, $0010, $0020
	even
M_Card_SLZ:
	dc.w 9			; STAR LIGHT
	dc.w $F805, $003E, $FFB4
	dc.w $F805, $0042, $FFC4
	dc.w $F805, $0000, $FFD4
	dc.w $F805, $003A, $FFE4
	dc.w $F805, $0026, $0004
	dc.w $F801, $0020, $0014
	dc.w $F805, $0018, $001C
	dc.w $F805, $001C, $002C
	dc.w $F805, $0042, $003C
	even
M_Card_SYZ:
	dc.w $A			; SPRING YARD
	dc.w $F805, $003E, $FFAC
	dc.w $F805, $0036, $FFBC
	dc.w $F805, $003A, $FFCC
	dc.w $F801, $0020, $FFDC
	dc.w $F805, $002E, $FFE4
	dc.w $F805, $0018, $FFF4
	dc.w $F805, $004A, $0014
	dc.w $F805, $0000, $0024
	dc.w $F805, $003A, $0034
	dc.w $F805, $000C, $0044
	even
M_Card_SBZ:
	dc.w $A			; SCRAP BRAIN
	dc.w $F805, $003E, $FFAC
	dc.w $F805, $0008, $FFBC
	dc.w $F805, $003A, $FFCC
	dc.w $F805, $0000, $FFDC
	dc.w $F805, $0036, $FFEC
	dc.w $F805, $0004, $000C
	dc.w $F805, $003A, $001C
	dc.w $F805, $0000, $002C
	dc.w $F801, $0020, $003C
	dc.w $F805, $002E, $0044
	even
M_Card_Zone:
	dc.w 4			; ZONE
	dc.w $F805, $004E, $FFE0
	dc.w $F805, $0032, $FFF0
	dc.w $F805, $002E, $0000
	dc.w $F805, $0010, $0010
	even
M_Card_Act1:
	dc.w 2			; ACT 1
	dc.w $040C, $0053, $FFEC
	dc.w $F402, $0057, $000C
M_Card_Act2:
	dc.w 2			; ACT 2
	dc.w $040C, $0053, $FFEC
	dc.w $F406, $005A, $0008
M_Card_Act3:
	dc.w 2			; ACT 3
	dc.w $040C, $0053, $FFEC
	dc.w $F406, $0060, $0008
M_Card_Oval:
	dc.w $D			; Oval
	dc.w $E40C, $0070, $FFF4
	dc.w $E402, $0074, $0014
	dc.w $EC04, $0077, $FFEC
	dc.w $F405, $0079, $FFE4
	dc.w $140C, $1870, $FFEC
	dc.w $0402, $1874, $FFE4
	dc.w $0C04, $1877, $0004
	dc.w $FC05, $1879, $000C
	dc.w $EC08, $007D, $FFFC
	dc.w $F40C, $007C, $FFF4
	dc.w $FC08, $007C, $FFF4
	dc.w $040C, $007C, $FFEC
	dc.w $0C08, $007C, $FFEC
M_Card_FZ:
	dc.w 5			; FINAL
	dc.w $F805, $0014, $FFDC
	dc.w $F801, $0020, $FFEC
	dc.w $F805, $002E, $FFF4
	dc.w $F805, $0000, $0004
	dc.w $F805, $0026, $0014
	even

; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------

Map_Got:
	dc.w M_Got_SonicHas-Map_Got
	dc.w M_Got_Passed-Map_Got
	dc.w M_Got_Score-Map_Got
	dc.w M_Got_TBonus-Map_Got
	dc.w M_Got_RBonus-Map_Got
	dc.w M_Card_Oval-Map_Got
	dc.w M_Card_Act1-Map_Got
	dc.w M_Card_Act2-Map_Got
	dc.w M_Card_Act3-Map_Got
M_Got_SonicHas:
	dc.w $C			; CRAZYBUS HAS
	dc.w $F805, $0008, $FFA0
	dc.w $F805, $003A, $FFB0
	dc.w $F805, $0000, $FFC0
	dc.w $F805, $004E, $FFD0
	dc.w $F805, $004A, $FFE0
	dc.w $F805, $0004, $FFF0
	dc.w $F805, $0046, $0000
	dc.w $F805, $003E, $0010
	dc.w $F800, $0056, $0020
	dc.w $F805, $001C, $0030
	dc.w $F805, $0000, $0040
	dc.w $F805, $003E, $0050
M_Got_Passed:
	dc.w 6			; PASSED
	dc.w $F805, $0036, $FFD0
	dc.w $F805, $0000, $FFE0
	dc.w $F805, $003E, $FFF0
	dc.w $F805, $003E, $0000
	dc.w $F805, $0010, $0010
	dc.w $F805, $000C, $0020
M_Got_Score:
	dc.w 6			; SCORE
	dc.w $F80D, $014A, $FFB0
	dc.w $F801, $0162, $FFD0
	dc.w $F809, $0164, $0018
	dc.w $F80D, $016A, $0030
	dc.w $F704, $006E, $FFCD
	dc.w $FF04, $186E, $FFCD
M_Got_TBonus:
	dc.w 7			; TIME BONUS
	dc.w $F80D, $015A, $FFB0
	dc.w $F80D, $0066, $FFD9
	dc.w $F801, $014A, $FFF9
	dc.w $F704, $006E, $FFF6
	dc.w $FF04, $186E, $FFF6
	dc.w $F80D, $FFF0, $0028
	dc.w $F801, $0170, $0048
M_Got_RBonus:
	dc.w 7			; RING BONUS
	dc.w $F80D, $0152, $FFB0
	dc.w $F80D, $0066, $FFD9
	dc.w $F801, $014A, $FFF9
	dc.w $F704, $006E, $FFF6
	dc.w $FF04, $186E, $FFF6
	dc.w $F80D, $FFF8, $0028
	dc.w $F801, $0170, $0048
	even

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Obj_Index:
	include "src/sonic/_inc/Object Pointers.asm"

Level_Index:
	dc.l	Level_Act1
	dc.l	Level_Act2
	dc.l	Level_Act3
	dc.l	Level_Act4

ObjPos_Index:
	dc.l	ObjPos_Act1
	dc.l	ObjPos_Act2
	dc.l	ObjPos_Act3
	dc.l	ObjPos_Act4
	
RingPos_Index:
	dc.l	RingPos_Act1
	dc.l	RingPos_Act2
	dc.l	RingPos_Act3
	dc.l	RingPos_Act4

Art_Sonic:
	incbin	"src/sonic/artunc/Sonic.bin"
	even
Map_Sonic:
	include	"src/sonic/_maps/Sonic.asm"
SonicDynPLC:
	include	"src/sonic/_maps/Sonic - Dynamic Gfx Script.asm"

Art_BigRing:
	incbin	"src/sonic/artunc/Giant Ring.bin"
	even

Nem_Eggman:
	incbin	"src/sonic/artnem/Boss - Main.bin"
	even
Nem_Weapons:
	incbin	"src/sonic/artnem/Boss - Weapons.bin"
	even
Nem_Prison:
	incbin	"src/sonic/artnem/Prison Capsule.bin"
	even
Nem_Exhaust:
	incbin	"src/sonic/artnem/Boss - Exhaust Flame.bin"
	even
Nem_Bomb:
	incbin	"src/sonic/artnem/Enemy Bomb.bin"
	even
Nem_SlzSpike:
	incbin	"src/sonic/artnem/SLZ Little Spikeball.bin"
	even
Nem_TitleCard:
	incbin	"src/sonic/artnem/Title Cards.bin"
	even
Nem_Hud:
	incbin	"src/sonic/artnem/HUD.bin"	; HUD (rings, time, score)
	even
Nem_Lives:
	incbin	"src/sonic/artnem/HUD - Life Counter Icon.bin"
	even
Nem_Ring:
	incbin	"src/sonic/artnem/Rings.bin"
	even
Nem_Monitors:
	incbin	"src/sonic/artnem/Monitors.bin"
	even
Nem_Explode:
	incbin	"src/sonic/artnem/Explosion.bin"
	even
Nem_Points:
	incbin	"src/sonic/artnem/Points.bin"	; points from destroyed enemy or object
	even
Nem_HSpring:
	incbin	"src/sonic/artnem/Spring Horizontal.bin"
	even
Nem_VSpring:
	incbin	"src/sonic/artnem/Spring Vertical.bin"
	even
Nem_SignPost:
	incbin	"src/sonic/artnem/Signpost.bin"	; end of level signpost
	even
Nem_Lamp:
	incbin	"src/sonic/artnem/Lamppost.bin"
	even
Nem_BigFlash:
	incbin	"src/sonic/artnem/Giant Ring Flash.bin"
	even
Nem_Bonus:
	incbin	"src/sonic/artnem/Hidden Bonuses.bin" ; hidden bonuses at end of a level
	even
Nem_Spikes:
	incbin	"src/sonic/artnem/Spikes.bin"
	even
Art_HudNums:
	incbin	"src/sonic/artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
	even
Art_LivesNums:
	incbin	"src/sonic/artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
	even
Art_Text:
	incbin	"src/sonic/artunc/menutext.bin" ; text used in level select and debug mode
	even

Drown_WobbleData:
	dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
	dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	dc.b 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
	dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
	dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
	dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
	dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
	dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1
	dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
	dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	dc.b 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
	dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
	dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
	dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
	dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
	dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1

Art_GameOver:
	incbin	"src/sonic/gameover/VRAM.nem"
	even
Pal_GameOver:
	incbin	"src/sonic/gameover/CRAM.bin"
	even
VDP_GameOver:
	incbin	"src/sonic/gameover/VDP.bin"
	even

; -------------------------------------------------------------------------
