; -------------------------------------------------------------------------
; PCM interface library
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; PCM register write
; -------------------------------------------------------------------------
; PARAMETERS:
;	val   - Value to write
;	reg   - Register to write to
;	delay - Register for handling delay
; -------------------------------------------------------------------------

PCM_WRITE macro val, reg, delay
	move.b	\val,\reg
	moveq	#20,\delay
	dbf	\delay,*
	endm
	
; -------------------------------------------------------------------------
; Initialize
; -------------------------------------------------------------------------

InitPCM:
	moveq	#-1,d0						; Disable PCM channels
	move.b	d0,pcmOnOff
	PCM_WRITE d0,PCM_ENABLE,d0
	
	moveq	#$FFFFFF80,d1					; Initial wave bank
	moveq	#16-1,d2					; Fill 16 wave banks
	
.BankLoop:
	PCM_WRITE d1,PCM_CTRL,d0				; Select wave bank
	PCM_WRITE d1,PCM_CTRL,d0
	
	lea	WAVE_START,a1					; Fill wave bank with loop flags
	move.w	#$1000-1,d0
	
.FillBank:
	move.b	#$FF,(a1)+
	addq.w	#1,a1
	dbf	d0,.FillBank
	
	addq.b	#1,d1						; Next bank
	dbf	d2,.BankLoop					; Loop until all banks are filled
	
	moveq	#$FFFFFFC0,d1					; Initial channel
	moveq	#8-1,d2						; 8 registers
	moveq	#0,d3						; Zero
	
	lea	pcmFreqs(pc),a0					; Saved frequencies
	lea	pcmVolumes(pc),a1				; Saved volumes
	
.InitRegs:
	PCM_WRITE d1,PCM_CTRL,d0				; Set register ID
	
	PCM_WRITE d3,PCM_ENV,d0					; Mute channel
	PCM_WRITE #$FF,PCM_PAN,d0				; Set panning
	PCM_WRITE d3,PCM_FDL,d0					; Clear frequency
	PCM_WRITE d3,PCM_FDH,d0
	PCM_WRITE d3,PCM_LSL,d0					; Reset loop address
	PCM_WRITE d3,PCM_LSH,d0
	PCM_WRITE d3,PCM_ST,d0					; Reset start address
	
	clr.w	(a0)+						; Reset saved frequency and volume
	clr.b	(a1)+
	
	addq.b	#1,d1						; Next register
	dbf	d2,.InitRegs					; Loop until registers are set up
	rts
	
; -------------------------------------------------------------------------
; Load PCM sample
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Sample pointer
;	d0.w - Sample size
;	d1.w - Start address
; -------------------------------------------------------------------------

LoadPCMSample:
	move.w	d1,-(sp)					; Get initial wave bank setting
	move.b	(sp)+,d2
	lsr.b	#4,d2
	tas.b	d2

	andi.w	#$F00,d1					; Get initial wave bank address
	lea	WAVE_START,a1
	adda.w	d1,a1
	adda.w	d1,a1
	
	subi.w	#$1000,d1					; Get leftover space in initial wave bank
	neg.w	d1
	bra.s	.GetCopyLength
	
.NextBank:
	move.w	#$1000,d1					; Wave bank size
	lea	WAVE_START,a1					; Wave bank address
	
.GetCopyLength:
	cmp.w	d1,d0						; Can the rest of the sample fit in the bank?
	bcc.s	.StartCopy					; If not, branch
	move.w	d0,d1						; If so, just copy what's left

.StartCopy:
	move.w	d1,d3						; Prepare copy length
	subq.w	#1,d1
	bmi.s	.Done
	
	PCM_WRITE d2,PCM_CTRL,d4				; Set wave bank
	PCM_WRITE d2,PCM_CTRL,d4

.CopySample:
	move.b	(a0)+,(a1)+					; Copy sample
	addq.w	#1,a1
	dbf	d1,.CopySample					; Loop until bank is set up
	
	addq.b	#1,d2						; Next wave bank
	sub.w	d3,d0						; Subtract copy length
	beq.s	.Done						; If there's nothing left, branch
	bpl.s	.NextBank					; If there's data left, loop
	
.Done:
	rts
	
; -------------------------------------------------------------------------
; Set PCM channel volume
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
;	d1.b - Volume
; -------------------------------------------------------------------------

SetPCMVolume:
	move.b	d0,d2						; Set register ID
	ori.b	#$C0,d0
	PCM_WRITE d0,PCM_CTRL,d3
	
	lea	pcmVolumes(pc),a6				; Save volume
	andi.w	#7,d2
	move.b	d1,(a6,d2.w)
	
	PCM_WRITE d1,PCM_ENV,d3					; Set volume
	rts
	
; -------------------------------------------------------------------------
; Set PCM channel panning
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
;	d1.b - Panning
; -------------------------------------------------------------------------

SetPCMPanning:
	ori.b	#$C0,d0						; Set register ID
	PCM_WRITE d0,PCM_CTRL,d2
	
	PCM_WRITE d1,PCM_PAN,d2					; Set panning
	rts

