Map_CFlo_internal:
	dc.w	byte_874E-Map_CFlo_internal
	dc.w	byte_8763-Map_CFlo_internal
	dc.w	byte_878C-Map_CFlo_internal
	dc.w	byte_87A1-Map_CFlo_internal

byte_874E:	dc.w 4
	dc.w $F80D, 0, $FFE0
	dc.w $80D, 0, $FFE0
	dc.w $F80D, 0, 0
	dc.w $80D, 0, 0

byte_8763:	dc.w 8
	dc.w $F805, 0, $FFE0
	dc.w $F805, 0, $FFF0
	dc.w $F805, 0, 0
	dc.w $F805, 0, $10
	dc.w $805, 0, $FFE0
	dc.w $805, 0, $FFF0
	dc.w $805, 0, 0
	dc.w $805, 0, $10

byte_878C:	dc.w 4
	dc.w $F80D, 0, $FFE0
	dc.w $80D, 8, $FFE0
	dc.w $F80D, 0, 0
	dc.w $80D, 8, 0

byte_87A1:	dc.w 8
	dc.w $F805, 0, $FFE0
	dc.w $F805, 4, $FFF0
	dc.w $F805, 0, 0
	dc.w $F805, 4, $10
	dc.w $805, 8, $FFE0
	dc.w $805, $C, $FFF0
	dc.w $805, 8, 0
	dc.w $805, $C, $10

	even
