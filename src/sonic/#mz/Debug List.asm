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
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	$345
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	$4000
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	$63A8
	dbug	Map_LWall,	id_LavaWall,	0,	0,	$63A8
	dbug	Map_Push,	id_PushBlock,	0,	0,	$42B8
	dbug	Map_Yad,	id_Yadrin,	0,	0,	$247B
	dbug	Map_Smab,	id_SmashBlock,	0,	0,	$42B8
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	$2B8
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	$62B8
	dbug	Map_LTag,	id_LavaTag,	0,	0,	$8680
	dbug	Map_Bas,	id_Basaran,	0,	0,	$4B8
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	$24FF
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	.end:

	even