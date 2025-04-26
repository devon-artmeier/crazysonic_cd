Map_Yad_internal:
	dc.w	.walk0-Map_Yad_internal
	dc.w	.walk1-Map_Yad_internal
	dc.w	.walk2-Map_Yad_internal
	dc.w	.walk3-Map_Yad_internal
	dc.w	.walk4-Map_Yad_internal
	dc.w	.walk5-Map_Yad_internal

.walk0:	dc.w 5
	dc.w $F408, 0, $FFF4
	dc.w $FC0E, 3, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $31, $FFFC

.walk1:	dc.w 5
	dc.w $F408, $14, $FFF4
	dc.w $FC0E, $17, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $31, $FFFC

.walk2:	dc.w 5
	dc.w $F409, $23, $FFF4
	dc.w $40D, $29, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $31, $FFFC

.walk3:	dc.w 5
	dc.w $F408, 0, $FFF4
	dc.w $FC0E, 3, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $37, $FFFC

.walk4:	dc.w 5
	dc.w $F408, $14, $FFF4
	dc.w $FC0E, $17, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $37, $FFFC

.walk5:	dc.w 5
	dc.w $F409, $23, $FFF4
	dc.w $40D, $29, $FFEC
	dc.w $EC04, $F, $FFFC
	dc.w $F402, $11, $C
	dc.w $409, $37, $FFFC

	even
