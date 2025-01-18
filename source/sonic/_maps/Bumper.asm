Map_Bump_internal:
	dc.w	.normal-Map_Bump_internal
	dc.w	.bumped1-Map_Bump_internal
	dc.w	.bumped2-Map_Bump_internal

.normal:	dc.w 2
	dc.w $F007, 0, $FFF0
	dc.w $F007, $800, 0

.bumped1:	dc.w 2
	dc.w $F406, 8, $FFF4
	dc.w $F402, $808, 4

.bumped2:	dc.w 2
	dc.w $F007, $E, $FFF0
	dc.w $F007, $80E, 0

	even
