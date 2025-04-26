Map_FBlock_internal:
	dc.w	.syz1x1-Map_FBlock_internal
	dc.w	.syz2x2-Map_FBlock_internal
	dc.w	.syz1x2-Map_FBlock_internal
	dc.w	.syzrect2x2-Map_FBlock_internal
	dc.w	.syzrect1x3-Map_FBlock_internal
	dc.w	.slz-Map_FBlock_internal
	dc.w	.lzvert-Map_FBlock_internal
	dc.w	.lzhoriz-Map_FBlock_internal

.syz1x1:	dc.w 1
	dc.w $F00F, $61, $FFF0

.syz2x2:	dc.w 4
	dc.w $E00F, $61, $FFE0
	dc.w $E00F, $61, 0
	dc.w $F, $61, $FFE0
	dc.w $F, $61, 0

.syz1x2:	dc.w 2
	dc.w $E00F, $61, $FFF0
	dc.w $F, $61, $FFF0

.syzrect2x2:	dc.w 4
	dc.w $E60F, $81, $FFE0
	dc.w $E60F, $81, 0
	dc.w $F, $81, $FFE0
	dc.w $F, $81, 0

.syzrect1x3:	dc.w 3
	dc.w $D90F, $81, $FFF0
	dc.w $F30F, $81, $FFF0
	dc.w $D0F, $81, $FFF0

.slz:	dc.w 1
	dc.w $F00F, $21, $FFF0

.lzvert:	dc.w 2
	dc.w $E007, 0, $FFF8
	dc.w 7, $1000, $FFF8

.lzhoriz:	dc.w 4
	dc.w $F00F, $22, $FFC0
	dc.w $F00F, $22, $FFE0
	dc.w $F00F, $22, 0
	dc.w $F00F, $22, $20

	even
