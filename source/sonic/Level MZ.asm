; -------------------------------------------------------------------------
; Marble Zone
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
	include	"source/sonic/#mz/Palette Cycle.asm"
	include "source/sonic/#mz/Level Events.asm"
	include "source/sonic/#mz/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Splash			EQU	NullObject
SecretWarp		EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
SpinningLight		EQU	NullObject
Bridge			EQU	NullObject
Harpoon			EQU	NullObject
Helix			EQU	NullObject
WaterSurface		EQU	NullObject
BallHog			EQU	NullObject
Crabmeat		EQU	NullObject
Cannonball		EQU	NullObject
AutoDoor		EQU	NullObject
Chopper			EQU	NullObject
Jaws			EQU	NullObject
Burrobot		EQU	NullObject
PurpleRock		EQU	NullObject
SmashWall		EQU	NullObject
BossGreenHill		EQU	NullObject
MotoBug			EQU	NullObject
Newtron			EQU	NullObject
Roller			EQU	NullObject
EdgeWalls		EQU	NullObject
Bumper			EQU	NullObject
BossBall		EQU	NullObject
WaterSound		EQU	NullObject
VanishSonic		EQU	NullObject
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
Teleport		EQU	NullObject
BossSpringYard		EQU	NullObject
BossBlock		EQU	NullObject
BossLabyrinth		EQU	NullObject
BossStarLight		EQU	NullObject
BossSpikeball		EQU	NullObject
ScrapEggman		EQU	NullObject
FalseFloor		EQU	NullObject
EggmanCylinder		EQU	NullObject
BossFinal		EQU	NullObject
BossPlasma		EQU	NullObject
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

	include	"source/sonic/_incObj/22 Buzz Bomber.asm"
	include	"source/sonic/_incObj/23 Buzz Bomber Missile.asm"
	include	"source/sonic/_anim/Buzz Bomber.asm"
	include	"source/sonic/_anim/Buzz Bomber Missile.asm"
Map_Buzz:
	include	"source/sonic/_maps/Buzz Bomber.asm"
Map_Missile:
	include	"source/sonic/_maps/Buzz Bomber Missile.asm"
	include	"source/sonic/_incObj/50 Yadrin.asm"
	include	"source/sonic/_anim/Yadrin.asm"
Map_Yad:
	include	"source/sonic/_maps/Yadrin.asm"
	include	"source/sonic/_incObj/55 Basaran.asm"
	include	"source/sonic/_anim/Basaran.asm"
Map_Bas:
	include	"source/sonic/_maps/Basaran.asm"
	include	"source/sonic/_incObj/78 Caterkiller.asm"
	include	"source/sonic/_anim/Caterkiller.asm"
Map_Cat:
	include	"source/sonic/_maps/Caterkiller.asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 1).asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 2).asm"
	include	"source/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"source/sonic/_incObj/2F MZ Large Grassy Platforms.asm"
	include	"source/sonic/_incObj/35 Burning Grass.asm"
	include	"source/sonic/_anim/Burning Grass.asm"
Map_LGrass:
	include	"source/sonic/_maps/MZ Large Grassy Platforms.asm"
Map_Fire:
	include	"source/sonic/_maps/Fireballs.asm"
	include	"source/sonic/_incObj/30 MZ Large Green Glass Blocks.asm"
Map_Glass:
	include	"source/sonic/_maps/MZ Large Green Glass Blocks.asm"
	include	"source/sonic/_incObj/31 Chained Stompers.asm"
Map_CStom:
	include	"source/sonic/_maps/Chained Stompers.asm"
	include	"source/sonic/_incObj/32 Button.asm"
Map_But:
	include	"source/sonic/_maps/Button.asm"
	include	"source/sonic/_incObj/33 Pushable Blocks.asm"
