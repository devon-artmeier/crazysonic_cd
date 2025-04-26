Map_Invis_internal:
	dc.w	.solid-Map_Invis_internal
	dc.w	.unused1-Map_Invis_internal
	dc.w	.unused2-Map_Invis_internal

.solid:	dc.w 4
	dc.w $F005, $18, $FFF0
	dc.w $F005, $18, 0
	dc.w 5, $18, $FFF0
	dc.w 5, $18, 0

.unused1:	dc.w 4
	dc.w $E005, $18, $FFC0
	dc.w $E005, $18, $30
	dc.w $1005, $18, $FFC0
	dc.w $1005, $18, $30

.unused2:	dc.w 4
	dc.w $E005, $18, $FF80
	dc.w $E005, $18, $70
	dc.w $1005, $18, $FF80
	dc.w $1005, $18, $70

	even
