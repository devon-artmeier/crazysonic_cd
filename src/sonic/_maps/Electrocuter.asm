Map_Elec_internal:
	dc.w	.normal-Map_Elec_internal
	dc.w	.zap1-Map_Elec_internal
	dc.w	.zap2-Map_Elec_internal
	dc.w	.zap3-Map_Elec_internal
	dc.w	.zap4-Map_Elec_internal
	dc.w	.zap5-Map_Elec_internal

.normal:	dc.w 2
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8

.zap1:	dc.w 3
	dc.w $F805, 8, $FFF8
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8

.zap2:	dc.w 5
	dc.w $F805, 8, $FFF8
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8
	dc.w $F60D, $C, 8
	dc.w $F60D, $80C, $FFDC

.zap3:	dc.w 4
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8
	dc.w $F60D, $C, 8
	dc.w $F60D, $80C, $FFDC

.zap4:	dc.w 6
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8
	dc.w $F60D, $100C, 8
	dc.w $F60D, $180C, $FFDC
	dc.w $F60D, $C, $24
	dc.w $F60D, $80C, $FFC0

.zap5:	dc.w 4
	dc.w $F804, $6000, $FFF8
	dc.w 6, $4002, $FFF8
	dc.w $F60D, $100C, $24
	dc.w $F60D, $180C, $FFC0

	even
