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
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Jaws,	id_Jaws,	8,	0,	$2486
	dbug	Map_Burro,	id_Burrobot,	0,	2,	$84A6
	dbug	Map_Harp,	id_Harpoon,	0,	0,	$3CC
	dbug	Map_Harp,	id_Harpoon,	2,	3,	$3CC
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_MBlockLZ,	id_MovingBlock,	4,	0,	$43BC
	dbug	Map_LBlock,	id_LabyrinthBlock, 1,	0,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, $13,	1,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, 5,	0,	$43E6
	dbug	Map_Gar,	id_Gargoyle,	0,	0,	$443E
	dbug	Map_LBlock,	id_LabyrinthBlock, $27,	2,	$43E6
	dbug	Map_LBlock,	id_LabyrinthBlock, $30,	3,	$43E6
	dbug	Map_LConv,	id_LabyrinthConvey, $7F, 0,	$3F6
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$467
	dbug	Map_WFall,	id_Waterfall,	2,	2,	$C259
	dbug	Map_WFall,	id_Waterfall,	9,	9,	$C259
	dbug	Map_Pole,	id_Pole,	0,	0,	$43DE
	dbug	Map_Flap,	id_FlapDoor,	2,	0,	$4328
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	.end:

	even