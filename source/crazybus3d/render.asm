; -------------------------------------------------------------------------
; Initialize 3D sprite positioning
; -------------------------------------------------------------------------

Init3DSpritePos:
	lea	gfxVars,a6					; Graphics operations variables
	
	move.w	gfxFOV(a6),d0					; FOV * cos(yaw)
	muls.w	gfxYawCos(a6),d0
	asr.l	#8,d0
	move.w	d0,gfxYcFOV(a6)
	
	move.w	gfxFOV(a6),d0					; FOV * sin(yaw)
	muls.w	gfxYawSin(a6),d0
	asr.l	#8,d0
	move.w	d0,gfxYsFOV(a6)
	rts

; -------------------------------------------------------------------------
; Generate trace table
; -------------------------------------------------------------------------

GenGfxTraceTbl:
	lea	WORD_START_2M+TRACE_TABLE,a5			; Trace table buffer
	
	move.w	gfxCamX(a6),d0					; Camera X
	lsl.w	#3,d0
	move.w	gfxCamY(a6),d1					; Camera Y
	lsl.w	#3,d1

	move.w	#-3,d2						; Initial line ID
	moveq	#8,d6						; 8 bit shifts
	
	move.w	gfxPitchCos(a6),d3				; cos(pitch) * sin(yaw)
	muls.w	gfxYawSin(a6),d3
	asr.l	#5,d3
	move.w	d3,gfxPcYs(a6)

	move.w	gfxPitchCos(a6),d3				; cos(pitch) * cos(yaw)
	muls.w	gfxYawCos(a6),d3
	asr.l	#5,d3
	move.w	d3,gfxPcYc(a6)

	move.w	gfxFOV(a6),d4					; FOV * sin(pitch) * sin(yaw)
	move.w	d4,d3
	muls.w	gfxPitchSin(a6),d3
	muls.w	gfxYawSin(a6),d3
	asr.l	#5,d3
	move.l	d3,gfxPsYsFOV(a6)
	
	move.w	d4,d3						; FOV * sin(pitch) * cos(yaw)
	muls.w	gfxPitchSin(a6),d3
	muls.w	gfxYawCos(a6),d3
	asr.l	#5,d3
	move.l	d3,gfxPsYcFOV(a6)

	move.w	d4,d3						; FOV * cos(pitch)
	muls.w	gfxPitchCos(a6),d3
	move.l	d3,gfxPcFOV(a6)

	move.w	#-128,d3					; -128 * cos(yaw)
	muls.w	gfxYawCos(a6),d3
	lsl.l	#3,d3
	movea.l	d3,a1

	move.w	#-128,d3					; -128 * sin(yaw)
	muls.w	gfxYawSin(a6),d3
	lsl.l	#3,d3
	movea.l	d3,a2

	move.w	#127,d3						; 127 * cos(yaw)
	muls.w	gfxYawCos(a6),d3
	lsl.l	#3,d3
	movea.l	d3,a3

	move.w	#127,d3						; 127 * sin(yaw)
	muls.w	gfxYawSin(a6),d3
	lsl.l	#3,d3
	movea.l	d3,a4
	
	move.w	gfxPitchSin(a6),d4				; (sin(pitch) * sin(yaw)) * (FOV + gfxCenter)
	muls.w	gfxYawSin(a6),d4
	asr.l	#5,d4
	move.w	gfxFOV(a6),d3
	add.w	gfxCenter(a6),d3
	muls.w	d4,d3
	asr.l	d6,d3
	move.w	d3,gfxCenterX(a6)

	move.w	gfxPitchSin(a6),d4				; (sin(pitch) * cos(yaw)) * (FOV + gfxCenter)
	muls.w	gfxYawCos(a6),d4
	asr.l	#5,d4
	move.w	gfxFOV(a6),d3
	add.w	gfxCenter(a6),d3
	muls.w	d4,d3
	asr.l	d6,d3
	move.w	d3,gfxCenterY(a6)
	
	move.w	#IMG_HEIGHT-3-1,d7				; Number of lines

; -------------------------------------------------------------------------

.GenLoop:
	; X point = -(line * cos(pitch) * sin(yaw)) + (FOV * sin(pitch) * sin(yaw))
	; Y point =  (line * cos(pitch) * cos(yaw)) - (FOV * sin(pitch) * cos(yaw))
	; Z point =  (line * sin(pitch)) + (FOV * cos(pitch))

	; Shear left X  = Camera X + (((-128 * cos(yaw)) + X point) * (Camera Z / Z point)) - Center X
	; Shear left Y  = Camera Y + (((-128 * sin(yaw)) + Y point) * (Camera Z / Z point)) + Center Y
	; Shear right X = Camera X + (((127 * cos(yaw)) + X point) * (Camera Z / Z point)) - Center X
	; Shear right Y = Camera Y + (((127 * sin(yaw)) + Y point) * (Camera Z / Z point)) + Center Y

	move.w	d2,d3						; Z point
	muls.w	gfxPitchSin(a6),d3
	add.l	gfxPcFOV(a6),d3
	asr.l	#5,d3
	bne.s	.NotZero
	moveq	#1,d3

