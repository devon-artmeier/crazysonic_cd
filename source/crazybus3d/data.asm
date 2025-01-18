; -------------------------------------------------------------------------
; CrazyBus 3D data
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	org	WORD_START

; -------------------------------------------------------------------------

	include	"source/crazybus/title_data.asm"

Pal_CrazyBus3D:
	incbin	"source/crazybus3d/data/palette.bin"
	incbin	"source/crazybus3d/data/bus_palette.bin"
	incbin	"source/crazybus3d/data/bg_palette.bin"
	incbin	"source/crazybus/data/palette.bin",0,2
	dc.w	$00E
	incbin	"source/crazybus/data/palette.bin",4,$1C
	even
Art_Graphics:
	incbin	"source/crazybus3d/data/graphics.nem"
	even
Map_Clouds:
	incbin	"source/crazybus3d/data/clouds_map.eni"
	even

; -------------------------------------------------------------------------
