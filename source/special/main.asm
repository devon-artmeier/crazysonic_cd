; -------------------------------------------------------------------------
; Special stage (Main CPU)
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"
	include	"source/special/data_labels.inc"
	include	"source/special/map.inc"

	org	RAMProgram
	
; -------------------------------------------------------------------------

	rsset	WORD_START+$1C000
	include	"source/special/shared.inc"
	
; -------------------------------------------------------------------------

IMG_SRC_1	EQU	gfxBuffer
IMG_SRC_2	EQU	gfxBuffer+IMG_COPY_1
IMG_SRC_3	EQU	IMG_SRC_2+IMG_COPY_2
	
; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

SpecialStage:
	bsr.w	ClearScreen					; Clear screen

	lea	VDP_CTRL,a0					; Set VDP registers

.WaitVBlank:
	move	(a0),ccr
	bpl.s	.WaitVBlank
	move.w	#$8134,(a0)
	move.w	#$8720,(a0)
	move.w	#$8B03,(a0)
	move.w	#$8C00,(a0)
	
	move.w	#$8F01,(a0)					; Clear VRAM
	VRAM_FILL 0,0,$10000,(a0),-4(a0)
	move.w	#$8F02,(a0)

	lea	Pal_SpecialStage,a0				; Load palette
	lea	v_pal_dry_dup.w,a1
	move.w	#$80/4-1,d0

.LoadPalette:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPalette
	
	lea	Art_Graphics,a0					; Load general graphics
	VDP_CMD move.l,IMG_END,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	lea	Art_Arrow,a0					; Load arrow graphics
	VDP_CMD move.l,VRAM_ARROW,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	lea	Art_Arrow3D,a0					; Load destination arrow graphics
	VDP_CMD move.l,VRAM_ARROW_3D,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	lea	Map_Clouds,a0					; Decompress clouds mappings
	lea	gfxBuffer(pc),a1
	move.w	#$4000|(VRAM_CLOUDS/$20),d0
	bsr.w	EniDec
	
	VDP_CMD move.l,vram_bg,VRAM,WRITE,d0			; Load clouds mappings
	moveq	#$40-1,d1
	moveq	#$B-1,d2
	bsr.w	TilemapToVRAM
	
	lea	Map_Buildings,a0				; Decompress buildings mappings
	lea	gfxBuffer(pc),a1
	move.w	#$4000|(VRAM_BUILDINGS/$20),d0
	bsr.w	EniDec
	
	VDP_CMD move.l,vram_fg+$600,VRAM,WRITE,d0		; Load buildings mappings
	moveq	#$40-1,d1
	moveq	#5-1,d2
	bsr.w	TilemapToVRAM
	VDP_CMD move.l,vram_bg+$880,VRAM,WRITE,d0
	lea	gfxBuffer+$280(pc),a1
	moveq	#$40-1,d1
	moveq	#1-1,d2
	bsr.w	TilemapToVRAM

	VDP_CMD move.l,vram_bg+$600,VRAM,WRITE,VDP_CTRL		; Draw gradient
	moveq	#3-1,d1
	move.w	#$45BD,d3

.DrawGradient:
	moveq	#$40-1,d0

.DrawGradientTile:
	move.w	d3,VDP_DATA
	dbf	d0,.DrawGradientTile
	addq.w	#1,d3
	dbf	d1,.DrawGradient
	
	bsr.w	DrawStageTilemap				; Draw map tilemap
	
	lea	v_objspace.w,a1					; Clear objects
	moveq	#0,d0
	move.w	#$7FF,d1

.ClearObjects:
	move.l	d0,(a1)+
	dbf	d1,.ClearObjects
	
	moveq	#0,d0						; Reset communication commands
	move.l	d0,COMM_CMD_0
	move.l	d0,COMM_CMD_2
	move.l	d0,COMM_CMD_4
	move.l	d0,COMM_CMD_6

	move.b	v_emeralds.w,COMM_CMD_6				; Set stage ID
	
	GIVE_WORD_ACCESS					; Run Sub CPU module
	bsr.w	RunSubModule
	WAIT_WORD_ACCESS
	
	move	#$2700,sr					; Set up V-BLANK interrupt
	move.l	#SpecStageVInt,_LEVEL6+2.w

	bsr.w	RenderBuffer2					; Render first set of frames
	bsr.w	RenderBuffer1
	bsr.w	RenderBuffer2

	move.w	#$8174,VDP_CTRL					; Fade from white
	bsr.w	PaletteWhiteIn

