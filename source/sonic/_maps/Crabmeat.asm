Map_Crab_internal:
	dc.w	.stand-Map_Crab_internal
	dc.w	.walk-Map_Crab_internal
	dc.w	.slope1-Map_Crab_internal
	dc.w	.slope2-Map_Crab_internal
	dc.w	.firing-Map_Crab_internal
	dc.w	.ball1-Map_Crab_internal
	dc.w	.ball2-Map_Crab_internal

.stand:	dc.w 4
	dc.w $F009, 0, $FFE8
	dc.w $F009, $800, 0
	dc.w 5, 6, $FFF0
	dc.w 5, $806, 0

.walk:	dc.w 4
	dc.w $F009, $A, $FFE8
	dc.w $F009, $10, 0
	dc.w 5, $16, $FFF0
	dc.w 9, $1A, 0

.slope1:	dc.w 4
	dc.w $EC09, 0, $FFE8
	dc.w $EC09, $800, 0
	dc.w $FC05, $806, 0
	dc.w $FC06, $20, $FFF0

.slope2:	dc.w 4
	dc.w $EC09, $A, $FFE8
	dc.w $EC09, $10, 0
	dc.w $FC09, $26, 0
	dc.w $FC06, $2C, $FFF0

.firing:	dc.w 6
	dc.w $F004, $32, $FFF0
	dc.w $F004, $832, 0
	dc.w $F809, $34, $FFE8
	dc.w $F809, $834, 0
	dc.w $804, $3A, $FFF0
	dc.w $804, $83A, 0

.ball1:	dc.w 1
	dc.w $F805, $3C, $FFF8

.ball2:	dc.w 1
	dc.w $F805, $40, $FFF8

	even
