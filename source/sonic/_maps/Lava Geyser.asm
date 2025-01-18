Map_Geyser_internal:
	dc.w	.bubble1-Map_Geyser_internal
	dc.w	.bubble2-Map_Geyser_internal
	dc.w	.bubble3-Map_Geyser_internal
	dc.w	.bubble4-Map_Geyser_internal
	dc.w	.bubble5-Map_Geyser_internal
	dc.w	.bubble6-Map_Geyser_internal
	dc.w	.end1-Map_Geyser_internal
	dc.w	.end2-Map_Geyser_internal
	dc.w	.medcolumn1-Map_Geyser_internal
	dc.w	.medcolumn2-Map_Geyser_internal
	dc.w	.medcolumn3-Map_Geyser_internal
	dc.w	.shortcolumn1-Map_Geyser_internal
	dc.w	.shortcolumn2-Map_Geyser_internal
	dc.w	.shortcolumn3-Map_Geyser_internal
	dc.w	.longcolumn1-Map_Geyser_internal
	dc.w	.longcolumn2-Map_Geyser_internal
	dc.w	.longcolumn3-Map_Geyser_internal
	dc.w	.bubble7-Map_Geyser_internal
	dc.w	.bubble8-Map_Geyser_internal
	dc.w	.blank-Map_Geyser_internal

.bubble1:	dc.w 2
	dc.w $EC0B, 0, $FFE8
	dc.w $EC0B, $800, 0

.bubble2:	dc.w 2
	dc.w $EC0B, $18, $FFE8
	dc.w $EC0B, $818, 0

.bubble3:	dc.w 4
	dc.w $EC0B, 0, $FFC8
	dc.w $F40E, $C, $FFE0
	dc.w $F40E, $80C, 0
	dc.w $EC0B, $800, $20

.bubble4:	dc.w 4
	dc.w $EC0B, $18, $FFC8
	dc.w $F40E, $24, $FFE0
	dc.w $F40E, $824, 0
	dc.w $EC0B, $818, $20

.bubble5:	dc.w 6
	dc.w $EC0B, 0, $FFC8
	dc.w $F40E, $C, $FFE0
	dc.w $F40E, $80C, 0
	dc.w $EC0B, $800, $20
	dc.w $E80E, $90, $FFE0
	dc.w $E80E, $890, 0

.bubble6:	dc.w 6
	dc.w $EC0B, $18, $FFC8
	dc.w $F40E, $24, $FFE0
	dc.w $F40E, $824, 0
	dc.w $EC0B, $818, $20
	dc.w $E80E, $890, $FFE0
	dc.w $E80E, $90, 0

.end1:	dc.w 2
	dc.w $E00F, $30, $FFE0
	dc.w $E00F, $830, 0

.end2:	dc.w 2
	dc.w $E00F, $830, $FFE0
	dc.w $E00F, $30, 0

.medcolumn1:	dc.w $A
	dc.w $900F, $40, $FFE0
	dc.w $900F, $840, 0
	dc.w $B00F, $40, $FFE0
	dc.w $B00F, $840, 0
	dc.w $D00F, $40, $FFE0
	dc.w $D00F, $840, 0
	dc.w $F00F, $40, $FFE0
	dc.w $F00F, $840, 0
	dc.w $100F, $40, $FFE0
	dc.w $100F, $840, 0

.medcolumn2:	dc.w $A
	dc.w $900F, $50, $FFE0
	dc.w $900F, $850, 0
	dc.w $B00F, $50, $FFE0
	dc.w $B00F, $850, 0
	dc.w $D00F, $50, $FFE0
	dc.w $D00F, $850, 0
	dc.w $F00F, $50, $FFE0
	dc.w $F00F, $850, 0
	dc.w $100F, $50, $FFE0
	dc.w $100F, $850, 0

