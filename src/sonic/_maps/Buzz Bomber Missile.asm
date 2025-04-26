Map_Missile_internal:
	dc.w	.Flare1-Map_Missile_internal
	dc.w	.Flare2-Map_Missile_internal
	dc.w	.Ball1-Map_Missile_internal
	dc.w	.Ball2-Map_Missile_internal

.Flare1:	dc.w 1
	dc.w $F805, $24, $FFF8

.Flare2:	dc.w 1
	dc.w $F805, $28, $FFF8

.Ball1:	dc.w 1
	dc.w $F805, $2C, $FFF8

.Ball2:	dc.w 1
	dc.w $F805, $33, $FFF8

	even
