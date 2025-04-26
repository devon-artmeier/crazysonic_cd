Map_LConv_internal:
	dc.w	.wheel1-Map_LConv_internal
	dc.w	.wheel2-Map_LConv_internal
	dc.w	.wheel3-Map_LConv_internal
	dc.w	.wheel4-Map_LConv_internal
	dc.w	.platform-Map_LConv_internal

.wheel1:	dc.w 1
	dc.w $F00F, 0, $FFF0

.wheel2:	dc.w 1
	dc.w $F00F, $10, $FFF0

.wheel3:	dc.w 1
	dc.w $F00F, $20, $FFF0

.wheel4:	dc.w 1
	dc.w $F00F, $30, $FFF0

.platform:	dc.w 1
	dc.w $F80D, $40, $FFF0

	even
