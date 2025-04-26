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
	dbug	Map_Ring,	id_Rings,	0,	0,	$27B2
	dbug	Map_Monitor,	id_Monitor,	0,	0,	$680
	dbug	Map_Elev,	id_Elevator,	0,	0,	$4000
	dbug	Map_CFlo,	id_CollapseFloor, 0,	2,	$44E0
	dbug	Map_Plat_SLZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_Circ,	id_CirclingPlatform, 0,	0,	$4000
	dbug	Map_Stair,	id_Staircase,	0,	0,	$4000
	dbug	Map_Fan,	id_Fan,		0,	0,	$43A0
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	$374
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$480
	dbug	Map_Scen,	id_Scenery,	0,	0,	$44D8
	dbug	Map_Bomb,	id_Bomb,	0,	0,	$400
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$2429
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	.end:

	even