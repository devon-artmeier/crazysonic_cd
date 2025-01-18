Map_Eggman_internal:
	dc.w	.ship-Map_Eggman_internal
	dc.w	.facenormal1-Map_Eggman_internal
	dc.w	.facenormal2-Map_Eggman_internal
	dc.w	.facelaugh1-Map_Eggman_internal
	dc.w	.facelaugh2-Map_Eggman_internal
	dc.w	.facehit-Map_Eggman_internal
	dc.w	.facepanic-Map_Eggman_internal
	dc.w	.facedefeat-Map_Eggman_internal
	dc.w	.flame1-Map_Eggman_internal
	dc.w	.flame2-Map_Eggman_internal
	dc.w	.blank-Map_Eggman_internal
	dc.w	.escapeflame1-Map_Eggman_internal
	dc.w	.escapeflame2-Map_Eggman_internal

.ship:	dc.w 6
	dc.w $EC01, $A, $FFE4
	dc.w $EC05, $C, $C
	dc.w $FC0E, $2010, $FFE4
	dc.w $FC0E, $201C, 4
	dc.w $140C, $2028, $FFEC
	dc.w $1400, $202C, $C

.facenormal1:	dc.w 2
	dc.w $E404, 0, $FFF4
	dc.w $EC0D, 2, $FFEC

.facenormal2:	dc.w 2
	dc.w $E404, 0, $FFF4
	dc.w $EC0D, $35, $FFEC

.facelaugh1:	dc.w 3
	dc.w $E408, $3D, $FFF4
	dc.w $EC09, $40, $FFEC
	dc.w $EC05, $46, 4

.facelaugh2:	dc.w 3
	dc.w $E408, $4A, $FFF4
	dc.w $EC09, $4D, $FFEC
	dc.w $EC05, $53, 4

.facehit:	dc.w 3
	dc.w $E408, $57, $FFF4
	dc.w $EC09, $5A, $FFEC
	dc.w $EC05, $60, 4

.facepanic:	dc.w 3
	dc.w $E404, $64, 4
	dc.w $E404, 0, $FFF4
	dc.w $EC0D, $35, $FFEC

.facedefeat:	dc.w 4
	dc.w $E409, $66, $FFF4
	dc.w $E408, $57, $FFF4
	dc.w $EC09, $5A, $FFEC
	dc.w $EC05, $60, 4

.flame1:	dc.w 1
	dc.w $405, $2D, $22

.flame2:	dc.w 1
	dc.w $405, $31, $22

.blank:	dc.w 0

.escapeflame1:	dc.w 2
	dc.w 8, $12A, $22
	dc.w $808, $112A, $22

.escapeflame2:	dc.w 2
	dc.w $F80B, $12D, $22
	dc.w 1, $139, $3A

	even
