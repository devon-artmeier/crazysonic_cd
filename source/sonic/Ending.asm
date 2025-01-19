; -------------------------------------------------------------------------
; Ending
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/sound/crazybus_pcm.inc"
	include	"source/sound/crazybus_ids.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"

	org	WORD_START
	
; -------------------------------------------------------------------------

StartEnding:
	lea	CBPCM_Init,a1
	jsr	CallSubFunction
	
	clr.l	v_buildrings.w
	clr.l	v_buildhud.w
	move.l	#LevelChunks,v_levelchunks.w
	move.l	#PalPointers,v_palindex.w
	move.l	#Obj_Index,v_objindex.w
	move.l	#ArtLoadCues,v_plcindex.w

	move.l	#Col_Level_1,v_colladdr1.w
	move.l	#Col_Level_2,v_colladdr2.w

	move.l	#VBlank,_LEVEL6+2.w
	move.l	#HBlank,_LEVEL4+2.w
	
; -------------------------------------------------------------------------

GM_Ending:
	moveq	#0,d0
	move.b	d0,(levelStarted).w
	move.b	d0,(levelEnded).w
	move.b	d0,(superFlag).w
	move.b	d0,(gameOverFlag).w
	
	lea	(v_objspace).w,a1
	moveq	#0,d0
	move.w	#$7FF,d1

End_ClrObjRam:
	move.l	d0,(a1)+
	dbf	d1,End_ClrObjRam ; clear object	RAM
	lea	($FFFF8628).w,a1
	moveq	#0,d0
	move.w	#$15,d1

End_ClrRam1:
	move.l	d0,(a1)+
	dbf	d1,End_ClrRam1	; clear	variables
	lea	(v_screenposx).w,a1
	moveq	#0,d0
	move.w	#$3F,d1

End_ClrRam2:
	move.l	d0,(a1)+
	dbf	d1,End_ClrRam2	; clear	variables
	lea	(v_oscillate+2).w,a1
	moveq	#0,d0
	move.w	#$47,d1

End_ClrRam3:
	move.l	d0,(a1)+
	dbf	d1,End_ClrRam3	; clear	variables

	disable_ints
	move.w	(v_vdp_buffer1).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_CTRL).l
	jsr	ClearScreen
	jsr	InitDMAQueue
	
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
	
	tst.b	secretBoss.w
	bmi.w	End_GoToCredits

	move.w	#id_EndZ<<8,(v_zone).w ; set level number to 0600 (extra flowers)
	cmpi.b	#7,(v_emeralds).w ; do you have all 6 emeralds?
	beq.s	End_LoadData	; if yes, branch
	move.w	#(id_EndZ<<8)+1,(v_zone).w ; set level number to 0601 (no flowers)

End_LoadData:
	moveq	#plcid_Main,d0
	jsr	QuickPLC
	moveq	#plcid_Ending,d0
	jsr	QuickPLC	; load ending sequence patterns
	jsr	LevelSizeLoad
	jsr	DeformLayers
	bset	#2,(v_fg_scroll_flags).w
	jsr	LevelDataLoad
	jsr	LoadTilesFromStart
	enable_ints
	moveq	#palid_Sonic,d0
	jsr	PalLoad1	; load Sonic's palette

	moveq	#CBID_BUS,d0
	lea	CBPCM_Play,a1
	jsr	CallSubFunction

	tst.b	(f_debugcheat).w ; has debug cheat been entered?
	beq.s	End_LoadSonic	; if not, branch
	btst	#bitA,(v_jpadhold1).w ; is button A pressed?
	beq.s	End_LoadSonic	; if not, branch
	move.b	#1,(f_debugmode).w ; enable debug mode

End_LoadSonic:
	moveq	#-1,d0
	move.b	d0,(health).w
	clr.b	(tireLeak).w
	move.w	d0,(tirePressure).w

