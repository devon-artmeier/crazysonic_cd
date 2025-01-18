Map_Edge_internal:
	dc.w	M_Edge_Shadow-Map_Edge_internal
	dc.w	M_Edge_Light-Map_Edge_internal
	dc.w	M_Edge_Dark-Map_Edge_internal

M_Edge_Shadow:	dc.w 4
	dc.w $E005, 4, $FFF8
	dc.w $F005, 8, $FFF8
	dc.w 5, 8, $FFF8
	dc.w $1005, 8, $FFF8

M_Edge_Light:	dc.w 4
	dc.w $E005, 8, $FFF8
	dc.w $F005, 8, $FFF8
	dc.w 5, 8, $FFF8
	dc.w $1005, 8, $FFF8

M_Edge_Dark:	dc.w 4
	dc.w $E005, 0, $FFF8
	dc.w $F005, 0, $FFF8
	dc.w 5, 0, $FFF8
	dc.w $1005, 0, $FFF8

	even
