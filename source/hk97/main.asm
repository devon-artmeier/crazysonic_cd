; -------------------------------------------------------------------------
; Hong Kong 97
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"
	include	"source/hk97/data_labels.inc"
	include	"source/hk97/field.inc"

	org	RAMProgram
	
; -------------------------------------------------------------------------

IMG_COPY_1	EQU	IMG_LENGTH/2
IMG_COPY_2	EQU	IMG_LENGTH/2

IMG_SRC_1	EQU	IMAGE_START
IMG_SRC_2	EQU	IMG_SRC_1+IMG_COPY_1

IMG_VRAM_11	EQU	0
IMG_VRAM_12	EQU	IMG_VRAM_11+(IMG_LENGTH/2)
IMG_VRAM_21	EQU	IMG_VRAM_11+IMG_LENGTH
IMG_VRAM_22	EQU	IMG_VRAM_21+(IMG_LENGTH/2)
IMG_END		EQU	IMG_VRAM_22+IMG_LENGTH
	
; -------------------------------------------------------------------------
; Shared memory
; -------------------------------------------------------------------------

	rsset	WORD_START+$10000
	include	"source/hk97/shared.inc"

; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

HongKong97:
	move	#$2700,sr					; Set up interrupts

	clr.l	v_cheatbutton.w					; Reset skip cheat

	bsr.w	ClearScreen					; Clear screen
	bsr.w	InitDMAQueue					; Initialize DMA queue

	lea	VDP_CTRL,a0					; Set up VDP registers
	move.w	#$8134,(a0)
	move.w	#$8200|($C000/$400),(a0)
	move.w	#$8400|($A000/$2000),(a0)
	move.w	#$8700,(a0)
	move.w	#$8B00,(a0)
	move.w	#$9011,(a0)

	move.w	#$8F01,(a0)					; Clear VRAM
	VRAM_FILL 0,0,$10000,(a0),-4(a0)
	move.w	#$8F02,(a0)

; -------------------------------------------------------------------------

	moveq	#5,d0						; Play title music
	bsr.w	LoopCDDA

	lea	Art_Title,a0					; Title screen
	lea	Map_Title,a1
	lea	Pal_Title,a2
	bsr.w	DrawImage

	lea	Art_Cutscene1,a0				; Cutscene 1
	lea	Map_Cutscene1,a1
	lea	Pal_Cutscene1,a2
	bsr.w	DrawImage

	lea	Art_Cutscene2,a0				; Cutscene 1
	lea	Map_Cutscene2,a1
	lea	Pal_Cutscene2,a2
	bsr.w	DrawImage

	lea	Art_Cutscene3,a0				; Cutscene 1
	lea	Map_Cutscene3,a1
	lea	Pal_Cutscene3,a2
	bsr.w	DrawImage

	lea	Art_Cutscene4,a0				; Cutscene 1
	lea	Map_Cutscene4,a1
	lea	Pal_Cutscene4,a2
	bsr.w	DrawImage
	
	bsr.w	PaletteFadeOut					; Fade to black
	move	#$2700,sr
	
	bsr.w	ClearScreen					; Clear screen
	bsr.w	StopCDDA					; Stop music
	
	lea	Art_Graphics,a0					; Load main graphics
	VDP_CMD move.l,$DE80,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	lea	Art_Background,a0				; Load main background
	VDP_CMD move.l,$A000,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	lea	Map_Border,a0					; Decompress border tilemap
	lea	mapBuffer(pc),a1
	move.w	#$8000|($DE80/$20),d0
	bsr.w	EniDec
	
	lea	mapBuffer(pc),a1				; Draw border tilemap
	VDP_CMD move.l,$C000,VRAM,WRITE,d0
	moveq	#$28-1,d1
	moveq	#$1C-1,d2
	bsr.w	TilemapToVRAM
	lea	mapBuffer(pc),a1
	VDP_CMD move.l,$D000,VRAM,WRITE,d0
	moveq	#$28-1,d1
	moveq	#$1C-1,d2
	bsr.w	TilemapToVRAM
	
	lea	Pal_HK97,a0					; Load palette
	lea	v_pal_dry_dup.w,a1
	moveq	#$80/4-1,d0

.LoadPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPal
	
	VDP_CMD move.l,$C184,VRAM,WRITE,d4			; Draw field tilemap	
	move.w	#$8021,d5
	bsr.w	DrawFieldMap
	VDP_CMD move.l,$D184,VRAM,WRITE,d4
	move.w	#($5000/$20)+$8021,d5
	bsr.w	DrawFieldMap
	
	VDP_CMD move.l,vram_hscroll+2,VRAM,WRITE,VDP_CTRL	; Set HScroll
	move.w	#-3,VDP_DATA
	
	moveq	#0,d0						; Reset communication commands
	move.l	d0,COMM_CMD_0
	move.l	d0,COMM_CMD_2
	move.l	d0,COMM_CMD_4
	move.l	d0,COMM_CMD_6
	
	GIVE_WORD_ACCESS					; Run Sub CPU module
	bsr.w	RunSubModule
	
.WaitSub:
	cmpi.b	#'R',COMM_STAT_0				; Wait for the Sub CPU to be ready
	bne.s	.WaitSub
	
	move.l	#VInt_HK97,_LEVEL6+2.w				; Set interrupt

; -------------------------------------------------------------------------

.MainLoop:
	cmpi.b	#2,started					; Check if we should fade from black
	beq.s	.NoFade
	addq.b	#1,started
	cmpi.b	#2,started
	bne.s	.NoFade

	move.w	#$8174,VDP_CTRL					; Fade from black
	bsr.w	PaletteFadeIn

; -------------------------------------------------------------------------

.NoFade:
	bsr.w	RenderBuffer1					; Render
	bsr.w	RenderBuffer2
	bra.s	.MainLoop					; Loop

; -------------------------------------------------------------------------
; Check for pausing
; -------------------------------------------------------------------------

CheckPause:
	cmpi.b	#2,started					; Check pause button
	bne.s	.NoPause
	tst.b	v_jpadpress1.w
	bpl.s	.NoPause

	moveq	#2,d0						; Pause the music
	bsr.w	HK97SubCmd

.Pause:
	st	v_vbla_routine.w				; Pause loop
	bsr.w	WaitForVBla

	tst.b	v_cheatactive.w					; Check skip cheat
	bne.s	.NoSkip
	
	lea	.SkipCheat(pc),a1
	lea	v_cheatbutton.w,a2
	jsr	CheckCheat
	beq.s	.NoSkip
	st	v_cheatactive.w

	move.b	#1,COMM_CMD_6