; -------------------------------------------------------------------------

.MainLoop:
	bsr.w	RenderBuffer1					; Render
	bne.s	.GoToResults
	bsr.w	RenderBuffer2
	bne.s	.GoToResults

	bra.w	.MainLoop					; Loop

; -------------------------------------------------------------------------

.GoToResults:
	bsr.w	FinishSubCmd					; Tell Sub CPU to exit module

	bsr.w	StopCDDA					; Fade to white
	move.w	#sfx_EnterSS,d0
	bsr.w	PlaySound_Special
	bsr.w	PaletteWhiteOut
	
	move	#$2700,sr					; Go to results
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr
	bra.w	SpecStageResults
	
; -------------------------------------------------------------------------
; Render frame
; -------------------------------------------------------------------------

RenderBuffer1:
	move	#$2700,sr					; Start next update
	move.w	v_jpadhold1.w,COMM_CMD_7
	move.w	#256,bufferOffset
	move.l	#SSVInt_Buf11,vintRoutine
	move.w	#$2300,sr

	bsr.w	UpdateScroll					; Update scrolling
	bsr.w	DrawTimer					; Draw timer

	GIVE_WORD_ACCESS					; Render frame
	WAIT_WORD_ACCESS
	
.WaitRender:
	cmpi.l	#SSVInt_End,vintRoutine				; Wait for current render
	bne.s	.WaitRender
	
	bsr.w	CopyWordRAM					; Copy new render into RAM
	bra.s	CheckPause					; Check pause and game over

; -------------------------------------------------------------------------

RenderBuffer2:
	move	#$2700,sr					; Start next update
	move.w	v_jpadhold1.w,COMM_CMD_7
	clr.w	bufferOffset
	move.l	#SSVInt_Buf21,vintRoutine
	move.w	#$2300,sr

	bsr.w	UpdateScroll					; Update scrolling
	bsr.w	DrawTimer					; Draw timer
	
	GIVE_WORD_ACCESS					; Render frame
	WAIT_WORD_ACCESS

.WaitRender:
	cmpi.l	#SSVInt_End,vintRoutine				; Wait for current render
	bne.s	.WaitRender
	
	bsr.w	CopyWordRAM					; Copy new render into RAM
	
; -------------------------------------------------------------------------
; Check pause
; -------------------------------------------------------------------------

CheckPause:
	tst.b	v_jpadpress1.w
	bpl.s	CheckGameOver

	move.b	#1,COMM_CMD_4
	st	v_vbla_routine.w
	bsr.w	WaitForVBla

.Paused:
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	tst.b	v_jpadpress1.w
	bpl.s	.Paused

	move.b	#0,COMM_CMD_4

; -------------------------------------------------------------------------
; Check game over
; -------------------------------------------------------------------------

CheckGameOver:
	moveq	#0,d0
	move.b	gameOver(pc),d0
	beq.s	.End
	tst.b	gameOverTime
	beq.s	.DrawText
	subq.b	#1,gameOverTime
	bne.s	.End

	cmpi.b	#2,d0
	bne.s	.Exit
	
	addq.b	#1,v_emeralds.w

.Exit:
	moveq	#1,d0
	rts

.DrawText:
	move.b	#(90*FPS_DEST)/FPS_SRC,gameOverTime
	VDP_CMD move.l,$C20E,VRAM,WRITE,d1
	add.w	d0,d0
	add.w	d0,d0
	movea.l	.Text-4(pc,d0.w),a0

.Line:
	move.l	d1,VDP_CTRL

.Character:
	moveq	#0,d0
	move.b	(a0)+,d0
	beq.s	.End
	bmi.s	.NewLine
	cmpi.b	#' ',d0
	bne.s	.NotSpace
	move.w	#0,VDP_DATA
	bra.s	.Character

.NotSpace:
	addi.w	#$C000|((VRAM_FONT/$20)-'0'),d0
	move.w	d0,VDP_DATA
	bra.s	.Character

.NewLine:
	addi.l	#$1000000,d1
	bra.s	.Line

