Map_EEgg_internal:
	dc.w	M_EEgg_Try1-Map_EEgg_internal
	dc.w	M_EEgg_Try2-Map_EEgg_internal
	dc.w	M_EEgg_Try3-Map_EEgg_internal
	dc.w	M_EEgg_Try4-Map_EEgg_internal
	dc.w	M_EEgg_End1-Map_EEgg_internal
	dc.w	M_EEgg_End2-Map_EEgg_internal
	dc.w	M_EEgg_End3-Map_EEgg_internal
	dc.w	M_EEgg_End4-Map_EEgg_internal

M_EEgg_Try1:	dc.w 8
	dc.w $E905, 0, $FFF0
	dc.w $F90C, 4, $FFE0
	dc.w $E904, 8, 0
	dc.w $F10D, $A, 0
	dc.w $106, $23, $FFF0
	dc.w $106, $823, 0
	dc.w $1804, $29, $FFEC
	dc.w $1804, $829, 4

M_EEgg_Try2:	dc.w 8
	dc.w $E80D, $12, $FFE0
	dc.w $F808, $1A, $FFE8
	dc.w $E805, $800, 0
	dc.w $F80C, $804, 0
	dc.w 6, $1D, $FFF0
	dc.w 6, $81D, 0
	dc.w $1804, $29, $FFEC
	dc.w $1804, $829, 4

M_EEgg_Try3:	dc.w 8
	dc.w $E904, $808, $FFF0
	dc.w $F10D, $80A, $FFE0
	dc.w $E905, $800, 0
	dc.w $F90C, $804, 0
	dc.w $106, $23, $FFF0
	dc.w $106, $823, 0
	dc.w $1804, $29, $FFEC
	dc.w $1804, $829, 4

M_EEgg_Try4:	dc.w 8
	dc.w $E805, 0, $FFF0
	dc.w $F80C, 4, $FFE0
	dc.w $E80D, $812, 0
	dc.w $F808, $81A, 0
	dc.w 6, $1D, $FFF0
	dc.w 6, $81D, 0
	dc.w $1804, $29, $FFEC
	dc.w $1804, $829, 4

M_EEgg_End1:	dc.w $C
	dc.w $ED0A, $2B, $FFE8
	dc.w $F500, $34, $FFE0
	dc.w $504, $35, $FFF0
	dc.w $D08, $37, $FFE8
	dc.w $ED0A, $82B, 0
	dc.w $F500, $834, $18
	dc.w $504, $835, 0
	dc.w $D08, $837, 0
	dc.w $100D, $73, $FFE0
	dc.w $100D, $7B, 0
	dc.w $1C0C, $5B, $FFE0
	dc.w $1C0C, $85B, 0

M_EEgg_End2:	dc.w $A
	dc.w $D207, $3A, $FFF0
	dc.w $DA00, $42, $FFE8
	dc.w $F207, $43, $FFF0
	dc.w $D207, $83A, 0
	dc.w $DA00, $842, $10
	dc.w $F207, $843, 0
	dc.w $100D, $67, $FFE8
	dc.w $1005, $6F, 8
	dc.w $1C0C, $5F, $FFE0
	dc.w $1C0C, $85F, 0

M_EEgg_End3:	dc.w $A
	dc.w $C40B, $4B, $FFE8
	dc.w $E408, $57, $FFE8
	dc.w $EC00, $5A, $FFF0
	dc.w $C40B, $84B, 0
	dc.w $E408, $857, 0
	dc.w $EC00, $85A, 8
	dc.w $100D, $67, $FFE8
	dc.w $1005, $6F, 8
	dc.w $1C0C, $63, $FFE0
	dc.w $1C0C, $863, 0

M_EEgg_End4:	dc.w $C
	dc.w $F40A, $2B, $FFE8
	dc.w $FC00, $34, $FFE0
	dc.w $C04, $35, $FFF0
	dc.w $1408, $37, $FFE8
	dc.w $F40A, $82B, 0
	dc.w $FC00, $834, $18
	dc.w $C04, $835, 0
	dc.w $1408, $837, 0
	dc.w $180C, $83, $FFE0
	dc.w $180C, $87, 0
	dc.w $1C0C, $5B, $FFE0
	dc.w $1C0C, $85B, 0

	even