.NoSkip:
	tst.b	v_jpadpress1.w
	bpl.s	.Pause

	moveq	#3,d0						; Unpause the music
	bra.w	HK97SubCmd

.NoPause:
	rts

; -------------------------------------------------------------------------

.SkipCheat:
	dc.b	btnUp, btnDn, btnL, btnR, 0
	even

; -------------------------------------------------------------------------
; Render frame
; -------------------------------------------------------------------------

RenderBuffer1:
	bsr.w	CheckPause					; Check for pausing

	move	#$2700,sr					; Start next update
	move.w	v_jpadhold1.w,COMM_CMD_7
	moveq	#1,d0
	bsr.w	HK97SubCmdStart

	st	v_vbla_routine.w				; Copy frame to VRAM
	move.l	#HK97VInt_Buf11,vintRoutine
	move	#$2300,sr
	bsr.w	WaitForVBla
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	
	bsr.w	HK97SubCmdEnd					; Wait for finish
	bra.s	CheckFlags					; Check flags

; -------------------------------------------------------------------------

RenderBuffer2:
	tst.b	skipBuffer2					; Should this be skipped?
	bne.s	.SkipBuffer2					; If so, branch

	bsr.w	CheckPause					; Check for pausing

	move	#$2700,sr					; Start next update
	move.w	v_jpadhold1.w,COMM_CMD_7
	moveq	#1,d0
	bsr.w	HK97SubCmdStart

	st	v_vbla_routine.w				; Copy frame to VRAM
	move.l	#HK97VInt_Buf21,vintRoutine
	move	#$2300,sr
	bsr.w	WaitForVBla
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	
	bsr.w	HK97SubCmdEnd					; Wait for finish
	bra.s	CheckFlags					; Check flags

.SkipBuffer2
	clr.b	skipBuffer2					; Clear skip flag
	rts

; -------------------------------------------------------------------------
; Check flags
; -------------------------------------------------------------------------

CheckFlags:
	clr.b	COMM_CMD_2					; CLear out respawn flag

	tst.b	gameWon						; Was the game won?
	bne.w	RunGameWin					; If so, branch
	tst.b	gameOver					; Is the game over?
	bne.w	RunGameOver					; If so, branch
	tst.b	bossCutscene					; Is the boss cutscene starting?
	bne.w	RunBossCutscene					; If so, branch

; -------------------------------------------------------------------------
; Palette change
; -------------------------------------------------------------------------

RunPalChange:
	move	#$2700,sr					; Execute palette change
	moveq	#0,d0
	move.b	palChange,d0
	beq.s	.End
	jsr	.PalChanges-2(pc,d0.w)
	clr.b	palChange

.End:
	rts

; -------------------------------------------------------------------------

.PalChanges:
	bra.s	.ToWhite
	bra.s	.FromWhite
	bra.s	.ToWhite
	bra.s	.PinkBG
	bra.s	.BGToWhite
	bra.s	.BGFromWhite

; -------------------------------------------------------------------------

.ToWhite:
	clr.b	COMM_CMD_3					; Stop palette changes
	move.w	#$1624,v_pfade_start.w				; Fade to white
	bra.w	PaletteWhiteOutAlt

; -------------------------------------------------------------------------

.FromWhite:
	clr.b	COMM_CMD_3					; Stop palette changes
	move.w	#$1624,v_pfade_start.w				; Fade from white
	bra.w	PaletteWhiteInAlt

; -------------------------------------------------------------------------

.PinkBG:
	clr.b	COMM_CMD_3					; Stop palette changes
	lea	v_pal_dry_dup.w,a0				; Copy palette
	lea	v_pal_dry.w,a1
	move.w	#$80/4-1,d0

.CopyPal2:
	move.l	(a0)+,(a1)+
	dbf	d0,.CopyPal2

	lea	Pal_BossBG(pc),a0				; Make background pink
	lea	v_pal_dry+$20.w,a1
	lea	v_pal_dry_dup+$20.w,a2
	move.w	#$20/4-1,d0

.MakePinkBG:
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,.MakePinkBG
	rts

; -------------------------------------------------------------------------

.BGToWhite:
	tst.b	palFadeCount					; Set fade counter
	bne.s	.DoBGToWhite
	move.b	#$16/2,palFadeCount

.DoBGToWhite:
	move.w	#$200F,v_pfade_start.w				; Fade to white
	bsr.w	WhiteOut_ToWhite
	bsr.w	WhiteOut_ToWhite
	bra.s	.CheckBGFadeDone

; -------------------------------------------------------------------------

.BGFromWhite:
	tst.b	palFadeCount					; Set fade counter
	bne.s	.DoBGFromWhite
	move.b	#$16/2,palFadeCount

.DoBGFromWhite:
	move.w	#$200F,v_pfade_start.w				; Fade from white
	bsr.w	WhiteIn_FromWhite
	bsr.w	WhiteIn_FromWhite

.CheckBGFadeDone:
	moveq	#0,d0						; Keep doing palette changes
	move.b	palChange,d0
	move.b	d0,COMM_CMD_3
	subq.b	#1,palFadeCount					; Decrement fade counter
	bne.s	.BGFadeNotDone
	clr.b	COMM_CMD_3					; Stop palette changes

.BGFadeNotDone:
	rts

; -------------------------------------------------------------------------
; Boss cutscene
; -------------------------------------------------------------------------

RunBossCutscene:
	move	#$2700,sr					; Disable interrupts

	lea	VDP_CTRL,a0					; Clear out field graphics
	move.w	#$8F01,(a0)
	VRAM_FILL 0,0,$A000,(a0),-4(a0)
	move.w	#$8F02,(a0)

	VDP_CMD move.l,$C184,VRAM,WRITE,d4			; Clear out field tilemap
	bsr.w	ClearFieldMap
	VDP_CMD move.l,$D184,VRAM,WRITE,d4
	bsr.w	ClearFieldMap
	
	VDP_CMD move.l,0,VSRAM,WRITE,(a0)			; Move away from loading zone
	move.w	#-256,-4(a0)

	VDP_CMD move.l,0,VRAM,WRITE,VDP_CTRL			; Load cutscene art
	lea	Art_Cutscene(pc),a0
	bsr.w	NemDec

	lea	Map_Cutscene(pc),a0				; Decompress cutscene map
	lea	mapBuffer,a1
	move.w	#$E000,d0
	bsr.w	EniDec

	VDP_CMD move.l,$C184,VRAM,WRITE,d0			; Load cutscene map
	moveq	#(IMG_TILES_X)-1,d1
	moveq	#(IMG_TILES_Y)-1,d2
	bsr.w	TilemapToVRAM

	lea	CutsceneText(pc),a1				; Cutscene text

