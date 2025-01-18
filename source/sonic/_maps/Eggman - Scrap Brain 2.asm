Map_SEgg_internal:
	dc.w	.stand-Map_SEgg_internal
	dc.w	.laugh1-Map_SEgg_internal
	dc.w	.laugh2-Map_SEgg_internal
	dc.w	.jump1-Map_SEgg_internal
	dc.w	.jump2-Map_SEgg_internal
	dc.w	.surprise-Map_SEgg_internal
	dc.w	.starjump-Map_SEgg_internal
	dc.w	.running1-Map_SEgg_internal
	dc.w	.running2-Map_SEgg_internal
	dc.w	.intube-Map_SEgg_internal
	dc.w	.cockpit-Map_SEgg_internal

.stand:	dc.w 3
	dc.w $FC00, $8F, $FFE8
	dc.w $E80E, 0, $FFF0
	dc.w $F, $6F, $FFF0

.laugh1:	dc.w 4
	dc.w $E80D, $E, $FFF0
	dc.w $E80E, 0, $FFF0
	dc.w $F, $6F, $FFF0
	dc.w $FC00, $8F, $FFE8

.laugh2:	dc.w 4
	dc.w $E90D, $E, $FFF0
	dc.w $E90E, 0, $FFF0
	dc.w $10F, $7F, $FFF0
	dc.w $FD00, $8F, $FFE8

.jump1:	dc.w 4
	dc.w $F40F, $820, $FFF0
	dc.w $F504, $830, $10
	dc.w $809, $84E, $FFF0
	dc.w $EC0E, 0, $FFF0

.jump2:	dc.w 4
	dc.w $F00F, $820, $FFF0
	dc.w $F104, $830, $10
	dc.w $806, $83E, $FFF8
	dc.w $E80E, 0, $FFF0

.surprise:	dc.w 4
	dc.w $E80D, $16, $FFEC
	dc.w $E801, $1E, $C
	dc.w $E80E, 0, $FFF0
	dc.w $F, $6F, $FFF0

.starjump:	dc.w 7
	dc.w $E80D, $16, $FFEC
	dc.w $E801, $1E, $C
	dc.w $409, $834, 0
	dc.w $405, $83A, $FFE8
	dc.w $F00F, $820, $FFF0
	dc.w $F104, $854, $10
	dc.w $F104, $54, $FFE0

.running1:	dc.w 5
	dc.w $F00F, $820, $FFF0
	dc.w $F104, $830, $10
	dc.w $409, $834, 0
	dc.w $405, $83A, $FFE8
	dc.w $E80E, 0, $FFF0

.running2:	dc.w 6
	dc.w $EE0F, $820, $FFF0
	dc.w $EF04, $830, $10
	dc.w $905, $844, 0
	dc.w $301, $848, $FFF8
	dc.w $B05, $84A, $FFE8
	dc.w $E60E, 0, $FFF0

.intube:	dc.w 8
	dc.w $E80D, $16, $FFEC
	dc.w $E801, $1E, $C
	dc.w $E80E, 0, $FFF0
	dc.w $F, $6F, $FFF0
	dc.w $E00D, $3EF0, $FFF0
	dc.w $F00D, $3EF0, $FFF0
	dc.w $D, $3EF0, $FFF0
	dc.w $100D, $3EF0, $FFF0

.cockpit:	dc.w 3
	dc.w $EC0D, $56, $FFE4
	dc.w $F408, $5E, 4
	dc.w $EC0D, $61, $FFFC

	even
