Map_Flap_internal:
	dc.w	.closed-Map_Flap_internal
	dc.w	.halfway-Map_Flap_internal
	dc.w	.open-Map_Flap_internal

.closed:	dc.w 2
	dc.w $E007, 0, $FFF8
	dc.w 7, $1000, $FFF8

.halfway:	dc.w 2
	dc.w $DA0F, 8, $FFFB
	dc.w $60F, $1008, $FFFB

.open:	dc.w 2
	dc.w $D80D, $18, 0
	dc.w $180D, $1018, 0

	even
