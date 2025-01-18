Map_Burro_internal:
	dc.w	.walk1-Map_Burro_internal
	dc.w	.walk2-Map_Burro_internal
	dc.w	.digging1-Map_Burro_internal
	dc.w	.digging2-Map_Burro_internal
	dc.w	.fall-Map_Burro_internal
	dc.w	.facedown-Map_Burro_internal
	dc.w	.walk3-Map_Burro_internal

.walk1:	dc.w 2
	dc.w $EC0A, 0, $FFF0
	dc.w $409, 9, $FFF4

.walk2:	dc.w 2
	dc.w $EC0A, $F, $FFF0
	dc.w $409, $18, $FFF4

.digging1:	dc.w 2
	dc.w $E80A, $1E, $FFF4
	dc.w $A, $27, $FFF4

.digging2:	dc.w 2
	dc.w $E80A, $30, $FFF4
	dc.w $A, $39, $FFF4

.fall:	dc.w 2
	dc.w $E80A, $F, $FFF0
	dc.w $A, $42, $FFF4

.facedown:	dc.w 2
	dc.w $F406, $4B, $FFE8
	dc.w $F40A, $51, $FFF8

.walk3:	dc.w 2
	dc.w $EC0A, $F, $FFF0
	dc.w $409, 9, $FFF4

	even
