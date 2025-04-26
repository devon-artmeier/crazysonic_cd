Map_Seesaw_internal:
	dc.w	.sloping-Map_Seesaw_internal
	dc.w	.flat-Map_Seesaw_internal
	dc.w	.sloping-Map_Seesaw_internal
	dc.w	.flat-Map_Seesaw_internal

.sloping:	dc.w 7
	dc.w $D406, 0, $FFD3
	dc.w $DC06, 6, $FFE3
	dc.w $E404, $C, $FFF3
	dc.w $EC0D, $E, $FFF3
	dc.w $FC08, $16, $FFFB
	dc.w $F406, 6, $13
	dc.w $FC05, $19, $23

.flat:	dc.w 4
	dc.w $E60A, $1D, $FFD0
	dc.w $E60A, $23, $FFE8
	dc.w $E60A, $823, 0
	dc.w $E60A, $81D, $18

	even
