Map_Flame_internal:
	dc.w	.pipe1-Map_Flame_internal
	dc.w	.pipe2-Map_Flame_internal
	dc.w	.pipe3-Map_Flame_internal
	dc.w	.pipe4-Map_Flame_internal
	dc.w	.pipe5-Map_Flame_internal
	dc.w	.pipe6-Map_Flame_internal
	dc.w	.pipe7-Map_Flame_internal
	dc.w	.pipe8-Map_Flame_internal
	dc.w	.pipe9-Map_Flame_internal
	dc.w	.pipe10-Map_Flame_internal
	dc.w	.pipe11-Map_Flame_internal
	dc.w	.valve1-Map_Flame_internal
	dc.w	.valve2-Map_Flame_internal
	dc.w	.valve3-Map_Flame_internal
	dc.w	.valve4-Map_Flame_internal
	dc.w	.valve5-Map_Flame_internal
	dc.w	.valve6-Map_Flame_internal
	dc.w	.valve7-Map_Flame_internal
	dc.w	.valve8-Map_Flame_internal
	dc.w	.valve9-Map_Flame_internal
	dc.w	.valve10-Map_Flame_internal
	dc.w	.valve11-Map_Flame_internal

.pipe1:	dc.w 1
	dc.w $2805, $4014, $FFFB

.pipe2:	dc.w 2
	dc.w $2001, 0, $FFFD
	dc.w $2805, $4014, $FFFB

.pipe3:	dc.w 2
	dc.w $2001, $800, $FFFC
	dc.w $2805, $4014, $FFFB

.pipe4:	dc.w 3
	dc.w $1006, 2, $FFF8
	dc.w $2001, 0, $FFFD
	dc.w $2805, $4014, $FFFB

.pipe5:	dc.w 3
	dc.w $1006, $802, $FFF8
	dc.w $2001, $800, $FFFC
	dc.w $2805, $4014, $FFFB

.pipe6:	dc.w 4
	dc.w $806, 2, $FFF8
	dc.w $1006, 2, $FFF8
	dc.w $2001, 0, $FFFD
	dc.w $2805, $4014, $FFFB

.pipe7:	dc.w 4
	dc.w $806, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2001, $800, $FFFC
	dc.w $2805, $4014, $FFFB

.pipe8:	dc.w 5
	dc.w $F80B, 8, $FFF4
	dc.w $806, 2, $FFF8
	dc.w $1006, 2, $FFF8
	dc.w $2001, 0, $FFFD
	dc.w $2805, $4014, $FFFB

.pipe9:	dc.w 5
	dc.w $F80B, $808, $FFF4
	dc.w $806, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2001, $800, $FFFC
	dc.w $2805, $4014, $FFFB

.pipe10:	dc.w 6
	dc.w $E80B, 8, $FFF4
	dc.w $F70B, 8, $FFF4
	dc.w $806, 2, $FFF8
	dc.w $F06, 2, $FFF8
	dc.w $2001, 0, $FFFD
	dc.w $2805, $4014, $FFFB

.pipe11:	dc.w 6
	dc.w $E70B, $808, $FFF4
	dc.w $F80B, $808, $FFF4
	dc.w $706, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2001, $800, $FFFC
	dc.w $2805, $4014, $FFFB

.valve1:	dc.w 1
	dc.w $2805, $4018, $FFF9

.valve2:	dc.w 2
	dc.w $2805, $4018, $FFF9
	dc.w $2001, 0, $FFFD

.valve3:	dc.w 2
	dc.w $2805, $4018, $FFF9
	dc.w $2001, $800, $FFFC

.valve4:	dc.w 3
	dc.w $1006, 2, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, 0, $FFFD

.valve5:	dc.w 3
	dc.w $1006, $802, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, $800, $FFFC

.valve6:	dc.w 4
	dc.w $806, 2, $FFF8
	dc.w $1006, 2, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, 0, $FFFD

.valve7:	dc.w 4
	dc.w $806, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, $800, $FFFC

.valve8:	dc.w 5
	dc.w $F80B, 8, $FFF4
	dc.w $806, 2, $FFF8
	dc.w $1006, 2, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, 0, $FFFD

.valve9:	dc.w 5
	dc.w $F80B, $808, $FFF4
	dc.w $806, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, $800, $FFFC

.valve10:	dc.w 6
	dc.w $E80B, 8, $FFF4
	dc.w $F70B, 8, $FFF4
	dc.w $806, 2, $FFF8
	dc.w $F06, 2, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, 0, $FFFD

.valve11:	dc.w 6
	dc.w $E70B, $808, $FFF4
	dc.w $F80B, $808, $FFF4
	dc.w $706, $802, $FFF8
	dc.w $1006, $802, $FFF8
	dc.w $2805, $4018, $FFF9
	dc.w $2001, $800, $FFFC

	even