Map_Push:
	include	"source/sonic/_maps/Pushable Blocks.asm"
	include	"source/sonic/_incObj/13 Lava Ball Maker.asm"
	include	"source/sonic/_incObj/14 Lava Ball.asm"
	include	"source/sonic/_anim/Fireballs.asm"
	include	"source/sonic/_incObj/46 MZ Bricks.asm"
Map_Brick:
	include	"source/sonic/_maps/MZ Bricks.asm"
	include	"source/sonic/_incObj/4C & 4D Lava Geyser Maker.asm"
	include	"source/sonic/_incObj/4E Wall of Lava.asm"
	include	"source/sonic/_incObj/54 Lava Tag.asm"
Map_LTag:
	include	"source/sonic/_maps/Lava Tag.asm"
	include	"source/sonic/_anim/Lava Geyser.asm"
	include	"source/sonic/_anim/Wall of Lava.asm"
Map_Geyser:
	include	"source/sonic/_maps/Lava Geyser.asm"
Map_LWall:
	include	"source/sonic/_maps/Wall of Lava.asm"
	include	"source/sonic/_incObj/51 Smashable Green Block.asm"
Map_Smab:
	include	"source/sonic/_maps/Smashable Green Block.asm"
	include	"source/sonic/_incObj/52 Moving Blocks.asm"
	include	"source/sonic/_incObj/73 Boss - Marble.asm"
	include	"source/sonic/_incObj/74 MZ Boss Fire.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#mz/Palettes.asm"
	include "source/sonic/#mz/Debug List.asm"
	include "source/sonic/#mz/Level Headers.asm"
	include "source/sonic/#mz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"source/sonic/levels/mz1.bin"
	even
Level_Act2:
	incbin	"source/sonic/levels/mz2.bin"
	even
Level_Act3:
	incbin	"source/sonic/levels/mz3.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"source/sonic/objpos/mz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/mz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/mz3.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
RingPos_Act4:
	incbin	"source/sonic/ringpos/mz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/mz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/mz3.bin"
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

Blk16_MZ:
	incbin	"source/sonic/map16/MZ.bin"
	even
Nem_MZ:
	incbin	"source/sonic/artnem/8x8 - MZ.bin"	; MZ primary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/MZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/MZ1.bin"	; MZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/MZ2.bin"	; MZ index 2
	even

Art_MzLava1:
	incbin	"source/sonic/artunc/MZ Lava Surface.bin"
	even
Art_MzLava2:
	incbin	"source/sonic/artunc/MZ Lava.bin"
	even
Art_MzTorch:
	incbin	"source/sonic/artunc/MZ Background Torch.bin"
	even

Nem_Swing:
	incbin	"source/sonic/artnem/GHZ Swinging Platform.bin"
	even
Nem_MzMetal:
	incbin	"source/sonic/artnem/MZ Metal Blocks.bin"
	even
Nem_MzSwitch:
	incbin	"source/sonic/artnem/MZ Switch.bin"
	even
Nem_MzGlass:
	incbin	"source/sonic/artnem/MZ Green Glass Block.bin"
	even
Nem_MzFire:
	incbin	"source/sonic/artnem/Fireballs.bin"
	even
Nem_Lava:
	incbin	"source/sonic/artnem/MZ Lava.bin"
	even
Nem_MzBlock:
	incbin	"source/sonic/artnem/MZ Green Pushable Block.bin"
	even

Nem_Buzz:
	incbin	"source/sonic/artnem/Enemy Buzz Bomber.bin"
	even
Nem_Yadrin:
	incbin	"source/sonic/artnem/Enemy Yadrin.bin"
	even
Nem_Basaran:
	incbin	"source/sonic/artnem/Enemy Basaran.bin"
	even
Nem_Cater:
	incbin	"source/sonic/artnem/Enemy Caterkiller.bin"
	even

Nem_Seal:
	incbin	"source/sonic/artnem/Animal Seal.bin"
	even
Nem_Squirrel:
	incbin	"source/sonic/artnem/Animal Squirrel.bin"
	even

; -------------------------------------------------------------------------
