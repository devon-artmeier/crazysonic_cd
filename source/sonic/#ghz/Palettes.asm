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
ptr_Pal_GHZ:		palp	Pal_GHZ,v_pal_dry+$20,$30			; 4 - GHZ
			even


palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_Level:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZSonWater:	equ (ptr_Pal_Sonic-PalPointers)/8
palid_SBZ3SonWat:	equ (ptr_Pal_Sonic-PalPointers)/8
palid_LZWater:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_SBZ3Water:	equ (ptr_Pal_GHZ-PalPointers)/8
palid_SBZ2:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_SBZ3:		equ (ptr_Pal_GHZ-PalPointers)/8

Pal_Sonic:	incbin	"source/sonic/palette/Sonic.bin"
Pal_GHZ:	incbin	"source/sonic/palette/Green Hill Zone.bin"