.Leaking:
	move.b	#id_SonicPlayer,(v_player).w ; load Sonic object
	move.b	#1,(f_lockctrl).w ; lock controls
	move.w	#(btnL<<8),(v_jpadhold2).w ; move Sonic to the left
	move.w	#-$100,(v_player+obInertia).w ; set Sonic's speed
	
	jsr	ObjPosLoad
	jsr	ExecuteObjects
	jsr	BuildSprites
	
	moveq	#0,d0
	move.w	d0,(v_rings).w
	move.l	d0,(v_time).w
	move.b	d0,(v_lifecount).w
	move.b	d0,(v_shoes).w
	move.w	d0,(v_debuguse).w
	move.w	d0,(f_restart).w
	move.w	d0,(v_framecount).w
	jsr	OscillateNumInit
	move.b	#1,(f_scorecount).w
	move.w	#1800,(v_demolength).w
	move.b	#$18,(v_vbla_routine).w
	jsr	WaitForVBla
	move.w	(v_vdp_buffer1).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_CTRL).l
	move.w	#$3F,(v_pfade_start).w
	jsr	PaletteFadeIn

; -------------------------------------------------------------------------

End_MainLoop:
	jsr	PauseGame
	move.b	#$18,(v_vbla_routine).w
	jsr	WaitForVBla
	addq.w	#1,(v_framecount).w
	bsr.w	End_MoveSonic
	jsr	ExecuteObjects
	jsr	DeformLayers
	jsr	BuildSprites
	jsr	ObjPosLoad
	jsr	PaletteCycle
	jsr	OscillateNumDo
	jsr	SynchroAnimate
	cmpi.b	#id_Ending,(v_gamemode).w ; is game mode $18 (ending)?
	beq.s	End_ChkEmerald	; if yes, branch

End_GoToCredits:
	move.b	#id_Ending|$80,(v_gamemode).w
	clr.b	(secretBoss).w
	clr.w	(v_creditsnum).w

	bra.w	GM_Credits
; ===========================================================================

End_ChkEmerald:
	tst.w	(f_restart).w	; has Sonic released the emeralds?
	beq.w	End_MainLoop	; if not, branch
	clr.w	(f_restart).w
	move.w	#$3F,(v_pfade_start).w
	clr.w	(v_palchgspeed).w

End_AllEmlds:
	jsr	PauseGame
	move.b	#$18,(v_vbla_routine).w
	jsr	WaitForVBla
	addq.w	#1,(v_framecount).w
	bsr.w	End_MoveSonic
	jsr	ExecuteObjects
	jsr	DeformLayers
	jsr	BuildSprites
	jsr	ObjPosLoad
	jsr	OscillateNumDo
	jsr	SynchroAnimate
	subq.w	#1,(v_palchgspeed).w
	bpl.s	End_SlowFade
	move.w	#2,(v_palchgspeed).w
	jsr	WhiteOut_ToWhite

End_SlowFade:
	tst.w	(f_restart).w
	beq.w	End_AllEmlds
	clr.w	(f_restart).w
	
	move.b	#bgm_Fade,d0					; Fade to black
	jsr	PlaySound_Special
	jsr	PaletteFadeOut

	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	jsr	StopCDDA

	move.b	#id_Level,(v_gamemode).w			; Go to secret level
	move.w	#id_SecretZ<<8,(v_zone).w

	move	#$2700,sr					; Only update sound
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr
	rts

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


End_MoveSonic:
	move.b	(v_sonicend).w,d0
	bne.s	End_MoveSon2
	cmpi.w	#$90,(v_player+obX).w ; has Sonic passed $90 on x-axis?
	bhs.s	End_MoveSonExit	; if not, branch

	addq.b	#2,(v_sonicend).w
	move.b	#1,(f_lockctrl).w ; lock player's controls
	move.w	#(btnR<<8),(v_jpadhold2).w ; move Sonic to the right
	rts	
; ===========================================================================

End_MoveSon2:
	subq.b	#2,d0
	bne.s	End_MoveSon3
	cmpi.w	#$A0,(v_player+obX).w ; has Sonic passed $A0 on x-axis?
	blo.s	End_MoveSonExit	; if not, branch

	addq.b	#2,(v_sonicend).w
	moveq	#0,d0
	move.b	d0,(f_lockctrl).w
	move.w	d0,(v_jpadhold2).w ; stop Sonic moving
	move.w	d0,(v_player+obInertia).w
	move.b	#$81,(f_lockmulti).w ; lock controls & position
	move.b	#1,(v_player+obFrame).w
	move.w	#(id_Walk<<8)+1,(v_player+obAnim).w ; use "standing" animation
	move.b	#3,(v_player+obTimeFrame).w
	rts	
; ===========================================================================

