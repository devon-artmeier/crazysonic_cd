Map_BSBall_internal:
	dc.w	.fireball1-Map_BSBall_internal
	dc.w	.fireball2-Map_BSBall_internal

.fireball1:	dc.w 1
	dc.w $FC00, $27, $FFFC

.fireball2:	dc.w 1
	dc.w $FC00, $28, $FFFC

	even
