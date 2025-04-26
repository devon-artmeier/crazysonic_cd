; -------------------------------------------------------------------------
; Green Hill Zone
; -------------------------------------------------------------------------

	include	"src/include/main_cpu.inc"
	include	"src/include/main_program.inc"
	include	"src/Constants.asm"
	include	"src/Variables.asm"
	include	"src/Macros.asm"

	org	WORD_START
	
; -------------------------------------------------------------------------
; Code
; -------------------------------------------------------------------------

	include	"src/sonic/Level Common.asm"
	include	"src/sonic/#sbz/Palette Cycle.asm"
	include "src/sonic/#sbz/Level Events.asm"
	include "src/sonic/#sbz/Animate.asm"

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

	include	"src/sonic/_incObj/15 Swinging Platforms (part 1).asm"
	include	"src/sonic/_incObj/15 Swinging Platforms (part 2).asm"
	include	"src/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"src/sonic/_incObj/32 Button.asm"
Map_But:
	include	"src/sonic/_maps/Button.asm"
	include	"src/sonic/_incObj/52 Moving Blocks.asm"
	include	"src/sonic/_incObj/5F Bomb Enemy.asm"
	include	"src/sonic/_anim/Bomb Enemy.asm"
Map_Bomb:
	include	"src/sonic/_maps/Bomb Enemy.asm"
	include	"src/sonic/_incObj/60 Orbinaut.asm"
	include	"src/sonic/_anim/Orbinaut.asm"
Map_Orb:
	include	"src/sonic/_maps/Orbinaut.asm"
	include	"src/sonic/_incObj/78 Caterkiller.asm"
	include	"src/sonic/_anim/Caterkiller.asm"
Map_Cat:
	include	"src/sonic/_maps/Caterkiller.asm"
	include	"src/sonic/_incObj/2A SBZ Small Door.asm"
	include	"src/sonic/_anim/SBZ Small Door.asm"
Map_ADoor:
	include	"src/sonic/_maps/SBZ Small Door.asm"
	include	"src/sonic/_incObj/1E Ball Hog.asm"
	include	"src/sonic/_incObj/20 Cannonball.asm"
	include	"src/sonic/_anim/Ball Hog.asm"
Map_Hog:
	include	"src/sonic/_maps/Ball Hog.asm"
	include	"src/sonic/_incObj/6D Flamethrower.asm"
	include	"src/sonic/_anim/Flamethrower.asm"
Map_Flame:
	include	"src/sonic/_maps/Flamethrower.asm"
	include	"src/sonic/_incObj/66 Rotating Junction.asm"
Map_Jun:
	include	"src/sonic/_maps/Rotating Junction.asm"
	include	"src/sonic/_incObj/67 Running Disc.asm"
Map_Disc:
	include	"src/sonic/_maps/Running Disc.asm"
	include	"src/sonic/_incObj/68 Conveyor Belt.asm"
	include	"src/sonic/_incObj/69 SBZ Spinning Platforms.asm"
	include	"src/sonic/_anim/SBZ Spinning Platforms.asm"
Map_Trap:
	include	"src/sonic/_maps/Trapdoor.asm"
Map_Spin:
	include	"src/sonic/_maps/SBZ Spinning Platforms.asm"
	include	"src/sonic/_incObj/6A Saws and Pizza Cutters.asm"
Map_Saw:
	include	"src/sonic/_maps/Saws and Pizza Cutters.asm"
	include	"src/sonic/_incObj/6B SBZ Stomper and Door.asm"
Map_Stomp:
	include	"src/sonic/_maps/SBZ Stomper and Door.asm"
	include	"src/sonic/_incObj/6C SBZ Vanishing Platforms.asm"
	include	"src/sonic/_anim/SBZ Vanishing Platforms.asm"
Map_VanP:
	include	"src/sonic/_maps/SBZ Vanishing Platforms.asm"
	include	"src/sonic/_incObj/6E Electrocuter.asm"
	include	"src/sonic/_anim/Electrocuter.asm"
Map_Elec:
	include	"src/sonic/_maps/Electrocuter.asm"
	include	"src/sonic/_incObj/6F SBZ Spin Platform Conveyor.asm"
	include	"src/sonic/_anim/SBZ Spin Platform Conveyor.asm"
	include	"src/sonic/_incObj/70 Girder Block.asm"
Map_Gird:
	include	"src/sonic/_maps/Girder Block.asm"
	include	"src/sonic/_incObj/72 Teleporter.asm"
	include	"src/sonic/_incObj/82 Eggman - Scrap Brain 2.asm"
	include	"src/sonic/_anim/Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:
	include	"src/sonic/_maps/Eggman - Scrap Brain 2.asm"
	include	"src/sonic/_incObj/83 SBZ Eggman's Crumbling Floor.asm"
Map_FFloor:
	include	"src/sonic/_maps/SBZ Eggman's Crumbling Floor.asm"
	include	"src/sonic/_incObj/85 Boss - Final.asm"
	include	"src/sonic/_anim/FZ Eggman in Ship.asm"
Map_FZDamaged:
	include	"src/sonic/_maps/FZ Damaged Eggmobile.asm"
Map_FZLegs:
	include	"src/sonic/_maps/FZ Eggmobile Legs.asm"
	include	"src/sonic/_incObj/84 FZ Eggman's Cylinders.asm"
Map_EggCyl:
	include	"src/sonic/_maps/FZ Eggman's Cylinders.asm"
	include	"src/sonic/_incObj/86 FZ Plasma Ball Launcher.asm"
	include	"src/sonic/_anim/Plasma Ball Launcher.asm"
Map_PLaunch:
	include	"src/sonic/_maps/Plasma Ball Launcher.asm"
	include	"src/sonic/_anim/Plasma Balls.asm"
