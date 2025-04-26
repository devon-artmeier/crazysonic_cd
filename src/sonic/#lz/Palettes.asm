; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro paladdress,ramaddress,colours
	dc.l paladdress
	dc.w ramaddress, (colours>>1)-1
	endm

PalPointers:

; palette address, RAM address, colours

ptr_Pal_Sonic:		palp	Pal_Sonic,v_pal_dry,$10		; 3 - Sonic
ptr_Pal_LZ:		palp	Pal_LZ,v_pal_dry+$20,$30	; 4 - LZ
ptr_Pal_LZWater:	palp	Pal_LZWater,v_pal_dry,$40	; $B (11) - LZ underwater
ptr_Pal_SBZ3:		palp	Pal_SBZ3,v_pal_dry+$20,$30	; $C (12) - SBZ3
ptr_Pal_SBZ3Water:	palp	Pal_SBZ3Water,v_pal_dry,$40	; $D (13) - SBZ3 underwater
ptr_Pal_LZSonWater:	palp	Pal_LZSonWater,v_pal_dry,$10	; $F (15) - LZ Sonic underwater
ptr_Pal_SBZ3SonWat:	palp	Pal_SBZ3SonWat,v_pal_dry,$10	; $10 (16) - SBZ3 Sonic underwater
			even

palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_Level:		equ (ptr_Pal_LZ-PalPointers)/8
palid_LZSonWater:	equ (ptr_Pal_LZSonWater-PalPointers)/8
palid_SBZ3SonWat:	equ (ptr_Pal_SBZ3SonWat-PalPointers)/8
palid_LZWater:		equ (ptr_Pal_LZWater-PalPointers)/8
palid_SBZ3Water:	equ (ptr_Pal_SBZ3Water-PalPointers)/8
palid_SBZ2:		equ (ptr_Pal_LZ-PalPointers)/8
palid_SBZ3:		equ (ptr_Pal_SBZ3-PalPointers)/8

Pal_Sonic:	incbin	"src/sonic/palette/Sonic.bin"
Pal_LZ:		incbin	"src/sonic/palette/Labyrinth Zone.bin"
Pal_LZWater:	incbin	"src/sonic/palette/Labyrinth Zone Underwater.bin"
Pal_SBZ3:	incbin	"src/sonic/palette/SBZ Act 3.bin"
Pal_SBZ3Water:	incbin	"src/sonic/palette/SBZ Act 3 Underwater.bin"
Pal_LZSonWater:	incbin	"src/sonic/palette/Sonic - LZ Underwater.bin"
Pal_SBZ3SonWat:	incbin	"src/sonic/palette/Sonic - SBZ3 Underwater.bin"
