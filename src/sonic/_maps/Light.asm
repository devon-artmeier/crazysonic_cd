Map_Light_internal:
	dc.w	.0-Map_Light_internal
	dc.w	.1-Map_Light_internal
	dc.w	.2-Map_Light_internal
	dc.w	.3-Map_Light_internal
	dc.w	.4-Map_Light_internal
	dc.w	.5-Map_Light_internal

.0:	dc.w 2
	dc.w $F80C, $31, $FFF0
	dc.w $C, $1031, $FFF0

.1:	dc.w 2
	dc.w $F80C, $35, $FFF0
	dc.w $C, $1035, $FFF0

.2:	dc.w 2
	dc.w $F80C, $39, $FFF0
	dc.w $C, $1039, $FFF0

.3:	dc.w 2
	dc.w $F80C, $3D, $FFF0
	dc.w $C, $103D, $FFF0

.4:	dc.w 2
	dc.w $F80C, $41, $FFF0
	dc.w $C, $1041, $FFF0

.5:	dc.w 2
	dc.w $F80C, $45, $FFF0
	dc.w $C, $1045, $FFF0

	even
