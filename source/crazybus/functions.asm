; -------------------------------------------------------------------------
; Vertical blank interrupt
; -------------------------------------------------------------------------

CrazyBusVInt:
	move	#$2700,sr					; Disable interrupts
	movem.l	d0-a6,-(sp)					; Save registers
	REQUEST_INT2						; Request Sub CPU interrupt

	clr.b	v_vbla_routine.w				; Clear VSync flag
	
	lea	VDP_CTRL,a5					; VDP control port
	move.w	(a5),d0

	STOP_Z80
	jsr	ReadJoypads					; Read controller data
	DMA_68K v_pal_dry,0,$80,CRAM,(a5)			; Copy palette
	START_Z80
	
	jsr	UpdateSound					; Update regular sound driver
	
	movem.l	(sp)+,d0-a6					; Restore registers
	rte

; -------------------------------------------------------------------------
; Draw text
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Text data
;	d0.l - VRAM write command
;	d1.w - Base tile ID
; -------------------------------------------------------------------------

DrawText:
	move.l	d0,VDP_CTRL					; Set write command
	
.Loop:
	moveq	#0,d2						; Get character
	move.b	(a0)+,d2
	beq.s	.End						; Branch if termination
	bmi.s	.NewLine					; Branch if new line

	cmpi.b	#' ',d2						; Is this character a space?
	bne.s	.NotSpace					; If not, branch
	moveq	#0,d2						; If so, draw blank

.NotSpace:
	add.w	d1,d2						; Add base tile and flags
	move.w	d2,VDP_DATA					; Draw character
	bra.s	.Loop						; Loop
	
.NewLine:
	addi.l	#$800000,d0					; Next line
	bra.s	DrawText					; Loop
	
.End:
	rts

; -------------------------------------------------------------------------
; Generate a random number
; -------------------------------------------------------------------------

CB_Random:
	move.l	d0,d2
	movem.l	cbRNGSeed(pc),d0-d1
	andi.b	#$E,d0
	ori.b	#$20,d0
	add.l	d0,d2
	move.l	d1,d3
	add.l	d2,d2
	addx.l	d3,d3
	add.l	d2,d0
	addx.l	d3,d1
	swap	d3
	swap	d2
	move.w	d2,d3
	clr.w	d2
	add.l	d2,d0
	addx.l	d3,d1
	movem.l	d0-d1,cbRNGSeed
	move.l	d1,d0
	rts

; -------------------------------------------------------------------------
; Generate a random number within a range
; -------------------------------------------------------------------------

CB_RandomRange:
	move.w	d0,d2						; Is this a valid range?
	beq.s	.End						; If not, branch
	
	movem.w	d2,-(sp)					; Generate random number
	bsr.s	CB_Random
	movem.w	(sp)+,d2
	
	clr.w	d0						; Keep within range
	swap	d0
	divu.w	d2,d0
	swap	d0

.End:
	rts

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

cbRNGSeed
	dcb.l	2, 0

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Art_CrazyBusFont:
	incbin	"source/crazybus/data/font_art.nem"
	even
Pal_CrazyBus:
	incbin	"source/crazybus/data/palette.bin"
	even

; -------------------------------------------------------------------------
