Map_Vanish_internal:
	dc.w	@flash1-Map_Vanish_internal
	dc.w	@flash2-Map_Vanish_internal
	dc.w	@flash3-Map_Vanish_internal
	dc.w	@sparkle1-Map_Vanish_internal
	dc.w	@sparkle2-Map_Vanish_internal
	dc.w	@sparkle3-Map_Vanish_internal
	dc.w	@sparkle4-Map_Vanish_internal
	dc.w	@blank-Map_Vanish_internal

@flash1:	dc.w 3
	dc.w $F800, 0, 8
	dc.w 4, 1, 0
	dc.w $800, $1000, 8

@flash2:	dc.w 3
	dc.w $F00D, 3, $FFF0
	dc.w $C, $B, $FFF0
	dc.w $80D, $1003, $FFF0

@flash3:	dc.w 5
	dc.w $E40E, $F, $FFF4
	dc.w $EC02, $1B, $FFEC
	dc.w $FC0C, $1E, $FFF4
	dc.w $40E, $100F, $FFF4
	dc.w $401, $101B, $FFEC

@sparkle1:	dc.w 9
	dc.w $F008, $22, $FFF8
	dc.w $F80E, $25, $FFF0
	dc.w $1008, $31, $FFF0
	dc.w 5, $34, $10
	dc.w $F800, $825, $10
	dc.w $F000, $1836, $18
	dc.w $F800, $1825, $20
	dc.w 0, $825, $28
	dc.w $F800, $25, $30

@sparkle2:	dc.w $12
	dc.w 0, $1825, $FFF0
	dc.w $F804, $38, $FFF8
	dc.w $F000, $26, 8
	dc.w 0, $25, 0
	dc.w $800, $1825, $FFF8
	dc.w $1000, $1026, 0
	dc.w $800, $1038, 8
	dc.w $F800, $29, $10
	dc.w 0, $26, $10
	dc.w 0, $2D, $18
	dc.w $800, $826, $18
	dc.w $800, $29, $20
	dc.w $F800, $26, $20
	dc.w $F800, $2D, $28
	dc.w 0, $3A, $28
	dc.w $F800, $1826, $30
	dc.w 0, $1025, $38
	dc.w $F800, $1025, $40

@sparkle3:	dc.w $11
	dc.w $F800, $825, 0
	dc.w $F000, $38, $10
	dc.w $1000, $825, 0
	dc.w 0, $1825, $10
	dc.w $800, $1025, $18
	dc.w $F800, $1825, $20
	dc.w 0, $1026, $28
	dc.w $F800, $1025, $30
	dc.w 0, $25, $30
	dc.w $800, $825, $30
	dc.w 0, $826, $38
	dc.w $800, $29, $38
	dc.w $F800, $826, $40
	dc.w 0, $2D, $40
	dc.w $F800, $825, $48
	dc.w 0, $25, $48
	dc.w 0, $1025, $50

@sparkle4:	dc.w 9
	dc.w $FC00, $826, $30
	dc.w $400, $825, $28
	dc.w $400, $1027, $38
	dc.w $400, $826, $40
	dc.w $FC00, $1025, $40
	dc.w $FC00, $1026, $48
	dc.w $C00, $827, $48
	dc.w $400, $1826, $50
	dc.w $400, $827, $58

@blank:	dc.w 0

	even
