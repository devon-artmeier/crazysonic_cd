Map_Cred_internal:
	dc.w	.staff-Map_Cred_internal
	dc.w	.gameplan-Map_Cred_internal
	dc.w	.program-Map_Cred_internal
	dc.w	.character-Map_Cred_internal
	dc.w	.design-Map_Cred_internal
	dc.w	.soundproduce-Map_Cred_internal
	dc.w	.soundprogram-Map_Cred_internal
	dc.w	.thanks-Map_Cred_internal
	dc.w	.presentedby-Map_Cred_internal
	dc.w	.tryagain-Map_Cred_internal
	dc.w	.sonicteam-Map_Cred_internal

.staff:	dc.w $E
	dc.w $F805, $2E, $FF88
	dc.w $F805, $26, $FF98
	dc.w $F805, $1A, $FFA8
	dc.w $F801, $46, $FFB8
	dc.w $F805, $1E, $FFC0
	dc.w $F805, $3E, $FFD8
	dc.w $F805, $E, $FFE8
	dc.w $F805, 4, $FFF8
	dc.w $F809, 8, 8
	dc.w $F805, $2E, $28
	dc.w $F805, $3E, $38
	dc.w $F805, 4, $48
	dc.w $F805, $5C, $58
	dc.w $F805, $5C, $68

.gameplan:	dc.w $10
	dc.w $D805, 0, $FF80
	dc.w $D805, 4, $FF90
	dc.w $D809, 8, $FFA0
	dc.w $D805, $E, $FFB4
	dc.w $D805, $12, $FFD0
	dc.w $D805, $16, $FFE0
	dc.w $D805, 4, $FFF0
	dc.w $D805, $1A, 0
	dc.w $805, $1E, $FFC8
	dc.w $805, 4, $FFD8
	dc.w $805, $22, $FFE8
	dc.w $805, $26, $FFF8
	dc.w $805, $16, 8
	dc.w $805, $2A, $20
	dc.w $805, 4, $30
	dc.w $805, $2E, $44

.program:	dc.w $A
	dc.w $D805, $12, $FF80
	dc.w $D805, $22, $FF90
	dc.w $D805, $26, $FFA0
	dc.w $D805, 0, $FFB0
	dc.w $D805, $22, $FFC0
	dc.w $D805, 4, $FFD0
	dc.w $D809, 8, $FFE0
	dc.w $805, $2A, $FFE8
	dc.w $805, $32, $FFF8
	dc.w $805, $36, 8

.character:	dc.w $18
	dc.w $D805, $1E, $FF88
	dc.w $D805, $3A, $FF98
	dc.w $D805, 4, $FFA8
	dc.w $D805, $22, $FFB8
	dc.w $D805, 4, $FFC8
	dc.w $D805, $1E, $FFD8
	dc.w $D805, $3E, $FFE8
	dc.w $D805, $E, $FFF8
	dc.w $D805, $22, 8
	dc.w $D805, $42, $20
	dc.w $D805, $E, $30
	dc.w $D805, $2E, $40
	dc.w $D801, $46, $50
	dc.w $D805, 0, $58
	dc.w $D805, $1A, $68
	dc.w $805, $48, $FFC0
	dc.w $801, $46, $FFD0
	dc.w $805, 0, $FFD8
	dc.w $801, $46, $FFE8
	dc.w $805, $2E, $FFF0
	dc.w $805, $16, 0
	dc.w $805, 4, $10
	dc.w $805, $1A, $20
	dc.w $805, $42, $30

.design:	dc.w $14
	dc.w $D005, $42, $FFA0
	dc.w $D005, $E, $FFB0
	dc.w $D005, $2E, $FFC0
	dc.w $D001, $46, $FFD0
	dc.w $D005, 0, $FFD8
	dc.w $D005, $1A, $FFE8
	dc.w 5, $4C, $FFE8
	dc.w 1, $46, $FFF8
	dc.w 5, $1A, 4
	dc.w 5, $2A, $14
	dc.w 5, 4, $24
	dc.w $2005, $12, $FFD0
	dc.w $2005, $3A, $FFE0
	dc.w $2005, $E, $FFF0
	dc.w $2005, $1A, 0
	dc.w $2001, $46, $10
	dc.w $2005, $50, $18
	dc.w $2005, $22, $30
	dc.w $2001, $46, $40
	dc.w $2005, $E, $48

