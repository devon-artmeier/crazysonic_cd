Map_Pylon_internal:
	dc.w	.pylon-Map_Pylon_internal

.pylon:	dc.w 9
	dc.w $800F, 0, $FFF0
	dc.w $A00F, $1000, $FFF0
	dc.w $C00F, 0, $FFF0
	dc.w $E00F, $1000, $FFF0
	dc.w $F, 0, $FFF0
	dc.w $200F, $1000, $FFF0
	dc.w $400F, 0, $FFF0
	dc.w $600F, $1000, $FFF0
	dc.w $7F0F, 0, $FFF0

	even
