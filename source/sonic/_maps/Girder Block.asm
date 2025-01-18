Map_Gird_internal:
	dc.w	.girder-Map_Gird_internal

.girder:	dc.w $C
	dc.w $E80E, 0, $FFA0
	dc.w $E, $1000, $FFA0
	dc.w $E80E, 6, $FFC0
	dc.w $E, $1006, $FFC0
	dc.w $E80E, 6, $FFE0
	dc.w $E, $1006, $FFE0
	dc.w $E80E, 6, 0
	dc.w $E, $1006, 0
	dc.w $E80E, 6, $20
	dc.w $E, $1006, $20
	dc.w $E80E, 6, $40
	dc.w $E, $1006, $40

	even
