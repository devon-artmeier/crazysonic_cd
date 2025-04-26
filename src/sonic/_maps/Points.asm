Map_Poi_internal:
	dc.w	byte_94BC-Map_Poi_internal
	dc.w	byte_94C2-Map_Poi_internal
	dc.w	byte_94C8-Map_Poi_internal
	dc.w	byte_94CE-Map_Poi_internal
	dc.w	byte_94D4-Map_Poi_internal
	dc.w	byte_94DA-Map_Poi_internal
	dc.w	byte_94E5-Map_Poi_internal

byte_94BC:	dc.w 1
	dc.w $FC04, 0, $FFF8

byte_94C2:	dc.w 1
	dc.w $FC04, 2, $FFF8

byte_94C8:	dc.w 1
	dc.w $FC04, 4, $FFF8

byte_94CE:	dc.w 1
	dc.w $FC08, 6, $FFF8

byte_94D4:	dc.w 1
	dc.w $FC00, 6, $FFFC

byte_94DA:	dc.w 2
	dc.w $FC08, 6, $FFF4
	dc.w $FC04, 7, 1

byte_94E5:	dc.w 2
	dc.w $FC08, 6, $FFF4
	dc.w $FC04, 7, 6

	even
