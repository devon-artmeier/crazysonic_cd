Map_VanP_internal:
	dc.w	.whole-Map_VanP_internal
	dc.w	.half-Map_VanP_internal
	dc.w	.quarter-Map_VanP_internal
	dc.w	.gone-Map_VanP_internal

.whole:	dc.w 1
	dc.w $F80F, 0, $FFF0

.half:	dc.w 1
	dc.w $F807, $10, $FFF8

.quarter:	dc.w 1
	dc.w $F803, $18, $FFFC

.gone:	dc.w 0

	even
