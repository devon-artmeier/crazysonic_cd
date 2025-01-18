Map_Plat_GHZ_internal:
	dc.w	.small-Map_Plat_GHZ_internal
	dc.w	.large-Map_Plat_GHZ_internal

.small:	dc.w 4
	dc.w $F40B, $3B, $FFE0
	dc.w $F407, $3F, $FFF8
	dc.w $F407, $3F, 8
	dc.w $F403, $47, $18

.large:	dc.w $A
	dc.w $F40F, $C5, $FFE0
	dc.w $40F, $D5, $FFE0
	dc.w $240F, $D5, $FFE0
	dc.w $440F, $D5, $FFE0
	dc.w $640F, $D5, $FFE0
	dc.w $F40F, $8C5, 0
	dc.w $40F, $8D5, 0
	dc.w $240F, $8D5, 0
	dc.w $440F, $8D5, 0
	dc.w $640F, $8D5, 0

	even
