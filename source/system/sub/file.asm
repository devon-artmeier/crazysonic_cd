; -------------------------------------------------------------------------
; File loading library
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Read file index
; -------------------------------------------------------------------------

ReadFileIndex:
	moveq	#16,d0						; Read first sector of file index
	moveq	#1,d1
	lea	FILE_INDEX(pc),a0
	bsr.w	ReadDisc
	
	move.l	FILE_INDEX+indexRemain,d1			; Read remaining sectors
	beq.s	.end
	bra.w	ReadDiscCont

.end:
	rts

; -------------------------------------------------------------------------
; Find file
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to file name
; RETURNS:
;	cc/cs - Success/Failure
;	a1.l  - Pointer to file index entry if successful
; -------------------------------------------------------------------------

FindFile:
	movem.l	a2-a3,-(sp)					; Save registers

	lea	FILE_INDEX(pc),a1				; File index
	move.l	indexFileCount(a1),d0				; Get number of files
	beq.s	.Fail						; If there are no files, branch
	bra.s	.NextFile					; Start searching

.FindLoop:
	movea.l	a0,a2						; Get file names
	movea.l	a1,a3

.CheckName:
	cmpm.b	(a2)+,(a3)+					; Do the file name characters match?
	bne.s	.NextFile					; If not, branch
	tst.b	-1(a2)						; Was the last character the termination character?
	beq.s	.Success					; If so, branch
	bra.s	.CheckName					; Keep checking file name

.NextFile:
	lea	fileEntrySize(a1),a1				; Next file
	dbf	d0,.FindLoop					; Loop until no more files are left

.Fail:
	movem.l	(sp)+,a2-a3					; Restore registers
	ori	#1,ccr						; Failure
	rts

.Success:
	movem.l	(sp)+,a2-a3					; Restore registers
	andi	#~1,ccr						; Success
	rts

; -------------------------------------------------------------------------
; Read file
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to file name
;	a2.l  - Pointer to read buffer
; RETURNS:
;	cc/cs - Success/Failure
;	d0.l  - Size of file if found
; -------------------------------------------------------------------------

ReadFile:
	movem.l	a0/a3,-(sp)					; Save register

	bsr.s	FindFile					; Find file
	bcs.s	.end						; If it wasn't found, branch
	
	move.l	fileLocSector(a1),d0				; Read file
	move.l	fileSizeSector(a1),d1
	move.l	fileSizeByte(a1),-(sp)
	movea.l	a2,a0
	bsr.w	ReadDisc

	move.l	(sp)+,d0					; Success
	andi	#~1,ccr

.end:
	movem.l	(sp)+,a0/a3					; Restore register
	rts

; -------------------------------------------------------------------------
