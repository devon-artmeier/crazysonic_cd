; -------------------------------------------------------------------------
; Spring Yard Zone
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
	include	"source/sonic/#syz/Palette Cycle.asm"
	include "source/sonic/#syz/Level Events.asm"
	include "source/sonic/#syz/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Splash			EQU	NullObject
SecretWarp		EQU	NullObject
DrownCount		EQU	NullObject
Pole			EQU	NullObject
FlapDoor		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
SwingingPlatform	EQU	NullObject
Bridge			EQU	NullObject
Harpoon			EQU	NullObject
Helix			EQU	NullObject
CollapseLedge		EQU	NullObject
WaterSurface		EQU	NullObject
BallHog			EQU	NullObject
Cannonball		EQU	NullObject
AutoDoor		EQU	NullObject
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
EdgeWalls		EQU	NullObject
MarbleBrick		EQU	NullObject
BossBall		EQU	NullObject
WaterSound		EQU	NullObject
VanishSonic		EQU	NullObject
GeyserMaker		EQU	NullObject
LavaGeyser		EQU	NullObject
LavaWall		EQU	NullObject
SmashBlock		EQU	NullObject
MovingBlock		EQU	NullObject
CollapseFloor		EQU	NullObject
LavaTag			EQU	NullObject
Basaran			EQU	NullObject
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
	include	"source/sonic/_incObj/50 Yadrin.asm"
	include	"source/sonic/_anim/Yadrin.asm"
Map_Yad:
	include	"source/sonic/_maps/Yadrin.asm"
	include	"source/sonic/_incObj/43 Roller.asm"
	include	"source/sonic/_anim/Roller.asm"
Map_Roll:
	include	"source/sonic/_maps/Roller.asm"
	include	"source/sonic/_incObj/12 Light.asm"
Map_Light
	include	"source/sonic/_maps/Light.asm"
	include	"source/sonic/_incObj/47 Bumper.asm"
	include	"source/sonic/_anim/Bumper.asm"
Map_Bump:
	include	"source/sonic/_maps/Bumper.asm"
	include	"source/sonic/_incObj/56 Floating Blocks and Doors.asm"
Map_FBlock:
	include	"source/sonic/_maps/Floating Blocks and Doors.asm"
	include	"source/sonic/_incObj/32 Button.asm"
Map_But:
	include	"source/sonic/_maps/Button.asm"
	include	"source/sonic/_incObj/57 Spiked Ball and Chain.asm"
	include	"source/sonic/_incObj/58 Big Spiked Ball.asm"
	include	"source/sonic/_incObj/75 Boss - Spring Yard.asm"
	include	"source/sonic/_incObj/76 SYZ Boss Blocks.asm"
Map_BossBlock:
	include	"source/sonic/_maps/SYZ Boss Blocks.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#syz/Palettes.asm"
	include "source/sonic/#syz/Debug List.asm"
	include "source/sonic/#syz/Level Headers.asm"
	include "source/sonic/#syz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
Level_Act4:
	incbin	"source/sonic/levels/syz1.bin"
	even
Level_Act2:
	incbin	"source/sonic/levels/syz2.bin"
	even
Level_Act3:
	incbin	"source/sonic/levels/syz3.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
ObjPos_Act4:
	incbin	"source/sonic/objpos/syz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/syz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/syz3.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
RingPos_Act4:
	incbin	"source/sonic/ringpos/syz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/syz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/syz3.bin"
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

Blk16_SYZ:
	incbin	"source/sonic/map16/SYZ.bin"
	even
Nem_SYZ:
	incbin	"source/sonic/artnem/8x8 - SYZ.bin"	; MZ primary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/SYZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/SYZ1.bin"	; MZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/SYZ2.bin"	; MZ index 2
	even

Nem_Bumper:
	incbin	"source/sonic/artnem/SYZ Bumper.bin"
	even
Nem_SyzSpike2:
	incbin	"source/sonic/artnem/SYZ Small Spikeball.bin"
	even
Nem_LzSwitch:
	incbin	"source/sonic/artnem/Switch.bin"
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
Nem_Roller:
	incbin	"source/sonic/artnem/Enemy Roller.bin"
	even
Nem_Yadrin:
	incbin	"source/sonic/artnem/Enemy Yadrin.bin"
	even

Nem_Chicken:
	incbin	"source/sonic/artnem/Animal Chicken.bin"
	even
Nem_Pig:
	incbin	"source/sonic/artnem/Animal Pig.bin"
	even

; -------------------------------------------------------------------------
