Map_Fan_internal:
	dc.w	.fan1-Map_Fan_internal
	dc.w	.fan2-Map_Fan_internal
	dc.w	.fan3-Map_Fan_internal
	dc.w	.fan2-Map_Fan_internal
	dc.w	.fan1-Map_Fan_internal

.fan1:	dc.w 2
	dc.w $F009, 0, $FFF8
	dc.w $D, 6, $FFF0

.fan2:	dc.w 2
	dc.w $F00D, $E, $FFF0
	dc.w $D, $16, $FFF0

.fan3:	dc.w 2
	dc.w $F00D, $1E, $FFF0
	dc.w 9, $26, $FFF8

	even
