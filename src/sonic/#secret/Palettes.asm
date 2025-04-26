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
ptr_Pal_Secret:		palp	Pal_Secret,v_pal_dry+$20,$30	; 4 - Secret
			even


palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_Level:		equ (ptr_Pal_Secret-PalPointers)/8
palid_LZSonWater:	equ (ptr_Pal_Sonic-PalPointers)/8
palid_SBZ3SonWat:	equ (ptr_Pal_Sonic-PalPointers)/8
palid_LZWater:		equ (ptr_Pal_Secret-PalPointers)/8
palid_SBZ3Water:	equ (ptr_Pal_Secret-PalPointers)/8
palid_SBZ2:		equ (ptr_Pal_Secret-PalPointers)/8
palid_SBZ3:		equ (ptr_Pal_Secret-PalPointers)/8

Pal_Sonic:	incbin	"src/sonic/palette/Sonic.bin"
Pal_Secret:	incbin	"src/sonic/palette/Secret Zone.bin"