End_MoveSon3:
	subq.b	#2,d0
	bne.s	End_MoveSonExit
	addq.b	#2,(v_sonicend).w
	move.w	#$A0,(v_player+obX).w
	move.b	#id_EndSonic,(v_player).w ; load Sonic ending sequence object
	clr.w	(v_player+obRoutine).w

End_MoveSonExit:
	rts	
; End of function End_MoveSonic

; ===========================================================================
; ---------------------------------------------------------------------------
; Credits ending sequence
; ---------------------------------------------------------------------------

GM_Credits:
	jsr	ClearPLC
	jsr	PaletteFadeOut
	
	lea	CBPCM_Stop,a1
	jsr	CallSubFunction
	
	moveq	#23,d0
	jsr	LoopCDDA
	
	lea	(VDP_CTRL).l,a6
	move.w	#$8004,(a6)		; 8-colour mode
	move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
	move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
	move.w	#$9001,(a6)		; 64-cell hscroll size
	move.w	#$9200,(a6)		; window vertical position
	move.w	#$8B03,(a6)		; line scroll mode
	move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
	clr.b	(f_wtr_state).w
	jsr	ClearScreen

	lea	(v_objspace).w,a1
	moveq	#0,d0
	move.w	#$7FF,d1

Cred_ClrObjRam:
	move.l	d0,(a1)+
	dbf	d1,Cred_ClrObjRam ; clear object RAM

	VDP_CMD move.l,$B400,VRAM,WRITE,VDP_CTRL
	lea	(Nem_CreditText).l,a0 ;	load credits alphabet patterns
	jsr	NemDec

	lea	(v_pal_dry_dup).w,a1
	moveq	#0,d0
	move.w	#$1F,d1

Cred_ClrPal:
	move.l	d0,(a1)+
	dbf	d1,Cred_ClrPal ; fill palette with black

	moveq	#palid_Sonic,d0
	jsr	PalLoad1	; load Sonic's palette
	move.b	#id_CreditsText,(v_objspace+$80).w ; load credits object

.WaitCDPlay:
	jsr	CheckCDDA
	beq.s	.WaitCDPlay

	move.w	(v_vdp_buffer1).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_CTRL).l

	bra.s	Cred_Start

Cred_Loop:
	jsr	PaletteFadeOut
	clr.b	(v_objspace+$80+obRoutine).w

Cred_Start:
	jsr	ExecuteObjects
	jsr	BuildSprites
	move.w	#120,(v_demolength).w ; display a credit for 2 seconds
	jsr	PaletteFadeIn

Cred_WaitLoop:
	move.b	#2,(v_vbla_routine).w
	jsr	WaitForVBla
	tst.w	(v_demolength).w ; have 2 seconds elapsed?
	bne.s	Cred_WaitLoop	; if not, branch
	cmpi.w	#8,(v_creditsnum).w ; have the credits finished?
	beq.s	TryAgainEnd	; if yes, branch
	addq.w	#1,(v_creditsnum).w
	bra.s	Cred_Loop	

; ===========================================================================
; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screens
; ---------------------------------------------------------------------------

TryAgainEnd:
	jsr	ClearPLC
	jsr	PaletteFadeOut
	lea	(VDP_CTRL).l,a6
	move.w	#$8004,(a6)	; use 8-colour mode
	move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
	move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
	move.w	#$9001,(a6)	; 64-cell hscroll size
	move.w	#$9200,(a6)	; window vertical position
	move.w	#$8B03,(a6)	; line scroll mode
	move.w	#$8720,(a6)	; set background colour (line 3; colour 0)
	clr.b	(f_wtr_state).w
	jsr	ClearScreen

	lea	(v_objspace).w,a1
	moveq	#0,d0
	move.w	#$7FF,d1

TryAg_ClrObjRam:
	move.l	d0,(a1)+
	dbf	d1,TryAg_ClrObjRam ; clear object RAM

	moveq	#plcid_TryAgain,d0
	jsr	QuickPLC	; load "TRY AGAIN" or "END" patterns

	lea	(v_pal_dry_dup).w,a1
	moveq	#0,d0
	move.w	#$1F,d1
