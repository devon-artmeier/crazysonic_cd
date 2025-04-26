Map_PLaunch_internal:
	dc.w	.red-Map_PLaunch_internal
	dc.w	.white-Map_PLaunch_internal
	dc.w	.sparking1-Map_PLaunch_internal
	dc.w	.sparking2-Map_PLaunch_internal

.red:	dc.w 1
	dc.w $F805, $6E, $FFF8

.white:	dc.w 1
	dc.w $F805, $76, $FFF8

.sparking1:	dc.w 1
	dc.w $F805, $72, $FFF8

.sparking2:	dc.w 1
	dc.w $F805, $1072, $FFF8

	even
