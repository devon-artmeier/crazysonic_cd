Map_Smash_internal:
	dc.w	.left-Map_Smash_internal
	dc.w	.middle-Map_Smash_internal
	dc.w	.right-Map_Smash_internal

.left:	dc.w 8
	dc.w $E005, 0, $FFF0
	dc.w $F005, 0, $FFF0
	dc.w 5, 0, $FFF0
	dc.w $1005, 0, $FFF0
	dc.w $E005, 4, 0
	dc.w $F005, 4, 0
	dc.w 5, 4, 0
	dc.w $1005, 4, 0

.middle:	dc.w 8
	dc.w $E005, 4, $FFF0
	dc.w $F005, 4, $FFF0
	dc.w 5, 4, $FFF0
	dc.w $1005, 4, $FFF0
	dc.w $E005, 4, 0
	dc.w $F005, 4, 0
	dc.w 5, 4, 0
	dc.w $1005, 4, 0

.right:	dc.w 8
	dc.w $E005, 4, $FFF0
	dc.w $F005, 4, $FFF0
	dc.w 5, 4, $FFF0
	dc.w $1005, 4, $FFF0
	dc.w $E005, 8, 0
	dc.w $F005, 8, 0
	dc.w 5, 8, 0
	dc.w $1005, 8, 0

	even
