Map_BossBlock_internal:
	dc.w	.wholeblock-Map_BossBlock_internal
	dc.w	.topleft-Map_BossBlock_internal
	dc.w	.topright-Map_BossBlock_internal
	dc.w	.bottomleft-Map_BossBlock_internal
	dc.w	.bottomright-Map_BossBlock_internal

.wholeblock:	dc.w 2
	dc.w $F00D, $71, $FFF0
	dc.w $D, $79, $FFF0

.topleft:	dc.w 1
	dc.w $F805, $71, $FFF8

.topright:	dc.w 1
	dc.w $F805, $75, $FFF8

.bottomleft:	dc.w 1
	dc.w $F805, $79, $FFF8

.bottomright:	dc.w 1
	dc.w $F805, $7D, $FFF8

	even
