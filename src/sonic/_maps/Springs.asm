Map_Spring_internal:
	dc.w	M_Spg_Up-Map_Spring_internal
	dc.w	M_Spg_UpFlat-Map_Spring_internal
	dc.w	M_Spg_UpExt-Map_Spring_internal
	dc.w	M_Spg_Left-Map_Spring_internal
	dc.w	M_Spg_LeftFlat-Map_Spring_internal
	dc.w	M_Spg_LeftExt-Map_Spring_internal

M_Spg_Up:	dc.w 2
	dc.w $F80C, 0, $FFF0
	dc.w $C, 4, $FFF0

M_Spg_UpFlat:	dc.w 1
	dc.w $C, 0, $FFF0

M_Spg_UpExt:	dc.w 3
	dc.w $E80C, 0, $FFF0
	dc.w $F005, 8, $FFF8
	dc.w $C, $C, $FFF0

M_Spg_Left:	dc.w 1
	dc.w $F007, 0, $FFF8

M_Spg_LeftFlat:	dc.w 1
	dc.w $F003, 4, $FFF8

M_Spg_LeftExt:	dc.w 4
	dc.w $F003, 4, $10
	dc.w $F809, 8, $FFF8
	dc.w $F000, 0, $FFF8
	dc.w $800, 3, $FFF8

	even
