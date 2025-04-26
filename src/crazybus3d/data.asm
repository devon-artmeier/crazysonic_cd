; -------------------------------------------------------------------------
; CrazyBus 3D data
; -------------------------------------------------------------------------

	include	"src/include/main_cpu.inc"
	org	WORD_START

; -------------------------------------------------------------------------

	include	"src/crazybus/title_data.asm"

Pal_CrazyBus3D:
	incbin	"src/crazybus3d/data/palette.bin"
	incbin	"src/crazybus3d/data/bus_palette.bin"
	incbin	"src/crazybus3d/data/bg_palette.bin"
	incbin	"src/crazybus/data/palette.bin",0,2
	dc.w	$00E
	incbin	"src/crazybus/data/palette.bin",4,$1C
	even
Art_Graphics:
	incbin	"src/crazybus3d/data/graphics.nem"
	even
Map_Clouds:
	incbin	"src/crazybus3d/data/clouds_map.eni"
	even

; -------------------------------------------------------------------------
