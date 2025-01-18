Map_SBall2_internal:
	dc.w	.chain-Map_SBall2_internal
	dc.w	.spikeball-Map_SBall2_internal
	dc.w	.base-Map_SBall2_internal

.chain:	dc.w 1
	dc.w $F805, 0, $FFF8

.spikeball:	dc.w 1
	dc.w $F00F, 4, $FFF0

.base:	dc.w 1
	dc.w $F805, $14, $FFF8

	even
