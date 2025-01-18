Map_Over_internal:
	dc.w	byte_CBAC-Map_Over_internal
	dc.w	byte_CBB7-Map_Over_internal
	dc.w	byte_CBC2-Map_Over_internal
	dc.w	byte_CBCD-Map_Over_internal

byte_CBAC:	dc.w 2
	dc.w $F80D, 0, $FFB8
	dc.w $F80D, 8, $FFD8

byte_CBB7:	dc.w 2
	dc.w $F80D, $14, 8
	dc.w $F80D, $C, $28

byte_CBC2:	dc.w 2
	dc.w $F809, $1C, $FFC4
	dc.w $F80D, 8, $FFDC

byte_CBCD:	dc.w 2
	dc.w $F80D, $14, $C
	dc.w $F80D, $C, $2C

	even
