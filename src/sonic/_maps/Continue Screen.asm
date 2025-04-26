Map_ContScr_internal:
	dc.w	M_Cont_text-Map_ContScr_internal
	dc.w	M_Cont_Sonic1-Map_ContScr_internal
	dc.w	M_Cont_Sonic2-Map_ContScr_internal
	dc.w	M_Cont_Sonic3-Map_ContScr_internal
	dc.w	M_Cont_oval-Map_ContScr_internal
	dc.w	M_Cont_Mini1-Map_ContScr_internal
	dc.w	M_Cont_Mini1-Map_ContScr_internal
	dc.w	M_Cont_Mini2-Map_ContScr_internal

M_Cont_text:	dc.w $B
	dc.w $F805, $88, $FFC4
	dc.w $F805, $B2, $FFD4
	dc.w $F805, $AE, $FFE4
	dc.w $F805, $C2, $FFF4
	dc.w $F801, $A0, 4
	dc.w $F805, $AE, $C
	dc.w $F805, $C6, $1C
	dc.w $F805, $90, $2C
	dc.w $3805, $2021, $FFE8
	dc.w $3805, $2021, 8
	dc.w $3605, $1FC, $FFF8

M_Cont_Sonic1:	dc.w 3
	dc.w $405, $15, $FFFC
	dc.w $F40A, 6, $FFEC
	dc.w $F406, $F, 4

M_Cont_Sonic2:	dc.w 3
	dc.w $405, $19, $FFFC
	dc.w $F40A, 6, $FFEC
	dc.w $F406, $F, 4

M_Cont_Sonic3:	dc.w 3
	dc.w $405, $1D, $FFFC
	dc.w $F40A, 6, $FFEC
	dc.w $F406, $F, 4

M_Cont_oval:	dc.w 2
	dc.w $6009, $2000, $FFE8
	dc.w $6009, $2800, 0

M_Cont_Mini1:	dc.w 1
	dc.w 6, $12, 0

M_Cont_Mini2:	dc.w 1
	dc.w 6, $18, 0

	even
