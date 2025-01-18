Map_Bomb_internal:
	dc.w	.stand1-Map_Bomb_internal
	dc.w	.stand2-Map_Bomb_internal
	dc.w	.walk1-Map_Bomb_internal
	dc.w	.walk2-Map_Bomb_internal
	dc.w	.walk3-Map_Bomb_internal
	dc.w	.walk4-Map_Bomb_internal
	dc.w	.activate1-Map_Bomb_internal
	dc.w	.activate2-Map_Bomb_internal
	dc.w	.fuse1-Map_Bomb_internal
	dc.w	.fuse2-Map_Bomb_internal
	dc.w	.shrapnel1-Map_Bomb_internal
	dc.w	.shrapnel2-Map_Bomb_internal

.stand1:	dc.w 3
	dc.w $F10A, 0, $FFF4
	dc.w $908, $12, $FFF4
	dc.w $E701, $21, $FFFC

.stand2:	dc.w 3
	dc.w $F10A, 9, $FFF4
	dc.w $908, $12, $FFF4
	dc.w $E701, $21, $FFFC

.walk1:	dc.w 3
	dc.w $F00A, 0, $FFF4
	dc.w $808, $15, $FFF4
	dc.w $E601, $21, $FFFC

.walk2:	dc.w 3
	dc.w $F10A, 9, $FFF4
	dc.w $908, $18, $FFF4
	dc.w $E701, $21, $FFFC

.walk3:	dc.w 3
	dc.w $F00A, 0, $FFF4
	dc.w $808, $1B, $FFF4
	dc.w $E601, $21, $FFFC

.walk4:	dc.w 3
	dc.w $F10A, 9, $FFF4
	dc.w $908, $1E, $FFF4
	dc.w $E701, $21, $FFFC

.activate1:	dc.w 2
	dc.w $F10A, 0, $FFF4
	dc.w $908, $12, $FFF4

.activate2:	dc.w 2
	dc.w $F10A, 9, $FFF4
	dc.w $908, $12, $FFF4

.fuse1:	dc.w 1
	dc.w $E701, $23, $FFFC

.fuse2:	dc.w 1
	dc.w $E701, $25, $FFFC

.shrapnel1:	dc.w 1
	dc.w $FC00, $27, $FFFC

.shrapnel2:	dc.w 1
	dc.w $FC00, $28, $FFFC

	even
