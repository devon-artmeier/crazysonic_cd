; -------------------------------------------------------------------------
; CrazyBus PCM driver
; -------------------------------------------------------------------------

	include	"source/include/sub_cpu.inc"
	include	"source/include/sub_program.inc"
	include	"source/sound/crazybus_ids.inc"
	
	org	PRG_START+$40000
	
; -------------------------------------------------------------------------
; Initialize
; -------------------------------------------------------------------------

CBPCM_Init:
	move.l	#CBPCM_Update,int2Routine			; Set INT2 routine

	jsr	InitPCM						; Stop all PCM channels

	lea	CBPCM_PSG(pc),a0				; Load PCM samples
	move.w	#CBPCM_PSGEnd-CBPCM_PSG,d0
	moveq	#SAMPLE_PSG,d1
	jsr	LoadPCMSample
	
	lea	CBPCM_Noise(pc),a0
	move.w	#CBPCM_NoiseEnd-CBPCM_Noise,d0
	move.w	#SAMPLE_NOISE,d1
	jsr	LoadPCMSample
	
	moveq	#0,d0						; Set up PCM1
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	moveq	#0,d1
	jsr	SetPCMVolume
	jsr	SetPCMFrequency
	jsr	SetPCMStart
	jsr	SetPCMLoop
	jsr	PlayPCM
	
	moveq	#1,d0						; Set up PCM2
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	moveq	#0,d1
	jsr	SetPCMVolume
	jsr	SetPCMFrequency
	jsr	SetPCMStart
	jsr	SetPCMLoop
	jsr	PlayPCM
	
	moveq	#2,d0						; Set up PCM3
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	moveq	#0,d1
	jsr	SetPCMVolume
	jsr	SetPCMFrequency
	jsr	SetPCMStart
	jsr	SetPCMLoop
	jsr	PlayPCM
	
	moveq	#3,d0						; Set up PCM4
	moveq	#0,d1
	jsr	SetPCMVolume
	moveq	#$FFFFFFFF,d1
	jsr	SetPCMPanning
	move.w	#$400,d1
	jsr	SetPCMFrequency
	moveq	#SAMPLE_NOISE>>8,d1
	jsr	SetPCMStart
	move.w	#SAMPLE_NOISE,d1
	jsr	SetPCMLoop
	jsr	PlayPCM
	
	clr.b	cbpcmSoundID					; Reset pause flag

; -------------------------------------------------------------------------
; Reset
; -------------------------------------------------------------------------

CBPCM_Reset:
	moveq	#0,d0						; Mute PCM
	moveq	#0,d1
	bsr.w	CBPCM_SetVolume
	moveq	#1,d0
	bsr.w	CBPCM_SetVolume
	moveq	#2,d0
	bsr.w	CBPCM_SetVolume
	moveq	#3,d0
	bsr.w	CBPCM_SetVolume

	move.w	d1,cbpcmPaused					; Reset variables
	move.l	d1,cbpcmMotorMode
	rts

; -------------------------------------------------------------------------
; Stop sound
; -------------------------------------------------------------------------

CBPCM_Stop:
	moveq	#0,d0						; Stop

; -------------------------------------------------------------------------
; Play sound
; -------------------------------------------------------------------------

CBPCM_Play:
	move.b	d0,cbpcmSoundID					; Set sound ID
	bra.s	CBPCM_Reset					; Reset

; -------------------------------------------------------------------------
; Pause
; -------------------------------------------------------------------------

CBPCM_Pause:
	st	cbpcmPaused					; Set pause flag

	moveq	#0,d0						; Pause channels
	jsr	PausePCM
	moveq	#1,d0
	jsr	PausePCM
	moveq	#2,d0
	jsr	PausePCM
	moveq	#3,d0
	jmp	PausePCM

; -------------------------------------------------------------------------
; Unpause
; -------------------------------------------------------------------------

CBPCM_Unpause:
	clr.b	cbpcmPaused					; Set pause flag

	moveq	#0,d0						; Pause channels
	jsr	UnpausePCM
	moveq	#1,d0
	jsr	UnpausePCM
	moveq	#2,d0
	jsr	UnpausePCM
	moveq	#3,d0
	jmp	UnpausePCM

; -------------------------------------------------------------------------
; Update
; -------------------------------------------------------------------------

CBPCM_Update:
	tst.b	cbpcmPaused					; Is the driver paused?
	bne.s	.End						; If so, branch
	
	moveq	#0,d0						; Handle sound
	move.b	cbpcmSoundID(pc),d0
	beq.s	.End
	add.w	d0,d0
	add.w	d0,d0
	jmp	.Sounds-4(pc,d0.w)

.End:
	rts
	
; -------------------------------------------------------------------------

.Sounds:
	bra.w	CBPCM_PlayTitle
	bra.w	CBPCM_PlayMenu
	bra.w	CBPCM_PlayBusSounds
	bra.w	CBPCM_PlayCount
	bra.w	CBPCM_PlayCountDone
	
