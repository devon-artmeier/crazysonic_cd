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
	.end:

	even