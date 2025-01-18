Map_Bri_internal:
	dc.w	M_Bri_Log-Map_Bri_internal
	dc.w	M_Bri_Stump-Map_Bri_internal
	dc.w	M_Bri_Rope-Map_Bri_internal

M_Bri_Log:	dc.w 1
	dc.w $F805, 0, $FFF8

M_Bri_Stump:	dc.w 2
	dc.w $F804, 4, $FFF0
	dc.w $C, 6, $FFF0

M_Bri_Rope:	dc.w 1
	dc.w $FC04, 8, $FFF8

	even
