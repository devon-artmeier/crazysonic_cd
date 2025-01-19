; -------------------------------------------------------------------------
; PCM interface library
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; PCM register write
; -------------------------------------------------------------------------
; PARAMETERS:
;	dreg  - Register for handling delay
; -------------------------------------------------------------------------

PCM_DELAY macro dreg
	moveq	#$80-1,\dreg
	dbf	\dreg,*
	endm

; -------------------------------------------------------------------------
; Initialize
; -------------------------------------------------------------------------

InitPCM:
	moveq	#-1,d0						; Disable PCM channels
	move.b	d0,pcmOnOff
	move.b	d0,PCM_ENABLE
	PCM_DELAY d0
	
	moveq	#$FFFFFF80,d1					; Initial wave bank
	moveq	#16-1,d2					; Fill 16 wave banks
	
.BankLoop:
	move.b	d1,PCM_CTRL					; Select wave bank
	PCM_DELAY d0
	
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
	move.b	d1,PCM_CTRL					; Set register ID
	PCM_DELAY d0
	
	move.b	d3,PCM_ENV					; Mute channel
	PCM_DELAY d0
	move.b	#$FF,PCM_PAN					; Set panning
	PCM_DELAY d0
	move.b	d3,PCM_FDL					; Clear frequency
	PCM_DELAY d0
	move.b	d3,PCM_FDH
	PCM_DELAY d0
	move.b	d3,PCM_LSL					; Reset loop address
	PCM_DELAY d0
	move.b	d3,PCM_LSH
	PCM_DELAY d0
	move.b	d3,PCM_ST					; Reset start address
	PCM_DELAY d0
	
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
	
	move.b	d2,PCM_CTRL					; Set wave bank
	PCM_DELAY d4

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
	move.b	d0,PCM_CTRL
	PCM_DELAY d3
	
	lea	pcmVolumes(pc),a6				; Save volume
	andi.w	#7,d2
	move.b	d1,(a6,d2.w)
	
	move.b	d1,PCM_ENV					; Set volume
	PCM_DELAY d3
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
	move.b	d0,PCM_CTRL
	PCM_DELAY d2
	
	move.b	d1,PCM_PAN					; Set panning
	PCM_DELAY d2
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
	move.b	d0,PCM_CTRL
	PCM_DELAY d3
	
	lea	pcmFreqs(pc),a6					; Save frequency
	andi.w	#7,d2
	add.b	d2,d2
	move.w	d1,(a6,d2.w)
	
	move.b	d1,PCM_FDL					; Set frequency
	PCM_DELAY d3
	move.w	d1,-(sp)
	move.b	(sp)+,PCM_FDH
	PCM_DELAY d3
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
	move.b	d0,PCM_CTRL
	PCM_DELAY d2
	
	move.b	d1,PCM_ST					; Set start address
	PCM_DELAY d2
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
	move.b	d0,PCM_CTRL
	PCM_DELAY d2
	
	move.b	d1,PCM_LSL					; Set loop address
	PCM_DELAY d2
	move.w	d1,-(sp)
	move.b	(sp)+,PCM_LSH
	PCM_DELAY d2
	rts

; -------------------------------------------------------------------------
; Play PCM channel
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
; -------------------------------------------------------------------------

PlayPCM:
	bsr.s	StopPCM						; Stop channel
	
	bclr	d0,pcmOnOff					; Play channel
	move.b	pcmOnOff(pc),PCM_ENABLE
	PCM_DELAY d1
	rts
	
; -------------------------------------------------------------------------
; Stop PCM channel
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Channel ID
; -------------------------------------------------------------------------

StopPCM:
	bset	d0,pcmOnOff					; Stop channel
	move.b	pcmOnOff(pc),PCM_ENABLE
	PCM_DELAY d1
	rts
	
; -------------------------------------------------------------------------
; Stop all PCM channels
; -------------------------------------------------------------------------

StopAllPCM:
	st	pcmOnOff					; Stop all channels
	move.b	pcmOnOff(pc),PCM_ENABLE
	PCM_DELAY d1
	rts

; -------------------------------------------------------------------------
; Pause PCM channel
; -------------------------------------------------------------------------

PausePCM:
	ori.b	#$C0,d0						; Set register ID
	move.b	d0,PCM_CTRL
	PCM_DELAY d1
	
	moveq	#0,d1						; Pause
	move.b	d1,PCM_ENV
	PCM_DELAY d2
	move.b	d1,PCM_FDL
	PCM_DELAY d2
	move.b	d1,PCM_FDH
	PCM_DELAY d2
	rts
	
; -------------------------------------------------------------------------
; Unpause PCM channel
; -------------------------------------------------------------------------

UnpausePCM:
	move.b	d0,d1						; Set register ID
	ori.b	#$C0,d0
	move.b	d0,PCM_CTRL
	PCM_DELAY d2
	
	andi.w	#7,d1						; Restore volume
	move.b	pcmVolumes(pc,d1.w),d2
	move.b	d2,PCM_ENV
	PCM_DELAY d2
	
	add.b	d1,d1						; Restore frequency
	move.b	pcmFreqs+1(pc,d1.w),d2
	move.b	d2,PCM_FDL
	PCM_DELAY d2
	move.b	pcmFreqs(pc,d1.w),d2
	move.b	d2,PCM_FDH
	PCM_DELAY d2
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
