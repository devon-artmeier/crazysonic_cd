; -------------------------------------------------------------------------
; Special stage data
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	org	WORD_START

; -------------------------------------------------------------------------

Pal_SpecialStage:
	incbin	"source/special/data/palette.bin",0,$1A
	dc.w	$4E4, $2C4, $282
	incbin	"source/special/data/bus_palette.bin"
	incbin	"source/special/data/bg_palette.bin"
	incbin	"source/special/data/sprites_palette.bin"
	even
Art_Graphics:
	incbin	"source/special/data/graphics.nem"
	even
Art_Arrow:
	incbin	"source/special/data/arrow_art.nem"
	even
Art_Arrow3D:
	incbin	"source/special/data/arrow_3d_art.nem"
	even
Map_Clouds:
	incbin	"source/special/data/clouds_map.eni"
	even
Map_Buildings:
	incbin	"source/special/data/buildings_map.eni"
	even

; -------------------------------------------------------------------------
