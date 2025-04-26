Map_LGrass_internal:
	dc.w	.wide-Map_LGrass_internal
	dc.w	.sloped-Map_LGrass_internal
	dc.w	.narrow-Map_LGrass_internal

.wide:	dc.w $D
	dc.w $D806, $57, $FFC0
	dc.w $F005, $53, $FFC0
	dc.w $F, 1, $FFC0
	dc.w $D00F, $27, $FFD0
	dc.w $F00D, $37, $FFD0
	dc.w $F00F, 1, $FFE0
	dc.w $D00F, $11, $FFF0
	dc.w $D00F, $3F, $10
	dc.w $F00D, $4F, $10
	dc.w $F00F, 1, 0
	dc.w $F, 1, $20
	dc.w $D806, $57, $30
	dc.w $F005, $53, $30

.sloped:	dc.w $A
	dc.w $D00F, $27, $FFC0
	dc.w $F00D, $37, $FFC0
	dc.w $F, 1, $FFC0
	dc.w $C00F, $27, $FFE0
	dc.w $E00D, $37, $FFE0
	dc.w $F00F, 1, $FFE0
	dc.w $C00F, $11, 0
	dc.w $E00F, 1, 0
	dc.w $C00F, $3F, $20
	dc.w $E00D, $4F, $20

.narrow:	dc.w 6
	dc.w $D00F, $11, $FFE0
	dc.w $F00F, 1, $FFE0
	dc.w $100F, 1, $FFE0
	dc.w $D00F, $11, 0
	dc.w $F00F, 1, 0
	dc.w $100F, 1, 0

	even
