; -------------------------------------------------------------------------
; Secret Zone
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
	include	"source/sonic/#secret/Palette Cycle.asm"
	include "source/sonic/#secret/Level Events.asm"
	include "source/sonic/#secret/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Splash			EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
SpinningLight		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
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
SmashBlock		EQU	NullObject
MovingBlock		EQU	NullObject
LavaTag			EQU	NullObject
Basaran			EQU	NullObject
FloatingBlock		EQU	NullObject
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
Newtron			EQU	NullObject
Chopper			EQU	NullObject
SwingingPlatform	EQU	NullObject
BossBall		EQU	NullObject
BossGreenHill		EQU	NullObject

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
	include	"source/sonic/_incObj/40 Moto Bug.asm"
	include	"source/sonic/_anim/Moto Bug.asm"
Map_Moto:
	include	"source/sonic/_maps/Moto Bug.asm"
	include	"source/sonic/_incObj/3B Purple Rock.asm"
	include	"source/sonic/_incObj/49 Waterfall Sound.asm"
Map_PRock:
	include	"source/sonic/_maps/Purple Rock.asm"
	include	"source/sonic/_incObj/3C Smashable Wall.asm"
Map_Smash:
	include	"source/sonic/_maps/Smashable Walls.asm"
	include	"source/sonic/_incObj/17 Spiked Pole Helix.asm"
Map_Hel:
	include	"source/sonic/_maps/Spiked Pole Helix.asm"
	include	"source/sonic/_incObj/44 GHZ Edge Walls.asm"
Map_Edge:
	include	"source/sonic/_maps/GHZ Edge Walls.asm"
	include	"source/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"source/sonic/_incObj/07 Secret Warp.asm"
	include	"source/sonic/_incObj/16 Harpoon.asm"
	include	"source/sonic/_anim/Harpoon.asm"
Map_Harp:
	include	"source/sonic/_maps/Harpoon.asm"
	include	"source/sonic/_incObj/78 Caterkiller.asm"
	include	"source/sonic/_anim/Caterkiller.asm"
Map_Cat:
	include	"source/sonic/_maps/Caterkiller.asm"
	include	"source/sonic/_incObj/50 Yadrin.asm"
	include	"source/sonic/_anim/Yadrin.asm"
Map_Yad:
	include	"source/sonic/_maps/Yadrin.asm"
	include	"source/sonic/_incObj/57 Spiked Ball and Chain.asm"
	include	"source/sonic/_incObj/58 Big Spiked Ball.asm"
	include "source/sonic/_incObj/Mr Rogers/06 Mr Rogers.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#secret/Palettes.asm"
	include "source/sonic/#secret/Debug List.asm"
	include "source/sonic/#secret/Level Headers.asm"
	include "source/sonic/#secret/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act2:
Level_Act3:
Level_Act4:
	incbin	"source/sonic/levels/secret.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act2:
ObjPos_Act3:
ObjPos_Act4:
	incbin	"source/sonic/objpos/secret.bin"
	even
	dc.w $FFFF, 0, 0
	
RingPos_Act1:
RingPos_Act2:
RingPos_Act3:
RingPos_Act4:
	incbin	"source/sonic/ringpos/secret.bin"
	even

AngleMap:
	incbin	"source/sonic/collide/Angle Map (Secret).bin"
	even
CollArray1:
	incbin	"source/sonic/collide/Collision Array (Normal, Secret).bin"
	even
CollArray2:
	incbin	"source/sonic/collide/Collision Array (Rotated, Secret).bin"
	even

Blk16_Secret:
	incbin	"source/sonic/map16/Secret.bin"
	even
Nem_Secret:
	incbin	"source/sonic/artnem/8x8 - Secret.bin"	; Secret patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/Secret.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/Secret1.bin"	; Secret index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/Secret2.bin"	; Secret index 2
	even

Nem_Collapse:
	incbin	"source/sonic/artnem/Secret - Collapsing Floor.bin"
	even
Nem_Harpoon:
	incbin	"source/sonic/artnem/LZ Harpoon.bin"
	even
Nem_LzSpikeBall:
	incbin	"source/sonic/artnem/LZ Spiked Ball & Chain.bin"
	even
Nem_SyzSpike1:
	incbin	"source/sonic/artnem/SYZ Large Spikeball.bin"
	even

Nem_Crabmeat:
	incbin	"source/sonic/artnem/Enemy Crabmeat.bin"
	even
Nem_Buzz:
	incbin	"source/sonic/artnem/Enemy Buzz Bomber.bin"
	even
Nem_Motobug:
	incbin	"source/sonic/artnem/Enemy Motobug.bin"
	even
Nem_Cater:
	incbin	"source/sonic/artnem/Enemy Caterkiller.bin"
	even
Nem_Yadrin:
	incbin	"source/sonic/artnem/Enemy Yadrin.bin"
	even

Nem_Rabbit:
	incbin	"source/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Flicky:
	incbin	"source/sonic/artnem/Animal Flicky.bin"
	even

Art_MrRogers:
	incbin	"source/sonic/_incObj/Mr Rogers/Art.nem"
	even
Map_MrRogers:
	incbin	"source/sonic/_incObj/Mr Rogers/Map.eni"
	even
Art_MrRogersFire:
	incbin	"source/sonic/_incObj/Mr Rogers/Fire Art.nem"
	even
Art_MrRogersFist:
	incbin	"source/sonic/_incObj/Mr Rogers/Fist Art.nem"
	even

; -------------------------------------------------------------------------
