Map_FZLegs_internal:
	dc.w	.extended-Map_FZLegs_internal
	dc.w	.halfway-Map_FZLegs_internal
	dc.w	.retracted-Map_FZLegs_internal

.extended:	dc.w 2
	dc.w $140E, $2800, $FFF4
	dc.w $2400, $280C, $FFEC

.halfway:	dc.w 3
	dc.w $C05, $280D, $C
	dc.w $1C00, $2811, $C
	dc.w $140D, $2812, $FFEC

.retracted:	dc.w 2
	dc.w $C01, $281A, $C
	dc.w $140C, $281C, $FFEC

	even
