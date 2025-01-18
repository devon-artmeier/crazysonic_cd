; ---------------------------------------------------------------------------
; Debug	mode item lists
; ---------------------------------------------------------------------------

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

DebugList:
	dc.w (.end-DebugList-2)/8

;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Chop,	id_Chopper,	0,	0,	$47B
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Plat_GHZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	$63D0
	dbug	Map_Moto,	id_MotoBug,	0,	0,	$4F0
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Newt,	id_Newtron,	0,	0,	$249B
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	$434C
	dbug	Map_GBall,	id_Obj19,	0,	0,	$43AA
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	dbug	Map_GRing,	id_GiantRing,	0,	0,	$2400
	dbug	Map_Bonus,	id_HiddenBonus,	1,	1,	$84B6
	.end:

	even