.CutsceneLoop:
	move	#$2700,sr					; Disable interrupts
	move.l	(a1)+,d0					; Draw text
	beq.s	.CutsceneOver

	move.l	d0,d1						; Clear previous text
	moveq	#7-1,d3

.CutsceneClearLine:
	moveq	#11-1,d2
	move.l	d1,VDP_CTRL

.CutsceneClearChar:
	move.w	#$805F,VDP_DATA
	dbf	d2,.CutsceneClearChar
	addi.l	#$800000,d1
	dbf	d3,.CutsceneClearLine

	movea.l	(a1)+,a0
	bsr.w	DrawText

.CutsceneWaitInput:
	st	v_vbla_routine.w				; Wait for user input
	bsr.w	WaitForVBla
	move.b	v_jpadpress1.w,d0			
	andi.b	#$C0,d0
	beq.s	.CutsceneWaitInput
	bra.s	.CutsceneLoop					; Do next set of text

.CutsceneOver:
	move.w	#$0EE,v_pal_dry+$10.w				; Enable "ENEMY!!" text
	move.w	#$0EE,v_pal_dry_dup+$10.w

	move.w	#$1000,hudBossHP				; Initialize boss HP bar
	bsr.w	DrawBossHP

GoBackToLevel:
	move.w	#$2700,sr					; Go back to buffer 1
	st	skipBuffer2

	clr.w	v_jpadhold1.w					; Clear controller data

	lea	VDP_CTRL,a0					; Wait until start of V-BLANK

.WaitVBlankEnd:
	move	(a0),ccr
	bmi.s	.WaitVBlankEnd

.WaitVBlankStart:
	move	(a0),ccr
	bpl.s	.WaitVBlankStart

	move.w	#$8F01,(a0)					; Clear out field graphics
	VRAM_FILL 0,0,$A000,(a0),-4(a0)
	move.w	#$8F02,(a0)
	
	VDP_CMD move.l,$C184,VRAM,WRITE,d4			; Draw field tilemap	
	move.w	#$8021,d5
	bsr.w	DrawFieldMap
	VDP_CMD move.l,$D184,VRAM,WRITE,d4
	move.w	#($5000/$20)+$8021,d5
	bra.w	DrawFieldMap

; -------------------------------------------------------------------------
; Game over
; -------------------------------------------------------------------------

RunGameOver:
	move	#$2700,sr					; Disable interrupts

	lea	VDP_CTRL,a0					; Wait until start of V-BLANK

.WaitVBlankEnd:
	move	(a0),ccr
	bmi.s	.WaitVBlankEnd

.WaitVBlankStart:
	move	(a0),ccr
	bpl.s	.WaitVBlankStart

	move.w	#$8F01,(a0)					; Clear out field graphics
	VRAM_FILL 0,0,$A000,(a0),-4(a0)
	move.w	#$8F02,(a0)

	VDP_CMD move.l,$C184,VRAM,WRITE,d4			; Clear out field tilemap
	bsr.w	ClearFieldMap
	VDP_CMD move.l,$D184,VRAM,WRITE,d4
	bsr.w	ClearFieldMap

	lea	spritesExt,a0					; Clear out sprites
	move.w	#$280/4-1,d0

.ClearSprites:
	clr.l	(a0)+
	dbf	d0,.ClearSprites

	VDP_CMD move.l,0,VRAM,WRITE,VDP_CTRL			; Load game over art
	lea	Art_GameOver(pc),a0		
	bsr.w	NemDec

; -------------------------------------------------------------------------

	lea	spritesExt,a0					; Draw "G" in "GAME OVER" moving to the left
	move.w	#128+112,(a0)+
	move.w	#$500,(a0)+
	clr.w	(a0)+
	move.w	#128+160,(a0)

.MoveG:
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	subq.w	#8,(a0)
	cmpi.w	#128+16+8,(a0)
	bcc.s	.MoveG
	move.w	#128+16+8,(a0)+
	st	v_vbla_routine.w
	bsr.w	WaitForVBla

	lea	GameOverSprites(pc),a1				; Draw the rest of the "GAME OVER" letters
	move.w	#128+16+8,d0
	moveq	#1,d1

.DrawGameOver:
	tst.w	(a1)
	bmi.s	.GameOverWait

	move.b	d1,-5(a0)
	addq.b	#1,d1

	move.w	#128+112,(a0)+
	move.w	#$500,(a0)+
	move.w	(a1)+,(a0)+
	move.w	d0,(a0)
	addi.w	#16,d0

.DrawGameOverLoop:
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	addq.w	#8,(a0)
	cmp.w	(a0),d0
	bcc.s	.DrawGameOverLoop
	move.w	d0,(a0)+
	st	v_vbla_routine.w
	bsr.w	WaitForVBla
	bra.s	.DrawGameOver

.GameOverWait:
	st	v_vbla_routine.w				; Wait for user input
	bsr.w	WaitForVBla				
	move.b	v_jpadpress1.w,d0
	andi.b	#btnA|btnStart,d0
	beq.s	.GameOverWait

; -------------------------------------------------------------------------

	tst.b	credits						; Do we have any credits left?
	beq.w	GameOverEnding					; If not, branch

	lea	spritesExt,a0					; Draw "CONTINUE?" text
	lea	ContinueSprites(pc),a1
	moveq	#1,d0
	move.w	#128+16,d1

.DrawContinueLoop:
	tst.w	(a1)
	bmi.s	.DrawCredit

	move.w	#128+64,(a0)+
	move.b	#5,(a0)+
	move.b	d0,(a0)+
	move.w	(a1)+,(a0)+
	move.w	d1,(a0)+

	addq.b	#1,d0
	addi.w	#16,d1
	bra.s	.DrawContinueLoop

.DrawCredit:
	lea	CreditSprites(pc),a1				; Draw "CREDIT" text
	move.w	#128+16+8,d1

.DrawCreditLoop:
	tst.w	(a1)
	bmi.s	.DrawCreditCount

	move.w	#128+176,(a0)+
	move.b	#5,(a0)+
	move.b	d0,(a0)+
	move.w	(a1)+,(a0)+
	move.w	d1,(a0)+

	addq.b	#1,d0
	addi.w	#16,d1
	bra.s	.DrawCreditLoop