.NotZero:
	move.l	a1,d4						; X start = Shear left X
	move.w	gfxPcYs(a6),d5
	muls.w	d2,d5
	sub.l	d5,d4
	add.l	gfxPsYsFOV(a6),d4
	asr.l	d6,d4
	muls.w	gfxCamZ(a6),d4
	divs.w	d3,d4
	add.w	d0,d4
	sub.w	gfxCenterX(a6),d4
	move.w	d4,(a5)+
	
	move.l	a2,d4						; Y start = Shear left Y
	move.w	gfxPcYc(a6),d5
	muls.w	d2,d5
	add.l	d5,d4
	sub.l	gfxPsYcFOV(a6),d4
	asr.l	d6,d4
	muls.w	gfxCamZ(a6),d4
	divs.w	d3,d4
	add.w	d1,d4
	add.w	gfxCenterY(a6),d4
	move.w	d4,(a5)+

	move.l	a3,d4						; X delta = Shear right X - Shear left X
	move.w	gfxPcYs(a6),d5
	muls.w	d2,d5
	sub.l	d5,d4
	add.l	gfxPsYsFOV(a6),d4
	asr.l	d6,d4
	muls.w	gfxCamZ(a6),d4
	divs.w	d3,d4
	add.w	d0,d4
	sub.w	gfxCenterX(a6),d4
	sub.w	-4(a5),d4
	move.w	d4,(a5)+
	
	move.l	a4,d4						; Y delta = Shear right Y - Shear left Y
	move.w	gfxPcYc(a6),d5
	muls.w	d2,d5
	add.l	d5,d4
	sub.l	gfxPsYcFOV(a6),d4
	asr.l	d6,d4
	muls.w	gfxCamZ(a6),d4
	divs.w	d3,d4
	add.w	d1,d4
	add.w	gfxCenterY(a6),d4
	sub.w	-4(a5),d4
	move.w	d4,(a5)+
	
	subq.w	#1,d2						; Next line
	dbf	d7,.GenLoop					; Loop until entire table is generated
	rts

; -------------------------------------------------------------------------
; Initialize graphics operation
; -------------------------------------------------------------------------

InitGfxOperation:
	lea	gfxVars,a1					; Graphics operations variables
	
	move.w	#%111,GFX_CTRL.w				; 32x32 stamps, 4096x4096 map, repeated
	move.w	#IMG_TILES_Y-1,GFX_STRIDE.w			; Image buffer stride
	move.w	#IMG_BUFFER/4,GFX_CANVAS.w			; Image buffer address
	move.w	#0,GFX_OFFSET.w					; Image buffer offset
	move.w	#IMG_WIDTH,GFX_WIDTH.w				; Image buffer width
	
	andi.b	#%11100111,MEMORY_MODE.w			; Set to normal mode
	
	move.w	#$80,gfxFOV(a1)					; Set FOV
	move.w	#-$28,gfxCenter(a1)				; Set center point
	rts

; -------------------------------------------------------------------------
; Run graphics operation
; -------------------------------------------------------------------------

RunGfxOperation:
	lea	gfxVars,a6					; Graphics operations variables

	move.w	gfxPitch(a6),d3					; sin(pitch)
	bsr.w	GetSine
	move.w	d3,gfxPitchSin(a6)

	move.w	gfxPitch(a6),d3					; cos(pitch)
	bsr.w	GetCosine
	move.w	d3,gfxPitchCos(a6)

	move.w	gfxYaw(a6),d3					; sin(yaw)
	bsr.w	GetSine
	move.w	d3,gfxYawSin(a6)
	
	move.w	gfxYaw(a6),d3					; cos(yaw)
	bsr.w	GetCosine
	move.w	d3,gfxYawCos(a6)

	bsr.w	GenGfxTraceTbl					; Generate trace table

RunNextGfxOp:
	move.w	#STAMP_MAP/4,GFX_MAP.w				; Stamp map
	move.w	#IMG_HEIGHT-3,GFX_HEIGHT.w			; Image buffer height
	move.w	#TRACE_TABLE/4,GFX_TRACE.w			; Set trace table and start operation
	rts

; -------------------------------------------------------------------------
