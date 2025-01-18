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
	include	"source/sonic/#ghz/Palette Cycle.asm"
	include "source/sonic/#ghz/Level Events.asm"
	include "source/sonic/#ghz/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Splash			EQU	NullObject
SecretWarp		EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
SpinningLight		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
Harpoon			EQU	NullObject
WaterSurface		EQU	NullObject
BallHog			EQU	NullObject
Cannonball		EQU	NullObject
AutoDoor		EQU	NullObject
Jaws			EQU	NullObject
Burrobot		EQU	NullObject
LargeGrass		EQU	NullObject
GlassBlock		EQU	NullObject
ChainStomp		EQU	NullObject
Button			EQU	NullObject
PushBlock		EQU	NullObject
GrassFire		EQU	NullObject
Roller			EQU	NullObject
MarbleBrick		EQU	NullObject
Bumper			EQU	NullObject
VanishSonic		EQU	NullObject
GeyserMaker		EQU	NullObject
LavaGeyser		EQU	NullObject
LavaWall		EQU	NullObject
Yadrin			EQU	NullObject
SmashBlock		EQU	NullObject
MovingBlock		EQU	NullObject
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
Teleport		EQU	NullObject
BossMarble		EQU	NullObject
BossFire		EQU	NullObject
BossSpringYard		EQU	NullObject
BossBlock		EQU	NullObject
BossLabyrinth		EQU	NullObject
Caterkiller		EQU	NullObject
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

	include	"source/sonic/_incObj/11 Bridge (part 1).asm"
	include	"source/sonic/_incObj/11 Bridge (part 2).asm"
	include	"source/sonic/_incObj/11 Bridge (part 3).asm"
	include	"source/sonic/_incObj/1F Crabmeat.asm"
	include	"source/sonic/_anim/Crabmeat.asm"
Map_Crab:
	include	"source/sonic/_maps/Crabmeat.asm"
	include	"source/sonic/_incObj/22 Buzz Bomber.asm"
	include	"source/sonic/_incObj/23 Buzz Bomber Missile.asm"
	include	"source/sonic/_anim/Buzz Bomber.asm"
	include	"source/sonic/_anim/Buzz Bomber Missile.asm"
Map_Buzz:
	include	"source/sonic/_maps/Buzz Bomber.asm"
Map_Missile:
	include	"source/sonic/_maps/Buzz Bomber Missile.asm"
	include	"source/sonic/_incObj/2B Chopper.asm"
	include	"source/sonic/_anim/Chopper.asm"
Map_Chop:
	include	"source/sonic/_maps/Chopper.asm"
	include	"source/sonic/_incObj/40 Moto Bug.asm"
	include	"source/sonic/_anim/Moto Bug.asm"
Map_Moto:
	include	"source/sonic/_maps/Moto Bug.asm"
	include	"source/sonic/_incObj/42 Newtron.asm"
	include	"source/sonic/_anim/Newtron.asm"
Map_Newt:
	include	"source/sonic/_maps/Newtron.asm"
	include	"source/sonic/_incObj/3B Purple Rock.asm"
	include	"source/sonic/_incObj/49 Waterfall Sound.asm"
Map_PRock:
	include	"source/sonic/_maps/Purple Rock.asm"
	include	"source/sonic/_incObj/3C Smashable Wall.asm"
Map_Smash:
	include	"source/sonic/_maps/Smashable Walls.asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 1).asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 2).asm"
	include	"source/sonic/_incObj/17 Spiked Pole Helix.asm"
Map_Hel:
	include	"source/sonic/_maps/Spiked Pole Helix.asm"
	include	"source/sonic/_incObj/44 GHZ Edge Walls.asm"
Map_Edge:
	include	"source/sonic/_maps/GHZ Edge Walls.asm"
	include	"source/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"source/sonic/_incObj/3D Boss - Green Hill (part 1).asm"
	include	"source/sonic/_incObj/3D Boss - Green Hill (part 2).asm"
	include	"source/sonic/_incObj/48 Eggman's Swinging Ball.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#ghz/Palettes.asm"
	include "source/sonic/#ghz/Debug List.asm"
	include "source/sonic/#ghz/Level Headers.asm"
	include "source/sonic/#ghz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"source/sonic/levels/ghz1.bin"
	even
Level_Act2:
	incbin	"source/sonic/levels/ghz2.bin"
	even
Level_Act3:
	incbin	"source/sonic/levels/ghz3.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"source/sonic/objpos/ghz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/ghz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/ghz3.bin"
	even
	dc.w $FFFF, 0, 0
	
RingPos_Act1:
RingPos_Act4:
	incbin	"source/sonic/ringpos/ghz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/ghz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/ghz3.bin"
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

Nem_Stalk:
	incbin	"source/sonic/artnem/GHZ Flower Stalk.bin"
	even
Nem_Swing:
	incbin	"source/sonic/artnem/GHZ Swinging Platform.bin"
	even
Nem_Bridge:
	incbin	"source/sonic/artnem/GHZ Bridge.bin"
	even
Nem_Ball:
	incbin	"source/sonic/artnem/GHZ Giant Ball.bin"
	even
Nem_SpikePole:
	incbin	"source/sonic/artnem/GHZ Spiked Log.bin"
	even
Nem_PplRock:
	incbin	"source/sonic/artnem/GHZ Purple Rock.bin"
	even
Nem_GhzWall1:
	incbin	"source/sonic/artnem/GHZ Breakable Wall.bin"
	even
Nem_GhzWall2:
	incbin	"source/sonic/artnem/GHZ Edge Wall.bin"
	even

Nem_Crabmeat:
	incbin	"source/sonic/artnem/Enemy Crabmeat.bin"
	even
Nem_Buzz:
	incbin	"source/sonic/artnem/Enemy Buzz Bomber.bin"
	even
Nem_Chopper:
	incbin	"source/sonic/artnem/Enemy Chopper.bin"
	even
Nem_Motobug:
	incbin	"source/sonic/artnem/Enemy Motobug.bin"
	even
Nem_Newtron:
	incbin	"source/sonic/artnem/Enemy Newtron.bin"
	even

Nem_Rabbit:
	incbin	"source/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Flicky:
	incbin	"source/sonic/artnem/Animal Flicky.bin"
	even

; -------------------------------------------------------------------------
