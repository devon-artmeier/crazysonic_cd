; -------------------------------------------------------------------------
; Title screen
; -------------------------------------------------------------------------

	include	"src/include/main_cpu.inc"
	include	"src/include/main_program.inc"
	include	"src/sound/crazybus_pcm.inc"
	include	"src/sound/crazybus_ids.inc"
	include	"src/Constants.asm"
	include	"src/Variables.asm"
	include	"src/Macros.asm"

	org	WORD_START

; -------------------------------------------------------------------------
; Program
; -------------------------------------------------------------------------

	move	#$2700,sr					; Run title screen
	move.l	#CrazyBusVInt,_LEVEL6+2.w
	bsr.w	CrazyBusTitle
	
	jmp	MainMenu					; Run main menu

; -------------------------------------------------------------------------

	include	"src/crazybus/functions.asm"
	include	"src/crazybus/title.asm"
	include	"src/crazybus/title_data.asm"
	include	"src/title/menu.asm"

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

decompBuffer	EQU	WORD_START+$30000

; -------------------------------------------------------------------------