.End:
	moveq	#0,d0
	rts

; -------------------------------------------------------------------------

.Text:
	dc.l	.PersonHit
	dc.l	.Won
	dc.l	.TimesUp

.PersonHit:
	dc.b	"DONT RUN OVER YOUR", -1
	dc.b	"PASSENGERS< IDIOT:", 0
	even

.Won:
	dc.b	"  THAT WAS SOME  ", -1
	dc.b	" SERIOUS DRIVING;", 0
	even

.TimesUp:
	dc.b	"     TIMES UP", 0
	even

; -------------------------------------------------------------------------
; Copy Word RAM data
; -------------------------------------------------------------------------

CopyWordRAM:
	lea	sprites,a0
	lea	v_spritetablebuffer,a1
	moveq	#($200/$80)-1,d0
	
.CopySprites:
	rept	$80/4
		move.l	(a0)+,(a1)+
	endr
	dbf	d0,.CopySprites

	move.w	(a0)+,v_scrposx_dup.w
	move.w	(a0)+,timer
	move.b	(a0)+,gameOver

	lea	WORD_START+IMG_BUFFER,a0
	lea	gfxBuffer(pc),a1
	moveq	#(IMG_LENGTH/$80)-1,d0

.CopyMap:
	rept	$80/4
		move.l	(a0)+,(a1)+
	endr
	dbf	d0,.CopyMap
	rts
	
; -------------------------------------------------------------------------
; Draw timer
; -------------------------------------------------------------------------

DrawTimer:
	lea	VDP_DATA,a1
	lea	4(a1),a2

	VDP_CMD move.l,vram_fg+$186,VRAM,WRITE,(a2)
	lea	.Nums(pc),a0
	move.b	timer(pc),d0

.GetDigit:
	moveq	#0,d1
	move.b	(a0)+,d2
	beq.s	.End

.GetDigitLoop:
	sub.b	d2,d0
	bmi.s	.GotDigit
	addq.b	#1,d1
	bra.s	.GetDigitLoop

.GotDigit:
	add.b	d2,d0

	addi.w	#$C000|(VRAM_FONT/$20),d1
	move.w	d1,(a1)
	bra.s	.GetDigit

.End:
	rts
	
; -------------------------------------------------------------------------

.Nums:
	dc.b	10
	dc.b	1
	dc.b	0
	even

; -------------------------------------------------------------------------
; Draw stage tilemap
; -------------------------------------------------------------------------

DrawStageTilemap:
	move.w	#(IMG_VRAM_11/$20),d6				; Buffer 1 base tile ID

	lea	VDP_CTRL,a2					; VDP control port
	lea	VDP_DATA,a3					; VDP data port

	VDP_CMD	move.l,vram_fg+$880,VRAM,WRITE,d0		; Draw buffer 1 tilemap
	bsr.s	.DrawMap

	move.w	#(IMG_VRAM_21/$20),d6				; Draw buffer 2 tilemap
	VDP_CMD	move.l,vram_fg+$8C0,VRAM,WRITE,d0

; -------------------------------------------------------------------------

.DrawMap:
	move.l	#$800000,d4					; Row delta
	moveq	#IMG_TILES_Y-1,d2				; Height

.DrawRow:
	move.l	d0,(a2)						; Set VDP command
	moveq	#IMG_TILES_X-1,d3				; Get width
	move.w	d6,d5						; Get first column tile

.DrawTile:
	move.w	d5,(a3)						; Write tile ID
	addi.w	#IMG_TILES_Y,d5					; Next column tile
	dbf	d3,.DrawTile					; Loop until row is written
	
	add.l	d4,d0						; Next row
	addq.w	#1,d6						; Next column tile
	dbf	d2,.DrawRow					; Loop until map is drawn
	rts
	
; -------------------------------------------------------------------------
; Update scrolling
; -------------------------------------------------------------------------

UpdateScroll:
	lea	v_hscrolltablebuffer.w,a0
	move.w	bufferOffset(pc),d1
	
	lea	v_bgscroll_buffer.w,a1
	subi.l	#($E000*FPS_SRC)/FPS_DEST,(a1)
	subi.l	#($8000*FPS_SRC)/FPS_DEST,4(a1)
	
	move.w	#48-1,d0
	move.w	v_scrposx_dup.w,d2
	neg.w	d2
	move.w	(a1),d3
	moveq	#0,d4

