Map_Spike_internal:
	dc.w	byte_CFF4-Map_Spike_internal
	dc.w	byte_D004-Map_Spike_internal
	dc.w	byte_D014-Map_Spike_internal
	dc.w	byte_D01A-Map_Spike_internal
	dc.w	byte_D02A-Map_Spike_internal
	dc.w	byte_D049-Map_Spike_internal

byte_CFF4:	dc.w 3
	dc.w $F003, 4, $FFEC
	dc.w $F003, 4, $FFFC
	dc.w $F003, 4, $C

byte_D004:	dc.w 3
	dc.w $EC0C, 0, $FFF0
	dc.w $FC0C, 0, $FFF0
	dc.w $C0C, 0, $FFF0

byte_D014:	dc.w 1
	dc.w $F003, 4, $FFFC

byte_D01A:	dc.w 3
	dc.w $F003, 4, $FFE4
	dc.w $F003, 4, $FFFC
	dc.w $F003, 4, $14

byte_D02A:	dc.w 6
	dc.w $F003, 4, $FFC0
	dc.w $F003, 4, $FFD8
	dc.w $F003, 4, $FFF0
	dc.w $F003, 4, 8
	dc.w $F003, 4, $20
	dc.w $F003, 4, $38

byte_D049:	dc.w 1
	dc.w $FC0C, 0, $FFF0

	even
