; -------------------------------------------------------------------------
; Main program
; -------------------------------------------------------------------------

	include	"src/include/main_cpu.inc"
	include	"src/sound/crazybus_pcm.inc"
	include	"src/sound/crazybus_ids.inc"
	include	"src/Constants.asm"
	include	"src/Variables.asm"
	include	"src/Macros.asm"

	org	RAM_START&$FFFFFF

; -------------------------------------------------------------------------
; Main function
; -------------------------------------------------------------------------

	bra.w	MainStart

; -------------------------------------------------------------------------
; Libraries
; -------------------------------------------------------------------------

	include	"src/libraries/Sub CPU.asm"
	include	"src/libraries/Joypad.asm"
	include	"src/libraries/VDPSetupGame.asm"
	include	"src/libraries/ClearScreen.asm"
	include	"src/libraries/DMA Queue.asm"
	include	"src/libraries/PlaySound.asm"
	include	"src/libraries/PauseGame.asm"
	include	"src/libraries/TilemapToVRAM.asm"
	include	"src/libraries/Nemesis Decompression.asm"
	include	"src/libraries/PLC.asm"
	include	"src/libraries/Enigma Decompression.asm"
	include	"src/libraries/Kosinski Decompression.asm"
	include	"src/libraries/Palette Fade.asm"
	include	"src/libraries/Palette Load.asm"
	include	"src/libraries/WaitForVBla.asm"
	include	"src/libraries/RandomNumber.asm"
	include	"src/libraries/CalcSine.asm"
	include	"src/libraries/CalcAngle.asm"
	include	"src/libraries/ExecuteObjects.asm"
	include	"src/libraries/ObjectFall.asm"
	include	"src/libraries/SpeedToPos.asm"
	include	"src/libraries/AnimateSprite.asm"
	include	"src/libraries/DisplaySprite.asm"
	include	"src/libraries/DeleteObject.asm"
	include	"src/libraries/BuildSprites.asm"
	include	"src/libraries/ChkObjectVisible.asm"
	include	"src/libraries/Cheat.asm"

; -------------------------------------------------------------------------
; Sound driver
; -------------------------------------------------------------------------

	include	"src/sound/smps_sfx.asm"
	
; -------------------------------------------------------------------------
; Main function
; -------------------------------------------------------------------------

MainStart:
	lea	.FileSound(pc),a0				; Load CrazyBus PCM sound driver
	lea	SUB_PRG_START+$40000,a1
	bsr.w	LoadFileAsync

	bsr.w	RAMProgram					; Run Sega logo transition

	move	#$2700,sr					; Set up interrupts
	move.l	#BlankInt,_LEVEL4+2.w
	move.l	#BlankInt,_LEVEL6+2.w

	move.b	VERSION,d0					; Get region setting
	andi.b	#$C0,d0
	move.b	d0,v_megadrive.w

	lea	RAMProgram,a6					; Clear RAM
	moveq	#0,d7
	move.w	#($FC00-(RAMProgram&$FFFF))/4-1,d6

.ClearRAM:
	move.l	d7,(a6)+
	dbf	d6,.ClearRAM

	bsr.w	VDPSetupGame					; Initialize VDP
	bsr.w	InitSound					; Initialize sound
	bsr.w	JoypadInit					; Initialize controllers

.MainLoop:
	moveq	#0,d0						; Run game mode
	move.b	v_gamemode.w,d0
	jsr	.GameModes(pc,d0.w)
	bra.s	.MainLoop					; Loop

; -------------------------------------------------------------------------

.GameModes:
	bra.w	LoadTitle					; Title screen
	bra.w	LoadLevel					; Level
	bra.w	LoadSpecial					; Special stage
	bra.w	LoadEnding					; Ending
	bra.w	LoadCrazyBus3D					; CrazyBus 3D
	bra.w	LoadHongKong97					; Hong Kong 97
	bra.w	LoadImageGallery				; Image Gallery

; -------------------------------------------------------------------------
	
.FileSound:
	dc.b	"CBPCM.S68", 0
	even
	
; -------------------------------------------------------------------------
; Load title screen
; -------------------------------------------------------------------------

LoadTitle:
	lea	TitleFile(pc),a0				; Run title screen
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile
	jmp	WORD_START

; -------------------------------------------------------------------------

TitleFile:
	dc.b	"TITLE.M68", 0
	even

; -------------------------------------------------------------------------
; Load level
; -------------------------------------------------------------------------

LoadLevel:
	moveq	#0,d0						; Run level file
	move.b	v_zone.w,d0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	.Files(pc,d0.w),a0
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile
	jmp	WORD_START
	
