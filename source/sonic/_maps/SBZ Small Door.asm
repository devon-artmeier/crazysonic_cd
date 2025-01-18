Map_ADoor_internal:
	dc.w	.closed-Map_ADoor_internal
	dc.w	.01-Map_ADoor_internal
	dc.w	.02-Map_ADoor_internal
	dc.w	.03-Map_ADoor_internal
	dc.w	.04-Map_ADoor_internal
	dc.w	.05-Map_ADoor_internal
	dc.w	.06-Map_ADoor_internal
	dc.w	.07-Map_ADoor_internal
	dc.w	.open-Map_ADoor_internal

.closed:	dc.w 2
	dc.w $E007, $800, $FFF8
	dc.w 7, $800, $FFF8

.01:	dc.w 2
	dc.w $DC07, $800, $FFF8
	dc.w $407, $800, $FFF8

.02:	dc.w 2
	dc.w $D807, $800, $FFF8
	dc.w $807, $800, $FFF8

.03:	dc.w 2
	dc.w $D407, $800, $FFF8
	dc.w $C07, $800, $FFF8

.04:	dc.w 2
	dc.w $D007, $800, $FFF8
	dc.w $1007, $800, $FFF8

.05:	dc.w 2
	dc.w $CC07, $800, $FFF8
	dc.w $1407, $800, $FFF8

.06:	dc.w 2
	dc.w $C807, $800, $FFF8
	dc.w $1807, $800, $FFF8

.07:	dc.w 2
	dc.w $C407, $800, $FFF8
	dc.w $1C07, $800, $FFF8

.open:	dc.w 2
	dc.w $C007, $800, $FFF8
	dc.w $2007, $800, $FFF8

	even
