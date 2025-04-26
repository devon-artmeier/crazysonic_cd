Map_Fire_internal:
	dc.w	.vertical1-Map_Fire_internal
	dc.w	.vertical2-Map_Fire_internal
	dc.w	.vertcollide-Map_Fire_internal
	dc.w	.horizontal1-Map_Fire_internal
	dc.w	.horizontal2-Map_Fire_internal
	dc.w	.horicollide-Map_Fire_internal

.vertical1:	dc.w 1
	dc.w $E807, 0, $FFF8

.vertical2:	dc.w 1
	dc.w $E807, 8, $FFF8

.vertcollide:	dc.w 1
	dc.w $F006, $10, $FFF8

.horizontal1:	dc.w 1
	dc.w $F80D, $16, $FFE8

.horizontal2:	dc.w 1
	dc.w $F80D, $1E, $FFE8

.horicollide:	dc.w 1
	dc.w $F809, $26, $FFF0

	even
