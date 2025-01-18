Map_Glass_internal:
	dc.w	.tall-Map_Glass_internal
	dc.w	.shine-Map_Glass_internal
	dc.w	.short-Map_Glass_internal

.tall:	dc.w $C
	dc.w $B80C, 0, $FFE0
	dc.w $B80C, $800, 0
	dc.w $C00F, 4, $FFE0
	dc.w $C00F, $804, 0
	dc.w $E00F, 4, $FFE0
	dc.w $E00F, $804, 0
	dc.w $F, 4, $FFE0
	dc.w $F, $804, 0
	dc.w $200F, 4, $FFE0
	dc.w $200F, $804, 0
	dc.w $400C, $1000, $FFE0
	dc.w $400C, $1800, 0

.shine:	dc.w 2
	dc.w $806, $14, $FFF0
	dc.w 6, $14, 0

.short:	dc.w $A
	dc.w $C80C, 0, $FFE0
	dc.w $C80C, $800, 0
	dc.w $D00F, 4, $FFE0
	dc.w $D00F, $804, 0
	dc.w $F00F, 4, $FFE0
	dc.w $F00F, $804, 0
	dc.w $100F, 4, $FFE0
	dc.w $100F, $804, 0
	dc.w $300C, $1000, $FFE0
	dc.w $300C, $1800, 0

	even
