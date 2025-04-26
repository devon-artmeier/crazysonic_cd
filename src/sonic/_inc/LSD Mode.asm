; -------------------------------------------------------------------------
; LSD mode
; -------------------------------------------------------------------------

InitLSDMode:
	bset	#LSD_MODE,effectFlags.w	
	bne.s	.Started

	move.w	#$8B07,VDP_CTRL
	move.l	#LSDColorTable,lsdColors.w
	move.l	#Sine_Data,lsdSine.w
	clr.w	lsdDelay.w
	move.w	#60*30,lsdTimer.w
	bra.w	PlayEffectMusic
	
.Started:
	rts

; -------------------------------------------------------------------------

StopLSDMode:
	bclr	#LSD_MODE,effectFlags.w	
	beq.s	.Ended
	move.w	#$8B03,VDP_CTRL
	bra.w	PlayEffectMusic
	
.Ended:
	rts
	
; -------------------------------------------------------------------------

UpdateLSDTimer:
	btst	#LSD_MODE,effectFlags.w			; Check if on
	beq.s	.End
	
	tst.l	warpX.w					; Handle delay
	bne.s	.CheckLSDOver
	subq.w	#1,lsdDelay.w
	bpl.s	.CheckLSDOver
	move.w	#16,lsdDelay.w
	
	addq.l	#2,lsdColors.w				; Advance color table
	cmpi.l	#LSDColorTableEnd,lsdColors.w
	bcs.s	.CheckLSDOver
	move.l	#LSDColorTable,lsdColors.w
	
.CheckLSDOver:
	subq.w	#1,lsdTimer.w				; Handle timer
	bne.s	.End
	bclr	#LSD_MODE,effectTriggers.w
	
.End:
	rts

; -------------------------------------------------------------------------

UpdateLSDMode:
	btst	#LSD_MODE,effectTriggers.w		; Check trigger
	beq.s	StopLSDMode
	bsr.w	InitLSDMode

	btst	#LSD_MODE,effectFlags.w			; Check mode
	beq.w	.End

	btst	#RAVE_MODE,effectFlags.w		; Update palette
	bne.s	.HScroll
	lea	effectWaterPal.w,a0
	movea.l	lsdColors.w,a1
	moveq	#$80-1,d0
	
.Convert:
	move.w	(a1)+,d1				; Set color
	bpl.s	.NoWrap
	lea	LSDColorTable(pc),a1
	move.w	(a1)+,d1
	
.NoWrap:
	move.w	d1,(a0)+
	dbf	d0,.Convert				; Loop

; -------------------------------------------------------------------------

.HScroll:
	lea	v_hscrolltablebuffer.w,a0		; Update HScroll
	movea.l	lsdSine.w,a1
	move.w	#$E0-1,d0
	
.HScrollSet:
	move.w	(a1)+,d1				; Add sine offset
	addq.w	#4,a1
	asr.w	#5,d1
	add.w	d1,(a0)+
	add.w	d1,(a0)+
	
	cmpa.l	#Sine_Data_End,a1			; Wrap
	bcs.s	.HScrollLoop
	suba.w	#Sine_Data_End-Sine_Data,a1
	
.HScrollLoop:
	dbf	d0,.HScrollSet				; Loop
	
; -------------------------------------------------------------------------

.VScroll:
	lea	lsdVScroll.w,a0				; Update VScroll
	movea.l	lsdSine.w,a1
	move.w	#$14-1,d0
	
.VScrollSet:
	move.w	(a1)+,d1				; Add sine offset
	adda.w	#32,a1
	asr.w	#5,d1
	move.l	v_scrposy_dup.w,d2
	swap	d2
	add.w	d1,d2
	swap	d2
	add.w	d1,d2
	move.l	d2,(a0)+
	
	cmpa.l	#Sine_Data_End,a1			; Wrap
	bcs.s	.VScrollLoop
	suba.w	#Sine_Data_End-Sine_Data,a1
	
.VScrollLoop:
	dbf	d0,.VScrollSet				; Loop

; -------------------------------------------------------------------------

.Sprites:
	lea	v_spritetablebuffer.w,a0		; Update sprites
	lea	v_hscrolltablebuffer.w,a1
	lea	lsdVScroll.w,a2
	moveq	#0,d0
	move.b	v_spritecount.w,d0
	subq.w	#1,d0
	bmi.s	.NoSprites
	
.SpriteSet:
	move.w	(a0),d1					; Get position
	move.w	6(a0),d2
	
	subi.w	#128,d2					; Y position
	bpl.s	.NoNegX
	moveq	#0,d2
	
.NoNegX:
	cmpi.w	#320,d2
	bcc.s	.NoX
	lsr.w	#2,d2
	andi.w	#~3,d2
	move.w	(a2,d2.w),d2
	sub.w	v_screenposy.w,d2
	sub.w	d2,(a0)
	
.NoX:
	subi.w	#128,d1					; X position
	bpl.s	.NoNegY
	moveq	#0,d1
	
.NoNegY:
	cmpi.w	#224,d1
	bcc.s	.NoY
	add.w	d1,d1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	add.w	v_screenposx.w,d1
	add.w	d1,6(a0)
	
.NoY:
	lea	8(a0),a0				; Next sprite
	dbf	d0,.SpriteSet				; Loop
	
; -------------------------------------------------------------------------

.NoSprites:
	addq.l	#2,lsdSine.w				; Check wrapping
	cmpi.l	#Sine_Data_End,lsdSine.w
	bcs.s	.End
	move.l	#Sine_Data,lsdSine.w

.End:
	rts
	
; -------------------------------------------------------------------------

.SpriteOffsets:
	dc.b	4, 8, 12, 16

; -------------------------------------------------------------------------

LSD_COLOR macro c1, c2
	local r1,r2,g1,g2,b1,b2,ri,gi,bi,c,p

	r1: = ((\c1)&$E)<<8
	g1: = (((\c1)>>4)&$E)<<8
	b1: = (((\c1)>>8)&$E)<<8
	r2: = ((\c2)&$E)<<8
	g2: = (((\c2)>>4)&$E)<<8
	b2: = (((\c2)>>8)&$E)<<8

	ri: = (r2-r1)/7
	gi: = (g2-g1)/7
	bi: = (b2-b1)/7
	p: = -1

	dc.w	\c1
	rept 7-1
		r1: = r1+ri
		g1: = g1+gi
		b1: = b1+bi
		c: = (b1&$E00)|((g1>>4)&$E0)|((r1>>8)&$E)
		if c<>p
			dc.w	c
		endif
		p: = c
	endr
	endm

; -------------------------------------------------------------------------

LSDColorTable:
	LSD_COLOR $88E, $8EE
	LSD_COLOR $8EE, $8E8
	LSD_COLOR $8E8, $EE8
	LSD_COLOR $EE8, $E68
	LSD_COLOR $E88, $E8E
	LSD_COLOR $E8E, $88E
LSDColorTableEnd:
	dc.w	-1
	
; -------------------------------------------------------------------------
