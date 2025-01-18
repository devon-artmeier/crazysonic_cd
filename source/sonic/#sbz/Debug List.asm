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
	dbug	Map_Bomb,	id_Bomb,	0,	0,	$400
	dbug	Map_Orb,	id_Orbinaut,	0,	0,	$429
	dbug	Map_Cat,	id_Caterkiller,	0,	0,	$22B0
	dbug	Map_BBall,	id_SwingingPlatform, 7,	2,	$4391
	dbug	Map_Disc,	id_RunningDisc,	$E0,	0,	$C344
	dbug	Map_MBlock,	id_MovingBlock,	$28,	2,	$22C0
	dbug	Map_But,	id_Button,	0,	0,	$513
	dbug	Map_Trap,	id_SpinPlatform, 3,	0,	$4492
	dbug	Map_Spin,	id_SpinPlatform, $83,	0,	$4DF
	dbug	Map_Saw,	id_Saws,	2,	0,	$43B5
	dbug	Map_CFlo,	id_CollapseFloor, 0,	0,	$43F5
	dbug	Map_MBlock,	id_MovingBlock,	$39,	3,	$4460
	dbug	Map_Stomp,	id_ScrapStomp,	0,	0,	$22C0
	dbug	Map_ADoor,	id_AutoDoor,	0,	0,	$42E8
	dbug	Map_Stomp,	id_ScrapStomp,	$13,	1,	$22C0
	dbug	Map_Saw,	id_Saws,	1,	0,	$43B5
	dbug	Map_Stomp,	id_ScrapStomp,	$24,	1,	$22C0
	dbug	Map_Saw,	id_Saws,	4,	2,	$43B5
	dbug	Map_Stomp,	id_ScrapStomp,	$34,	1,	$22C0
	dbug	Map_VanP,	id_VanishPlatform, 0,	0,	$44C3
	dbug	Map_Flame,	id_Flamethrower, $64,	0,	$83D9
	dbug	Map_Flame,	id_Flamethrower, $64,	$B,	$83D9
	dbug	Map_Elec,	id_Electro,	4,	0,	$47E
	dbug	Map_Gird,	id_Girder,	0,	0,	$42F0
	dbug	Map_Invis,	id_Invisibarrier, $11,	0,	$8680
	dbug	Map_Hog,	id_BallHog,	4,	0,	$2302
	dbug	Map_Lamp,	id_Lamppost,	1,	0,	$7A0
	.end:

	even