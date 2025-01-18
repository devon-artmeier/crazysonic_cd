; -------------------------------------------------------------------------
; Green Hill Zone
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"

	org	WORD_START
	
; -------------------------------------------------------------------------
; Code
; -------------------------------------------------------------------------

	include	"source/sonic/Level Common.asm"
	include	"source/sonic/#sbz/Palette Cycle.asm"
	include "source/sonic/#sbz/Level Events.asm"
	include "source/sonic/#sbz/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Splash			EQU	NullObject
SecretWarp		EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
Bridge			EQU	NullObject
SpinningLight		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
Harpoon			EQU	NullObject
Helix			EQU	NullObject
WaterSurface		EQU	NullObject
Crabmeat		EQU	NullObject
BuzzBomber		EQU	NullObject
Missile			EQU	NullObject
Chopper			EQU	NullObject
Jaws			EQU	NullObject
Burrobot		EQU	NullObject
LargeGrass		EQU	NullObject
GlassBlock		EQU	NullObject
ChainStomp		EQU	NullObject
PushBlock		EQU	NullObject
GrassFire		EQU	NullObject
PurpleRock		EQU	NullObject
SmashWall		EQU	NullObject
BossGreenHill		EQU	NullObject
MotoBug			EQU	NullObject
Newtron			EQU	NullObject
Roller			EQU	NullObject
EdgeWalls		EQU	NullObject
SideStomp		EQU	NullObject
MarbleBrick		EQU	NullObject
Bumper			EQU	NullObject
BossBall		EQU	NullObject
WaterSound		EQU	NullObject
VanishSonic		EQU	NullObject
GeyserMaker		EQU	NullObject
LavaGeyser		EQU	NullObject
LavaWall		EQU	NullObject
Yadrin			EQU	NullObject
SmashBlock		EQU	NullObject
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
LabyrinthBlock		EQU	NullObject
Gargoyle		EQU	NullObject
LabyrinthConvey		EQU	NullObject
Bubble			EQU	NullObject
Waterfall		EQU	NullObject
BossMarble		EQU	NullObject
BossFire		EQU	NullObject
BossSpringYard		EQU	NullObject
BossBlock		EQU	NullObject
BossLabyrinth		EQU	NullObject
BossStarLight		EQU	NullObject
BossSpikeball		EQU	NullObject
EndSonic		EQU	NullObject
EndChaos		EQU	NullObject
EndSTH			EQU	NullObject
CreditsText		EQU	NullObject
EndEggman		EQU	NullObject
TryChaos		EQU	NullObject
MrRogers		EQU	NullObject

; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"source/sonic/_incObj/15 Swinging Platforms (part 1).asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 2).asm"
	include	"source/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"source/sonic/_incObj/32 Button.asm"
Map_But:
	include	"source/sonic/_maps/Button.asm"
	include	"source/sonic/_incObj/52 Moving Blocks.asm"
	include	"source/sonic/_incObj/5F Bomb Enemy.asm"
	include	"source/sonic/_anim/Bomb Enemy.asm"
Map_Bomb:
	include	"source/sonic/_maps/Bomb Enemy.asm"
	include	"source/sonic/_incObj/60 Orbinaut.asm"
	include	"source/sonic/_anim/Orbinaut.asm"
Map_Orb:
	include	"source/sonic/_maps/Orbinaut.asm"
	include	"source/sonic/_incObj/78 Caterkiller.asm"
	include	"source/sonic/_anim/Caterkiller.asm"
Map_Cat:
	include	"source/sonic/_maps/Caterkiller.asm"
	include	"source/sonic/_incObj/2A SBZ Small Door.asm"
	include	"source/sonic/_anim/SBZ Small Door.asm"
Map_ADoor:
	include	"source/sonic/_maps/SBZ Small Door.asm"
	include	"source/sonic/_incObj/1E Ball Hog.asm"
	include	"source/sonic/_incObj/20 Cannonball.asm"
	include	"source/sonic/_anim/Ball Hog.asm"
Map_Hog:
	include	"source/sonic/_maps/Ball Hog.asm"
	include	"source/sonic/_incObj/6D Flamethrower.asm"
	include	"source/sonic/_anim/Flamethrower.asm"
