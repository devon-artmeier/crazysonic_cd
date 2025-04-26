Map_Splash_internal:
	dc.w	.splash1-Map_Splash_internal
	dc.w	.splash2-Map_Splash_internal
	dc.w	.splash3-Map_Splash_internal

.splash1:	dc.w 2
	dc.w $F204, $6D, $FFF8
	dc.w $FA0C, $6F, $FFF0

.splash2:	dc.w 2
	dc.w $E200, $73, $FFF8
	dc.w $EA0E, $74, $FFF0

.splash3:	dc.w 1
	dc.w $E20F, $80, $FFF0

	even
