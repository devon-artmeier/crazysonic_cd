Map_FZDamaged_internal:
	dc.w	.damage1-Map_FZDamaged_internal
	dc.w	.damage2-Map_FZDamaged_internal

.damage1:	dc.w 6
	dc.w $E408, $20, $FFF4
	dc.w $EC0D, $23, $FFE4
	dc.w $EC09, $2B, 4
	dc.w $FC05, $203A, $FFE4
	dc.w $FC0E, $203E, 4
	dc.w $1404, $204A, 4

.damage2:	dc.w 6
	dc.w $E40A, $31, $FFF4
	dc.w $EC05, $23, $FFE4
	dc.w $EC09, $2B, 4
	dc.w $FC05, $203A, $FFE4
	dc.w $FC0E, $203E, 4
	dc.w $1404, $204A, 4

	even