TryAg_ClrPal:
	move.l	d0,(a1)+
	dbf	d1,TryAg_ClrPal ; fill palette with black

	moveq	#palid_Ending,d0
	jsr	PalLoad1	; load ending palette
	clr.w	(v_pal_dry_dup+$40).w
	move.b	#id_EndEggman,(v_objspace+$80).w ; load Eggman object
	jsr	ExecuteObjects
	jsr	BuildSprites
	move.w	#1800,(v_demolength).w ; show screen for 30 seconds
	jsr	PaletteFadeIn

; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screen main loop
; ---------------------------------------------------------------------------

TryAg_MainLoop:
	jsr	PauseGame
	move.b	#2,(v_vbla_routine).w
	jsr	WaitForVBla
	jsr	ExecuteObjects
	jsr	BuildSprites
	andi.b	#btnStart,(v_jpadpress1).w ; is Start button pressed?
	bne.s	TryAg_Exit	; if yes, branch
	tst.w	(v_demolength).w ; has 30 seconds elapsed?
	beq.s	TryAg_Exit	; if yes, branch
	cmpi.b	#id_Ending|$80,(v_gamemode).w
	beq.s	TryAg_MainLoop

TryAg_Exit:
	move.b	#id_Title,(v_gamemode).w ; goto Sega screen
	move.b	#bgm_Fade,d0
	jsr	PlaySound_Special
	jsr	StopCDDA
	jsr	PaletteFadeOut
	move	#$2700,sr
	rts	

; ---------------------------------------------------------------------------

Touch_Rings:
HUD_Update:
	rts

; -------------------------------------------------------------------------
; Code
; -------------------------------------------------------------------------

	include	"source/sonic/#ghz/Palette Cycle.asm"
	include "source/sonic/#end/Level Events.asm"
	include "source/sonic/#end/Animate.asm"
	include	"source/sonic/_inc/Interrupts.asm"
	include	"source/sonic/_inc/Level Object Animate.asm"
	include	"source/sonic/_inc/Oscillatory Routines.asm"
	include	"source/sonic/_inc/LevelSizeLoad & BgScrollSpeed (JP1).asm"
	include	"source/sonic/_inc/DeformLayers (JP1).asm"
	include	"source/sonic/_inc/Level Draw.asm"
	include	"source/sonic/_inc/Load Level Data.asm"
	include	"source/sonic/_inc/DynamicLevelEvents.asm"
	include	"source/sonic/_incObj/sub SmashObject.asm"
	include	"source/sonic/_inc/Object Manager.asm"
	include	"source/sonic/_incObj/sub FindFreeObj.asm"
	include	"source/sonic/_incObj/sub SolidObject.asm"
	include	"source/sonic/_incObj/sub FindNearestTile.asm"
	include	"source/sonic/_incObj/sub FindFloor.asm"
	include	"source/sonic/_incObj/sub FindWall.asm"
	include	"source/sonic/_incObj/Sonic AnglePos.asm"
	include	"source/sonic/_incObj/Sonic Floor.asm"
	include	"source/sonic/_incObj/Sonic ResetOnFloor.asm"
	include	"source/sonic/_incObj/sub ReactToItem.asm"
	include	"source/sonic/_incObj/sub RememberState.asm"
	include	"source/sonic/_incObj/sub AddPoints.asm"
	include	"source/sonic/_incObj/DebugMode.asm"
	include	"source/sonic/_inc/AnimateLevelGfx.asm"
	include	"source/sonic/_inc/Effects.asm"
	include	"source/sonic/_inc/Stage Music.asm"
	
; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"source/sonic/_incObj/01 Sonic.asm"
	include	"source/sonic/_maps/Explosions.asm"
	include	"source/sonic/_incObj/28 Animals.asm"
Map_Animal1:
	include	"source/sonic/_maps/Animals 1.asm"
Map_Animal2:
	include	"source/sonic/_maps/Animals 2.asm"
Map_Animal3:
	include	"source/sonic/_maps/Animals 3.asm"
	include	"source/sonic/_incObj/25 & 37 Rings.asm"
	include	"source/sonic/_anim/Rings.asm"
Map_Ring:
	include	"source/sonic/_maps/Rings.asm"
	include	"source/sonic/_incObj/79 Lamppost.asm"
Map_Lamp:
	include	"source/sonic/_maps/Lamppost.asm"
	include	"source/sonic/_incObj/87 Ending Sequence Sonic.asm"
	include "source/sonic/_anim/Ending Sequence Sonic.asm"
	include	"source/sonic/_incObj/88 Ending Sequence Emeralds.asm"
	include	"source/sonic/_incObj/89 Ending Sequence STH.asm"