Map_Plasma:
	include	"src/sonic/_maps/Plasma Balls.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "src/sonic/#sbz/Palettes.asm"
	include "src/sonic/#sbz/Debug List.asm"
	include "src/sonic/#sbz/Level Headers.asm"
	include "src/sonic/#sbz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"src/sonic/levels/sbz1.bin"
	even
Level_Act2:
Level_Act3:
	incbin	"src/sonic/levels/sbz2.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"src/sonic/objpos/sbz1.bin"
	even
ObjPos_Act2:
	incbin	"src/sonic/objpos/sbz2.bin"
	even
ObjPos_Act3:
	incbin	"src/sonic/objpos/fz.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
RingPos_Act4:
	incbin	"src/sonic/ringpos/sbz1.bin"
	even
RingPos_Act2:
	incbin	"src/sonic/ringpos/sbz2.bin"
	even
RingPos_Act3:
	incbin	"src/sonic/ringpos/fz.bin"
	even

AngleMap:
	incbin	"src/sonic/collide/Angle Map.bin"
	even
CollArray1:
	incbin	"src/sonic/collide/Collision Array (Normal).bin"
	even
CollArray2:
	incbin	"src/sonic/collide/Collision Array (Rotated).bin"
	even

ObjPosSBZPlatform_Index:
	dc.w ObjPos_SBZ1pf1-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf2-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf3-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf4-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf5-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf6-ObjPosSBZPlatform_Index
	dc.w ObjPos_SBZ1pf1-ObjPosSBZPlatform_Index, ObjPos_SBZ1pf2-ObjPosSBZPlatform_Index

ObjPos_SBZ1pf1:
	incbin	"src/sonic/objpos/sbz1pf1.bin"
	even
ObjPos_SBZ1pf2:
	incbin	"src/sonic/objpos/sbz1pf2.bin"
	even
ObjPos_SBZ1pf3:
	incbin	"src/sonic/objpos/sbz1pf3.bin"
	even
ObjPos_SBZ1pf4:
	incbin	"src/sonic/objpos/sbz1pf4.bin"
	even
ObjPos_SBZ1pf5:
	incbin	"src/sonic/objpos/sbz1pf5.bin"
	even
ObjPos_SBZ1pf6:
	incbin	"src/sonic/objpos/sbz1pf6.bin"
	even

Blk16_SBZ:
	incbin	"src/sonic/map16/SBZ.bin"
	even
Nem_SBZ:
	incbin	"src/sonic/artnem/8x8 - SBZ.bin"	; SBZ primary patterns
	even
LevelChunks:
	incbin	"src/sonic/map128/SBZ.unc"
	even
Col_Level_1:
	incbin	"src/sonic/collide/SBZ1.bin"	; SBZ index 1
	even
Col_Level_2:
	incbin	"src/sonic/collide/SBZ2.bin"	; SBZ index 2
	even

Art_SbzSmoke:
	incbin	"src/sonic/artunc/SBZ Background Smoke.bin"
	even

Nem_BallHog:
	incbin	"src/sonic/artnem/Enemy Ball Hog.bin"
	even
Nem_Cater:
	incbin	"src/sonic/artnem/Enemy Caterkiller.bin"
	even
Nem_Orbinaut:
	incbin	"src/sonic/artnem/Enemy Orbinaut.bin"
	even

Nem_SbzWheel1:
	incbin	"src/sonic/artnem/SBZ Running Disc.bin"
	even
Nem_SbzWheel2:
	incbin	"src/sonic/artnem/SBZ Junction Wheel.bin"
	even
Nem_Cutter:
	incbin	"src/sonic/artnem/SBZ Pizza Cutter.bin"
	even
Nem_Stomper:
	incbin	"src/sonic/artnem/SBZ Stomper.bin"
	even
Nem_SpinPform:
	incbin	"src/sonic/artnem/SBZ Spinning Platform.bin"
	even
Nem_TrapDoor:
	incbin	"src/sonic/artnem/SBZ Trapdoor.bin"
	even
Nem_SbzFloor:
	incbin	"src/sonic/artnem/SBZ Collapsing Floor.bin"
	even
Nem_Electric:
	incbin	"src/sonic/artnem/SBZ Electrocuter.bin"
	even
Nem_SbzBlock:
	incbin	"src/sonic/artnem/SBZ Vanishing Block.bin"
	even
Nem_FlamePipe:
	incbin	"src/sonic/artnem/SBZ Flaming Pipe.bin"
	even
Nem_SbzDoor1:
	incbin	"src/sonic/artnem/SBZ Small Vertical Door.bin"
	even
Nem_SlideFloor:
	incbin	"src/sonic/artnem/SBZ Sliding Floor Trap.bin"
	even
Nem_SbzDoor2:
	incbin	"src/sonic/artnem/SBZ Large Horizontal Door.bin"
	even
Nem_Girder:
	incbin	"src/sonic/artnem/SBZ Crushing Girder.bin"
	even
Nem_LzSwitch:
	incbin	"src/sonic/artnem/Switch.bin"
	even
Nem_SyzSpike1:
	incbin	"src/sonic/artnem/SYZ Large Spikeball.bin"
	even
Nem_Sbz2Eggman:
	incbin	"src/sonic/artnem/Boss - Eggman in SBZ2 & FZ.bin"
	even
Nem_FzBoss:
	incbin	"src/sonic/artnem/Boss - Final Zone.bin"
	even
Nem_FzEggman:
	incbin	"src/sonic/artnem/Boss - Eggman after FZ Fight.bin"
	even

Nem_Rabbit:
	incbin	"src/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Chicken:
	incbin	"src/sonic/artnem/Animal Chicken.bin"
	even

; -------------------------------------------------------------------------
