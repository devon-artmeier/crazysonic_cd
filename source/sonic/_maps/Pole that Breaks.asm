Map_Pole_internal:
	dc.w	.normal-Map_Pole_internal
	dc.w	.broken-Map_Pole_internal

.normal:	dc.w 2
	dc.w $E003, 0, $FFFC
	dc.w 3, $1000, $FFFC

.broken:	dc.w 4
	dc.w $E001, 0, $FFFC
	dc.w $F005, 4, $FFFC
	dc.w 5, $1004, $FFFC
	dc.w $1001, $1000, $FFFC

	even
