; -------------------------------------------------------------------------
; Disc reading library
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Continue reading disc
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.l - Sector read count
; -------------------------------------------------------------------------

ReadDiscCont:
	movem.l	d0-d2/a0-a1,-(sp)				; Save registers
	
	move.l	d1,discReadCount.w				; Set sector read parameter
	bra.s	ReadDiscStart					; Start reading

; -------------------------------------------------------------------------
; Read disc
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.l - Starting sector to read from
;	d1.l - Sector read count
;	a0.l - Read buffer address
; -------------------------------------------------------------------------

ReadDisc:
	movem.l	d0-d2/a0-a1,-(sp)				; Save registers
	
	move.l	d0,discReadSector.w				; Set disc read parameters
	move.l	d1,discReadCount.w
	move.l	a0,discReadBuffer.w

ReadDiscStart:
	lea	discReadSector.w,a0				; Start read operation
	BIOS_MSCSTOP
	BIOS_CDCSTOP
	BIOS_ROMREADN

.WaitPrepare:
	BIOS_CDCSTAT						; Query the CDC buffer
	bcs.s	.WaitPrepare					; If data has not been buffered, wait

.WaitRead:
	BIOS_CDCREAD						; Read the data from the CDC buffer
	bcs.s	.WaitRead					; If it's not read, wait

.WaitTransfer:
	movea.l	discReadBuffer.w,a0				; Transfer data from the CDC buffer
	lea	discHeaderBuffer.w,a1
	BIOS_CDCTRN
	bcs.s	.WaitTransfer					; If it's not done, wait

	BIOS_CDCACK						; Finish sector read

	addq.l	#1,discReadSector.w				; Next sector
	addi.l	#$800,discReadBuffer.w
	subq.l	#1,discReadCount.w
	bne.s	.WaitPrepare					; If we are not done, keep reading

.Finished:
	movem.l	(sp)+,d0-d2/a0-a1				; Restore registers
	rts

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

discReadSector:
	dc.l	0						; Disc read starting sector
discReadCount:
	dc.l	0						; Disc read sector count
discReadBuffer:
	dc.l	0						; Disc read buffer
discHeaderBuffer:
	dc.l	0						; Disc read header buffer

; -------------------------------------------------------------------------
