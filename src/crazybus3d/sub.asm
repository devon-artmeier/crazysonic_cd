; -------------------------------------------------------------------------
; CrazyBus 3D (Sub CPU)
; -------------------------------------------------------------------------

	include	"src/include/sub_cpu.inc"
	include	"src/include/sub_program.inc"
	include	"src/sound/crazybus_pcm.inc"
	include	"src/sound/crazybus_ids.inc"
	include	"src/crazybus3d/map.inc"
	include	"src/crazybus3d/sub_variables.inc"
	
	org	PRG_START+$10000
	
; -------------------------------------------------------------------------

	rsset	WORD_START_2M+$1C000
	include	"src/crazybus3d/shared.inc"
	
; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

CrazyBus3D:
	jsr	CBPCM_Init					; Initialize sound driver
	
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
	
	move.l	#ObjBus,playerObject				; Spawn bus
	
	bsr.w	LoadStageMap					; Load stage map
	bsr.w	UpdateObjects					; Update objects
	bsr.w	InitGfxOperation				; Initialize graphics operation

	moveq	#CBID_BUS,d0					; Play bus sounds
	jsr	CBPCM_Play

	GIVE_WORD_ACCESS					; Swap Word RAM access

; -------------------------------------------------------------------------

.MainLoop:
.WaitAccess:
	tst.b	MAIN_FLAG.w					; Is it time to exit
	beq.w	.Exit						; If so, branch
	CHECK_WORD_ACCESS					; Wait for Word RAM access
	beq.s	.WaitAccess

	bsr.w	RunGfxOperation					; Start operation
	bsr.w	UpdateObjects					; Update objects

.WaitGfx:
	tst.b	GFX_CTRL.w					; Wait for the operation to be finished
	bmi.s	.WaitGfx

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
; Libraries
; -------------------------------------------------------------------------

	include	"src/crazybus3d/object.asm"
	include	"src/crazybus3d/render.asm"
	include	"src/crazybus3d/map.asm"
	include	"src/libraries/Kosinski Decompression.asm"
	include	"src/crazybus3d/math.asm"
	
; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------

	include	"src/crazybus3d/objects/bus.asm"
	
; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Stamps:
	incbin	"src/crazybus3d/data/stamps.kos"
	even
Map:
	incbin	"src/crazybus3d/data/map.kos"
	even
	
; -------------------------------------------------------------------------
