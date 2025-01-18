Map_CStom_internal:
	dc.w	.wideblock-Map_CStom_internal
	dc.w	.spikes-Map_CStom_internal
	dc.w	.ceiling-Map_CStom_internal
	dc.w	.chain1-Map_CStom_internal
	dc.w	.chain2-Map_CStom_internal
	dc.w	.chain3-Map_CStom_internal
	dc.w	.chain4-Map_CStom_internal
	dc.w	.chain5-Map_CStom_internal
	dc.w	.chain5-Map_CStom_internal
	dc.w	.mediumblock-Map_CStom_internal
	dc.w	.smallblock-Map_CStom_internal

.wideblock:	dc.w 5
	dc.w $F406, 0, $FFC8
	dc.w $F40A, 6, $FFD8
	dc.w $EC0F, $F, $FFF0
	dc.w $F40A, $806, $10
	dc.w $F406, $800, $28

.spikes:	dc.w 5
	dc.w $F003, $121F, $FFD4
	dc.w $F003, $121F, $FFE8
	dc.w $F003, $121F, $FFFC
	dc.w $F003, $121F, $10
	dc.w $F003, $121F, $24

.ceiling:	dc.w 1
	dc.w $DC0F, $100F, $FFF0

.chain1:	dc.w 2
	dc.w 1, $3F, $FFFC
	dc.w $1001, $3F, $FFFC

.chain2:	dc.w 4
	dc.w $E001, $3F, $FFFC
	dc.w $F001, $3F, $FFFC
	dc.w 1, $3F, $FFFC
	dc.w $1001, $3F, $FFFC

.chain3:	dc.w 6
	dc.w $C001, $3F, $FFFC
	dc.w $D001, $3F, $FFFC
	dc.w $E001, $3F, $FFFC
	dc.w $F001, $3F, $FFFC
	dc.w 1, $3F, $FFFC
	dc.w $1001, $3F, $FFFC

.chain4:	dc.w 8
	dc.w $A001, $3F, $FFFC
	dc.w $B001, $3F, $FFFC
	dc.w $C001, $3F, $FFFC
	dc.w $D001, $3F, $FFFC
	dc.w $E001, $3F, $FFFC
	dc.w $F001, $3F, $FFFC
	dc.w 1, $3F, $FFFC
	dc.w $1001, $3F, $FFFC

.chain5:	dc.w $A
	dc.w $8001, $3F, $FFFC
	dc.w $9001, $3F, $FFFC
	dc.w $A001, $3F, $FFFC
	dc.w $B001, $3F, $FFFC
	dc.w $C001, $3F, $FFFC
	dc.w $D001, $3F, $FFFC
	dc.w $E001, $3F, $FFFC
	dc.w $F001, $3F, $FFFC
	dc.w 1, $3F, $FFFC
	dc.w $1001, $3F, $FFFC

.mediumblock:	dc.w 5
	dc.w $F406, 0, $FFD0
	dc.w $F40A, 6, $FFE0
	dc.w $F40A, $806, 8
	dc.w $F406, $800, $20
	dc.w $EC0F, $F, $FFF0

.smallblock:	dc.w 1
	dc.w $EC0F, $2F, $FFF0

	even
