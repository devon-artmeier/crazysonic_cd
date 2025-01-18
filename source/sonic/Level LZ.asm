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
	include	"source/sonic/#lz/Palette Cycle.asm"
	include "source/sonic/#lz/Level Events.asm"
	include "source/sonic/#lz/Animate.asm"

; -------------------------------------------------------------------------
; Null objects
; -------------------------------------------------------------------------

Bridge			EQU	NullObject
SecretWarp		EQU	NullObject
SpinningLight		EQU	NullObject
LavaMaker		EQU	NullObject
LavaBall		EQU	NullObject
SwingingPlatform	EQU	NullObject
Helix			EQU	NullObject
CollapseLedge		EQU	NullObject
BallHog			EQU	NullObject
Crabmeat		EQU	NullObject
Cannonball		EQU	NullObject
BuzzBomber		EQU	NullObject
Missile			EQU	NullObject
AutoDoor		EQU	NullObject
Chopper			EQU	NullObject
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
CollapseFloor		EQU	NullObject
LavaTag			EQU	NullObject
Basaran			EQU	NullObject
BigSpikeBall		EQU	NullObject
Elevator		EQU	NullObject
CirclingPlatform	EQU	NullObject
Staircase		EQU	NullObject
Pylon			EQU	NullObject
Fan			EQU	NullObject
Seesaw			EQU	NullObject
Bomb			EQU	NullObject
Junction		EQU	NullObject
RunningDisc		EQU	NullObject
Conveyor		EQU	NullObject
SpinPlatform		EQU	NullObject
Saws			EQU	NullObject
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
DrownCount		EQU	NullObject
Bubble			EQU	NullObject
MrRogers		EQU	NullObject

; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"source/sonic/_incObj/08 Water Splash.asm"
	include	"source/sonic/_anim/Water Splash.asm"
Map_Splash:
	include	"source/sonic/_maps/Water Splash.asm"
	include	"source/sonic/_incObj/2C Jaws.asm"
	include	"source/sonic/_anim/Jaws.asm"
Map_Jaws:
	include	"source/sonic/_maps/Jaws.asm"
	include	"source/sonic/_incObj/2D Burrobot.asm"
	include	"source/sonic/_anim/Burrobot.asm"
Map_Burro:
	include	"source/sonic/_maps/Burrobot.asm"
	include	"source/sonic/_incObj/1B Water Surface.asm"
Map_Surf:
	include	"source/sonic/_maps/Water Surface.asm"
	include	"source/sonic/_incObj/0B Pole that Breaks.asm"
Map_Pole:
	include	"source/sonic/_maps/Pole that Breaks.asm"
	include	"source/sonic/_incObj/0C Flapping Door.asm"
	include	"source/sonic/_anim/Flapping Door.asm"
Map_Flap:
	include	"source/sonic/_maps/Flapping Door.asm"
	include	"source/sonic/_incObj/60 Orbinaut.asm"
	include	"source/sonic/_anim/Orbinaut.asm"
Map_Orb:
	include	"source/sonic/_maps/Orbinaut.asm"
	include	"source/sonic/_incObj/16 Harpoon.asm"
	include	"source/sonic/_anim/Harpoon.asm"
Map_Harp:
	include	"source/sonic/_maps/Harpoon.asm"
	include	"source/sonic/_incObj/61 LZ Blocks.asm"
Map_LBlock:
	include	"source/sonic/_maps/LZ Blocks.asm"
	include	"source/sonic/_incObj/62 Gargoyle.asm"
Map_Gar:
	include	"source/sonic/_maps/Gargoyle.asm"
	include	"source/sonic/_incObj/63 LZ Conveyor.asm"
Map_LConv:
	include	"source/sonic/_maps/LZ Conveyor.asm"
	include	"source/sonic/_incObj/65 Waterfalls.asm"
	include	"source/sonic/_anim/Waterfalls.asm"
Map_WFall:
	include	"source/sonic/_maps/Waterfalls.asm"
	include	"source/sonic/_incObj/52 Moving Blocks.asm"
	include	"source/sonic/_incObj/56 Floating Blocks and Doors.asm"
Map_FBlock:
	include	"source/sonic/_maps/Floating Blocks and Doors.asm"
	include	"source/sonic/_incObj/32 Button.asm"
Map_But:
	include	"source/sonic/_maps/Button.asm"
	include	"source/sonic/_incObj/57 Spiked Ball and Chain.asm"
	include	"source/sonic/_incObj/6B SBZ Stomper and Door.asm"
Map_Stomp:
	include	"source/sonic/_maps/SBZ Stomper and Door.asm"
	include	"source/sonic/_incObj/77 Boss - Labyrinth.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include "source/sonic/#lz/Palettes.asm"
	include "source/sonic/#lz/Debug List.asm"
	include "source/sonic/#lz/Level Headers.asm"
	include "source/sonic/#lz/Pattern Load Cues.asm"
	
; -------------------------------------------------------------------------

Level_Act1:
	incbin	"source/sonic/levels/lz1.bin"
	even
Level_Act2:
	incbin	"source/sonic/levels/lz2.bin"
	even
Level_Act3:
	incbin	"source/sonic/levels/lz3.bin"
	even
