; -------------------------------------------------------------------------
; Title screen
; -------------------------------------------------------------------------

	include	"source/include/main_cpu.inc"
	include	"source/include/main_program.inc"
	include	"source/sound/crazybus_pcm.inc"
	include	"source/sound/crazybus_ids.inc"
	include	"source/Constants.asm"
	include	"source/Variables.asm"
	include	"source/Macros.asm"

	org	WORD_START

; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

	move	#$2700,sr					; Run title screen
	move.l	#CrazyBusVInt,_LEVEL6+2.w
	bsr.w	CrazyBusTitle
	
	jmp	MainMenu					; Run main menu

; -------------------------------------------------------------------------

	include	"source/crazybus/functions.asm"
	include	"source/crazybus/title.asm"
	include	"source/crazybus/title_data.asm"
	include	"source/title/menu.asm"

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

decompBuffer	EQU	WORD_START+$30000

; -------------------------------------------------------------------------
