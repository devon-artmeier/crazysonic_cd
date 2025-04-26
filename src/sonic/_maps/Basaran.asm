Map_Bas_internal:
	dc.w	.still-Map_Bas_internal
	dc.w	.fly1-Map_Bas_internal
	dc.w	.fly2-Map_Bas_internal
	dc.w	.fly3-Map_Bas_internal

.still:	dc.w 1
	dc.w $F406, 0, $FFF8

.fly1:	dc.w 3
	dc.w $F20E, 6, $FFF4
	dc.w $A04, $12, $FFFC
	dc.w $200, $27, $C

.fly2:	dc.w 4
	dc.w $F804, $14, $FFF8
	dc.w $C, $16, $FFF0
	dc.w $804, $1A, 0
	dc.w 0, $28, $C

.fly3:	dc.w 4
	dc.w $F609, $1C, $FFF5
	dc.w $608, $22, $FFF4
	dc.w $E04, $25, $FFF4
	dc.w $FE00, $27, $C

	even
