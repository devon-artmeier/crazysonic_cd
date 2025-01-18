Map_FFloor_internal:
	dc.w	.wholeblock-Map_FFloor_internal
	dc.w	.topleft-Map_FFloor_internal
	dc.w	.topright-Map_FFloor_internal
	dc.w	.bottomleft-Map_FFloor_internal
	dc.w	.bottomright-Map_FFloor_internal

.wholeblock:	dc.w 1
	dc.w $F00F, 0, $FFF0

.topleft:	dc.w 2
	dc.w $F801, 0, $FFF8
	dc.w $F801, 4, 0

.topright:	dc.w 2
	dc.w $F801, 8, $FFF8
	dc.w $F801, $C, 0

.bottomleft:	dc.w 2
	dc.w $F801, 2, $FFF8
	dc.w $F801, 6, 0

.bottomright:	dc.w 2
	dc.w $F801, $A, $FFF8
	dc.w $F801, $E, 0

	even
