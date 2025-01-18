; -------------------------------------------------------------------------
; Text
; -------------------------------------------------------------------------

Txt_PressStart:
	dc.b	"Press ", 4, "!", 0
	even
Txt_PressStartBlank:
	dc.b	"           ", 0
	even
Txt_CoverBus1:
	dc.b	"   Cover bus: Busscar Panoramico DD  ", 0
	even
Txt_CoverBus2:
	dc.b	"    Cover bus: Irizar Century 3.95   ", 0
	even
Txt_CoverBus3:
	dc.b	"  Cover bus:  Marcopolo Andare Class ", 0
	even
Txt_CoverBus4:
	dc.b	" Cover bus: Marcopolo Paradiso GV1450", 0
	even
Txt_CoverBus5:
	dc.b	"   Cover bus: Busscar Panoramico DD  ", 0
	even
Txt_CoverBus6:
	dc.b	" Cover bus: Marcopolo Paradiso 1800DD", 0
	even
Txt_HackTitle:
	dc.b	"Super Ultra Cool Bodacious Radical", -1
	dc.b	"  Mega CD Remastered Edition!!!", -1, -1, -1, -1, -1, -1
	dc.b	"CrazyBus (C)2004-2010 Tom Scripts", -1
	dc.b	" Sonic The Hedgehog (C)1991 SEGA", -1
	dc.b	"  Hack by Ralakimus 2015, 2023", 0
	even

; -------------------------------------------------------------------------
; Title data
; -------------------------------------------------------------------------

Art_HackLogo:
	incbin	"source/crazybus/data/hack_logo_art.nem"
	even
Map_HackLogo:
	incbin	"source/crazybus/data/hack_logo_map.eni"
	even
Pal_HackLogo:
	incbin	"source/crazybus/data/hack_logo_pal.bin"
	even

Art_CoverBus1:
	incbin	"source/crazybus/data/cover_art_1.nem"
	even
Art_CoverBus2:
	incbin	"source/crazybus/data/cover_art_2.nem"
	even
Art_CoverBus3:
	incbin	"source/crazybus/data/cover_art_3.nem"
	even
Art_CoverBus4:
	incbin	"source/crazybus/data/cover_art_4.nem"
	even
Art_CoverBus5:
	incbin	"source/crazybus/data/cover_art_5.nem"
	even
Art_CoverBus6:
	incbin	"source/crazybus/data/cover_art_6.nem"
	even

Map_CoverBus1:
	incbin	"source/crazybus/data/cover_map_1.eni"
	even
Map_CoverBus2:
	incbin	"source/crazybus/data/cover_map_2.eni"
	even
Map_CoverBus3:
	incbin	"source/crazybus/data/cover_map_3.eni"
	even
Map_CoverBus4:
	incbin	"source/crazybus/data/cover_map_4.eni"
	even
Map_CoverBus5:
	incbin	"source/crazybus/data/cover_map_5.eni"
	even
Map_CoverBus6:
	incbin	"source/crazybus/data/cover_map_6.eni"
	even

Pal_CoverBus1:
	incbin	"source/crazybus/data/cover_pal_1.bin"
	even
Pal_CoverBus2:
	incbin	"source/crazybus/data/cover_pal_2.bin"
	even
Pal_CoverBus3:
	incbin	"source/crazybus/data/cover_pal_3.bin"
	even
Pal_CoverBus4:
	incbin	"source/crazybus/data/cover_pal_4.bin"
	even
Pal_CoverBus5:
	incbin	"source/crazybus/data/cover_pal_5.bin"
	even
Pal_CoverBus6:
	incbin	"source/crazybus/data/cover_pal_6.bin"
	even

; -------------------------------------------------------------------------