Map_ECha:
	include	"source/sonic/_maps/Ending Sequence Emeralds.asm"
Map_ESth:
	include	"source/sonic/_maps/Ending Sequence STH.asm"
	include	"source/sonic/_incObj/8B Try Again & End Eggman.asm"
	include "source/sonic/_anim/Try Again & End Eggman.asm"
	include	"source/sonic/_incObj/8C Try Again Emeralds.asm"
Map_EEgg:
	include	"source/sonic/_maps/Try Again & End Eggman.asm"
	include	"source/sonic/_incObj/8A Credits.asm"
Map_Cred:
	include	"source/sonic/_maps/Credits.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

PathSwapper		EQU	NullObject
SecretWarp		EQU	NullObject
Splash			EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
Signpost		EQU	NullObject
Bridge			EQU	NullObject
SpinningLight		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
SwingingPlatform	EQU	NullObject
Harpoon			EQU	NullObject
Helix			EQU	NullObject
BasicPlatform		EQU	NullObject
CollapseLedge		EQU	NullObject
WaterSurface		EQU	NullObject
Scenery			EQU	NullObject
BallHog			EQU	NullObject
Crabmeat		EQU	NullObject
Cannonball		EQU	NullObject
BuzzBomber		EQU	NullObject
Missile			EQU	NullObject
MissileDissolve		EQU	NullObject
Monitor			EQU	NullObject
ExplosionItem		EQU	NullObject
Points			EQU	NullObject
AutoDoor		EQU	NullObject
Chopper			EQU	NullObject
Jaws			EQU	NullObject
Burrobot		EQU	NullObject
PowerUp			EQU	NullObject
LargeGrass		EQU	NullObject
GlassBlock		EQU	NullObject
ChainStomp		EQU	NullObject
Button			EQU	NullObject
PushBlock		EQU	NullObject
TitleCard		EQU	NullObject
GrassFire		EQU	NullObject
Spikes			EQU	NullObject
ShieldItem		EQU	NullObject
GameOverCard		EQU	NullObject
GotThroughCard		EQU	NullObject
PurpleRock		EQU	NullObject
SmashWall		EQU	NullObject
BossGreenHill		EQU	NullObject
Prison			EQU	NullObject
ExplosionBomb		EQU	NullObject
MotoBug			EQU	NullObject
Springs			EQU	NullObject
Newtron			EQU	NullObject
Roller			EQU	NullObject
EdgeWalls		EQU	NullObject
SideStomp		EQU	NullObject
MarbleBrick		EQU	NullObject
Bumper			EQU	NullObject
BossBall		EQU	NullObject
WaterSound		EQU	NullObject
VanishSonic		EQU	NullObject
GiantRing		EQU	NullObject
GeyserMaker		EQU	NullObject
LavaGeyser		EQU	NullObject
LavaWall		EQU	NullObject
Yadrin			EQU	NullObject
SmashBlock		EQU	NullObject
MovingBlock		EQU	NullObject
CollapseFloor		EQU	NullObject
LavaTag			EQU	NullObject
Basaran			EQU	NullObject
FloatingBlock		EQU	NullObject
SpikeBall		EQU	NullObject
BigSpikeBall		EQU	NullObject
Elevator		EQU	NullObject
CirclingPlatform	EQU	NullObject
Staircase		EQU	NullObject
Pylon			EQU	NullObject
Fan			EQU	NullObject
Seesaw			EQU	NullObject
Bomb			EQU	NullObject
Orbinaut		EQU	NullObject
LabyrinthBlock		EQU	NullObject
Gargoyle		EQU	NullObject
LabyrinthConvey		EQU	NullObject
Bubble			EQU	NullObject
Waterfall		EQU	NullObject
Junction		EQU	NullObject
RunningDisc		EQU	NullObject
Conveyor		EQU	NullObject
SpinPlatform		EQU	NullObject
Saws			EQU	NullObject
ScrapStomp		EQU	NullObject
VanishPlatform		EQU	NullObject
Flamethrower		EQU	NullObject
Electro			EQU	NullObject
SpinConvey		EQU	NullObject
Girder			EQU	NullObject
Invisibarrier		EQU	NullObject
Teleport		EQU	NullObject
BossMarble		EQU	NullObject
BossFire		EQU	NullObject
BossSpringYard		EQU	NullObject
BossBlock		EQU	NullObject
BossLabyrinth		EQU	NullObject
Caterkiller		EQU	NullObject
BossStarLight		EQU	NullObject
BossSpikeball		EQU	NullObject
RingFlash		EQU	NullObject
HiddenBonus		EQU	NullObject
ScrapEggman		EQU	NullObject
FalseFloor		EQU	NullObject
EggmanCylinder		EQU	NullObject
BossFinal		EQU	NullObject
BossPlasma		EQU	NullObject
MrRogers		EQU	NullObject

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#end/Palettes.asm"
	include "source/sonic/#end/Debug List.asm"
	include "source/sonic/#end/Level Headers.asm"
	include "source/sonic/#end/Pattern Load Cues.asm"

