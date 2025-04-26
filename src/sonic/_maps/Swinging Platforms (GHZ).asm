Map_Swing_GHZ_internal:
	dc.w	.block-Map_Swing_GHZ_internal
	dc.w	.chain-Map_Swing_GHZ_internal
	dc.w	.anchor-Map_Swing_GHZ_internal

.block:	dc.w 2
	dc.w $F809, 4, $FFE8
	dc.w $F809, 4, 0

.chain:	dc.w 1
	dc.w $F805, 0, $FFF8

.anchor:	dc.w 1
	dc.w $F805, $A, $FFF8

	even
