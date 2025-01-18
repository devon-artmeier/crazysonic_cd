Map_Monitor_internal:
	dc.w	.static0-Map_Monitor_internal
	dc.w	.static1-Map_Monitor_internal
	dc.w	.static2-Map_Monitor_internal
	dc.w	.eggman-Map_Monitor_internal
	dc.w	.sonic-Map_Monitor_internal
	dc.w	.shoes-Map_Monitor_internal
	dc.w	.shield-Map_Monitor_internal
	dc.w	.invincible-Map_Monitor_internal
	dc.w	.rings-Map_Monitor_internal
	dc.w	.s-Map_Monitor_internal
	dc.w	.goggles-Map_Monitor_internal
	dc.w	.broken-Map_Monitor_internal

.static0:	dc.w 1
	dc.w $EF0F, 0, $FFF0

.static1:	dc.w 2
	dc.w $F505, $10, $FFF8
	dc.w $EF0F, 0, $FFF0

.static2:	dc.w 2
	dc.w $F505, $14, $FFF8
	dc.w $EF0F, 0, $FFF0

.eggman:	dc.w 2
	dc.w $F505, $18, $FFF8
	dc.w $EF0F, 0, $FFF0

.sonic:	dc.w 2
	dc.w $F505, $1C, $FFF8
	dc.w $EF0F, 0, $FFF0

.shoes:	dc.w 2
	dc.w $F505, $24, $FFF8
	dc.w $EF0F, 0, $FFF0

.shield:	dc.w 2
	dc.w $F505, $28, $FFF8
	dc.w $EF0F, 0, $FFF0

.invincible:	dc.w 2
	dc.w $F505, $2C, $FFF8
	dc.w $EF0F, 0, $FFF0

.rings:	dc.w 2
	dc.w $F505, $30, $FFF8
	dc.w $EF0F, 0, $FFF0

.s:	dc.w 2
	dc.w $F505, $34, $FFF8
	dc.w $EF0F, 0, $FFF0

.goggles:	dc.w 2
	dc.w $F505, $20, $FFF8
	dc.w $EF0F, 0, $FFF0

.broken:	dc.w 1
	dc.w $FF0D, $38, $FFF0

	even
