Map_MBlock_internal:
	dc.w	.mz1-Map_MBlock_internal
	dc.w	.mz2-Map_MBlock_internal
	dc.w	.sbz-Map_MBlock_internal
	dc.w	.sbzwide-Map_MBlock_internal
	dc.w	.mz3-Map_MBlock_internal

.mz1:	dc.w 1
	dc.w $F80F, 8, $FFF0

.mz2:	dc.w 2
	dc.w $F80F, 8, $FFE0
	dc.w $F80F, 8, 0

.sbz:	dc.w 4
	dc.w $F80C, $2000, $FFE0
	dc.w $D, 4, $FFE0
	dc.w $F80C, $2000, 0
	dc.w $D, 4, 0

.sbzwide:	dc.w 4
	dc.w $F80E, 0, $FFC0
	dc.w $F80E, 3, $FFE0
	dc.w $F80E, 3, 0
	dc.w $F80E, $800, $20

.mz3:	dc.w 3
	dc.w $F80F, 8, $FFD0
	dc.w $F80F, 8, $FFF0
	dc.w $F80F, 8, $10

	even
