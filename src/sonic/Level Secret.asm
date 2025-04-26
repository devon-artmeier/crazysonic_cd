; -------------------------------------------------------------------------
; Secret Zone
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
	include	"src/sonic/#secret/Palette Cycle.asm"
	include "src/sonic/#secret/Level Events.asm"
	include "src/sonic/#secret/Animate.asm"

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

	include	"src/sonic/_incObj/11 Bridge (part 1).asm"
	include	"src/sonic/_incObj/11 Bridge (part 2).asm"
	include	"src/sonic/_incObj/11 Bridge (part 3).asm"
	include	"src/sonic/_incObj/1F Crabmeat.asm"
	include	"src/sonic/_anim/Crabmeat.asm"
Map_Crab:
	include	"src/sonic/_maps/Crabmeat.asm"
	include	"src/sonic/_incObj/22 Buzz Bomber.asm"
	include	"src/sonic/_incObj/23 Buzz Bomber Missile.asm"
	include	"src/sonic/_anim/Buzz Bomber.asm"
	include	"src/sonic/_anim/Buzz Bomber Missile.asm"
Map_Buzz:
	include	"src/sonic/_maps/Buzz Bomber.asm"
Map_Missile:
	include	"src/sonic/_maps/Buzz Bomber Missile.asm"
	include	"src/sonic/_incObj/40 Moto Bug.asm"
	include	"src/sonic/_anim/Moto Bug.asm"
Map_Moto:
	include	"src/sonic/_maps/Moto Bug.asm"
	include	"src/sonic/_incObj/3B Purple Rock.asm"
	include	"src/sonic/_incObj/49 Waterfall Sound.asm"
Map_PRock:
	include	"src/sonic/_maps/Purple Rock.asm"
	include	"src/sonic/_incObj/3C Smashable Wall.asm"
Map_Smash:
	include	"src/sonic/_maps/Smashable Walls.asm"
	include	"src/sonic/_incObj/17 Spiked Pole Helix.asm"
Map_Hel:
	include	"src/sonic/_maps/Spiked Pole Helix.asm"
	include	"src/sonic/_incObj/44 GHZ Edge Walls.asm"
Map_Edge:
	include	"src/sonic/_maps/GHZ Edge Walls.asm"
	include	"src/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"src/sonic/_incObj/07 Secret Warp.asm"
	include	"src/sonic/_incObj/16 Harpoon.asm"
	include	"src/sonic/_anim/Harpoon.asm"
Map_Harp:
	include	"src/sonic/_maps/Harpoon.asm"
	include	"src/sonic/_incObj/78 Caterkiller.asm"
	include	"src/sonic/_anim/Caterkiller.asm"
Map_Cat:
	include	"src/sonic/_maps/Caterkiller.asm"
	include	"src/sonic/_incObj/50 Yadrin.asm"
	include	"src/sonic/_anim/Yadrin.asm"
Map_Yad:
	include	"src/sonic/_maps/Yadrin.asm"
	include	"src/sonic/_incObj/57 Spiked Ball and Chain.asm"
	include	"src/sonic/_incObj/58 Big Spiked Ball.asm"
	include "src/sonic/_incObj/Mr Rogers/06 Mr Rogers.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "src/sonic/#secret/Palettes.asm"
	include "src/sonic/#secret/Debug List.asm"
	include "src/sonic/#secret/Level Headers.asm"
	include "src/sonic/#secret/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act2:
Level_Act3:
Level_Act4:
	incbin	"src/sonic/levels/secret.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act2:
ObjPos_Act3:
ObjPos_Act4:
	incbin	"src/sonic/objpos/secret.bin"
	even
	dc.w $FFFF, 0, 0
	
RingPos_Act1:
RingPos_Act2:
RingPos_Act3:
RingPos_Act4:
	incbin	"src/sonic/ringpos/secret.bin"
	even

AngleMap:
	incbin	"src/sonic/collide/Angle Map (Secret).bin"
	even
CollArray1:
	incbin	"src/sonic/collide/Collision Array (Normal, Secret).bin"
	even
CollArray2:
	incbin	"src/sonic/collide/Collision Array (Rotated, Secret).bin"
	even

Blk16_Secret:
	incbin	"src/sonic/map16/Secret.bin"
	even
Nem_Secret:
	incbin	"src/sonic/artnem/8x8 - Secret.bin"	; Secret patterns
	even
LevelChunks:
	incbin	"src/sonic/map128/Secret.unc"
	even
Col_Level_1:
	incbin	"src/sonic/collide/Secret1.bin"	; Secret index 1
	even
Col_Level_2:
	incbin	"src/sonic/collide/Secret2.bin"	; Secret index 2
	even

Nem_Collapse:
	incbin	"src/sonic/artnem/Secret - Collapsing Floor.bin"
	even
Nem_Harpoon:
	incbin	"src/sonic/artnem/LZ Harpoon.bin"
	even
Nem_LzSpikeBall:
	incbin	"src/sonic/artnem/LZ Spiked Ball & Chain.bin"
	even
Nem_SyzSpike1:
	incbin	"src/sonic/artnem/SYZ Large Spikeball.bin"
	even

Nem_Crabmeat:
	incbin	"src/sonic/artnem/Enemy Crabmeat.bin"
	even
Nem_Buzz:
	incbin	"src/sonic/artnem/Enemy Buzz Bomber.bin"
	even
Nem_Motobug:
	incbin	"src/sonic/artnem/Enemy Motobug.bin"
	even
Nem_Cater:
	incbin	"src/sonic/artnem/Enemy Caterkiller.bin"
	even
Nem_Yadrin:
	incbin	"src/sonic/artnem/Enemy Yadrin.bin"
	even

Nem_Rabbit:
	incbin	"src/sonic/artnem/Animal Rabbit.bin"
	even
Nem_Flicky:
	incbin	"src/sonic/artnem/Animal Flicky.bin"
	even

Art_MrRogers:
	incbin	"src/sonic/_incObj/Mr Rogers/Art.nem"
	even
Map_MrRogers:
	incbin	"src/sonic/_incObj/Mr Rogers/Map.eni"
	even
Art_MrRogersFire:
	incbin	"src/sonic/_incObj/Mr Rogers/Fire Art.nem"
	even
Art_MrRogersFist:
	incbin	"src/sonic/_incObj/Mr Rogers/Fist Art.nem"
	even

; -------------------------------------------------------------------------