.DrawCreditCount:
	move.w	#128+176,(a0)+					; Draw credit count
	move.b	#5,(a0)+
	move.b	d0,(a0)+
	addq.b	#1,d0

	lea	CreditCountSprites-2(pc),a1
	moveq	#0,d2
	move.b	credits,d2
	add.w	d2,d2
	move.w	(a1,d2.w),(a0)+
	addi.w	#16,d1
	move.w	d1,(a0)+

	moveq	#0,d5						; Draw options
	movea.l	a0,a2
	move.b	d0,d2
	bsr.w	DrawOptions

; -------------------------------------------------------------------------

.ContinueWait:
	st	v_vbla_routine.w				; Wait for user input
	bsr.w	WaitForVBla
	move.b	v_jpadpress1.w,d0
	andi.b	#btnUp|btnDn,d0
	beq.s	.ContCheckStart
	eori.b	#1,d5
	bsr.w	DrawOptions

.ContCheckStart:
	move.b	v_jpadpress1.w,d0
	andi.b	#btnA|btnStart,d0
	beq.s	.ContinueWait

	tst.b	d5						; Did we select "NO"?
	bne.s	GameOverEnding					; If so, branch

	move.b	#1,COMM_CMD_2					; Respawn player
	subq.b	#1,credits					; Decrement credit count
	
	bra.w	GoBackToLevel					; Go back to level

; -------------------------------------------------------------------------

GameOverEnding:
	lea	Txt_GameOver(pc),a0				; Game over
	bra.s	GameEnding

RunGameWin:
	lea	Txt_GameWin(pc),a0				; Win

GameEnding:
	move	#$2700,sr					; Disable interrupts
	move.l	a0,-(sp)

	moveq	#-1,d0						; Exit out of Sub CPU module
	bsr.w	HK97SubCmdStart
	bsr.w	FinishSubCmd

	lea	VDP_CTRL,a0					; Reset VDP
	move.w	#$8134,(a0)
	move.w	#$8200|(vram_fg/$400),(a0)
	move.w	#$8400|(vram_bg/$2000),(a0)
	move.w	#$8C81,(a0)
	move.w	#$9001,(a0)
	bsr.w	ClearScreen

	VDP_CMD move.l,$20,VRAM,WRITE,VDP_CTRL			; Load BSOD art
	lea	Art_BSOD(pc),a0
	bsr.w	NemDec

	lea	Pal_BSOD(pc),a0					; Load BSOD palette
	lea	v_pal_dry.w,a1
	moveq	#$40/4-1,d0

.LoadBSODPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadBSODPal

	movea.l	(sp)+,a0					; Draw text
	VDP_CMD move.l,vram_fg+$82,VRAM,WRITE,d0
	bsr.w	DrawBSODText

	move.w	#$8174,VDP_CTRL					; Enable display

.BSODWait:
	st	v_vbla_routine.w				; Wait for user input
	bsr.w	WaitForVBla
	move.b	v_jpadpress1.w,d0
	andi.b	#btnStart,d0
	beq.s	.BSODWait

GameDone:
	bsr.w	PaletteFadeOut					; Fade to black

	move	#$2700,sr					; Restore VDP settings
	bsr.w	VDPSetupGame

	addq.w	#4,sp						; Exit to title screen
	move.b	#id_Title,v_gamemode.w
	rts

; -------------------------------------------------------------------------

DrawOptions:
	movea.l	a2,a0						; Draw options text
	move.b	d2,d0
	move.w	#128+64,d1
	move.w	#128+96,d3
	lea	OptionsYes(pc),a1
	tst.b	d5
	beq.s	.OptChar
	lea	OptionsNo(pc),a1

.OptChar:
	tst.w	(a1)
	beq.s	.OptNextLine
	bmi.s	.OptDone

	move.w	d3,(a0)+
	move.b	#5,(a0)+
	move.b	d0,(a0)+
	move.w	(a1)+,(a0)+
	move.w	d1,(a0)+

	addq.b	#1,d0
	addi.w	#16,d1
	bra.s	.OptChar

.OptNextLine:
	addi.w	#24,d3
	move.w	#128+64+8,d1
	addq.l	#2,a1
	bra.s	.OptChar

.OptDone:
	clr.b	-5(a0)
	rts

; -------------------------------------------------------------------------

GameOverSprites:
	dc.w	$0004
	dc.w	$0008
	dc.w	$0030
	dc.w	$0018
	dc.w	$000C
	dc.w	$0030
	dc.w	$0010
	dc.w	-1

ContinueSprites:
	dc.w	$0014
	dc.w	$0018
	dc.w	$001C
	dc.w	$0020
	dc.w	$0024
	dc.w	$0028
	dc.w	$002C
	dc.w	$0030
	dc.w	$0034
	dc.w	-1

CreditSprites:
	dc.w	$0054
	dc.w	$0058
	dc.w	$005C
	dc.w	$0060
	dc.w	$0064
	dc.w	$0068
	dc.w	-1

CreditCountSprites:
	dc.w	$0074
	dc.w	$0070
	dc.w	$006C

OptionsYes:
	dc.w	$0038
	dc.w	$003C
	dc.w	$0040
	dc.w	0
	dc.w	$001C
	dc.w	$0018
	dc.w	-1

OptionsNo:
	dc.w	$004C
	dc.w	$0030
	dc.w	$0050
	dc.w	0
	dc.w	$0044
	dc.w	$0048
	dc.w	-1

; -------------------------------------------------------------------------
; Text
; -------------------------------------------------------------------------

CHIN_TEXT_VDP	EQU	$49120003
TONG_TEXT_VDP	EQU	$45040003

; -------------------------------------------------------------------------

CutsceneText:
	dc.l	CHIN_TEXT_VDP, Txt_Cutscene1
	dc.l	TONG_TEXT_VDP, Txt_Cutscene2
	dc.l	CHIN_TEXT_VDP, Txt_Cutscene3
	dc.l	TONG_TEXT_VDP, Txt_Cutscene4
	dc.l	TONG_TEXT_VDP, Txt_Cutscene5
	dc.l	CHIN_TEXT_VDP, Txt_Cutscene6
	dc.l	TONG_TEXT_VDP, Txt_Cutscene7
	dc.l	TONG_TEXT_VDP, Txt_Cutscene8
	dc.l	CHIN_TEXT_VDP, Txt_Cutscene9
	dc.l	TONG_TEXT_VDP, Txt_Cutscene10
	dc.l	0

; -------------------------------------------------------------------------

Txt_Cutscene1:
	dc.b	"Chin:", -1
	dc.b	"What the", -1
	dc.b	"hell are", -1
	dc.b	"you doing?", 0
	even

