Map_Jaws_internal:
	dc.w	.open1-Map_Jaws_internal
	dc.w	.shut1-Map_Jaws_internal
	dc.w	.open2-Map_Jaws_internal
	dc.w	.shut2-Map_Jaws_internal

.open1:	dc.w 2
	dc.w $F40E, 0, $FFF0
	dc.w $F505, $18, $10

.shut1:	dc.w 2
	dc.w $F40E, $C, $FFF0
	dc.w $F505, $1C, $10

.open2:	dc.w 2
	dc.w $F40E, 0, $FFF0
	dc.w $F505, $1018, $10

.shut2:	dc.w 2
	dc.w $F40E, $C, $FFF0
	dc.w $F505, $101C, $10

	even
