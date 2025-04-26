Map_Swing_SLZ_internal:
	dc.w	.block-Map_Swing_SLZ_internal
	dc.w	.chain-Map_Swing_SLZ_internal
	dc.w	.anchor-Map_Swing_SLZ_internal

.block:	dc.w 8
	dc.w $F00F, 4, $FFE0
	dc.w $F00F, $804, 0
	dc.w $F005, $14, $FFD0
	dc.w $F005, $814, $20
	dc.w $1004, $18, $FFE0
	dc.w $1004, $818, $10
	dc.w $1001, $1A, $FFF8
	dc.w $1001, $81A, 0

.chain:	dc.w 1
	dc.w $F805, $4000, $FFF8

.anchor:	dc.w 1
	dc.w $F805, $1C, $FFF8

	even
