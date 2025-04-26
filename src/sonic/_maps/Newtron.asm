Map_Newt_internal:
	dc.w	M_Newt_Trans-Map_Newt_internal
	dc.w	M_Newt_Norm-Map_Newt_internal
	dc.w	M_Newt_Fires-Map_Newt_internal
	dc.w	M_Newt_Drop1-Map_Newt_internal
	dc.w	M_Newt_Drop2-Map_Newt_internal
	dc.w	M_Newt_Drop3-Map_Newt_internal
	dc.w	M_Newt_Fly1a-Map_Newt_internal
	dc.w	M_Newt_Fly1b-Map_Newt_internal
	dc.w	M_Newt_Fly2a-Map_Newt_internal
	dc.w	M_Newt_Fly2b-Map_Newt_internal
	dc.w	M_Newt_Blank-Map_Newt_internal

M_Newt_Trans:	dc.w 3
	dc.w $EC0D, 0, $FFEC
	dc.w $F400, 8, $C
	dc.w $FC0E, 9, $FFF4

M_Newt_Norm:	dc.w 3
	dc.w $EC06, $15, $FFEC
	dc.w $EC09, $1B, $FFFC
	dc.w $FC0A, $21, $FFFC

M_Newt_Fires:	dc.w 3
	dc.w $EC06, $2A, $FFEC
	dc.w $EC09, $1B, $FFFC
	dc.w $FC0A, $21, $FFFC

M_Newt_Drop1:	dc.w 4
	dc.w $EC06, $30, $FFEC
	dc.w $EC09, $1B, $FFFC
	dc.w $FC09, $36, $FFFC
	dc.w $C00, $3C, $C

M_Newt_Drop2:	dc.w 3
	dc.w $F40D, $3D, $FFEC
	dc.w $FC00, $20, $C
	dc.w $408, $45, $FFFC

M_Newt_Drop3:	dc.w 2
	dc.w $F80D, $48, $FFEC
	dc.w $F801, $50, $C

M_Newt_Fly1a:	dc.w 3
	dc.w $F80D, $48, $FFEC
	dc.w $F801, $50, $C
	dc.w $FE00, $52, $14

M_Newt_Fly1b:	dc.w 3
	dc.w $F80D, $48, $FFEC
	dc.w $F801, $50, $C
	dc.w $FE04, $53, $14

M_Newt_Fly2a:	dc.w 3
	dc.w $F80D, $48, $FFEC
	dc.w $F801, $50, $C
	dc.w $FE00, $E052, $14

M_Newt_Fly2b:	dc.w 3
	dc.w $F80D, $48, $FFEC
	dc.w $F801, $50, $C
	dc.w $FE04, $E053, $14

M_Newt_Blank:	dc.w 0

	even
