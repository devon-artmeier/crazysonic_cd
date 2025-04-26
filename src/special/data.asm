; -------------------------------------------------------------------------
; Special stage data
; -------------------------------------------------------------------------

	include	"src/include/main_cpu.inc"
	org	WORD_START

; -------------------------------------------------------------------------

Pal_SpecialStage:
	incbin	"src/special/data/palette.bin",0,$1A
	dc.w	$4E4, $2C4, $282
	incbin	"src/special/data/bus_palette.bin"
	incbin	"src/special/data/bg_palette.bin"
	incbin	"src/special/data/sprites_palette.bin"
	even
Art_Graphics:
	incbin	"src/special/data/graphics.nem"
	even
Art_Arrow:
	incbin	"src/special/data/arrow_art.nem"
	even
Art_Arrow3D:
	incbin	"src/special/data/arrow_3d_art.nem"
	even
Map_Clouds:
	incbin	"src/special/data/clouds_map.eni"
	even
Map_Buildings:
	incbin	"src/special/data/buildings_map.eni"
	even

; -------------------------------------------------------------------------
