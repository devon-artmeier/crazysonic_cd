Map_GBall_internal:
	dc.w	.shiny-Map_GBall_internal
	dc.w	.check1-Map_GBall_internal
	dc.w	.check2-Map_GBall_internal
	dc.w	.check3-Map_GBall_internal

.shiny:	dc.w 6
	dc.w $F004, $24, $FFF0
	dc.w $F804, $1024, $FFF0
	dc.w $E80A, 0, $FFE8
	dc.w $E80A, $800, 0
	dc.w $A, $1000, $FFE8
	dc.w $A, $1800, 0

.check1:	dc.w 4
	dc.w $E80A, 9, $FFE8
	dc.w $E80A, $809, 0
	dc.w $A, $1009, $FFE8
	dc.w $A, $1809, 0

.check2:	dc.w 4
	dc.w $E80A, $12, $FFE8
	dc.w $E80A, $1B, 0
	dc.w $A, $181B, $FFE8
	dc.w $A, $1812, 0

.check3:	dc.w 4
	dc.w $E80A, $81B, $FFE8
	dc.w $E80A, $812, 0
	dc.w $A, $1012, $FFE8
	dc.w $A, $101B, 0

	even
