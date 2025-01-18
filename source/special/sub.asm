; -------------------------------------------------------------------------
; Special stage (Sub CPU)
; -------------------------------------------------------------------------

	include	"source/include/sub_cpu.inc"
	include	"source/include/sub_program.inc"
	include	"source/sound/crazybus_pcm.inc"
	include	"source/sound/crazybus_ids.inc"
	include	"source/special/map.inc"
	include	"source/special/sub_variables.inc"
	
	org	PRG_START+$10000

; -------------------------------------------------------------------------
; Shared data
; -------------------------------------------------------------------------

	rsset	WORD_START_2M+$1C000
	include	"source/special/shared.inc"
	
; -------------------------------------------------------------------------
; Sample addresses
; -------------------------------------------------------------------------

SAMPLE_SCREAM	EQU	SAMPLE_FREE
SAMPLE_SIGN	EQU	SAMPLE_SCREAM+$4300
	
; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

SpecialStage:
	jsr	CBPCM_Init					; Initialize sound driver
	
	lea	PCM_Scream(pc),a0				; Load samples
	move.w	#PCM_ScreamEnd-PCM_Scream,d0
	move.w	#SAMPLE_FREE,d1
	jsr	LoadPCMSample
	
	lea	PCM_Sign(pc),a0
	move.w	#PCM_SignEnd-PCM_Sign,d0
	move.w	#SAMPLE_SIGN,d1
	jsr	LoadPCMSample
	
	moveq	#4,d0						; Set up PCM5
	moveq	#$FFFFFFA8,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#SAMPLE_SCREAM>>8,d1
	jsr	SetPCMStart
	move.w	#SAMPLE_SCREAM+(PCM_ScreamLoop-PCM_Scream),d1
	jsr	SetPCMLoop
	
	moveq	#5,d0						; Set up PCM6
	moveq	#$FFFFFFD0,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#SAMPLE_SIGN>>8,d1
	jsr	SetPCMStart
	move.w	#SAMPLE_SIGN+(PCM_SignLoop-PCM_Sign),d1
	jsr	SetPCMLoop
	
	WAIT_WORD_ACCESS					; Wait for Word RAM access

	lea	VARS_START,a0					; Clear variables
	move.w	#(VARS_END-VARS_START)/2-1,d0
	moveq	#0,d1

.ClearVars:
	move.w	d1,(a0)+
	dbf	d0,.ClearVars
	
	lea	WORD_START_2M,a0				; Clear Word RAM
	move.w	#WORD_SIZE_2M/16-1,d0

.ClearWordRAM:
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbf	d0,.ClearWordRAM

	move.w	#(15<<8)|(FPS_DEST-1),timerSub			; Set timer
	
	bsr.w	LoadStageMap					; Load stage map
	bsr.w	LoadObjectMap					; Load object map
	bsr.w	InitGfxOperation				; Initialize graphics operation

	lea	cddaParam,a0					; Play music
	move.w	#8,(a0)
	BIOS_MSCPLAYR

	moveq	#CBID_BUS,d0					; Play bus sounds
	jsr	CBPCM_Play

	GIVE_WORD_ACCESS					; Swap Word RAM access

; -------------------------------------------------------------------------

.MainLoop:
.WaitAccess:
	tst.b	MAIN_FLAG.w					; Is it time to exit
	beq.w	.Exit						; If so, branch
	tst.b	COMM_CMD_4.w					; Are we paused?
	bne.w	.Paused						; If so, branch

	CHECK_WORD_ACCESS					; Wait for Word RAM access
	beq.s	.WaitAccess

	bsr.w	RunGfxOperation					; Start operation
	bsr.w	UpdateObjects					; Update objects

.WaitGfx:
	tst.b	GFX_CTRL.w					; Wait for the operation to be finished
	bmi.s	.WaitGfx
	
	tst.b	gameOverSub					; Game already over?
	bne.s	.FrameDone					; If so, branch

	move.b	timerInc,d0					; Handle timer increment
	beq.s	.NoTimerInc
	subq.b	#1,timerInc
	addq.b	#1,timerSub
	move.b	#FPS_DEST-1,timerSub+1
	bra.s	.FrameDone

.NoTimerInc:
	tst.b	timerPaused					; Check timer pause
	bne.s	.FrameDone

	subq.b	#1,timerSub+1					; Handle timer
	bpl.s	.FrameDone
	move.b	#FPS_DEST-1,timerSub+1
	subq.b	#1,timerSub
	bne.s	.FrameDone

	bset	#6,playerObject+oFlags				; Time over
	clr.l	arrowObject
	clr.l	destArrowObject
	move.b	#3,gameOverSub

.FrameDone:
	GIVE_WORD_ACCESS					; Swap Word RAM access
	bra.w	.MainLoop					; Loop
	
; -------------------------------------------------------------------------

.Exit:
	jsr	CBPCM_Stop					; Stop sound
	jsr	StopAllPCM
	clr.l	int2Routine
	
	GIVE_WORD_ACCESS					; Exit
	rts

; -------------------------------------------------------------------------

.Paused:
	BIOS_MSCPAUSEON
	jsr	CBPCM_Pause

.PauseLoop:
	tst.b	COMM_CMD_4.w
	bne.s	.PauseLoop

	BIOS_MSCPAUSEOFF
	jsr	CBPCM_Unpause
	bra.w	.MainLoop

; -------------------------------------------------------------------------
; Libraries
; -------------------------------------------------------------------------

	include	"source/special/object.asm"
	include	"source/special/render.asm"
	include	"source/special/map.asm"
	include	"source/libraries/Kosinski Decompression.asm"
	include	"source/special/math.asm"
	
; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"source/special/objects/bus.asm"
	include	"source/special/objects/person.asm"
	include	"source/special/objects/sign.asm"
	include	"source/special/objects/tree.asm"
	include	"source/special/objects/arrow.asm"
	include	"source/special/objects/destination.asm"
	
; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Stamps:
	incbin	"source/special/data/stamps.kos"
	even
Map:
	incbin	"source/special/data/map.kos"
	even
ObjectMap:
	incbin	"source/special/data/objects.bin"
	even
	
; -------------------------------------------------------------------------
; PCM samples
; -------------------------------------------------------------------------

PCM_Scream:
	incbin	"source/special/pcm/scream.pcm"
PCM_ScreamLoop:
	dcb.b	$20, $00
	dcb.b	$20, $FF
	even
PCM_ScreamEnd:

PCM_Sign:
	incbin	"source/special/pcm/sign.pcm"
PCM_SignLoop:
	dcb.b	$20, $00
	dcb.b	$20, $FF
	even
PCM_SignEnd:
	
; -------------------------------------------------------------------------
