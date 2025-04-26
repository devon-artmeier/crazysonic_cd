Map_Bub_internal:
	dc.w	.bubble1-Map_Bub_internal
	dc.w	.bubble2-Map_Bub_internal
	dc.w	.bubble3-Map_Bub_internal
	dc.w	.bubble4-Map_Bub_internal
	dc.w	.bubble5-Map_Bub_internal
	dc.w	.bubble6-Map_Bub_internal
	dc.w	.bubblefull-Map_Bub_internal
	dc.w	.burst1-Map_Bub_internal
	dc.w	.burst2-Map_Bub_internal
	dc.w	.zero_sm-Map_Bub_internal
	dc.w	.five_sm-Map_Bub_internal
	dc.w	.three_sm-Map_Bub_internal
	dc.w	.one_sm-Map_Bub_internal
	dc.w	.zero-Map_Bub_internal
	dc.w	.five-Map_Bub_internal
	dc.w	.four-Map_Bub_internal
	dc.w	.three-Map_Bub_internal
	dc.w	.two-Map_Bub_internal
	dc.w	.one-Map_Bub_internal
	dc.w	.bubmaker1-Map_Bub_internal
	dc.w	.bubmaker2-Map_Bub_internal
	dc.w	.bubmaker3-Map_Bub_internal
	dc.w	.blank-Map_Bub_internal

.bubble1:	dc.w 1
	dc.w $FC00, 0, $FFFC

.bubble2:	dc.w 1
	dc.w $FC00, 1, $FFFC

.bubble3:	dc.w 1
	dc.w $FC00, 2, $FFFC

.bubble4:	dc.w 1
	dc.w $F805, 3, $FFF8

.bubble5:	dc.w 1
	dc.w $F805, 7, $FFF8

.bubble6:	dc.w 1
	dc.w $F40A, $B, $FFF4

.bubblefull:	dc.w 1
	dc.w $F00F, $14, $FFF0

.burst1:	dc.w 4
	dc.w $F005, $24, $FFF0
	dc.w $F005, $824, 0
	dc.w 5, $1024, $FFF0
	dc.w 5, $1824, 0

.burst2:	dc.w 4
	dc.w $F005, $28, $FFF0
	dc.w $F005, $828, 0
	dc.w 5, $1028, $FFF0
	dc.w 5, $1828, 0

.zero_sm:	dc.w 1
	dc.w $F406, $2C, $FFF8

.five_sm:	dc.w 1
	dc.w $F406, $32, $FFF8

.three_sm:	dc.w 1
	dc.w $F406, $38, $FFF8

.one_sm:	dc.w 1
	dc.w $F406, $3E, $FFF8

.zero:	dc.w 1
	dc.w $F406, $2044, $FFF8

.five:	dc.w 1
	dc.w $F406, $204A, $FFF8

.four:	dc.w 1
	dc.w $F406, $2050, $FFF8

.three:	dc.w 1
	dc.w $F406, $2056, $FFF8

.two:	dc.w 1
	dc.w $F406, $205C, $FFF8

.one:	dc.w 1
	dc.w $F406, $2062, $FFF8

.bubmaker1:	dc.w 1
	dc.w $F805, $68, $FFF8

.bubmaker2:	dc.w 1
	dc.w $F805, $6C, $FFF8

.bubmaker3:	dc.w 1
	dc.w $F805, $70, $FFF8

.blank:	dc.w 0

	even
