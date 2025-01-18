Map_Elev_internal:
	dc.w	.elevator-Map_Elev_internal

.elevator:	dc.w 3
	dc.w $F80F, $41, $FFD8
	dc.w $F80F, $41, $FFF8
	dc.w $F807, $41, $18

	even
