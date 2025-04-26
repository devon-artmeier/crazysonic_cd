Map_Harp_internal:
	dc.w	.h_retracted-Map_Harp_internal
	dc.w	.h_middle-Map_Harp_internal
	dc.w	.h_extended-Map_Harp_internal
	dc.w	.v_retracted-Map_Harp_internal
	dc.w	.v_middle-Map_Harp_internal
	dc.w	.v_extended-Map_Harp_internal

.h_retracted:	dc.w 1
	dc.w $FC04, 0, $FFF8

.h_middle:	dc.w 1
	dc.w $FC0C, 2, $FFF8

.h_extended:	dc.w 2
	dc.w $FC08, 6, $FFF8
	dc.w $FC08, 3, $10

.v_retracted:	dc.w 1
	dc.w $F801, 9, $FFFC

.v_middle:	dc.w 1
	dc.w $E803, $B, $FFFC

.v_extended:	dc.w 2
	dc.w $D802, $B, $FFFC
	dc.w $F002, $F, $FFFC

	even
