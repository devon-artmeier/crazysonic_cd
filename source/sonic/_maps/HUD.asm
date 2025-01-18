Map_HUD_internal:
	dc.w	.allyellow-Map_HUD_internal
	dc.w	.ringred-Map_HUD_internal

.allyellow:	dc.w $C
	dc.w $800D, $8000, 0
	dc.w $800D, $8018, $20
	dc.w $800D, $8020, $40
	dc.w $900D, $8008, 0
	dc.w $9001, $8000, $20
	dc.w $9009, $8030, $48
	dc.w $4005, $810A, 0
	dc.w $400D, $810E, $10
	dc.w $A005, $A010, 0
	dc.w $B203, $A028, 4
	dc.w $A005, $A014, $12
	dc.w $B203, $A02C, $16

.ringred:	dc.w $C
	dc.w $800D, $8000, 0
	dc.w $800D, $8018, $20
	dc.w $800D, $8020, $40
	dc.w $900D, $A008, 0
	dc.w $9001, $A000, $20
	dc.w $9009, $8030, $48
	dc.w $4005, $810A, 0
	dc.w $400D, $810E, $10
	dc.w $A005, $A010, 0
	dc.w $B203, $A028, 4
	dc.w $A005, $A014, $12
	dc.w $B203, $A02C, $16

	even