Txt_Cutscene2:
	dc.b	"Shau Ping:", -1
	dc.b	"I am", -1
	dc.b	"bringing", -1
	dc.b	"greatness", -1
	dc.b	"to Hong", -1
	dc.b	"Kong!", 0
	even

Txt_Cutscene3:
	dc.b	"Chin:", -1
	dc.b	"Fuck you!", -1
	dc.b	"Hong Kong", -1
	dc.b	"is ruined!", -1
	dc.b	"Commies are", -1
	dc.b	"scum of the", -1
	dc.b	"Earth!", 0
	even

Txt_Cutscene4:
	dc.b	"Shau Ping:", -1
	dc.b	"My army of", -1
	dc.b	"1.2 billion", -1
	dc.b	"seem to say", -1
	dc.b	"otherwise.", 0
	even

Txt_Cutscene5:
	dc.b	"Shau Ping:", -1
	dc.b	"Communism", -1
	dc.b	"is the way", -1
	dc.b	"to go!", 0
	even

Txt_Cutscene6:
	dc.b	"Chin:", -1
	dc.b	"Those", -1
	dc.b	"fuckin ugly", -1
	dc.b	"reds? Ha!", -1
	dc.b	"You don't", -1
	dc.b	"know what", -1
	dc.b	"power is!!!", 0
	even

Txt_Cutscene7:
	dc.b	"Shau Ping:", -1
	dc.b	"Why don't", -1
	dc.b	"you show me", -1
	dc.b	"it, then? I", -1
	dc.b	"have the", -1
	dc.b	"population", -1
	dc.b	"of China", 0
	even

Txt_Cutscene8:
	dc.b	"Shau Ping:", -1
	dc.b	"with me!!!", -1
	dc.b	"I'm too", -1
	dc.b	"powerful", -1
	dc.b	"to fail!!!!", 0
	even

Txt_Cutscene9:
	dc.b	"Chin:", -1
	dc.b	"You're", -1
	dc.b	"gonna eat", -1
	dc.b	"those", -1
	dc.b	"words.", 0
	even

Txt_Cutscene10:
	dc.b	"Shau Ping:", -1
	dc.b	"Try it! I'm", -1
	dc.b	"quite a big", -1
	dc.b	"guy, and", -1
	dc.b	"I'm", -1
	dc.b	"starving!", 0
	even

Txt_GameOver:
	dc.b	"           ", -2, $83, "Sega MegaDrive", $86, -3, -1, -1
	dc.b	"Chin is dead!! To continue:", -1, -1
	dc.b	"Press Start to return to the title", -1
	dc.b	"screen, or press the reset button on", -1
	dc.b	"your console to restart it.", -1, -1
	dc.b	"The fuckin' ugly reds have won. :(", -1, -1
	dc.b	"Error: 01 : 420 : CHIN_IS_DEAD", -1, -1
	dc.b	"              Game Over", $87, 0
	even

Txt_GameWin:
	dc.b	"           ", -2, $83, "Sega MegaDrive", $86, -3, -1, -1
	dc.b	"The game is over. To continue:", -1, -1
	dc.b	"Press Start to return to the title", -1
	dc.b	"screen, or press the reset button on", -1
	dc.b	"your console to restart it.", -1, -1
	dc.b	"There is no ending. Screw you.", -1, -1
	dc.b	"Error: 02 : 420 : GAME_WON", -1, -1
	dc.b	"              Game Over", $87, 0
	even

; -------------------------------------------------------------------------
; Sub CPU command 
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Command ID
; -------------------------------------------------------------------------

HK97SubCmd:
	bsr.s	HK97SubCmdStart					; Start command
	
; -------------------------------------------------------------------------

HK97SubCmdEnd:
	clr.b	COMM_CMD_0					; Clear command ID

.WaitDone:
	cmpi.b	#'R',COMM_STAT_0				; Has the Sub CPU finished?
	bne.s	.WaitDone					; If not, wait
	rts

; -------------------------------------------------------------------------

HK97SubCmdStart:
	move.b	d0,COMM_CMD_0					; Set command ID

.WaitAck:
	cmpi.b	#'B',COMM_STAT_0				; Has the Sub CPU acknowledged it?
	bne.s	.WaitAck					; If not, wait
	rts

; -------------------------------------------------------------------------
; V-BLANK interrupt (image)
; -------------------------------------------------------------------------

VInt_Image:
	move	#$2700,sr					; Disable interrupts
	movem.l	d0-a6,-(sp)					; Save registers
	REQUEST_INT2						; Request Sub CPU interrupt

	clr.b	v_vbla_routine.w				; Clear VSync flag
	lea	VDP_CTRL,a5					; Clear V-BLANK flag
	move.w	(a5),d0
	
	STOP_Z80
	bsr.w	ReadJoypads					; Read controller data
	DMA_68K v_pal_dry,0,$80,CRAM,(a5)			; Copy palette
	bsr.w	ProcessDMAQueue					; Process DMA queue

	START_Z80

	movem.l	(sp)+,d0-a6					; Restore registers
	rte

; -------------------------------------------------------------------------
; V-BLANK interrupt (game)
; -------------------------------------------------------------------------

VInt_HK97:
	move	#$2700,sr					; Stop interrupts
	movem.l	d0-a6,-(sp)					; Push all registers
	REQUEST_INT2						; Request Sub CPU interrupt

	clr.b	v_vbla_routine.w				; Clear VSync flag
	lea	VDP_CTRL,a5					; Clear V-BLANK flag
	move.w	(a5),d0

	STOP_Z80						; Run routine
	movea.l	vintRoutine,a0
	jsr	(a0)
	START_Z80

	jsr	UpdateSound					; Update sound

	movem.l	(sp)+,d0-a6					; Pop all registers
	rte

; -------------------------------------------------------------------------

HK97VInt_Buf11:
	bsr.w	ReadJoypads
	
	VDP_CMD move.l,0,VSRAM,WRITE,(a5)
	move.w	#-256,-4(a5)

	DMA_68K v_pal_dry,0,$80,CRAM,(a5)
	
	DMA_68K spritesExt+2,vram_sprites,$280,VRAM,(a5)
	VDP_CMD move.l,vram_sprites,VRAM,WRITE,(a5)
	move.l	spritesExt,-4(a5)

	DMA_68K IMG_SRC_1+2,IMG_VRAM_11,IMG_COPY_1,VRAM,(a5)
	VDP_CMD move.l,IMG_VRAM_11,VRAM,WRITE,(a5)
	move.l	IMG_SRC_1,-4(a5)

	move.l	#HK97VInt_Buf12,vintRoutine
	rts
	
