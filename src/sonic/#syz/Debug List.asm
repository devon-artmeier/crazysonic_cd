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
	dbug	Map_Spike,	id_Spikes,	0,	0,	$51B
	dbug	Map_Spring,	id_Springs,	0,	0,	$523
	dbug	Map_Roll,	id_Roller,	0,	0,	$4B8
	dbug	Map_Light,	id_SpinningLight, 0,	0,	0
	dbug	Map_Bump,	id_Bumper,	0,	0,	$380
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	$400
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	$444
	dbug	Map_Yad,	id_Yadrin,	0,	0,	$247B
	dbug	Map_Plat_SYZ,	id_BasicPlatform, 0,	0,	$4000
	dbug	Map_FBlock,	id_FloatingBlock, 0,	0,	$4000
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	.end:

	even