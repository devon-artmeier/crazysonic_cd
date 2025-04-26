SME_uFC4V:
	dc.w	SME_uFC4V_A-SME_uFC4V
	dc.w	SME_uFC4V_1A-SME_uFC4V
	dc.w	SME_uFC4V_25-SME_uFC4V
	dc.w	SME_uFC4V_30-SME_uFC4V
	dc.w	SME_uFC4V_3B-SME_uFC4V

SME_uFC4V_A:	dc.w 3
	dc.w $F00B, 0, $FFE8
	dc.w $F00B, $800, 0
	dc.w $1001, $38, $FFFC

SME_uFC4V_1A:	dc.w 2
	dc.w $F00F, $C, $FFF0
	dc.w $1001, $38, $FFFC

SME_uFC4V_25:	dc.w 2
	dc.w $F003, $1C, $FFFC
	dc.w $1001, $838, $FFFC

SME_uFC4V_30:	dc.w 2
	dc.w $F00F, $80C, $FFF0
	dc.w $1001, $838, $FFFC

SME_uFC4V_3B:	dc.w 3
	dc.w $F00B, $2020, $FFE8
	dc.w $F00B, $202C, 0
	dc.w $1001, $38, $FFFC

	even
