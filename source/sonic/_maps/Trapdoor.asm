Map_Trap_internal:
	dc.w	.closed-Map_Trap_internal
	dc.w	.half-Map_Trap_internal
	dc.w	.open-Map_Trap_internal

.closed:	dc.w 4
	dc.w $F40E, 0, $FFC0
	dc.w $F40E, $800, $FFE0
	dc.w $F40E, 0, 0
	dc.w $F40E, $800, $20

.half:	dc.w 8
	dc.w $F20F, $C, $FFB6
	dc.w $1A0F, $180C, $FFD6
	dc.w $20A, $1C, $FFD6
	dc.w $120A, $181C, $FFBE
	dc.w $F20F, $80C, $2A
	dc.w $1A0F, $100C, $A
	dc.w $20A, $81C, $12
	dc.w $120A, $101C, $2A

.open:	dc.w 4
	dc.w $B, $25, $FFB4
	dc.w $200B, $1025, $FFB4
	dc.w $B, $25, $34
	dc.w $200B, $1025, $34

	even