; -------------------------------------------------------------------------

.Files:
	dc.l	.GHZ
	dc.l	.LZ
	dc.l	.MZ
	dc.l	.SLZ
	dc.l	.SYZ
	dc.l	.SBZ
	dc.l	.GHZ
	dc.l	.Secret

.GHZ:
	dc.b	"GHZ.M68", 0
	even
.LZ:
	dc.b	"LZ.M68", 0
	even
.MZ:
	dc.b	"MZ.M68", 0
	even
.SLZ:
	dc.b	"SLZ.M68", 0
	even
.SYZ:
	dc.b	"SYZ.M68", 0
	even
.SBZ:
	dc.b	"SBZ.M68", 0
	even
.Secret:
	dc.b	"SECRET.M68", 0
	even

; -------------------------------------------------------------------------
; Load special stage
; -------------------------------------------------------------------------

LoadSpecial:
	lea	.FileMain(pc),a0			; Load Main CPU special stage program
	bsr.w	LoadRAMProgram

	lea	.FileSub(pc),a0				; Load Sub CPU special stage program
	bsr.w	LoadSubModule
	
	lea	.FileData(pc),a0			; Load data file
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile

	bra.w	RAMProgram				; Run special stage

; -------------------------------------------------------------------------

.FileMain:
	dc.b	"SPECMAIN.M68", 0
	even
.FileSub:
	dc.b	"SPECSUB.S68", 0
	even
.FileData:
	dc.b	"SPECDATA.DAT", 0
	even

; -------------------------------------------------------------------------
; Load ending
; -------------------------------------------------------------------------

LoadEnding:
	lea	.File(pc),a0				; Run ending
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile
	jmp	WORD_START

; -------------------------------------------------------------------------

.File:
	dc.b	"END.M68", 0
	even

; -------------------------------------------------------------------------
; Load CrazyBus 3D
; -------------------------------------------------------------------------

LoadCrazyBus3D:
	lea	.FileMain(pc),a0			; Load Main CPU program
	bsr.w	LoadRAMProgram

	lea	.FileSub(pc),a0				; Load Sub CPU program
	bsr.w	LoadSubModule
	
	lea	.FileData(pc),a0			; Load data file
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile

	bra.w	RAMProgram				; Run CrazyBus 3D

; -------------------------------------------------------------------------

.FileMain:
	dc.b	"BUS3DMAIN.M68", 0
	even
.FileSub:
	dc.b	"BUS3DSUB.S68", 0
	even
.FileData:
	dc.b	"BUS3DDATA.DAT", 0
	even
	
; -------------------------------------------------------------------------
; Load Hong Kong 97
; -------------------------------------------------------------------------

LoadHongKong97:
	lea	.FileMain(pc),a0			; Load Main CPU program
	bsr.w	LoadRAMProgram
	
	lea	.FileSub(pc),a0				; Load Sub CPU program
	bsr.w	LoadSubModule
	
	lea	.FileData(pc),a0			; Load data file
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile
	
	bra.w	RAMProgram				; Run Hong Kong 97

; -------------------------------------------------------------------------

.FileMain:
	dc.b	"HK97MAIN.M68", 0
	even
.FileSub:
	dc.b	"HK97SUB.S68", 0
	even
.FileData:
	dc.b	"HK97DATA.DAT", 0
	even
	
; -------------------------------------------------------------------------
; Load image gallery
; -------------------------------------------------------------------------

LoadImageGallery:
	lea	.File(pc),a0
	lea	SUB_WORD_START_2M,a1
	bsr.w	LoadFile
	jmp	WORD_START

; -------------------------------------------------------------------------

.File:
	dc.b	"MEME.M68", 0
	even

; -------------------------------------------------------------------------
; V-BLANK interrupt that only updates sound
; -------------------------------------------------------------------------

VInt_Sound:
	movem.l	d0-a6,-(sp)
	REQUEST_INT2
	clr.b	v_vbla_routine.w
	move.w	VDP_CTRL,d0
	bsr.w	UpdateSound
	movem.l	(sp)+,d0-a6

BlankInt:
	rte
	
; -------------------------------------------------------------------------

	if *>(RAM_START+$8000)&$FFFFFF
		inform 3,"Main program is too large by $%h bytes",(*&$FFFF)-$8000
	else
		inform 0,"Main program has $%h bytes free",$8000-(*&$FFFF)
	endif

; -------------------------------------------------------------------------
; Free space for program code
; -------------------------------------------------------------------------

RAMProgram:
	include	"src/sega/sega.asm"				; Have Sega logo program here by default
	
; -------------------------------------------------------------------------

	align	16

; -------------------------------------------------------------------------