.medcolumn3:	dc.w $A
	dc.w $900F, $60, $FFE0
	dc.w $900F, $860, 0
	dc.w $B00F, $60, $FFE0
	dc.w $B00F, $860, 0
	dc.w $D00F, $60, $FFE0
	dc.w $D00F, $860, 0
	dc.w $F00F, $60, $FFE0
	dc.w $F00F, $860, 0
	dc.w $100F, $60, $FFE0
	dc.w $100F, $860, 0

.shortcolumn1:	dc.w 6
	dc.w $900F, $40, $FFE0
	dc.w $900F, $840, 0
	dc.w $B00F, $40, $FFE0
	dc.w $B00F, $840, 0
	dc.w $D00F, $40, $FFE0
	dc.w $D00F, $840, 0

.shortcolumn2:	dc.w 6
	dc.w $900F, $50, $FFE0
	dc.w $900F, $850, 0
	dc.w $B00F, $50, $FFE0
	dc.w $B00F, $850, 0
	dc.w $D00F, $50, $FFE0
	dc.w $D00F, $850, 0

.shortcolumn3:	dc.w 6
	dc.w $900F, $60, $FFE0
	dc.w $900F, $860, 0
	dc.w $B00F, $60, $FFE0
	dc.w $B00F, $860, 0
	dc.w $D00F, $60, $FFE0
	dc.w $D00F, $860, 0

.longcolumn1:	dc.w $10
	dc.w $900F, $40, $FFE0
	dc.w $900F, $840, 0
	dc.w $B00F, $40, $FFE0
	dc.w $B00F, $840, 0
	dc.w $D00F, $40, $FFE0
	dc.w $D00F, $840, 0
	dc.w $F00F, $40, $FFE0
	dc.w $F00F, $840, 0
	dc.w $100F, $40, $FFE0
	dc.w $100F, $840, 0
	dc.w $300F, $40, $FFE0
	dc.w $300F, $840, 0
	dc.w $500F, $40, $FFE0
	dc.w $500F, $840, 0
	dc.w $700F, $40, $FFE0
	dc.w $700F, $840, 0

.longcolumn2:	dc.w $10
	dc.w $900F, $50, $FFE0
	dc.w $900F, $850, 0
	dc.w $B00F, $50, $FFE0
	dc.w $B00F, $850, 0
	dc.w $D00F, $50, $FFE0
	dc.w $D00F, $850, 0
	dc.w $F00F, $50, $FFE0
	dc.w $F00F, $850, 0
	dc.w $100F, $50, $FFE0
	dc.w $100F, $850, 0
	dc.w $300F, $50, $FFE0
	dc.w $300F, $850, 0
	dc.w $500F, $50, $FFE0
	dc.w $500F, $850, 0
	dc.w $700F, $50, $FFE0
	dc.w $700F, $850, 0

.longcolumn3:	dc.w $10
	dc.w $900F, $60, $FFE0
	dc.w $900F, $860, 0
	dc.w $B00F, $60, $FFE0
	dc.w $B00F, $860, 0
	dc.w $D00F, $60, $FFE0
	dc.w $D00F, $860, 0
	dc.w $F00F, $60, $FFE0
	dc.w $F00F, $860, 0
	dc.w $100F, $60, $FFE0
	dc.w $100F, $860, 0
	dc.w $300F, $60, $FFE0
	dc.w $300F, $860, 0
	dc.w $500F, $60, $FFE0
	dc.w $500F, $860, 0
	dc.w $700F, $60, $FFE0
	dc.w $700F, $860, 0

.bubble7:	dc.w 6
	dc.w $E00B, 0, $FFC8
	dc.w $E80E, $C, $FFE0
	dc.w $E80E, $80C, 0
	dc.w $E00B, $800, $20
	dc.w $D80E, $90, $FFE0
	dc.w $D80E, $890, 0

.bubble8:	dc.w 6
	dc.w $E00B, $18, $FFC8
	dc.w $E80E, $24, $FFE0
	dc.w $E80E, $824, 0
	dc.w $E00B, $818, $20
	dc.w $D80E, $890, $FFE0
	dc.w $D80E, $90, 0

.blank:	dc.w 0

	even
