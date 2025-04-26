Map_LBlock_internal:
	dc.w	.sinkblock-Map_LBlock_internal
	dc.w	.riseplatform-Map_LBlock_internal
	dc.w	.cork-Map_LBlock_internal
	dc.w	.block-Map_LBlock_internal

.sinkblock:	dc.w 1
	dc.w $F00F, 0, $FFF0

.riseplatform:	dc.w 2
	dc.w $F40E, $69, $FFE0
	dc.w $F40E, $75, 0

.cork:	dc.w 1
	dc.w $F00F, $11A, $FFF0

.block:	dc.w 1
	dc.w $F00F, $FDFA, $FFF0

	even
