Map_GRing_internal:
	dc.w	byte_9FDA-Map_GRing_internal
	dc.w	byte_A00D-Map_GRing_internal
	dc.w	byte_A036-Map_GRing_internal
	dc.w	byte_A04B-Map_GRing_internal

byte_9FDA:	dc.w $A
	dc.w $E008, 0, $FFE8
	dc.w $E008, 3, 0
	dc.w $E80C, 6, $FFE0
	dc.w $E80C, $A, 0
	dc.w $F007, $E, $FFE0
	dc.w $F007, $16, $10
	dc.w $100C, $1E, $FFE0
	dc.w $100C, $22, 0
	dc.w $1808, $26, $FFE8
	dc.w $1808, $29, 0

byte_A00D:	dc.w 8
	dc.w $E00C, $2C, $FFF0
	dc.w $E808, $30, $FFE8
	dc.w $E809, $33, 0
	dc.w $F007, $39, $FFE8
	dc.w $F805, $41, 8
	dc.w $809, $45, 0
	dc.w $1008, $4B, $FFE8
	dc.w $180C, $4E, $FFF0

byte_A036:	dc.w 4
	dc.w $E007, $52, $FFF4
	dc.w $E003, $852, 4
	dc.w 7, $5A, $FFF4
	dc.w 3, $85A, 4

byte_A04B:	dc.w 8
	dc.w $E00C, $82C, $FFF0
	dc.w $E808, $830, 0
	dc.w $E809, $833, $FFE8
	dc.w $F007, $839, 8
	dc.w $F805, $841, $FFE8
	dc.w $809, $845, $FFE8
	dc.w $1008, $84B, 0
	dc.w $180C, $84E, $FFF0

	even
