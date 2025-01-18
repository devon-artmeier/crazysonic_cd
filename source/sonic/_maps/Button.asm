Map_But_internal:
	dc.w	byte_BEAC-Map_But_internal
	dc.w	byte_BEB7-Map_But_internal
	dc.w	byte_BEC2-Map_But_internal
	dc.w	byte_BEB7-Map_But_internal

byte_BEAC:	dc.w 2
	dc.w $F505, 0, $FFF0
	dc.w $F505, $800, 0

byte_BEB7:	dc.w 2
	dc.w $F505, 4, $FFF0
	dc.w $F505, $804, 0

byte_BEC2:	dc.w 2
	dc.w $F505, $FFFC, $FFF0
	dc.w $F505, $7FC, 0

	even
