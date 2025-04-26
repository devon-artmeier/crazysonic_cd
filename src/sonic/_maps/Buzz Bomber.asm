Map_Buzz_internal:
	dc.w	.Fly1-Map_Buzz_internal
	dc.w	.Fly2-Map_Buzz_internal
	dc.w	.Fly3-Map_Buzz_internal
	dc.w	.Fly4-Map_Buzz_internal
	dc.w	.Fire1-Map_Buzz_internal
	dc.w	.Fire2-Map_Buzz_internal

.Fly1:	dc.w 6
	dc.w $F409, 0, $FFE8
	dc.w $F409, $F, 0
	dc.w $408, $15, $FFE8
	dc.w $404, $18, 0
	dc.w $F108, $1A, $FFEC
	dc.w $F104, $1D, 4

.Fly2:	dc.w 6
	dc.w $F409, 0, $FFE8
	dc.w $F409, $F, 0
	dc.w $408, $15, $FFE8
	dc.w $404, $18, 0
	dc.w $F408, $1F, $FFEC
	dc.w $F404, $22, 4

.Fly3:	dc.w 7
	dc.w $400, $30, $C
	dc.w $F409, 0, $FFE8
	dc.w $F409, $F, 0
	dc.w $408, $15, $FFE8
	dc.w $404, $18, 0
	dc.w $F108, $1A, $FFEC
	dc.w $F104, $1D, 4

.Fly4:	dc.w 7
	dc.w $404, $31, $C
	dc.w $F409, 0, $FFE8
	dc.w $F409, $F, 0
	dc.w $408, $15, $FFE8
	dc.w $404, $18, 0
	dc.w $F408, $1F, $FFEC
	dc.w $F404, $22, 4

.Fire1:	dc.w 6
	dc.w $F40D, 0, $FFEC
	dc.w $40C, 8, $FFEC
	dc.w $400, $C, $C
	dc.w $C04, $D, $FFF4
	dc.w $F108, $1A, $FFEC
	dc.w $F104, $1D, 4

.Fire2:	dc.w 4
	dc.w $F40D, 0, $FFEC
	dc.w $40C, 8, $FFEC
	dc.w $400, $C, $C
	dc.w $C04, $D, $FFF4

	even
