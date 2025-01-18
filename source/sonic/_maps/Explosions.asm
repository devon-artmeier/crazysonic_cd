; ---------------------------------------------------------------------------
; Sprite mappings - explosion from a badnik or monitor
; ---------------------------------------------------------------------------
Map_ExplodeItem:dc.w byte_8ED0-Map_ExplodeItem, byte_8ED6-Map_ExplodeItem
		dc.w byte_8EDC-Map_ExplodeItem, byte_8EE2-Map_ExplodeItem
		dc.w byte_8EF7-Map_ExplodeItem
		
byte_8ED0:	dc.w 1
	dc.w $F809, 0, $FFF4

byte_8ED6:	dc.w 1
	dc.w $F00F, 6, $FFF0

byte_8EDC:	dc.w 1
	dc.w $F00F, $16, $FFF0

byte_8EE2:	dc.w 4
	dc.w $EC0A, $26, $FFEC
	dc.w $EC05, $2F, 4
	dc.w $405, $182F, $FFEC
	dc.w $FC0A, $1826, $FFFC

byte_8EF7:	dc.w 4
	dc.w $EC0A, $33, $FFEC
	dc.w $EC05, $3C, 4
	dc.w $405, $183C, $FFEC
	dc.w $FC0A, $1833, $FFFC
	even
; ---------------------------------------------------------------------------
; Sprite mappings - explosion from when	a boss is destroyed
; ---------------------------------------------------------------------------
Map_ExplodeBomb:dc.w byte_8ED0-Map_ExplodeBomb
		dc.w byte_8F16-Map_ExplodeBomb
		dc.w byte_8F1C-Map_ExplodeBomb
		dc.w byte_8EE2-Map_ExplodeBomb
		dc.w byte_8EF7-Map_ExplodeBomb
		
byte_8F16:	dc.w 1
	dc.w $F00F, $0040, $FFF0
	
byte_8F1C:	dc.w 1
	dc.w $F00F, $0050, $FFF0
	even