; -------------------------------------------------------------------------
; Title "music"
; -------------------------------------------------------------------------

CBPCM_PlayTitle:
	moveq	#0,d0						; Activate PCM 1-3
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume
	moveq	#1,d0
	bsr.w	CBPCM_SetVolume
	moveq	#2,d0
	bsr.w	CBPCM_SetVolume
	moveq	#3,d0
	moveq	#0,d1
	bsr.w	CBPCM_SetVolume
	
	subq.b	#1,cbpcmMusicCnt				; Handle timer
	bpl.s	.End
	move.b	#10-1,cbpcmMusicCnt
	
	move.w	#40,d0						; Set PCM1 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#500,d0
	move.w	d0,d1
	moveq	#0,d0
	bsr.w	CBPCM_SetFrequency
	
	move.w	#40,d0						; Set PCM2 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#600,d0
	move.w	d0,d1
	moveq	#1,d0
	bsr.w	CBPCM_SetFrequency
	
	move.w	#40,d0						; Set PCM3 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#700,d0
	move.w	d0,d1
	moveq	#2,d0
	bsr.w	CBPCM_SetFrequency
	
	moveq	#0,d0						; Set key on
	jsr	PlayPCM
	moveq	#1,d0
	jsr	PlayPCM
	moveq	#2,d0
	jmp	PlayPCM
	
.End:
	rts
	
; -------------------------------------------------------------------------
; Menu "music"
; -------------------------------------------------------------------------

CBPCM_PlayMenu:
	moveq	#0,d0						; Activate PCM 1-3
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume
	moveq	#1,d0
	bsr.w	CBPCM_SetVolume
	moveq	#2,d0
	bsr.w	CBPCM_SetVolume
	moveq	#3,d0
	moveq	#0,d1
	bsr.w	CBPCM_SetVolume
	
	subq.b	#1,cbpcmMusicCnt				; Handle timer
	bpl.s	.End
	move.b	#10-1,cbpcmMusicCnt
	
	move.w	#40,d0						; Set PCM1 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#200,d0
	move.w	d0,d1
	moveq	#0,d0
	bsr.w	CBPCM_SetFrequency
	
	move.w	#40,d0						; Set PCM2 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#250,d0
	move.w	d0,d1
	moveq	#1,d0
	bsr.w	CBPCM_SetFrequency
	
	move.w	#40,d0						; Set PCM3 frequency
	bsr.w	CBPCM_RandomRange
	mulu.w	#10,d0
	addi.w	#325,d0
	move.w	d0,d1
	moveq	#2,d0
	bra.w	CBPCM_SetFrequency
	
.End:
	rts
	
; -------------------------------------------------------------------------
; Play bus sounds
; -------------------------------------------------------------------------

CBPCM_PlayBusSounds:
	moveq	#2,d0						; Set PCM3 frequency
	move.w	#980,d1
	bsr.w	CBPCM_SetFrequency
	
; -------------------------------------------------------------------------

	moveq	#0,d1						; 0 = mute
	moveq	#0,d4
	tst.b	cbpcmMotorMode
	beq.s	.SetMotorVolume
	
	moveq	#$D,d1						; 1-2 = moving
	moveq	#$C,d4
	cmpi.b	#1,cbpcmMotorMode
	beq.s	.SetMotorVolume
	cmpi.b	#2,cbpcmMotorMode
	beq.s	.SetMotorVolume
	
	moveq	#9,d1						; 3 = idle
	moveq	#8,d4
	
.SetMotorVolume:
	moveq	#0,d0						; Set PCM1 volume
	bsr.w	CBPCM_SetVolume
	
	moveq	#3,d0						; Set PCM2 volume
	move.b	d4,d1
	bsr.w	CBPCM_SetVolume
	
; -------------------------------------------------------------------------

	subi.b	#25,cbpcmMotorFreq				; Update motor frequency
	beq.s	.ResetMotor
	bpl.s	.SetMotorFreq
	
.ResetMotor:
	move.b	#75,cbpcmMotorFreq
	
.SetMotorFreq:
	moveq	#0,d0						; Set PCM1 frequency
	moveq	#0,d1
	move.b	cbpcmMotorFreq,d1
	bsr.w	CBPCM_SetFrequency
	
; -------------------------------------------------------------------------

	cmpi.b	#1,cbpcmMotorMode				; Should the backup sound be playing?
	bne.s	.NoBackup					; If not, branch
	
	addq.b	#1,cbpcmBackupCnt				; Handle backup counter
	cmpi.b	#20,cbpcmBackupCnt
	bcs.s	.Backup
	cmpi.b	#39,cbpcmBackupCnt
	bcs.s	.BackupMute
	clr.b	cbpcmBackupCnt
	bra.s	.BackupMute

.Backup:
	moveq	#1,d0						; Set PCM2 volume
	moveq	#$D,d1
	bsr.w	CBPCM_SetVolume
	
	move.w	#891,d1						; Set PCM2 frequency
	bsr.w	CBPCM_SetFrequency
	
	moveq	#1,d4						; Backup sound playing
	bra.s	.CheckHonk

