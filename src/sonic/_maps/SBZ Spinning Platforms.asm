Map_Spin_internal:
	dc.w	.flat-Map_Spin_internal
	dc.w	.spin1-Map_Spin_internal
	dc.w	.spin2-Map_Spin_internal
	dc.w	.spin3-Map_Spin_internal
	dc.w	.spin4-Map_Spin_internal

.flat:	dc.w 2
	dc.w $F805, 0, $FFF0
	dc.w $F805, $800, 0

.spin1:	dc.w 2
	dc.w $F00D, $14, $FFF0
	dc.w $D, $1C, $FFF0

.spin2:	dc.w 2
	dc.w $F009, 4, $FFF0
	dc.w 9, $A, $FFF8

.spin3:	dc.w 2
	dc.w $F009, $24, $FFF0
	dc.w 9, $2A, $FFF8

.spin4:	dc.w 2
	dc.w $F005, $10, $FFF8
	dc.w 5, $1010, $FFF8

	even
