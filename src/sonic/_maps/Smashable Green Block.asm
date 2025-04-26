Map_Smab_internal:
	dc.w	.two-Map_Smab_internal
	dc.w	.four-Map_Smab_internal

.two:	dc.w 2
	dc.w $F00D, 0, $FFF0
	dc.w $D, 0, $FFF0

.four:	dc.w 4
	dc.w $F005, $8000, $FFF0
	dc.w 5, $8000, $FFF0
	dc.w $F005, $8000, 0
	dc.w 5, $8000, 0

	even
