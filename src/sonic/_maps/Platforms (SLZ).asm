Map_Plat_SLZ_internal:
	dc.w	.platform-Map_Plat_SLZ_internal

.platform:	dc.w 2
	dc.w $F80F, $21, $FFE0
	dc.w $F80F, $21, 0

	even
