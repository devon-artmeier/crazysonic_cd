Map_Jun_internal:
	dc.w	.gap0-Map_Jun_internal
	dc.w	.gap1-Map_Jun_internal
	dc.w	.gap2-Map_Jun_internal
	dc.w	.gap3-Map_Jun_internal
	dc.w	.gap4-Map_Jun_internal
	dc.w	.gap5-Map_Jun_internal
	dc.w	.gap6-Map_Jun_internal
	dc.w	.gap7-Map_Jun_internal
	dc.w	.gap8-Map_Jun_internal
	dc.w	.gap9-Map_Jun_internal
	dc.w	.gapA-Map_Jun_internal
	dc.w	.gapB-Map_Jun_internal
	dc.w	.gapC-Map_Jun_internal
	dc.w	.gapD-Map_Jun_internal
	dc.w	.gapE-Map_Jun_internal
	dc.w	.gapF-Map_Jun_internal
	dc.w	.circle-Map_Jun_internal

.gap0:	dc.w 6
	dc.w $E805, $22, $FFD0
	dc.w $805, $1022, $FFD0
	dc.w $E80A, 0, $FFC8
	dc.w $E80A, $800, $FFE0
	dc.w $A, $1000, $FFC8
	dc.w $A, $1800, $FFE0

.gap1:	dc.w 6
	dc.w $F803, $26, $FFD0
	dc.w $1805, $2A, $FFD8
	dc.w $F60A, 0, $FFCA
	dc.w $F60A, $800, $FFE2
	dc.w $E0A, $1000, $FFCA
	dc.w $E0A, $1800, $FFE2

.gap2:	dc.w 6
	dc.w 6, $2E, $FFD0
	dc.w $2009, $34, $FFE8
	dc.w $A, 0, $FFD0
	dc.w $A, $800, $FFE8
	dc.w $180A, $1000, $FFD0
	dc.w $180A, $1800, $FFE8

.gap3:	dc.w 6
	dc.w $807, $3A, $FFD8
	dc.w $2808, $42, $FFF0
	dc.w $60A, 0, $FFDA
	dc.w $60A, $800, $FFF2
	dc.w $1E0A, $1000, $FFDA
	dc.w $1E0A, $1800, $FFF2

.gap4:	dc.w 6
	dc.w $2005, $45, $FFE8
	dc.w $2005, $845, 8
	dc.w $80A, 0, $FFE8
	dc.w $80A, $800, 0
	dc.w $200A, $1000, $FFE8
	dc.w $200A, $1800, 0

.gap5:	dc.w 6
	dc.w $2808, $842, $FFF8
	dc.w $807, $83A, $18
	dc.w $60A, 0, $FFF6
	dc.w $60A, $800, $E
	dc.w $1E0A, $1000, $FFF6
	dc.w $1E0A, $1800, $E

.gap6:	dc.w 6
	dc.w $2009, $834, 0
	dc.w 6, $82E, $20
	dc.w $A, 0, 0
	dc.w $A, $800, $18
	dc.w $180A, $1000, 0
	dc.w $180A, $1800, $18

.gap7:	dc.w 6
	dc.w $1805, $82A, $18
	dc.w $F803, $826, $28
	dc.w $F60A, 0, 6
	dc.w $F60A, $800, $1E
	dc.w $E0A, $1000, 6
	dc.w $E0A, $1800, $1E

.gap8:	dc.w 6
	dc.w $E805, $822, $20
	dc.w $805, $1822, $20
	dc.w $E80A, 0, 8
	dc.w $E80A, $800, $20
	dc.w $A, $1000, 8
	dc.w $A, $1800, $20

.gap9:	dc.w 6
	dc.w $D805, $182A, $18
	dc.w $E803, $1826, $28
	dc.w $DA0A, 0, 6
	dc.w $DA0A, $800, $1E
	dc.w $F20A, $1000, 6
	dc.w $F20A, $1800, $1E

.gapA:	dc.w 6
	dc.w $D009, $1834, 0
	dc.w $E806, $182E, $20
	dc.w $D00A, 0, 0
	dc.w $D00A, $800, $18
	dc.w $E80A, $1000, 0
	dc.w $E80A, $1800, $18

.gapB:	dc.w 6
	dc.w $D008, $1842, $FFF8
	dc.w $D807, $183A, $18
	dc.w $CA0A, 0, $FFF6
	dc.w $CA0A, $800, $E
	dc.w $E20A, $1000, $FFF6
	dc.w $E20A, $1800, $E

.gapC:	dc.w 6
	dc.w $D005, $1045, $FFE8
	dc.w $D005, $1845, 8
	dc.w $C80A, 0, $FFE8
	dc.w $C80A, $800, 0
	dc.w $E00A, $1000, $FFE8
	dc.w $E00A, $1800, 0

.gapD:	dc.w 6
	dc.w $D807, $103A, $FFD8
	dc.w $D008, $1042, $FFF0
	dc.w $CA0A, 0, $FFDA
	dc.w $CA0A, $800, $FFF2
	dc.w $E20A, $1000, $FFDA
	dc.w $E20A, $1800, $FFF2

.gapE:	dc.w 6
	dc.w $E806, $102E, $FFD0
	dc.w $D009, $1034, $FFE8
	dc.w $D00A, 0, $FFD0
	dc.w $D00A, $800, $FFE8
	dc.w $E80A, $1000, $FFD0
	dc.w $E80A, $1800, $FFE8

.gapF:	dc.w 6
	dc.w $E803, $1026, $FFD0
	dc.w $D805, $102A, $FFD8
	dc.w $DA0A, 0, $FFCA
	dc.w $DA0A, $800, $FFE2
	dc.w $F20A, $1000, $FFCA
	dc.w $F20A, $1800, $FFE2

.circle:	dc.w $C
	dc.w $C80D, 9, $FFE0
	dc.w $D00A, $11, $FFD0
	dc.w $E007, $1A, $FFC8
	dc.w $C80D, $809, 0
	dc.w $D00A, $811, $18
	dc.w $E007, $81A, $28
	dc.w 7, $101A, $FFC8
	dc.w $180A, $1011, $FFD0
	dc.w $280D, $1009, $FFE0
	dc.w $280D, $1809, 0
	dc.w $180A, $1811, $18
	dc.w 7, $181A, $28

	even
