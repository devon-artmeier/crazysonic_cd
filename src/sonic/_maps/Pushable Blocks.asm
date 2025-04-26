Map_Push_internal:
	dc.w	.single-Map_Push_internal
	dc.w	.four-Map_Push_internal

.single:	dc.w 1
	dc.w $F00F, 8, $FFF0

.four:	dc.w 4
	dc.w $F00F, 8, $FFC0
	dc.w $F00F, 8, $FFE0
	dc.w $F00F, 8, 0
	dc.w $F00F, 8, $20

	even
