Map_Moto_internal:
	dc.w	.moto1-Map_Moto_internal
	dc.w	.moto2-Map_Moto_internal
	dc.w	.moto3-Map_Moto_internal
	dc.w	.smoke1-Map_Moto_internal
	dc.w	.smoke2-Map_Moto_internal
	dc.w	.smoke3-Map_Moto_internal
	dc.w	.blank-Map_Moto_internal

.moto1:	dc.w 4
	dc.w $F00D, 0, $FFEC
	dc.w $C, 8, $FFEC
	dc.w $F801, $C, $C
	dc.w $808, $E, $FFF4

.moto2:	dc.w 4
	dc.w $F10D, 0, $FFEC
	dc.w $10C, 8, $FFEC
	dc.w $F901, $C, $C
	dc.w $908, $11, $FFF4

.moto3:	dc.w 5
	dc.w $F00D, 0, $FFEC
	dc.w $C, $14, $FFEC
	dc.w $F801, $C, $C
	dc.w $804, $18, $FFEC
	dc.w $804, $12, $FFFC

.smoke1:	dc.w 1
	dc.w $FA00, $1A, $10

.smoke2:	dc.w 1
	dc.w $FA00, $1B, $10

.smoke3:	dc.w 1
	dc.w $FA00, $1C, $10

.blank:	dc.w 0

	even
