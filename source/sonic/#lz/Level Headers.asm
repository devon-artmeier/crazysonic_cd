; ---------------------------------------------------------------------------
; Level Headers
; ---------------------------------------------------------------------------

LevelHeaders:

lhead:	macro plc1,lvlgfx,plc2,sixteen,twofivesix,music,pal
	dc.l (plc1<<24)+lvlgfx
	dc.l (plc2<<24)+sixteen
	dc.l twofivesix
	dc.b 0, music, pal, pal
	endm

; 1st PLC, level gfx (unused), 2nd PLC, 16x16 data, 128x128 data,
; music (unused), palette (unused), palette

;		1st PLC				2nd PLC				128x128 data			palette
;				level gfx*			16x16 data			music*

	lhead	plcid_Level,	0,		plcid_Level2,	Blk16_LZ,	0,		0,		palid_Level