.NoBackup:
	clr.b	cbpcmBackupCnt					; Reset counter

.BackupMute:
	moveq	#1,d0						; Mute PCM2
	moveq	#0,d1
	bsr.w	CBPCM_SetVolume
	
	moveq	#0,d4						; No backup sound playing

; -------------------------------------------------------------------------

.CheckHonk:
	tst.b	cbpcmHonk					; Should we play thr honking sound?
	beq.s	.NoHonk						; If not, branch
	
	moveq	#1,d0						; Set PCM2 volume
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume
	
	moveq	#2,d0						; Set PCM3 volume
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume
	
	moveq	#1,d0						; Set PCM2 frequency
	move.w	#630,d1
	bsr.w	CBPCM_SetFrequency
	
	moveq	#2,d0						; Set PCM3 frequency
	move.w	#980,d1
	bra.w	CBPCM_SetFrequency
	
.NoHonk:
	tst.b	d4						; Is the backup sound playing?
	bne.s	.NoBackupOverride				; If so, branch
	
	moveq	#1,d0						; Mute PCM2
	moveq	#0,d1
	bsr.w	CBPCM_SetVolume
	
.NoBackupOverride:
	moveq	#2,d0						; Mute PCM3
	moveq	#0,d1
	bra.w	CBPCM_SetVolume

; -------------------------------------------------------------------------
; Play countdown sound
; -------------------------------------------------------------------------

CBPCM_PlayCount:
	moveq	#1,d0						; Set PCM2 volume
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume
		
	move.w	#750,d1
	bra.s	CBPCM_SetFrequency

; -------------------------------------------------------------------------
; Play countdown done sound
; -------------------------------------------------------------------------

CBPCM_PlayCountDone:
	moveq	#1,d0						; Set PCM2 volume
	moveq	#$F,d1
	bsr.w	CBPCM_SetVolume

	move.w	#971,d1						; Set PCM2 frequency

; -------------------------------------------------------------------------
; Set channel frequency
; -------------------------------------------------------------------------

CBPCM_SetFrequency:
	not.w	d1						; Convert value
	andi.w	#$3FF,d1
	add.w	d1,d1
	move.w	CBPCM_FreqConv(pc,d1.w),d1
	jmp	SetPCMFrequency					; Set frequency
	
; -------------------------------------------------------------------------
; Set channel volume
; -------------------------------------------------------------------------

CBPCM_SetVolume:
	move.w	d1,-(sp)					; Convert value
	move.b	CBPCM_VolConv(pc,d1.w),d1
	jsr	SetPCMVolume					; Set frequency
	move.w	(sp)+,d1
	rts

; -------------------------------------------------------------------------
; Conversion table
; -------------------------------------------------------------------------

CBPCM_VolConv:
	dc.b	$00, $10, $20, $30
	dc.b	$40, $50, $60, $70
	dc.b	$80, $90, $A0, $B0
	dc.b	$C0, $D0, $E0, $F0

CBPCM_FreqConv:
	include	"source/sound/crazybus_psg_conv.asm"

; -------------------------------------------------------------------------
; Generate a random number
; -------------------------------------------------------------------------

CBPCM_Random:
	move.l	d0,d2
	movem.l	cbpcmRNGSeed(pc),d0-d1
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
	movem.l	d0-d1,cbpcmRNGSeed
	move.l	d1,d0
	rts

; -------------------------------------------------------------------------
; Generate a random number within a range
; -------------------------------------------------------------------------

CBPCM_RandomRange:
	move.w	d0,d2						; Is this a valid range?
	beq.s	.End						; If not, branch
	
	movem.w	d2,-(sp)					; Generate random number
	bsr.s	CBPCM_Random
	movem.w	(sp)+,d2
	
	clr.w	d0						; Keep within range
	swap	d0
	divu.w	d2,d0
	swap	d0

.End:
	rts

; -------------------------------------------------------------------------
; Samples (8138 Hz)
; -------------------------------------------------------------------------

CBPCM_PSG:
	incbin	"source/sound/pcm/psg.pcm"
CBPCM_PSGEnd:
	even
CBPCM_Noise:
	incbin	"source/sound/pcm/noise.pcm"
CBPCM_NoiseEnd:
	even

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

cbpcmSoundID:							; Sound ID
	dc.b	0
	even
cbpcmPaused:							; Pause flag
	dc.b	0
cbpcmMusicCnt:							; "Music" counter
	dc.b	0
cbpcmMotorMode:							; Motor mode
	dc.b	0
cbpcmMotorFreq:							; Motor frequency
	dc.b	0
cbpcmBackupCnt:							; Back-up counter
	dc.b	0
cbpcmHonk:							; Honk flag
	dc.b	0
cbpcmRNGSeed:							; RNG seed
	dcb.l	2, 0

; -------------------------------------------------------------------------