Obj_Index:
	include "source/sonic/_inc/Object Pointers.asm"

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

AngleMap:
	incbin	"source/sonic/collide/Angle Map.bin"
	even
CollArray1:
	incbin	"source/sonic/collide/Collision Array (Normal).bin"
	even
CollArray2:
	incbin	"source/sonic/collide/Collision Array (Rotated).bin"
	even

Art_Sonic:
	incbin	"source/sonic/artunc/Sonic.bin"
	even
Map_Sonic:
	include	"source/sonic/_maps/Sonic.asm"
SonicDynPLC:
	include	"source/sonic/_maps/Sonic - Dynamic Gfx Script.asm"

Art_BigRing:
	incbin	"source/sonic/artunc/Giant Ring.bin"
	even

Level_Act1:
Level_Act2:
Level_Act3:
Level_Act4:
	incbin	"source/sonic/levels/ending.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act2:
ObjPos_Act3:
ObjPos_Act4:
	incbin	"source/sonic/objpos/ending.bin"
	even
	dc.w $FFFF, 0, 0
	
RingPos_Act1:
RingPos_Act2:
RingPos_Act3:
RingPos_Act4:
	incbin	"source/sonic/ringpos/ending.bin"
	even

Blk16_GHZ:
	incbin	"source/sonic/map16/GHZ.bin"
	even
Nem_GHZ_1st:
	incbin	"source/sonic/artnem/8x8 - GHZ1.bin"	; GHZ primary patterns
	even
Nem_GHZ_2nd:
	incbin	"source/sonic/artnem/8x8 - GHZ2.bin"	; GHZ secondary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/GHZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/GHZ1.bin"	; GHZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/GHZ2.bin"	; GHZ index 2
	even

Art_GhzWater:
	incbin	"source/sonic/artunc/GHZ Waterfall.bin"
	even
Art_GhzFlower1:
	incbin	"source/sonic/artunc/GHZ Flower Large.bin"
	even
Art_GhzFlower2:
	incbin	"source/sonic/artunc/GHZ Flower Small.bin"
	even

Nem_Ring:
	incbin	"source/sonic/artnem/Rings.bin"
	even
Nem_Stalk:
	incbin	"source/sonic/artnem/GHZ Flower Stalk.bin"
	even
Nem_EndEm:
	incbin	"source/sonic/artnem/Ending - Emeralds.bin"
	even
Nem_EndFlower:
	incbin	"source/sonic/artnem/Ending - Flowers.bin"
	even
Nem_EndStH:
	incbin	"source/sonic/artnem/Ending - StH Logo.bin"
	even
Nem_TryAgain:
	incbin	"source/sonic/artnem/Ending - Try Again.bin"
	even
Nem_CreditText:
	incbin	"source/sonic/artnem/Ending - Credits.bin"
	even

Nem_Rabbit:
	incbin	"source/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Chicken:
	incbin	"source/sonic/artnem/Animal Chicken.bin"
	even
Nem_BlackBird:
	incbin	"source/sonic/artnem/Animal Blackbird.bin"
	even
Nem_Seal:
	incbin	"source/sonic/artnem/Animal Seal.bin"
	even
Nem_Pig:
	incbin	"source/sonic/artnem/Animal Pig.bin"
	even
Nem_Flicky:
	incbin	"source/sonic/artnem/Animal Flicky.bin"
	even
Nem_Squirrel:
	incbin	"source/sonic/artnem/Animal Squirrel.bin"
	even

Drown_WobbleData:

; -------------------------------------------------------------------------
