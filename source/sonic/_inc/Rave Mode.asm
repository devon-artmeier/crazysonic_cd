; -------------------------------------------------------------------------
; Rave mode
; -------------------------------------------------------------------------

RAVE_BPM	EQU	135
RAVE_ACCUM	EQU	((RAVE_BPM*$10000)/3600)/2

; -------------------------------------------------------------------------

InitRaveMode:
	bset	#RAVE_MODE,effectFlags.w	
	bne.s	.Started

	move.l	#RaveColorTable,raveColors.w
	clr.w	raveDelay.w
	if REGION<>EUROPE
		move.w	#51*60,raveTimer.w
	else
		move.w	#((51*60)*50)/60,raveTimer.w
	endif
	bra.w	PlayEffectMusic
	
.Started:
	rts
	
; -------------------------------------------------------------------------

StopRaveMode:
	bclr	#RAVE_MODE,effectFlags.w	
	bne.w	PlayEffectMusic
	rts
	
; -------------------------------------------------------------------------

UpdateRaveTimer:
	btst	#RAVE_MODE,effectFlags.w		; Check if on
	beq.s	.End
	
	tst.l	warpX.w					; Handle delay
	bne.s	.CheckRaveOver
	if REGION<>EUROPE
		addi.w	#RAVE_ACCUM,raveDelay.w
	else
		addi.w	#(RAVE_ACCUM*60)/50,raveDelay.w
	endif
	bcc.s	.CheckRaveOver
	
	addq.l	#1,raveColors.w				; Advance color table	
	cmpi.l	#RaveColorTableEnd,raveColors.w	
	bcs.s	.CheckRaveOver
	move.l	#RaveColorTable,raveColors.w
	
.CheckRaveOver:
	subq.w	#1,raveTimer.w				; Handle timer
	bne.s	.End
	bclr	#RAVE_MODE,effectTriggers.w
	
.End:
	rts

; -------------------------------------------------------------------------

UpdateRaveMode:
	btst	#RAVE_MODE,effectTriggers.w		; Check trigger
	beq.s	StopRaveMode
	bsr.w	InitRaveMode

	btst	#RAVE_MODE,effectFlags.w		; Check mode
	beq.w	.End

	lea	v_pal_water.w,a0			; Update palette
	lea	effectWaterPal.w,a1
	movea.l	raveColors.w,a2
	lea	.ConvTable(pc),a3
	moveq	#$80-1,d0
	moveq	#7,d4
	
.Convert:
	move.w	(a0)+,d1				; Get color
	move.w	d1,d2
	move.w	d1,d3
	
	lsr.b	#1,d1					; Red
	and.w	d4,d1
	
	lsr.b	#5,d2					; Green
	and.w	d4,d2
	
	move.w	d3,-(sp)				; Blue
	move.b	(sp)+,d3
	lsr.b	#1,d3
	and.w	d4,d3
	
	add.w	d2,d1					; Combine
	add.w	d3,d1
	move.b	(a3,d1.w),d1
	
	move.b	(a2),d2					; Get flags
	
	lsr.b	#1,d2					; Check brighten
	bcc.s	.Start
	add.w	d1,d1
	cmpi.w	#$E,d1
	bcs.s	.Start
	moveq	#$E,d1
	
.Start:
	moveq	#0,d3					; Destination color
	
	lsr.b	#1,d2					; Red
	bcc.s	.NoRed
	or.w	d1,d3

.NoRed:
	lsl.w	#4,d1					; Green
	lsr.b	#1,d2
	bcc.s	.NoGreen
	or.w	d1,d3

.NoGreen:
	lsl.w	#4,d1					; Blue
	lsr.b	#1,d2
	bcc.s	.NoBlue
	or.w	d1,d3

.NoBlue:
	move.w	d3,(a1)+				; Set color
	dbf	d0,.Convert				; Loop
	
.End:
	rts
	
; -------------------------------------------------------------------------

.ConvTable:
	.c: = 0
	rept	22
		dc.b	(.c/3)*2
		.c: = .c+1
	endr

; -------------------------------------------------------------------------

RAVE_COLOR macro red,green,blue,bright
	dc.b	((\blue)<<3)|((\green)<<2)|((\red)<<1)|(\bright)
	endm

; -------------------------------------------------------------------------

RaveColorTable:
	RAVE_COLOR 1, 0, 0, 0
	RAVE_COLOR 0, 1, 0, 1
	RAVE_COLOR 0, 0, 1, 0
	RAVE_COLOR 0, 1, 1, 1
	RAVE_COLOR 1, 1, 0, 0
	RAVE_COLOR 1, 0, 1, 1
	RAVE_COLOR 0, 1, 1, 0
	RAVE_COLOR 0, 0, 1, 1
	RAVE_COLOR 0, 1, 0, 0
	RAVE_COLOR 1, 0, 0, 1
	RAVE_COLOR 1, 0, 1, 0
	RAVE_COLOR 1, 1, 0, 1	
RaveColorTableEnd:
	even
	
; -------------------------------------------------------------------------