; -------------------------------------------------------------------------
; Set PCM channel frequency
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
;	d1.w - Frequency
; -------------------------------------------------------------------------

SetPCMFrequency:
	move.b	d0,d2						; Set register ID
	ori.b	#$C0,d0
	PCM_WRITE d0,PCM_CTRL,d3
	
	lea	pcmFreqs(pc),a6					; Save frequency
	andi.w	#7,d2
	add.b	d2,d2
	move.w	d1,(a6,d2.w)
	
	PCM_WRITE d1,PCM_FDL,d3					; Set frequency
	move.w	d1,-(sp)
	PCM_WRITE (sp)+,PCM_FDH,d3
	rts

; -------------------------------------------------------------------------
; Set PCM channel start wave address
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
;	d1.b - Start address
; -------------------------------------------------------------------------

SetPCMStart:
	ori.b	#$C0,d0						; Set register ID
	PCM_WRITE d0,PCM_CTRL,d2
	
	PCM_WRITE d1,PCM_ST,d2					; Set start address
	rts
	
; -------------------------------------------------------------------------
; Set PCM channel loop wave address
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
;	d1.w - Loop address
; -------------------------------------------------------------------------

SetPCMLoop:
	ori.b	#$C0,d0						; Set register ID
	PCM_WRITE d0,PCM_CTRL,d2
	
	PCM_WRITE d1,PCM_LSL,d2					; Set loop address
	move.w	d1,-(sp)
	PCM_WRITE (sp)+,PCM_LSH,d2
	rts

; -------------------------------------------------------------------------
; Play PCM channel
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
; -------------------------------------------------------------------------

PlayPCM:
	bsr.s	StopPCM
	bclr	d0,pcmOnOff
	PCM_WRITE pcmOnOff(pc),PCM_ENABLE,d1
	rts
	
; -------------------------------------------------------------------------
; Stop PCM channel
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
; -------------------------------------------------------------------------

StopPCM:
	bset	d0,pcmOnOff
	PCM_WRITE pcmOnOff(pc),PCM_ENABLE,d1
	rts
	
; -------------------------------------------------------------------------
; Stop all PCM channels
; -------------------------------------------------------------------------

StopAllPCM:
	st	pcmOnOff
	PCM_WRITE pcmOnOff(pc),PCM_ENABLE,d1
	rts

; -------------------------------------------------------------------------
; Pause PCM channel
; -------------------------------------------------------------------------

PausePCM:
	ori.b	#$C0,d0						; Set register ID
	PCM_WRITE d0,PCM_CTRL,d1
	
	moveq	#0,d1						; Pause
	PCM_WRITE d1,PCM_ENV,d2
	PCM_WRITE d1,PCM_FDL,d2
	PCM_WRITE d1,PCM_FDH,d2
	rts
	
; -------------------------------------------------------------------------
; Unpause PCM channel
; -------------------------------------------------------------------------

UnpausePCM:
	move.b	d0,d1						; Set register ID
	ori.b	#$C0,d0
	PCM_WRITE d0,PCM_CTRL,d2
	
	andi.w	#7,d1						; Restore volume
	move.b	pcmVolumes(pc,d1.w),d2
	PCM_WRITE d2,PCM_ENV,d2
	
	add.b	d1,d1						; Restore frequency
	move.b	pcmFreqs+1(pc,d1.w),d2
	PCM_WRITE d2,PCM_FDL,d2
	move.b	pcmFreqs(pc,d1.w),d2
	PCM_WRITE d2,PCM_FDH,d2
	rts

; -------------------------------------------------------------------------
; PCM register data
; -------------------------------------------------------------------------

pcmOnOff:
	dc.b	%11111111
	even
pcmFreqs:
	dcb.w	8, 0
pcmVolumes:
	dcb.b	8, 0

; -------------------------------------------------------------------------
; Pause all PCM channels
; -------------------------------------------------------------------------

PauseAllPCM:
	moveq	#0,d0						; Pause channels
	bsr.w	PausePCM
	moveq	#1,d0
	bsr.w	PausePCM
	moveq	#2,d0
	bsr.w	PausePCM
	moveq	#3,d0
	bsr.w	PausePCM
	moveq	#4,d0
	bsr.w	PausePCM
	moveq	#5,d0
	bsr.w	PausePCM
	moveq	#6,d0
	bsr.w	PausePCM
	moveq	#7,d0
	bra.w	PausePCM

; -------------------------------------------------------------------------
; Unpause all PCM channels
; -------------------------------------------------------------------------

UnpauseAllPCM:
	moveq	#0,d0						; Pause channels
	bsr.w	UnpausePCM
	moveq	#1,d0
	bsr.w	UnpausePCM
	moveq	#2,d0
	bsr.w	UnpausePCM
	moveq	#3,d0
	bsr.w	UnpausePCM
	moveq	#4,d0
	bsr.w	UnpausePCM
	moveq	#5,d0
	bsr.w	UnpausePCM
	moveq	#6,d0
	bsr.w	UnpausePCM
	moveq	#7,d0
	bra.w	UnpausePCM

; -------------------------------------------------------------------------
