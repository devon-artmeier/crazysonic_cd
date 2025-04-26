Map_WFall_internal:
	dc.w	.vertnarrow-Map_WFall_internal
	dc.w	.cornerwide-Map_WFall_internal
	dc.w	.cornermedium-Map_WFall_internal
	dc.w	.cornernarrow-Map_WFall_internal
	dc.w	.cornermedium2-Map_WFall_internal
	dc.w	.cornernarrow2-Map_WFall_internal
	dc.w	.cornernarrow3-Map_WFall_internal
	dc.w	.vertwide-Map_WFall_internal
	dc.w	.diagonal-Map_WFall_internal
	dc.w	.splash1-Map_WFall_internal
	dc.w	.splash2-Map_WFall_internal
	dc.w	.splash3-Map_WFall_internal

.vertnarrow:	dc.w 1
	dc.w $F007, 0, $FFF8

.cornerwide:	dc.w 2
	dc.w $F804, 8, $FFFC
	dc.w 8, $A, $FFF4

.cornermedium:	dc.w 2
	dc.w $F800, 8, 0
	dc.w 4, $D, $FFF8

.cornernarrow:	dc.w 1
	dc.w $F801, $F, 0

.cornermedium2:	dc.w 2
	dc.w $F800, 8, 0
	dc.w 4, $D, $FFF8

.cornernarrow2:	dc.w 1
	dc.w $F801, $11, 0

.cornernarrow3:	dc.w 1
	dc.w $F801, $13, 0

.vertwide:	dc.w 1
	dc.w $F007, $15, $FFF8

.diagonal:	dc.w 2
	dc.w $F80C, $1D, $FFF6
	dc.w $C, $21, $FFE8

.splash1:	dc.w 2
	dc.w $F00B, $25, $FFE8
	dc.w $F00B, $31, 0

.splash2:	dc.w 2
	dc.w $F00B, $3D, $FFE8
	dc.w $F00B, $49, 0

.splash3:	dc.w 2
	dc.w $F00B, $55, $FFE8
	dc.w $F00B, $61, 0

	even
