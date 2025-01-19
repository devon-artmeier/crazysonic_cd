; -------------------------------------------------------------------------
; Hong Kong 97 data
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	org	WORD_START

; -------------------------------------------------------------------------

Art_Title:
	incbin	"source/hk97/images/title_tiles.nem"
	even
Map_Title:
	incbin	"source/hk97/images/title_map.eni"
	even
Pal_Title:
	incbin	"source/hk97/images/title_pal.bin"
	even
	
Art_Cutscene1:
	incbin	"source/hk97/images/cutscene1_tiles.nem"
	even
Map_Cutscene1:
	incbin	"source/hk97/images/cutscene1_map.eni"
	even
Pal_Cutscene1:
	incbin	"source/hk97/images/cutscene1_pal.bin"
	even
	
Art_Cutscene2:
	incbin	"source/hk97/images/cutscene2_tiles.nem"
	even
Map_Cutscene2:
	incbin	"source/hk97/images/cutscene2_map.eni"
	even
Pal_Cutscene2:
	incbin	"source/hk97/images/cutscene2_pal.bin"
	even
	
Art_Cutscene3:
	incbin	"source/hk97/images/cutscene3_tiles.nem"
	even
Map_Cutscene3:
	incbin	"source/hk97/images/cutscene3_map.eni"
	even
Pal_Cutscene3:
	incbin	"source/hk97/images/cutscene3_pal.bin"
	even
	
Art_Cutscene4:
	incbin	"source/hk97/images/cutscene4_tiles.nem"
	even
Map_Cutscene4:
	incbin	"source/hk97/images/cutscene4_map.eni"
	even
Pal_Cutscene4:
	incbin	"source/hk97/images/cutscene4_pal.bin"
	even

Art_Graphics:
	incbin	"source/hk97/data/graphics.kos"
	even
Art_Background:
	incbin	"source/hk97/data/background.kos"
	even
Map_Border:
	incbin	"source/hk97/data/bordermap.eni"
	even
Pal_HK97:
	incbin	"source/hk97/data/palette.bin"
	even

; -------------------------------------------------------------------------