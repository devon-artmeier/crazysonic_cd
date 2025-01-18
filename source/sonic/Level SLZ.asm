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
	include	"source/sonic/#slz/Palette Cycle.asm"
	include "source/sonic/#slz/Level Events.asm"
	include "source/sonic/#slz/Animate.asm"

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
Harpoon			EQU	NullObject
Helix			EQU	NullObject
WaterSurface		EQU	NullObject
BallHog			EQU	NullObject
Crabmeat		EQU	NullObject
Cannonball		EQU	NullObject
BuzzBomber		EQU	NullObject
Missile			EQU	NullObject
AutoDoor		EQU	NullObject
Chopper			EQU	NullObject
Jaws			EQU	NullObject
Burrobot		EQU	NullObject
LargeGrass		EQU	NullObject
GlassBlock		EQU	NullObject
ChainStomp		EQU	NullObject
Button			EQU	NullObject
PushBlock		EQU	NullObject
GrassFire		EQU	NullObject
PurpleRock		EQU	NullObject
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
MovingBlock		EQU	NullObject
LavaTag			EQU	NullObject
Basaran			EQU	NullObject
SpikeBall		EQU	NullObject
BigSpikeBall		EQU	NullObject
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

	include	"source/sonic/_incObj/15 Swinging Platforms (part 1).asm"
	include	"source/sonic/_incObj/15 Swinging Platforms (part 2).asm"
	include	"source/sonic/_incObj/1A & 53 Collapsing Ledge.asm"
	include	"source/sonic/_incObj/13 Lava Ball Maker.asm"
	include	"source/sonic/_incObj/14 Lava Ball.asm"
Map_Fire:
	include	"source/sonic/_maps/Fireballs.asm"
	include	"source/sonic/_anim/Fireballs.asm"
	include	"source/sonic/_incObj/3C Smashable Wall.asm"
Map_Smash:
	include	"source/sonic/_maps/Smashable Walls.asm"
	include	"source/sonic/_incObj/60 Orbinaut.asm"
	include	"source/sonic/_anim/Orbinaut.asm"
Map_Orb:
	include	"source/sonic/_maps/Orbinaut.asm"
	include	"source/sonic/_incObj/56 Floating Blocks and Doors.asm"
Map_FBlock:
	include	"source/sonic/_maps/Floating Blocks and Doors.asm"
	include	"source/sonic/_incObj/59 SLZ Elevators.asm"
Map_Elev:
	include	"source/sonic/_maps/SLZ Elevators.asm"
	include	"source/sonic/_incObj/5A SLZ Circling Platform.asm"
Map_Circ:
	include	"source/sonic/_maps/SLZ Circling Platform.asm"
	include	"source/sonic/_incObj/5B Staircase.asm"
Map_Stair:
	include	"source/sonic/_maps/Staircase.asm"
	include	"source/sonic/_incObj/5C Pylon.asm"
Map_Pylon:
	include	"source/sonic/_maps/Pylon.asm"
	include	"source/sonic/_incObj/5D Fan.asm"
Map_Fan:
	include	"source/sonic/_maps/Fan.asm"
	include	"source/sonic/_incObj/5E Seesaw.asm"
Map_Seesaw:
	include	"source/sonic/_maps/Seesaw.asm"
Map_SSawBall:
	include	"source/sonic/_maps/Seesaw Ball.asm"
	include	"source/sonic/_incObj/5F Bomb Enemy.asm"
	include	"source/sonic/_anim/Bomb Enemy.asm"
Map_Bomb:
	include	"source/sonic/_maps/Bomb Enemy.asm"
	include	"source/sonic/_incObj/7A Boss - Star Light.asm"
	include	"source/sonic/_incObj/7B SLZ Boss Spikeball.asm"
Map_BSBall:
	include	"source/sonic/_maps/SLZ Boss Spikeball.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#slz/Palettes.asm"
	include "source/sonic/#slz/Debug List.asm"
	include "source/sonic/#slz/Level Headers.asm"
	include "source/sonic/#slz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"source/sonic/levels/slz1.bin"
	even
Level_Act2:
	incbin	"source/sonic/levels/slz2.bin"
	even
Level_Act3:
	incbin	"source/sonic/levels/slz3.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"source/sonic/objpos/slz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/slz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/slz3.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
RingPos_Act4:
	incbin	"source/sonic/ringpos/slz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/slz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/slz3.bin"
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

Blk16_SLZ:
	incbin	"source/sonic/map16/SLZ.bin"
	even
Nem_SLZ:
	incbin	"source/sonic/artnem/8x8 - SLZ.bin"	; SLZ primary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/SLZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/SLZ1.bin"	; SLZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/SLZ2.bin"	; SLZ index 2
	even

Nem_Orbinaut:
	incbin	"source/sonic/artnem/Enemy Orbinaut.bin"
	even

Nem_MzFire:
	incbin	"source/sonic/artnem/Fireballs.bin"
	even
Nem_Seesaw:
	incbin	"source/sonic/artnem/SLZ Seesaw.bin"
	even
Nem_Fan:
	incbin	"source/sonic/artnem/SLZ Fan.bin"
	even
Nem_SlzWall:
	incbin	"source/sonic/artnem/SLZ Breakable Wall.bin"
	even
Nem_Pylon:
	incbin	"source/sonic/artnem/SLZ Pylon.bin"
	even
Nem_SlzSwing:
	incbin	"source/sonic/artnem/SLZ Swinging Platform.bin"
	even
Nem_SlzBlock:
	incbin	"source/sonic/artnem/SLZ 32x32 Block.bin"
	even
Nem_SlzCannon:
	incbin	"source/sonic/artnem/SLZ Cannon.bin"
	even

Nem_Pig:
	incbin	"source/sonic/artnem/Animal Pig.bin"
	even
Nem_Flicky:
	incbin	"source/sonic/artnem/Animal Flicky.bin"
	even

; -------------------------------------------------------------------------
