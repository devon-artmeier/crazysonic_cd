Map_Bonus_internal:
	dc.w	.blank-Map_Bonus_internal
	dc.w	.10000-Map_Bonus_internal
	dc.w	.1000-Map_Bonus_internal
	dc.w	.100-Map_Bonus_internal

.blank:	dc.w 0

.10000:	dc.w 1
	dc.w $F40E, 0, $FFF0

.1000:	dc.w 1
	dc.w $F40E, $C, $FFF0

.100:	dc.w 1
	dc.w $F40E, $18, $FFF0

	even
