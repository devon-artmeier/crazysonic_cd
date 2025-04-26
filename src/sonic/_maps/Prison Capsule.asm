Map_Pri_internal:
	dc.w	.capsule-Map_Pri_internal
	dc.w	.switch1-Map_Pri_internal
	dc.w	.broken-Map_Pri_internal
	dc.w	.switch2-Map_Pri_internal
	dc.w	.unusedthing1-Map_Pri_internal
	dc.w	.unusedthing2-Map_Pri_internal
	dc.w	.blank-Map_Pri_internal

.capsule:	dc.w 7
	dc.w $E00C, $2000, $FFF0
	dc.w $E80D, $2004, $FFE0
	dc.w $E80D, $200C, 0
	dc.w $F80E, $2014, $FFE0
	dc.w $F80E, $2020, 0
	dc.w $100D, $202C, $FFE0
	dc.w $100D, $2034, 0

.switch1:	dc.w 1
	dc.w $F809, $3C, $FFF4

.broken:	dc.w 6
	dc.w 8, $2042, $FFE0
	dc.w $80C, $2045, $FFE0
	dc.w 4, $2049, $10
	dc.w $80C, $204B, 0
	dc.w $100D, $202C, $FFE0
	dc.w $100D, $2034, 0

.switch2:	dc.w 1
	dc.w $F809, $4F, $FFF4

.unusedthing1:	dc.w 2
	dc.w $E80E, $2055, $FFF0
	dc.w $E, $2061, $FFF0

.unusedthing2:	dc.w 1
	dc.w $F007, $206D, $FFF8

.blank:	dc.w 0

	even
