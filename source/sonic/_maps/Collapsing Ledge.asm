Map_Ledge_internal:
	dc.w	.left-Map_Ledge_internal
	dc.w	.right-Map_Ledge_internal
	dc.w	.leftsmash-Map_Ledge_internal
	dc.w	.rightsmash-Map_Ledge_internal

.left:	dc.w $10
	dc.w $C80E, $57, $10
	dc.w $D00D, $63, $FFF0
	dc.w $E00D, $6B, $10
	dc.w $E00D, $73, $FFF0
	dc.w $D806, $7B, $FFE0
	dc.w $D806, $81, $FFD0
	dc.w $F00D, $87, $10
	dc.w $F00D, $8F, $FFF0
	dc.w $F005, $97, $FFE0
	dc.w $F005, $9B, $FFD0
	dc.w $D, $9F, $10
	dc.w 5, $A7, 0
	dc.w $D, $AB, $FFE0
	dc.w 5, $B3, $FFD0
	dc.w $100D, $AB, $10
	dc.w $1005, $B7, 0

.right:	dc.w $10
	dc.w $C80E, $57, $10
	dc.w $D00D, $63, $FFF0
	dc.w $E00D, $6B, $10
	dc.w $E00D, $73, $FFF0
	dc.w $D806, $7B, $FFE0
	dc.w $D806, $BB, $FFD0
	dc.w $F00D, $87, $10
	dc.w $F00D, $8F, $FFF0
	dc.w $F005, $97, $FFE0
	dc.w $F005, $C1, $FFD0
	dc.w $D, $9F, $10
	dc.w 5, $A7, 0
	dc.w $D, $AB, $FFE0
	dc.w 5, $B7, $FFD0
	dc.w $100D, $AB, $10
	dc.w $1005, $B7, 0

.leftsmash:	dc.w $19
	dc.w $C806, $5D, $20
	dc.w $C806, $57, $10
	dc.w $D005, $67, 0
	dc.w $D005, $63, $FFF0
	dc.w $E005, $6F, $20
	dc.w $E005, $6B, $10
	dc.w $E005, $77, 0
	dc.w $E005, $73, $FFF0
	dc.w $D806, $7B, $FFE0
	dc.w $D806, $81, $FFD0
	dc.w $F005, $8B, $20
	dc.w $F005, $87, $10
	dc.w $F005, $93, 0
	dc.w $F005, $8F, $FFF0
	dc.w $F005, $97, $FFE0
	dc.w $F005, $9B, $FFD0
	dc.w 5, $8B, $20
	dc.w 5, $8B, $10
	dc.w 5, $A7, 0
	dc.w 5, $AB, $FFF0
	dc.w 5, $AB, $FFE0
	dc.w 5, $B3, $FFD0
	dc.w $1005, $AB, $20
	dc.w $1005, $AB, $10
	dc.w $1005, $B7, 0

.rightsmash:	dc.w $19
	dc.w $C806, $5D, $20
	dc.w $C806, $57, $10
	dc.w $D005, $67, 0
	dc.w $D005, $63, $FFF0
	dc.w $E005, $6F, $20
	dc.w $E005, $6B, $10
	dc.w $E005, $77, 0
	dc.w $E005, $73, $FFF0
	dc.w $D806, $7B, $FFE0
	dc.w $D806, $BB, $FFD0
	dc.w $F005, $8B, $20
	dc.w $F005, $87, $10
	dc.w $F005, $93, 0
	dc.w $F005, $8F, $FFF0
	dc.w $F005, $97, $FFE0
	dc.w $F005, $C1, $FFD0
	dc.w 5, $8B, $20
	dc.w 5, $8B, $10
	dc.w 5, $A7, 0
	dc.w 5, $AB, $FFF0
	dc.w 5, $AB, $FFE0
	dc.w 5, $B7, $FFD0
	dc.w $1005, $AB, $20
	dc.w $1005, $AB, $10
	dc.w $1005, $B7, 0

	even
