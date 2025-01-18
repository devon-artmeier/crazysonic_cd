; -------------------------------------------------------------------------
; Image gallery
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"

	org	WORD_START

; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

	move	#$2700,sr					; Set V-INT
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr

; -------------------------------------------------------------------------

.Loop:
	lea	Images(pc),a0
	lea	imageOffset(pc),a1
	adda.w	(a1),a0
	cmpi.w	#ImagesEnd-Images,(a1)
	bcs.s	.Draw

	jsr	StopCDDA
	move.b	#id_Title,v_gamemode.w
	jmp	VDPSetupGame
	
.Draw:
	addi.w	#4*3,(a1)

	move.l	(a0)+,-(sp)
	move.l	(a0)+,-(sp)
	move.l	(a0)+,-(sp)

	lea	VDP_DATA,a5
	lea	VDP_CTRL,a6
	
	moveq	#0,d0
	move.w	#$100,d1

	move.l	(sp)+,a0
	move.w	#$8000,d2
	moveq	#$12-1,d3

.WriteVDP:
	move.b	(a0)+,d2
	move.w	d2,(a6)
	add.w	d1,d2
	dbf	d3,.WriteVDP

	VDP_CMD move.l,0,VSRAM,WRITE,(a6)
	moveq	#$50/4-1,d2

.ClearVSRAM:
	move.l	d0,(a5)
	dbf	d2,.ClearVSRAM

	movea.l	(sp)+,a0
	VDP_CMD move.l,0,CRAM,WRITE,(a6)
	moveq	#(($80/$04)/$04)-1,d3

.WritePalette:
	move.l	(a0)+,(a5)
	move.l	(a0)+,(a5)
	move.l	(a0)+,(a5)
	move.l	(a0)+,(a5)
	dbf	d3,.WritePalette

	movea.l	(sp)+,a0
	VDP_CMD move.l,0,VRAM,WRITE,(a6)
	jsr	NemDec

	move.w	#$8174,(a6)
	if REGION<>EUROPE
		move.w	#60*7,imageTimer
	else
		move.w	#50*7,imageTimer
	endif

	cmpi.w	#4*3,imageOffset
	bne.s	.Delay
	moveq	#22,d0
	jsr	LoopCDDA

; -------------------------------------------------------------------------

.Delay:
	st	v_vbla_routine.w
	jsr	WaitForVBla
	subq.w	#1,imageTimer
	bne.s	.Delay

	move.w	#$8134,(a6)
	bra.w	.Loop
	
; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

imageOffset:
	dc.w	0
imageTimer:
	dc.w	0

; -------------------------------------------------------------------------
; Images
; -------------------------------------------------------------------------

Images:
	dc.l	Art_Image1, Pal_Image1, VDP_Image1
	dc.l	Art_Image2, Pal_Image2, VDP_Image2
	dc.l	Art_Image3, Pal_Image3, VDP_Image3
	dc.l	Art_Image4, Pal_Image4, VDP_Image4
	dc.l	Art_Image5, Pal_Image5, VDP_Image5
	dc.l	Art_Image6, Pal_Image6, VDP_Image6
	dc.l	Art_Image7, Pal_Image7, VDP_Image7
	dc.l	Art_Image8, Pal_Image8, VDP_Image8
	dc.l	Art_Image9, Pal_Image9, VDP_Image9
	dc.l	Art_Image10, Pal_Image10, VDP_Image10
	dc.l	Art_Image11, Pal_Image11, VDP_Image11
ImagesEnd:

; -------------------------------------------------------------------------

Art_Image1:
	incbin	"source/meme/bussy/VRAM.nem"
	even
Pal_Image1:
	incbin	"source/meme/bussy/CRAM.bin"
	even
VDP_Image1:
	incbin	"source/meme/bussy/VDP.bin"
	even

Art_Image2:
	incbin	"source/meme/johnny/VRAM.nem"
	even
Pal_Image2:
	incbin	"source/meme/johnny/CRAM.bin"
	even
VDP_Image2:
	incbin	"source/meme/johnny/VDP.bin"
	even

Art_Image3:
	incbin	"source/meme/bussprite/VRAM.nem"
	even
Pal_Image3:
	incbin	"source/meme/bussprite/CRAM.bin"
	even
VDP_Image3:
	incbin	"source/meme/bussprite/VDP.bin"
	even

Art_Image4:
	incbin	"source/meme/gf/VRAM.nem"
	even
Pal_Image4:
	incbin	"source/meme/gf/CRAM.bin"
	even
VDP_Image4:
	incbin	"source/meme/gf/VDP.bin"
	even

Art_Image5:
	incbin	"source/meme/shawsh/VRAM.nem"
	even
Pal_Image5:
	incbin	"source/meme/shawsh/CRAM.bin"
	even
VDP_Image5:
	incbin	"source/meme/shawsh/VDP.bin"
	even

Art_Image6:
	incbin	"source/meme/linux/VRAM.nem"
	even
Pal_Image6:
	incbin	"source/meme/linux/CRAM.bin"
	even
VDP_Image6:
	incbin	"source/meme/linux/VDP.bin"
	even

Art_Image7:
	incbin	"source/meme/men/VRAM.nem"
	even
Pal_Image7:
	incbin	"source/meme/men/CRAM.bin"
	even
VDP_Image7:
	incbin	"source/meme/men/VDP.bin"
	even

Art_Image8:
	incbin	"source/meme/evil/VRAM.nem"
	even
Pal_Image8:
	incbin	"source/meme/evil/CRAM.bin"
	even
VDP_Image8:
	incbin	"source/meme/evil/VDP.bin"
	even

Art_Image9:
	incbin	"source/meme/milhoos/VRAM.nem"
	even
Pal_Image9:
	incbin	"source/meme/milhoos/CRAM.bin"
	even
VDP_Image9:
	incbin	"source/meme/milhoos/VDP.bin"
	even

Art_Image10:
	incbin	"source/meme/busahegao/VRAM.nem"
	even
Pal_Image10:
	incbin	"source/meme/busahegao/CRAM.bin"
	even
VDP_Image10:
	incbin	"source/meme/busahegao/VDP.bin"
	even

Art_Image11:
	incbin	"source/meme/garfield/VRAM.nem"
	even
Pal_Image11:
	incbin	"source/meme/garfield/CRAM.bin"
	even
VDP_Image11:
	incbin	"source/meme/garfield/VDP.bin"
	even

; -------------------------------------------------------------------------
