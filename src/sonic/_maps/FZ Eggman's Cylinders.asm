Map_EggCyl_internal:
	dc.w	.flat-Map_EggCyl_internal
	dc.w	.extending1-Map_EggCyl_internal
	dc.w	.extending2-Map_EggCyl_internal
	dc.w	.extending3-Map_EggCyl_internal
	dc.w	.extending4-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.extendedfully-Map_EggCyl_internal
	dc.w	.controlpanel-Map_EggCyl_internal

.flat:	dc.w 6
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0

.extending1:	dc.w 8
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0
	dc.w $D80F, $4020, $FFE0
	dc.w $D80F, $4820, 0

.extending2:	dc.w $A
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0
	dc.w $D80F, $4020, $FFE0
	dc.w $D80F, $4820, 0
	dc.w $F80F, $4030, $FFE0
	dc.w $F80F, $4830, 0

.extending3:	dc.w $C
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0
	dc.w $D80F, $4020, $FFE0
	dc.w $D80F, $4820, 0
	dc.w $F80F, $4030, $FFE0
	dc.w $F80F, $4830, 0
	dc.w $180F, $4040, $FFE0
	dc.w $180F, $4840, 0

.extending4:	dc.w $D
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0
	dc.w $D80F, $4020, $FFE0
	dc.w $D80F, $4820, 0
	dc.w $F80F, $4030, $FFE0
	dc.w $F80F, $4830, 0
	dc.w $180F, $4040, $FFE0
	dc.w $180F, $4840, 0
	dc.w $380F, $4050, $FFF0

.extendedfully:	dc.w $E
	dc.w $A00D, $4000, $FFE0
	dc.w $A00D, $4800, 0
	dc.w $B00C, $2008, $FFE0
	dc.w $B00C, $200C, 0
	dc.w $B80F, $4010, $FFE0
	dc.w $B80F, $4810, 0
	dc.w $D80F, $4020, $FFE0
	dc.w $D80F, $4820, 0
	dc.w $F80F, $4030, $FFE0
	dc.w $F80F, $4830, 0
	dc.w $180F, $4040, $FFE0
	dc.w $180F, $4840, 0
	dc.w $380F, $4050, $FFF0
	dc.w $580F, $4050, $FFF0

.controlpanel:	dc.w 2
	dc.w $F804, $68, $FFF0
	dc.w $C, $6A, $FFF0

	even