.TopClouds:
	move.w	d4,(a0)+
	move.w	d3,(a0)
	add.w	d2,(a0)+
	dbf	d0,.TopClouds
	
	move.w	#40-1,d0
	move.w	4(a1),d3

.BtmClouds:
	move.w	d4,(a0)+
	move.w	d3,(a0)
	add.w	d2,(a0)+
	dbf	d0,.BtmClouds
	
	move.w	#48-1,d0

.BtmClouds2:
	move.w	d2,(a0)+
	move.w	d4,(a0)+
	dbf	d0,.BtmClouds2

	move.w	#IMG_HEIGHT-1,d0
	
.Stage:
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	dbf	d0,.Stage
	rts

; -------------------------------------------------------------------------
; Vertical blank interrupt
; -------------------------------------------------------------------------

SpecStageVInt:
	move	#$2700,sr					; Disable interrupts
	movem.l	d0-a6,-(sp)					; Save registers
	
	REQUEST_INT2						; Request Sub CPU interrupt
	clr.b	v_vbla_routine.w				; Clear VSync flag
	
	lea	VDP_CTRL,a0					; VDP control port
	move.w	(a0),d0
	
	STOP_Z80						; Run routine
	movea.l	vintRoutine,a1
	jsr	(a1)
	START_Z80
	
	bsr.w	UpdateSound					; Update sound driver
	
	movem.l	(sp)+,d0-a6					; Restore registers
	rte
	
; -------------------------------------------------------------------------

SSVInt_Buf11:
	DMA_68K v_pal_dry,0,$80,CRAM,(a0)
	DMA_68K v_spritetablebuffer,vram_sprites,$200,VRAM,(a0)
	DMA_68K v_hscrolltablebuffer,vram_hscroll,$380,VRAM,(a0)
	DMA_68K IMG_SRC_1,IMG_VRAM_11,IMG_COPY_1,VRAM,(a0)

	move.l	#SSVInt_Buf12,vintRoutine
	rts
	
; -------------------------------------------------------------------------

SSVInt_Buf12:
	DMA_68K IMG_SRC_2,IMG_VRAM_12,IMG_COPY_2,VRAM,(a0)

	move.l	#SSVInt_Buf13,vintRoutine
	rts
	
; -------------------------------------------------------------------------

SSVInt_Buf13:
	DMA_68K IMG_SRC_3,IMG_VRAM_13,IMG_COPY_3,VRAM,(a0)

	move.l	#SSVInt_End,vintRoutine
	bra.w	ReadJoypads
	
; -------------------------------------------------------------------------

SSVInt_Buf21:
	DMA_68K v_pal_dry,0,$80,CRAM,(a0)
	DMA_68K v_spritetablebuffer,vram_sprites,$200,VRAM,(a0)
	DMA_68K v_hscrolltablebuffer,vram_hscroll,$380,VRAM,(a0)
	DMA_68K IMG_SRC_1,IMG_VRAM_21,IMG_COPY_1,VRAM,(a0)

	move.l	#SSVInt_Buf22,vintRoutine
	rts
	
; -------------------------------------------------------------------------

SSVInt_Buf22:
	DMA_68K IMG_SRC_2,IMG_VRAM_22,IMG_COPY_2,VRAM,(a0)

	move.l	#SSVInt_Buf23,vintRoutine
	rts
	
; -------------------------------------------------------------------------

SSVInt_Buf23:
	DMA_68K IMG_SRC_3,IMG_VRAM_23,IMG_COPY_3,VRAM,(a0)

	move.l	#SSVInt_End,vintRoutine
	bra.w	ReadJoypads

; -------------------------------------------------------------------------

SSVInt_End:
	DMA_68K v_pal_dry,0,$80,CRAM,(a0)
	bra.w	ReadJoypads
	
; -------------------------------------------------------------------------

	include	"source/special/results.asm"
	
; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

vintRoutine:
	dc.l	SSVInt_End
bufferOffset:
	dc.w	0
timer:
	dc.w	0
gameOver:
	dc.b	0
gameOverTime:
	dc.b	0
gfxBuffer:

; -------------------------------------------------------------------------

	align	16

; -------------------------------------------------------------------------
