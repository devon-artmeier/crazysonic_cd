Map_Lamp_internal:
	dc.w	.blue-Map_Lamp_internal
	dc.w	.poleonly-Map_Lamp_internal
	dc.w	.redballonly-Map_Lamp_internal
	dc.w	.red-Map_Lamp_internal

.blue:	dc.w 6
	dc.w $E401, 0, $FFF8
	dc.w $E401, $800, 0
	dc.w $F403, $2002, $FFF8
	dc.w $F403, $2802, 0
	dc.w $D401, 6, $FFF8
	dc.w $D401, $806, 0

.poleonly:	dc.w 4
	dc.w $E401, 0, $FFF8
	dc.w $E401, $800, 0
	dc.w $F403, $2002, $FFF8
	dc.w $F403, $2802, 0

.redballonly:	dc.w 2
	dc.w $F801, 8, $FFF8
	dc.w $F801, $808, 0

.red:	dc.w 6
	dc.w $E401, 0, $FFF8
	dc.w $E401, $800, 0
	dc.w $F403, $2002, $FFF8
	dc.w $F403, $2802, 0
	dc.w $D401, 8, $FFF8
	dc.w $D401, $808, 0

	even