; -------------------------------------------------------------------------

HK97VInt_Buf12:
	DMA_68K IMG_SRC_2+2,IMG_VRAM_12,IMG_COPY_2,VRAM,(a5)
	VDP_CMD move.l,IMG_VRAM_12,VRAM,WRITE,(a5)
	move.l	IMG_SRC_2,-4(a5)

	bsr.w	UpdateHUD
	move.l	#HK97VInt_Busy,vintRoutine
	rts
	
; -------------------------------------------------------------------------

HK97VInt_Buf21:
	bsr.w	ReadJoypads
	
	VDP_CMD move.l,0,VSRAM,WRITE,(a5)
	move.w	#0,-4(a5)

	DMA_68K v_pal_dry,0,$80,CRAM,(a5)

	DMA_68K spritesExt+2,vram_sprites,$280,VRAM,(a5)
	VDP_CMD move.l,vram_sprites,VRAM,WRITE,(a5)
	move.l	spritesExt,-4(a5)
	
	DMA_68K IMG_SRC_1+2,IMG_VRAM_21,IMG_COPY_1,VRAM,(a5)
	VDP_CMD move.l,IMG_VRAM_21,VRAM,WRITE,(a5)
	move.l	IMG_SRC_1,-4(a5)

	move.l	#HK97VInt_Buf22,vintRoutine
	rts
	
; -------------------------------------------------------------------------

HK97VInt_Buf22:
	DMA_68K IMG_SRC_2+2,IMG_VRAM_22,IMG_COPY_2,VRAM,(a5)
	VDP_CMD move.l,IMG_VRAM_22,VRAM,WRITE,(a5)
	move.l	IMG_SRC_2,-4(a5)

	bsr.w	UpdateHUD
	move.l	#HK97VInt_Busy,vintRoutine
	rts

; -------------------------------------------------------------------------

HK97VInt_Busy:
	bsr.w	ReadJoypads
	
	VDP_CMD move.l,0,VSRAM,WRITE,(a5)
	move.w	#0,-4(a5)

	DMA_68K v_pal_dry,0,$80,CRAM,(a5)

	DMA_68K spritesExt+2,vram_sprites,$280,VRAM,(a5)
	VDP_CMD move.l,vram_sprites,VRAM,WRITE,(a5)
	move.l	spritesExt,-4(a5)
	rts

; -------------------------------------------------------------------------
; Update HUD
; -------------------------------------------------------------------------

UpdateHUD:
	bclr	#0,hudFlags					; Should we update the score counter?
	beq.s	.NoScore					; If not, branch
	move.l	hudScore,d0					; Update score counter
	VDP_CMD move.l,$C22A,VRAM,WRITE,d1
	lea	Digits_1000000(pc),a0
	bsr.w	UpdateHUDNumber

.NoScore:
	bclr	#1,hudFlags					; Should we update the life counter?
	beq.s	.NoLives					; If not, branch
	moveq	#0,d0						; Update life counter
	move.b	hudLives,d0
	VDP_CMD move.l,$C646,VRAM,WRITE,d1
	lea	Digits_1(pc),a0
	bsr.w	UpdateHUDNumber

.NoLives:
	bclr	#2,hudFlags					; Should we update the bomb counter?
	beq.s	.NoBombs					; If not, branch
	moveq	#0,d0						; Update bomb counter
	move.b	hudBombs,d0
	VDP_CMD move.l,$C746,VRAM,WRITE,d1
	lea	Digits_1(pc),a0
	bsr.w	UpdateHUDNumber

.NoBombs:
	bclr	#3,hudFlags					; Should we update the graze counter?
	beq.s	.NoGraze					; If not, branch
	moveq	#0,d0						; Update graze counter
	move.w	hudGraze,d0
	VDP_CMD move.l,$C83A,VRAM,WRITE,d1
	lea	Digits_1000(pc),a0
	bsr.w	UpdateHUDNumber

.NoGraze:
	bclr	#4,hudFlags					; Should we update the boss HP bar?
	beq.s	.NoBossHP					; If not, branch
	bra.w	DrawBossHP					; Update boss HP bar

.NoBossHP:
	rts

; -------------------------------------------------------------------------
; Update HUD number
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.l	- Number to print
;	d1.l	- VDP command
;	a0.l	- Digit counter start
; -------------------------------------------------------------------------

UpdateHUDNumber:
	moveq	#2-1,d3						; 2 buffers
	move.l	d0,d4
	movea.l	a0,a1

.DrawNumber:
	move.l	d1,d5						; Get VDP command

.NumberLoop:
	move.l	(a0)+,d6					; Are we done?
	beq.s	.NumberDone					; If so, branch

	moveq	#-1,d2						; Find digit

.FindDigit:
	addq.w	#1,d2
	sub.l	d6,d0
	bpl.s	.FindDigit
	add.l	d6,d0
	
	lsl.w	#3,d2						; Draw number
	lea	.Mappings(pc,d2.w),a2
	move.l	d5,VDP_CTRL
	move.l	(a2)+,VDP_DATA
	addi.l	#$800000,d5
	move.l	d5,VDP_CTRL
	move.l	(a2),VDP_DATA

	subi.l	#$800000-$40000,d5				; Do next digit
	bra.s	.NumberLoop

.NumberDone:
	move.l	d4,d0						; Restore settings
	movea.l	a1,a0
	addi.l	#$10000000,d1					; Draw to next buffer
	dbf	d3,.DrawNumber					; Loop

	rts

; -------------------------------------------------------------------------

