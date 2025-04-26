Map_Gar_internal:
	dc.w	.head-Map_Gar_internal
	dc.w	.head-Map_Gar_internal
	dc.w	.fireball1-Map_Gar_internal
	dc.w	.fireball2-Map_Gar_internal

.head:	dc.w 3
	dc.w $F004, 0, 0
	dc.w $F80D, 2, $FFF0
	dc.w $808, $A, $FFF8

.fireball1:	dc.w 1
	dc.w $FC04, $D, $FFF8

.fireball2:	dc.w 1
	dc.w $FC04, $F, $FFF8

	even