Level_Act4:
	incbin	"source/sonic/levels/sbz3.bin"
	even

	dc.w $FFFF, 0, 0
ObjPos_Act1:
	incbin	"source/sonic/objpos/lz1.bin"
	even
ObjPos_Act2:
	incbin	"source/sonic/objpos/lz2.bin"
	even
ObjPos_Act3:
	incbin	"source/sonic/objpos/lz3.bin"
	even
ObjPos_Act4:
	incbin	"source/sonic/objpos/sbz3.bin"
	even
	dc.w $FFFF, 0, 0

RingPos_Act1:
	incbin	"source/sonic/ringpos/lz1.bin"
	even
RingPos_Act2:
	incbin	"source/sonic/ringpos/lz2.bin"
	even
RingPos_Act3:
	incbin	"source/sonic/ringpos/lz3.bin"
	even
RingPos_Act4:
	incbin	"source/sonic/ringpos/sbz3.bin"
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
	
ObjPosLZPlatform_Index:
	dc.w	ObjPos_LZ1pf1-ObjPosLZPlatform_Index, ObjPos_LZ1pf2-ObjPosLZPlatform_Index
	dc.w	ObjPos_LZ2pf1-ObjPosLZPlatform_Index, ObjPos_LZ2pf2-ObjPosLZPlatform_Index
	dc.w	ObjPos_LZ3pf1-ObjPosLZPlatform_Index, ObjPos_LZ3pf2-ObjPosLZPlatform_Index
	dc.w	ObjPos_LZ1pf1-ObjPosLZPlatform_Index, ObjPos_LZ1pf2-ObjPosLZPlatform_Index

ObjPos_LZ1pf1:
	incbin	"source/sonic/objpos/lz1pf1.bin"
	even
ObjPos_LZ1pf2:
	incbin	"source/sonic/objpos/lz1pf2.bin"
	even
ObjPos_LZ2pf1:
	incbin	"source/sonic/objpos/lz2pf1.bin"
	even
ObjPos_LZ2pf2:
	incbin	"source/sonic/objpos/lz2pf2.bin"
	even
ObjPos_LZ3pf1:
	incbin	"source/sonic/objpos/lz3pf1.bin"
	even
ObjPos_LZ3pf2:
	incbin	"source/sonic/objpos/lz3pf2.bin"
	even

Blk16_LZ:
	incbin	"source/sonic/map16/LZ.bin"
	even
Nem_LZ:
	incbin	"source/sonic/artnem/8x8 - LZ.bin"	; LZ primary patterns
	even
LevelChunks:
	incbin	"source/sonic/map128/LZ.unc"
	even
Col_Level_1:
	incbin	"source/sonic/collide/LZ1.bin"	; LZ index 1
	even
Col_Level_2:
	incbin	"source/sonic/collide/LZ2.bin"	; LZ index 2
	even

Nem_Burrobot:
	incbin	"source/sonic/artnem/Enemy Burrobot.bin"
	even
Nem_Jaws:
	incbin	"source/sonic/artnem/Enemy Jaws.bin"
	even
Nem_Orbinaut:
	incbin	"source/sonic/artnem/Enemy Orbinaut.bin"
	even

Nem_Water:
	incbin	"source/sonic/artnem/LZ Water Surface.bin"
	even
Nem_Splash:
	incbin	"source/sonic/artnem/LZ Water & Splashes.bin"
	even
Nem_LzSpikeBall:
	incbin	"source/sonic/artnem/LZ Spiked Ball & Chain.bin"
	even
Nem_FlapDoor:
	incbin	"source/sonic/artnem/LZ Flapping Door.bin"
	even
Nem_LzBlock3:
	incbin	"source/sonic/artnem/LZ 32x16 Block.bin"
	even
Nem_LzDoor1:
	incbin	"source/sonic/artnem/LZ Vertical Door.bin"
	even
Nem_Harpoon:
	incbin	"source/sonic/artnem/LZ Harpoon.bin"
	even
Nem_LzPole:
	incbin	"source/sonic/artnem/LZ Breakable Pole.bin"
	even
Nem_LzDoor2:
	incbin	"source/sonic/artnem/LZ Horizontal Door.bin"
	even
Nem_LzWheel:
	incbin	"source/sonic/artnem/LZ Wheel.bin"
	even
Nem_Gargoyle:
	incbin	"source/sonic/artnem/LZ Gargoyle & Fireball.bin"
	even
Nem_LzBlock2:
	incbin	"source/sonic/artnem/LZ Blocks.bin"
	even
Nem_LzPlatfm:
	incbin	"source/sonic/artnem/LZ Rising Platform.bin"
	even
Nem_LzSwitch:
	incbin	"source/sonic/artnem/Switch.bin"
	even
Nem_Cork:
	incbin	"source/sonic/artnem/LZ Cork.bin"
	even
Nem_LzBlock1:
	incbin	"source/sonic/artnem/LZ 32x32 Block.bin"
	even

Nem_BlackBird:
	incbin	"source/sonic/artnem/Animal Blackbird.bin"
	even
Nem_Seal:
	incbin	"source/sonic/artnem/Animal Seal.bin"
	even

; -------------------------------------------------------------------------