.Mappings:
	dc.w	($DE80/$20)+$8083				; 0
	dc.w	($DE80/$20)+$8085
	dc.w	($DE80/$20)+$8084
	dc.w	($DE80/$20)+$8086
	
	dc.w	($DE80/$20)+$8087				; 1
	dc.w	($DE80/$20)+$8089
	dc.w	($DE80/$20)+$8088
	dc.w	($DE80/$20)+$808A
	
	dc.w	($DE80/$20)+$808B				; 2
	dc.w	($DE80/$20)+$808D
	dc.w	($DE80/$20)+$808C
	dc.w	($DE80/$20)+$808E

	dc.w	($DE80/$20)+$808F				; 3
	dc.w	($DE80/$20)+$8091
	dc.w	($DE80/$20)+$8090
	dc.w	($DE80/$20)+$8092
	
	dc.w	($DE80/$20)+$8093				; 4
	dc.w	($DE80/$20)+$8095
	dc.w	($DE80/$20)+$8094
	dc.w	($DE80/$20)+$8096
	
	dc.w	($DE80/$20)+$8097				; 5
	dc.w	($DE80/$20)+$8099
	dc.w	($DE80/$20)+$8098
	dc.w	($DE80/$20)+$809A
	
	dc.w	($DE80/$20)+$809B				; 6
	dc.w	($DE80/$20)+$809D
	dc.w	($DE80/$20)+$809C
	dc.w	($DE80/$20)+$809E
	
	dc.w	($DE80/$20)+$809F				; 7
	dc.w	($DE80/$20)+$80A1
	dc.w	($DE80/$20)+$80A0
	dc.w	($DE80/$20)+$80A2
	
	dc.w	($DE80/$20)+$80A3				; 8
	dc.w	($DE80/$20)+$80A5
	dc.w	($DE80/$20)+$80A4
	dc.w	($DE80/$20)+$80A6
	
	dc.w	($DE80/$20)+$80A7				; 9
	dc.w	($DE80/$20)+$80A9
	dc.w	($DE80/$20)+$80A8
	dc.w	($DE80/$20)+$80AA

; -------------------------------------------------------------------------

Digits_10000000:
	dc.l	10000000
Digits_1000000:
	dc.l	1000000
Digits_100000:
	dc.l	100000
Digits_10000:
	dc.l	10000
Digits_1000:
	dc.l	1000
Digits_100:
	dc.l	100
Digits_10:
	dc.l	10
Digits_1:
	dc.l	1
	dc.l	0

; -------------------------------------------------------------------------
; Draw boss HP
; -------------------------------------------------------------------------

DrawBossHP:
	lea	VDP_CTRL,a1					; VDP control port
	move.l	#$44AA0003,d5					; Base VDP command
	moveq	#2-1,d6

.DrawHPBarLoop:
	move.l	d5,d2						; Copy base VDP command

.DrawFilledTiles:
	moveq	#0,d0						; Get filled tiles
	move.b	hudBossHP,d0
	subq.w	#1,d0
	bmi.s	.DrawPartTile

	move.w	d0,d1						; Set color
	add.w	d1,d1
	lea	.Colors(pc),a0
	move.w	(a0,d1.w),v_pal_dry+$12.w
	move.w	v_pal_dry+$12.w,v_pal_dry_dup+$12.w

	moveq	#2-1,d1						; Draw filled tiles
	move.w	#($DE80/$20)+$80E9,d3
	move.w	d0,d4

.DrawFilledTilesLoop:
	move.l	d2,(a1)

.DrawFilledTilesLoop2:
	move.w	d3,-4(a1)
	dbf	d0,.DrawFilledTilesLoop2
	ori.w	#$1000,d3
	addi.l	#$800000,d2
	move.w	d4,d0
	dbf	d1,.DrawFilledTilesLoop

	moveq	#0,d2						; Get next VDP address
	move.b	hudBossHP,d2
	add.w	d2,d2
	swap	d2
	add.l	d5,d2

; -------------------------------------------------------------------------

.DrawPartTile:
	moveq	#0,d0						; Draw part tile
	move.b	hudBossHP+1,d0
	lsr.b	#4,d0
	andi.b	#$E,d0
	beq.s	.DrawEmptyTiles

	lea	.PartTiles-2(pc),a0
	move.w	(a0,d0.w),d0
	move.l	d2,(a1)
	move.w	d0,-4(a1)
	addi.l	#$800000,d2
	ori.w	#$1000,d0
	move.l	d2,(a1)
	move.w	d0,-4(a1)

	subi.l	#$800000-$20000,d2				; Get next VDP address

; -------------------------------------------------------------------------

.DrawEmptyTiles:
	moveq	#16-1,d0					; Get empty tiles
	sub.b	hudBossHP,d0
	bmi.s	.Done

	moveq	#2-1,d1						; Draw empty tiles
	move.w	d0,d3

.DrawEmptyTilesLoop:
	move.l	d2,(a1)

.DrawEmptyTilesLoop2:
	move.w	#($DE80/$20)+$8000,-4(a1)
	dbf	d0,.DrawEmptyTilesLoop2
	addi.l	#$800000,d2
	move.w	d3,d0
	dbf	d1,.DrawEmptyTilesLoop

.Done:
	addi.l	#$10000000,d5					; Next buffer
	dbf	d6,.DrawHPBarLoop				; Loop until both buffers have been drawn to
	rts

; -------------------------------------------------------------------------

.Colors:
	dc.w	$000E
	dc.w	$000E
	dc.w	$000E
	dc.w	$0E0E
	dc.w	$0E0E
	dc.w	$0E0E
	dc.w	$0EE0
	dc.w	$0EE0
	dc.w	$0EE0
	dc.w	$00EE
	dc.w	$00EE
	dc.w	$00EE
	dc.w	$0EEE
	dc.w	$0EEE
	dc.w	$0EEE
	dc.w	$0EEE

.PartTiles:
	dc.w	($DE80/$20)+$810A
	dc.w	($DE80/$20)+$8109
	dc.w	($DE80/$20)+$8108
	dc.w	($DE80/$20)+$8107
	dc.w	($DE80/$20)+$8106
	dc.w	($DE80/$20)+$80EB
	dc.w	($DE80/$20)+$80EA

; -------------------------------------------------------------------------
; Draw text
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Text pointer
;	d0.l	- VDP command
; -------------------------------------------------------------------------

DrawText:
.Line:
	move.l	d0,VDP_CTRL						; Set VDP command

.Char:
	moveq	#0,d1							; Get character
	move.b	(a0)+,d1
	bmi.s	.NewLine						; New line
	beq.s	.End							; Terminator
	addi.w	#$E03F,d1						; Draw character
	move.w	d1,VDP_DATA
	bra.s	.Char							; Loop

.NewLine:
	addi.l	#$800000,d0
	bra.s	.Line

.End:
	rts

; -------------------------------------------------------------------------
; Draw iamge
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to image data
; -------------------------------------------------------------------------

