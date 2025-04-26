Map_BossItems_internal:
	dc.w	.chainanchor1-Map_BossItems_internal
	dc.w	.chainanchor2-Map_BossItems_internal
	dc.w	.cross-Map_BossItems_internal
	dc.w	.widepipe-Map_BossItems_internal
	dc.w	.pipe-Map_BossItems_internal
	dc.w	.spike-Map_BossItems_internal
	dc.w	.legmask-Map_BossItems_internal
	dc.w	.legs-Map_BossItems_internal

.chainanchor1:	dc.w 1
	dc.w $F805, 0, $FFF8

.chainanchor2:	dc.w 2
	dc.w $FC04, 4, $FFF8
	dc.w $F805, 0, $FFF8

.cross:	dc.w 1
	dc.w $FC00, 6, $FFFC

.widepipe:	dc.w 1
	dc.w $1409, 7, $FFF4

.pipe:	dc.w 1
	dc.w $1405, $D, $FFF8

.spike:	dc.w 4
	dc.w $F004, $11, $FFF8
	dc.w $F801, $13, $FFF8
	dc.w $F801, $813, 0
	dc.w $804, $15, $FFF8

.legmask:	dc.w 2
	dc.w 5, $17, 0
	dc.w 0, $1B, $10

.legs:	dc.w 2
	dc.w $1804, $1C, 0
	dc.w $B, $1E, $10

	even
