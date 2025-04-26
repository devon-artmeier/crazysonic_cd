Map_Plasma_internal:
	dc.w	.fuzzy1-Map_Plasma_internal
	dc.w	.fuzzy2-Map_Plasma_internal
	dc.w	.white1-Map_Plasma_internal
	dc.w	.white2-Map_Plasma_internal
	dc.w	.white3-Map_Plasma_internal
	dc.w	.white4-Map_Plasma_internal
	dc.w	.fuzzy3-Map_Plasma_internal
	dc.w	.fuzzy4-Map_Plasma_internal
	dc.w	.fuzzy5-Map_Plasma_internal
	dc.w	.fuzzy6-Map_Plasma_internal
	dc.w	.blank-Map_Plasma_internal

.fuzzy1:	dc.w 2
	dc.w $F00D, $7A, $FFF0
	dc.w $D, $187A, $FFF0

.fuzzy2:	dc.w 2
	dc.w $F406, $82, $FFF4
	dc.w $F402, $1882, 4

.white1:	dc.w 2
	dc.w $F804, $88, $FFF8
	dc.w 4, $1088, $FFF8

.white2:	dc.w 2
	dc.w $F804, $8A, $FFF8
	dc.w 4, $108A, $FFF8

.white3:	dc.w 2
	dc.w $F804, $8C, $FFF8
	dc.w 4, $108C, $FFF8

.white4:	dc.w 2
	dc.w $F406, $8E, $FFF4
	dc.w $F402, $188E, 4

.fuzzy3:	dc.w 1
	dc.w $F805, $94, $FFF8

.fuzzy4:	dc.w 1
	dc.w $F805, $98, $FFF8

.fuzzy5:	dc.w 2
	dc.w $F00D, $87A, $FFF0
	dc.w $D, $107A, $FFF0

.fuzzy6:	dc.w 2
	dc.w $F406, $1082, $FFF4
	dc.w $F402, $882, 4

.blank:	dc.w 0

	even
