Map_Hog_internal:
	dc.w	M_Hog_Stand-Map_Hog_internal
	dc.w	M_Hog_Open-Map_Hog_internal
	dc.w	M_Hog_Squat-Map_Hog_internal
	dc.w	M_Hog_Leap-Map_Hog_internal
	dc.w	M_Hog_Ball1-Map_Hog_internal
	dc.w	M_Hog_Ball2-Map_Hog_internal

M_Hog_Stand:	dc.w 2
	dc.w $EF09, 0, $FFF4
	dc.w $FF0A, 6, $FFF4

M_Hog_Open:	dc.w 2
	dc.w $EF09, 0, $FFF4
	dc.w $FF0A, $F, $FFF4

M_Hog_Squat:	dc.w 2
	dc.w $F409, 0, $FFF4
	dc.w $409, $18, $FFF4

M_Hog_Leap:	dc.w 2
	dc.w $E409, 0, $FFF4
	dc.w $F40A, $1E, $FFF4

M_Hog_Ball1:	dc.w 1
	dc.w $F805, $27, $FFF8

M_Hog_Ball2:	dc.w 1
	dc.w $F805, $2B, $FFF8

	even
