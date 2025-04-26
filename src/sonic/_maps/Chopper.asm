Map_Chop_internal:
	dc.w	.mouthshut-Map_Chop_internal
	dc.w	.mouthopen-Map_Chop_internal

.mouthshut:	dc.w 1
	dc.w $F00F, 0, $FFF0

.mouthopen:	dc.w 1
	dc.w $F00F, $10, $FFF0

	even