.soundproduce:	dc.w $1A
	dc.w $D805, $2E, $FF98
	dc.w $D805, $26, $FFA8
	dc.w $D805, $32, $FFB8
	dc.w $D805, $1A, $FFC8
	dc.w $D805, $54, $FFD8
	dc.w $D805, $12, $FFF8
	dc.w $D805, $22, 8
	dc.w $D805, $26, $18
	dc.w $D805, $42, $28
	dc.w $D805, $32, $38
	dc.w $D805, $1E, $48
	dc.w $D805, $E, $58
	dc.w $809, 8, $FF88
	dc.w $805, 4, $FF9C
	dc.w $805, $2E, $FFAC
	dc.w $805, 4, $FFBC
	dc.w $805, $3E, $FFCC
	dc.w $805, $26, $FFDC
	dc.w $805, $1A, $FFF8
	dc.w $805, 4, 8
	dc.w $805, $58, $18
	dc.w $805, 4, $28
	dc.w $809, 8, $38
	dc.w $805, $32, $4C
	dc.w $805, $22, $5C
	dc.w $805, 4, $6C

.soundprogram:	dc.w $17
	dc.w $D005, $2E, $FF98
	dc.w $D005, $26, $FFA8
	dc.w $D005, $32, $FFB8
	dc.w $D005, $1A, $FFC8
	dc.w $D005, $54, $FFD8
	dc.w $D005, $12, $FFF8
	dc.w $D005, $22, 8
	dc.w $D005, $26, $18
	dc.w $D005, 0, $28
	dc.w $D005, $22, $38
	dc.w $D005, 4, $48
	dc.w $D009, 8, $58
	dc.w 5, $4C, $FFD0
	dc.w 1, $46, $FFE0
	dc.w 9, 8, $FFE8
	dc.w 1, $46, $FFFC
	dc.w 5, $3E, 4
	dc.w 5, 4, $14
	dc.w $2009, 8, $FFD0
	dc.w $2005, 4, $FFE4
	dc.w $2005, $1E, $FFF4
	dc.w $2005, $58, 4
	dc.w $2005, $2A, $14

.thanks:	dc.w $1F
	dc.w $D805, $2E, $FF80
	dc.w $D805, $12, $FF90
	dc.w $D805, $E, $FFA0
	dc.w $D805, $1E, $FFB0
	dc.w $D801, $46, $FFC0
	dc.w $D805, 4, $FFC8
	dc.w $D805, $16, $FFD8
	dc.w $D805, $3E, $FFF8
	dc.w $D805, $3A, 8
	dc.w $D805, 4, $18
	dc.w $D805, $1A, $28
	dc.w $D805, $58, $38
	dc.w $D805, $2E, $48
	dc.w 5, $5C, $FFB0
	dc.w 5, $32, $FFC0
	dc.w 5, $4C, $FFD0
	dc.w 1, $46, $FFE0
	dc.w 5, $26, $FFE8
	dc.w 9, 8, 0
	dc.w 1, $46, $14
	dc.w 5, $1A, $1C
	dc.w 5, $E, $2C
	dc.w 5, 0, $3C
	dc.w 1, $46, $4C
	dc.w 5, $2E, $54
	dc.w 5, $3A, $64
	dc.w 1, $46, $74
	dc.w $2005, $12, $FFF8
	dc.w $2005, 4, 8
	dc.w $2005, $12, $18
	dc.w $2005, 4, $28

.presentedby:	dc.w $F
	dc.w $F805, $12, $FF80
	dc.w $F805, $22, $FF90
	dc.w $F805, $E, $FFA0
	dc.w $F805, $2E, $FFB0
	dc.w $F805, $E, $FFC0
	dc.w $F805, $1A, $FFD0
	dc.w $F805, $3E, $FFE0
	dc.w $F805, $E, $FFF0
	dc.w $F805, $42, 0
	dc.w $F805, $48, $18
	dc.w $F805, $2A, $28
	dc.w $F805, $2E, $40
	dc.w $F805, $E, $50
	dc.w $F805, 0, $60
	dc.w $F805, 4, $70

.tryagain:	dc.w 8
	dc.w $3005, $3E, $FFC0
	dc.w $3005, $22, $FFD0
	dc.w $3005, $2A, $FFE0
	dc.w $3005, 4, $FFF8
	dc.w $3005, 0, 8
	dc.w $3005, 4, $18
	dc.w $3001, $46, $28
	dc.w $3005, $1A, $30

.sonicteam:	dc.w $11
	dc.w $E805, $2E, $FFB4
	dc.w $E805, $26, $FFC4
	dc.w $E805, $1A, $FFD4
	dc.w $E801, $46, $FFE4
	dc.w $E805, $1E, $FFEC
	dc.w $E805, $3E, 4
	dc.w $E805, $E, $14
	dc.w $E805, 4, $24
	dc.w $E809, 8, $34
	dc.w 5, $12, $FFC0
	dc.w 5, $22, $FFD0
	dc.w 5, $E, $FFE0
	dc.w 5, $2E, $FFF0
	dc.w 5, $E, 0
	dc.w 5, $1A, $10
	dc.w 5, $3E, $20
	dc.w 5, $2E, $30

	even
