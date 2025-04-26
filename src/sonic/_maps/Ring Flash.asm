Map_Flash_internal:
	dc.w	byte_A084-Map_Flash_internal
	dc.w	byte_A08F-Map_Flash_internal
	dc.w	byte_A0A4-Map_Flash_internal
	dc.w	byte_A0B9-Map_Flash_internal
	dc.w	byte_A0CE-Map_Flash_internal
	dc.w	byte_A0E3-Map_Flash_internal
	dc.w	byte_A0F8-Map_Flash_internal
	dc.w	byte_A103-Map_Flash_internal

byte_A084:	dc.w 2
	dc.w $E00F, 0, 0
	dc.w $F, $1000, 0

byte_A08F:	dc.w 4
	dc.w $E00F, $10, $FFF0
	dc.w $E007, $20, $10
	dc.w $F, $1010, $FFF0
	dc.w 7, $1020, $10

byte_A0A4:	dc.w 4
	dc.w $E00F, $28, $FFE8
	dc.w $E00B, $38, 8
	dc.w $F, $1028, $FFE8
	dc.w $B, $1038, 8

byte_A0B9:	dc.w 4
	dc.w $E00F, $834, $FFE0
	dc.w $E00F, $34, 0
	dc.w $F, $1834, $FFE0
	dc.w $F, $1034, 0

byte_A0CE:	dc.w 4
	dc.w $E00B, $838, $FFE0
	dc.w $E00F, $828, $FFF8
	dc.w $B, $1838, $FFE0
	dc.w $F, $1828, $FFF8

byte_A0E3:	dc.w 4
	dc.w $E007, $820, $FFE0
	dc.w $E00F, $810, $FFF0
	dc.w 7, $1820, $FFE0
	dc.w $F, $1810, $FFF0

byte_A0F8:	dc.w 2
	dc.w $E00F, $800, $FFE0
	dc.w $F, $1800, $FFE0

byte_A103:	dc.w 4
	dc.w $E00F, $44, $FFE0
	dc.w $E00F, $844, 0
	dc.w $F, $1044, $FFE0
	dc.w $F, $1844, 0

	even
