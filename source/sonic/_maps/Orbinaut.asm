Map_Orb_internal:
	dc.w	.normal-Map_Orb_internal
	dc.w	.medium-Map_Orb_internal
	dc.w	.angry-Map_Orb_internal
	dc.w	.spikeball-Map_Orb_internal

.normal:	dc.w 1
	dc.w $F40A, 0, $FFF4

.medium:	dc.w 1
	dc.w $F40A, $2009, $FFF4

.angry:	dc.w 1
	dc.w $F40A, $12, $FFF4

.spikeball:	dc.w 1
	dc.w $F805, $1B, $FFF8

	even
