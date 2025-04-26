; -------------------------------------------------------------------------
; Sega logo transition
; -------------------------------------------------------------------------

	move.l	#SegaVInt,_LEVEL6+2.w				; Set up interrupts

	lea	VDP_CTRL,a0					; VDP control port
	lea	-4(a0),a1					; VDP data port

.WaitVBlankEnd:
	move	(a0),ccr					; Wait until start of V-BLANK
	bmi.s	.WaitVBlankEnd

.WaitVBlankStart:
	move	(a0),ccr
	bpl.s	.WaitVBlankStart

	move.w	#$8174,(a0)					; Enable DMA
	move.w	#$8B00,(a0)					; Scroll by screen

	VDP_CMD move.l,0,CRAM,READ,(a0)				; Copy palette from CRAM
	lea	v_pal_dry.w,a2
	moveq	#$80/4-1,d0

.GetPal:
	move.w	(a1),(a2)+
	move.w	(a1),(a2)+
	dbf	d0,.GetPal
	
	VDP_CMD move.l,$B800,VRAM,READ,(a0)			; Copy sprites from VRAM
	lea	v_spritetablebuffer.w,a2
	move.w	#$280/4-1,d0

.GetSprites:
	move.w	(a1),(a2)+
	move.w	(a1),(a2)+
	dbf	d0,.GetSprites

	clr.w	v_scrposx_dup.w					; Reset scroll position

	if REGION<>JAPAN					; Fade out sparkles and text
		move.w	#$002F,v_pfade_start.w
	else
		move.w	#$0200,v_pfade_start.w
	endif
	bsr.w	PalFadeOut_Alt
	
	bsr.w	FinishAsyncFileLoad				; Wait for sound driver to be loaded
	
	lea	CBPCM_Init,a1					; Initialize CrazyBus sound driver
	bsr.w	CallSubFunction
	
	moveq	#CBID_BUS,d0					; Play backing up sound
	lea	CBPCM_Play,a1
	bsr.w	CallSubFunction
	
	moveq	#1,d0
	lea	cbpcmMotorMode,a1
	bsr.w	WriteSubByte

	clr.l	v_spritetablebuffer.w				; Erase sprites

.Scroll:
	st	v_vbla_routine.w				; VSync
	bsr.w	WaitForVBla

	subq.w	#1,v_scrposx_dup.w				; Move Sega logo backwards
	cmpi.w	#-$100,v_scrposx_dup.w				; Has it moved off screen?
	bgt.s	.Scroll						; If not, loop

	moveq	#15-1,d0					; Set delay time

.Delay:
	st	v_vbla_routine.w				; VSync
	bsr.w	WaitForVBla
	dbf	d0,.Delay					; Loop until delay is over

	lea	CBPCM_Stop,a1					; Stop sound
	jmp	CallSubFunction

; -------------------------------------------------------------------------
; Vertical blank interrupt
; -------------------------------------------------------------------------

SegaVInt:
	move	#$2700,sr					; Disable interrupts
	movem.l	d0-a6,-(sp)					; Save registers
	
	REQUEST_INT2						; Request Sub CPU interrupt
	clr.b	v_vbla_routine.w				; Clear VSync flag
	
	lea	VDP_CTRL,a0					; VDP control port
	move.w	(a0),d0
	
	STOP_Z80
	DMA_68K v_pal_dry,0,$80,CRAM,(a0)			; Copy palette
	DMA_68K v_spritetablebuffer,$B800,$280,VRAM,(a0)	; Copy sprites
	START_Z80

	VDP_CMD move.l,$BC00,VRAM,WRITE,(a0)			; Copy horizontal scroll data
	move.l	v_scrposx_dup.w,-4(a0)
	
	movem.l	(sp)+,d0-a6					; Restore registers
	rte

; -------------------------------------------------------------------------
