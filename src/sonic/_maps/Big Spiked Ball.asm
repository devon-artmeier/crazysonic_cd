Map_BBall_internal:
	dc.w	.ball-Map_BBall_internal
	dc.w	.chain-Map_BBall_internal
	dc.w	.anchor-Map_BBall_internal

.ball:	dc.w 5
	dc.w $E804, 0, $FFF8
	dc.w $F00F, 2, $FFF0
	dc.w $F801, $12, $FFE8
	dc.w $F801, $14, $10
	dc.w $1004, $16, $FFF8

.chain:	dc.w 1
	dc.w $F805, $20, $FFF8

.anchor:	dc.w 2
	dc.w $F80D, $18, $FFF0
	dc.w $E80D, $1018, $FFF0

	even
