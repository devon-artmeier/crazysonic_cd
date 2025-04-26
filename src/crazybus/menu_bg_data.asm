; -------------------------------------------------------------------------
; Menu background data
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Load menu background
; -------------------------------------------------------------------------

LoadMenuBG:
	VDP_CMD move.l,$1800,VRAM,WRITE,VDP_CTRL		; Load background art
	lea	Art_MenuBG(pc),a0
	jsr	NemDec
	
	lea	Pal_MenuBG(pc),a0				; Load palette
	lea	v_pal_dry_dup.w,a1
	adda.w	d7,a1
	moveq	#(Pal_MenuBGEnd-Pal_MenuBG)/4-1,d0

.LoadPalette:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPalette
	
	lea	Map_MenuBG(pc),a0				; Load background map sections
	lea	decompBuffer,a1
	move.b	d7,-(sp)
	move.w	(sp)+,d0
	move.b	#$C0,d0
	jsr	EniDec
	
	VDP_CMD move.l,vram_bg,VRAM,WRITE,d0			; VRAM write command
	moveq	#4-1,d2						; Number of rows
	
.Row:
	move.l	d0,-(sp)					; Save write command
	moveq	#4-1,d1						; Sections per row

.Section:
	movem.l	d0-d2,-(sp)					; Draw section
	lea	decompBuffer,a1
	moveq	#10-1,d1
	moveq	#8-1,d2
	jsr	TilemapToVRAM
	movem.l	(sp)+,d0-d2
	
	addi.l	#$140000,d0					; Next section
	dbf	d1,.Section					; Loop until row is drawn
	
	move.l	(sp)+,d0					; Next row
	addi.l	#$4000000,d0
	dbf	d2,.Row						; Loop until background is drawn
	
	rts

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Art_MenuBG:
	incbin	"src/crazybus/data/menu_bg_art.nem"
	even
Map_MenuBG:
	incbin	"src/crazybus/data/menu_bg_map.eni"
	even
Pal_MenuBG:
	incbin	"src/crazybus/data/menu_palette.bin"
Pal_MenuBGEnd:
	even

; -------------------------------------------------------------------------
