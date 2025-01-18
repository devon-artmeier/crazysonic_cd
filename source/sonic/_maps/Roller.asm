Map_Roll_internal:
	dc.w	M_Roll_Stand-Map_Roll_internal
	dc.w	M_Roll_Fold-Map_Roll_internal
	dc.w	M_Roll_Roll1-Map_Roll_internal
	dc.w	M_Roll_Roll2-Map_Roll_internal
	dc.w	M_Roll_Roll3-Map_Roll_internal

M_Roll_Stand:	dc.w 2
	dc.w $DE0E, 0, $FFF0
	dc.w $F60E, $C, $FFF0

M_Roll_Fold:	dc.w 2
	dc.w $E60E, 0, $FFF0
	dc.w $FE0D, $18, $FFF0

M_Roll_Roll1:	dc.w 1
	dc.w $F00F, $20, $FFF0

M_Roll_Roll2:	dc.w 1
	dc.w $F00F, $30, $FFF0

M_Roll_Roll3:	dc.w 1
	dc.w $F00F, $40, $FFF0

	even