DrawImage:
	move	#$2700,sr						; Set interrupt
	move.l	#VInt_Image,_LEVEL6+2.w
	
	move.l	a2,-(sp)
	move.l	a1,-(sp)
	move.l	a0,-(sp)

	bsr.w	PaletteFadeOut						; Fade out
	move	#$2700,sr
	bsr.w	ClearScreen
	move.w	#$8134,VDP_CTRL	

	VDP_CMD move.l,0,VRAM,WRITE,VDP_CTRL				; Clear first tile		
	moveq	#0,d0
	rept	8
		move.l	d0,VDP_DATA
	endr

	movea.l	(sp)+,a0						; Load art
	VDP_CMD move.l,$20,VRAM,WRITE,VDP_CTRL
	bsr.w	NemDec
	
	movea.l	(sp)+,a0						; Decompress tilemap
	lea	mapBuffer,a1
	move.w	#$8001,d0
	bsr.w	EniDec

	VDP_CMD move.l,$C000,VRAM,WRITE,d0				; Load tilemap
	moveq	#$28-1,d1
	moveq	#$1C-1,d2
	bsr.w	TilemapToVRAM

	movea.l	(sp)+,a0						; Load palette
	lea	v_pal_dry_dup.w,a1
	move.w	#$20/4-1,d0

.LoadPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPal

	move.w	#$8174,VDP_CTRL						; Enable display
	bsr.w	PaletteFadeIn						; Fade from black

.WaitInput:
	st	v_vbla_routine.w					; VSync
	bsr.w	WaitForVBla
	
	move.b	v_jpadpress1.w,d0					; Wait for user input
	andi.b	#btnA|btnStart,d0
	beq.s	.WaitInput
	rts

; -------------------------------------------------------------------------
; Draw field map
; -------------------------------------------------------------------------
; PARAMETERS:
;	d4.l	- VDP command
;	d5.w	- Base tile
; -------------------------------------------------------------------------

DrawFieldMap:
	moveq	#IMG_TILES_X-1,d1
	moveq	#IMG_TILES_Y-1,d2

.FieldRow:
	move.l	d4,VDP_CTRL
	move.w	d1,d3
	move.w	d5,d0

.FieldTile:
	move.w	d0,VDP_DATA
	addi.w	#$20,d0
	dbf	d3,.FieldTile
	addq.w	#1,d5
	addi.l	#$800000,d4
	dbf	d2,.FieldRow
	rts

; -------------------------------------------------------------------------
; Clear field map
; -------------------------------------------------------------------------
; PARAMETERS:
;	d4.l	- VDP command
; -------------------------------------------------------------------------

ClearFieldMap:
	moveq	#IMG_TILES_X-1,d1
	moveq	#IMG_TILES_Y-1,d2

.FieldRow:
	move.l	d4,VDP_CTRL
	move.w	d1,d3

.FieldTile:
	move.w	#($DE80/$20)+$8004,VDP_DATA
	dbf	d3,.FieldTile
	addi.l	#$800000,d4
	dbf	d2,.FieldRow
	rts
	
; -------------------------------------------------------------------------
; Draw BSOD text
; -------------------------------------------------------------------------

DrawBSODText:
	lea	VDP_CTRL,a1
	move.w	#$8F80,(a1)
	moveq	#0,d3

.Line:
	move.l	d0,d1

.Loop:
	move.l	d1,(a1)

.GetChar:
	moveq	#0,d2
	move.b	(a0)+,d2
	beq.s	.End
	cmpi.b	#-1,d2
	beq.s	.NewLine
	cmpi.b	#-2,d2
	beq.s	.SetGray
	cmpi.b	#-3,d2
	beq.s	.SetNormal

	subi.b	#$20,d2
	add.w	d2,d2

	move.b	.Chars(pc,d2.w),d3
	move.w	d3,-4(a1)
	move.b	.Chars+1(pc,d2.w),d3
	move.w	d3,-4(a1)

	addi.l	#$20000,d1
	bra.s	.Loop

.NewLine:
	addi.l	#$1000000,d0
	bra.s	.Line

.SetGray:
	move.w	#$2000,d3
	bra.s	.GetChar

.SetNormal:
	moveq	#0,d3
	bra.s	.GetChar

.End:
	move.w	#$8F02,(a1)
	rts
	
; -------------------------------------------------------------------------

.Chars:
	dc.b 	$A8,$A8,$57,$01,$58,$00,$59,$02,$5A,$03,$5B,$04,$5C,$05,$5D,$00
	dc.b	$5E,$06,$5F,$07,$60,$08,$61,$09,$00,$0A,$00,$0B,$00,$0C,$62,$0D
	dc.b 	$63,$0E,$64,$0F,$65,$10,$66,$11,$67,$12,$68,$13,$69,$14,$6A,$15
	dc.b	$6B,$16,$6C,$17,$6D,$18,$6D,$19,$5E,$1A,$6E,$1B,$5F,$1C,$6F,$01
	dc.b 	$70,$1D,$71,$1E,$72,$1F,$73,$20,$74,$21,$75,$22,$76,$23,$73,$24
	dc.b	$77,$25,$78,$26,$79,$27,$7A,$28,$7B,$29,$7C,$2A,$7D,$2B,$7E,$2C
	dc.b 	$72,$2D,$7E,$2E,$72,$2F,$7F,$30,$80,$26,$77,$31,$77,$32,$81,$33
	dc.b	$82,$34,$77,$35,$83,$36,$84,$37,$85,$38,$86,$39,$87,$00,$00,$3A
	dc.b 	$88,$00,$89,$3B,$8A,$3C,$89,$3D,$8B,$3E,$89,$3F,$8C,$40,$8D,$41
	dc.b	$8E,$42,$8F,$43,$90,$44,$91,$45,$92,$43,$93,$46,$94,$47,$89,$31
	dc.b 	$95,$48,$96,$49,$97,$4A,$89,$4B,$98,$4C,$99,$4D,$99,$4E,$9A,$4F
	dc.b	$9A,$50,$9B,$51,$A2,$52,$9C,$53,$9D,$54,$9E,$55,$9F,$00,$A0,$56
	dc.b 	$00,$00,$00,$00,$00,$00,$A3,$A3,$A4,$A4,$A5,$A5,$A6,$A6,$00,$A7

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Art_Cutscene:
	incbin	"source/hk97/data/cutsceneart.nem"
	even
Map_Cutscene:
	incbin	"source/hk97/data/cutscenemap.eni"
	even
Art_GameOver:
	incbin	"source/hk97/data/gameover.nem"
	even
Pal_BossBG:
	incbin	"source/hk97/data/bosspal.bin"
	even
Art_BSOD:
	incbin	"source/hk97/data/bsod_art.nem"
	even
Pal_BSOD:
	incbin	"source/hk97/data/bsod_palette.bin"
	even

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

vintRoutine:
	dc.l	HK97VInt_Busy
started:
	dc.b	0
palFadeCount:
	dc.b	0
credits:
	dc.b	3
skipBuffer2:
	dc.b	0
mapBuffer:

; -------------------------------------------------------------------------