Map_Flame:
	include	"source/sonic/_maps/Flamethrower.asm"
	include	"source/sonic/_incObj/66 Rotating Junction.asm"
Map_Jun:
	include	"source/sonic/_maps/Rotating Junction.asm"
	include	"source/sonic/_incObj/67 Running Disc.asm"
Map_Disc:
	include	"source/sonic/_maps/Running Disc.asm"
	include	"source/sonic/_incObj/68 Conveyor Belt.asm"
	include	"source/sonic/_incObj/69 SBZ Spinning Platforms.asm"
	include	"source/sonic/_anim/SBZ Spinning Platforms.asm"
Map_Trap:
	include	"source/sonic/_maps/Trapdoor.asm"
Map_Spin:
	include	"source/sonic/_maps/SBZ Spinning Platforms.asm"
	include	"source/sonic/_incObj/6A Saws and Pizza Cutters.asm"
Map_Saw:
	include	"source/sonic/_maps/Saws and Pizza Cutters.asm"
	include	"source/sonic/_incObj/6B SBZ Stomper and Door.asm"
Map_Stomp:
	include	"source/sonic/_maps/SBZ Stomper and Door.asm"
	include	"source/sonic/_incObj/6C SBZ Vanishing Platforms.asm"
	include	"source/sonic/_anim/SBZ Vanishing Platforms.asm"
Map_VanP:
	include	"source/sonic/_maps/SBZ Vanishing Platforms.asm"
	include	"source/sonic/_incObj/6E Electrocuter.asm"
	include	"source/sonic/_anim/Electrocuter.asm"
Map_Elec:
	include	"source/sonic/_maps/Electrocuter.asm"
	include	"source/sonic/_incObj/6F SBZ Spin Platform Conveyor.asm"
	include	"source/sonic/_anim/SBZ Spin Platform Conveyor.asm"
	include	"source/sonic/_incObj/70 Girder Block.asm"
Map_Gird:
	include	"source/sonic/_maps/Girder Block.asm"
	include	"source/sonic/_incObj/72 Teleporter.asm"
	include	"source/sonic/_incObj/82 Eggman - Scrap Brain 2.asm"
	include	"source/sonic/_anim/Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:
	include	"source/sonic/_maps/Eggman - Scrap Brain 2.asm"
	include	"source/sonic/_incObj/83 SBZ Eggman's Crumbling Floor.asm"
Map_FFloor:
	include	"source/sonic/_maps/SBZ Eggman's Crumbling Floor.asm"
	include	"source/sonic/_incObj/85 Boss - Final.asm"
	include	"source/sonic/_anim/FZ Eggman in Ship.asm"
Map_FZDamaged:
	include	"source/sonic/_maps/FZ Damaged Eggmobile.asm"
Map_FZLegs:
	include	"source/sonic/_maps/FZ Eggmobile Legs.asm"
	include	"source/sonic/_incObj/84 FZ Eggman's Cylinders.asm"
Map_EggCyl:
	include	"source/sonic/_maps/FZ Eggman's Cylinders.asm"
	include	"source/sonic/_incObj/86 FZ Plasma Ball Launcher.asm"
	include	"source/sonic/_anim/Plasma Ball Launcher.asm"
Map_PLaunch:
	include	"source/sonic/_maps/Plasma Ball Launcher.asm"
	include	"source/sonic/_anim/Plasma Balls.asm"
Map_Plasma:
	include	"source/sonic/_maps/Plasma Balls.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#sbz/Palettes.asm"
	include "source/sonic/#sbz/Debug List.asm"
	include "source/sonic/#sbz/Level Headers.asm"
	include "source/sonic/#sbz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"source/sonic/levels/sbz1.bin"
	even
Level_Act2:
Level_Act3:
	incbin	"source/sonic/levels/sbz2.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"source/sonic/objpos/sbz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/sbz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/fz.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
RingPos_Act4:
	incbin	"source/sonic/ringpos/sbz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/sbz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/fz.bin"
	even

AngleMap:
	incbin	"source/sonic/collide/Angle Map.bin"
	even
CollArray1:
	incbin	"source/sonic/collide/Collision Array (Normal).bin"
	even
