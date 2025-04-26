Map_Stomp_internal:
	dc.w	.door-Map_Stomp_internal
	dc.w	.stomper-Map_Stomp_internal
	dc.w	.stomper-Map_Stomp_internal
	dc.w	.stomper-Map_Stomp_internal
	dc.w	.bigdoor-Map_Stomp_internal

.door:	dc.w 4
	dc.w $F40E, $21AF, $FFC0
	dc.w $F40E, $21B2, $FFE0
	dc.w $F40E, $21B2, 0
	dc.w $F40E, $29AF, $20

.stomper:	dc.w 8
	dc.w $E00C, $C, $FFE4
	dc.w $E008, $10, 4
	dc.w $E80E, $2013, $FFE4
	dc.w $E80A, $201F, 4
	dc.w $E, $2013, $FFE4
	dc.w $A, $201F, 4
	dc.w $180C, $C, $FFE4
	dc.w $1808, $10, 4

.bigdoor:	dc.w $E
	dc.w $C00F, 0, $FF80
	dc.w $C00F, $10, $FFA0
	dc.w $C00F, $20, $FFC0
	dc.w $C00F, $10, $FFE0
	dc.w $C00F, $20, 0
	dc.w $C00F, $10, $20
	dc.w $C00F, $30, $40
	dc.w $C00D, $40, $60
	dc.w $E00F, $48, $FF80
	dc.w $E00F, $48, $FFC0
	dc.w $E00F, $58, 0
	dc.w $F, $48, $FF80
	dc.w $F, $58, $FFC0
	dc.w $200F, $58, $FF80

	even