CollArray2:
	incbin	"source/sonic/collide/Collision Array (Rotated).bin"
	even

ObjPosSBZPlatform_Index:
	dc.w ObjPos_SBZ1pf1-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf2-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf3-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf4-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf5-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf6-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf1-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf2-ObjPosSBZPlatform_Index

ObjPos_SBZ1pf1:
	incbin	"source/sonic/objpos/sbz1pf1.bin"
	even
ObjPos_SBZ1pf2:
	incbin	"source/sonic/objpos/sbz1pf2.bin"
	even
ObjPos_SBZ1pf3:
	incbin	"source/sonic/objpos/sbz1pf3.bin"
	even
ObjPos_SBZ1pf4:
	incbin	"source/sonic/objpos/sbz1pf4.bin"
	even
ObjPos_SBZ1pf5:
	incbin	"source/sonic/objpos/sbz1pf5.bin"
	even
ObjPos_SBZ1pf6:
	incbin	"source/sonic/objpos/sbz1pf6.bin"
	even

Blk16_SBZ:
	incbin	"source/sonic/map16/SBZ.bin"
	even
Nem_SBZ:
	incbin	"source/sonic/artnem/8x8 - SBZ.bin"	; SBZ primary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/SBZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/SBZ1.bin"	; SBZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/SBZ2.bin"	; SBZ index 2
	even

Art_SbzSmoke:
	incbin	"source/sonic/artunc/SBZ Background Smoke.bin"
	even

Nem_BallHog:
	incbin	"source/sonic/artnem/Enemy Ball Hog.bin"
	even
Nem_Cater:
	incbin	"source/sonic/artnem/Enemy Caterkiller.bin"
	even
Nem_Orbinaut:
	incbin	"source/sonic/artnem/Enemy Orbinaut.bin"
	even

Nem_SbzWheel1:
	incbin	"source/sonic/artnem/SBZ Running Disc.bin"
	even
Nem_SbzWheel2:
	incbin	"source/sonic/artnem/SBZ Junction Wheel.bin"
	even
Nem_Cutter:
	incbin	"source/sonic/artnem/SBZ Pizza Cutter.bin"
	even
Nem_Stomper:
	incbin	"source/sonic/artnem/SBZ Stomper.bin"
	even
Nem_SpinPform:
	incbin	"source/sonic/artnem/SBZ Spinning Platform.bin"
	even
Nem_TrapDoor:
	incbin	"source/sonic/artnem/SBZ Trapdoor.bin"
	even
Nem_SbzFloor:
	incbin	"source/sonic/artnem/SBZ Collapsing Floor.bin"
	even
Nem_Electric:
	incbin	"source/sonic/artnem/SBZ Electrocuter.bin"
	even
Nem_SbzBlock:
	incbin	"source/sonic/artnem/SBZ Vanishing Block.bin"
	even
Nem_FlamePipe:
	incbin	"source/sonic/artnem/SBZ Flaming Pipe.bin"
	even
Nem_SbzDoor1:
	incbin	"source/sonic/artnem/SBZ Small Vertical Door.bin"
	even
Nem_SlideFloor:
	incbin	"source/sonic/artnem/SBZ Sliding Floor Trap.bin"
	even
Nem_SbzDoor2:
	incbin	"source/sonic/artnem/SBZ Large Horizontal Door.bin"
	even
Nem_Girder:
	incbin	"source/sonic/artnem/SBZ Crushing Girder.bin"
	even
Nem_LzSwitch:
	incbin	"source/sonic/artnem/Switch.bin"
	even
Nem_SyzSpike1:
	incbin	"source/sonic/artnem/SYZ Large Spikeball.bin"
	even
Nem_Sbz2Eggman:
	incbin	"source/sonic/artnem/Boss - Eggman in SBZ2 & FZ.bin"
	even
Nem_FzBoss:
	incbin	"source/sonic/artnem/Boss - Final Zone.bin"
	even
Nem_FzEggman:
	incbin	"source/sonic/artnem/Boss - Eggman after FZ Fight.bin"
	even

Nem_Rabbit:
	incbin	"source/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Chicken:
	incbin	"source/sonic/artnem/Animal Chicken.bin"
	even

; -------------------------------------------------------------------------
