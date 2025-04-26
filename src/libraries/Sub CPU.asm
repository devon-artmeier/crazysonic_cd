; -------------------------------------------------------------------------
; Sub CPU functions
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Start Sub CPU command 
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Command ID
; -------------------------------------------------------------------------

StartSubCmd:
	move.b	d0,MAIN_FLAG					; Set command ID

.WaitAck:
	tst.b	SUB_FLAG					; Has the Sub CPU acknowledged it?
	beq.s	.WaitAck					; If not, wait
	rts

; -------------------------------------------------------------------------
; Finish Sub CPU command 
; -------------------------------------------------------------------------

FinishSubCmd:
	clr.b	MAIN_FLAG					; Clear command ID

.WaitDone:
	tst.b	SUB_FLAG					; Has the Sub CPU finished?
	bne.s	.WaitDone					; If not, wait
	rts
	
; -------------------------------------------------------------------------
; Load file
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to file name
;	a1.l - Read address in Sub CPU space
; -------------------------------------------------------------------------

LoadFile:
	bsr.s	LoadFileAsync
	bra.s	FinishAsyncFileLoad
	
; -------------------------------------------------------------------------
; Load Sub CPU module file
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to file name
;	a1.l - Read address in Sub CPU space
; -------------------------------------------------------------------------

LoadSubModule:
	lea	SUB_PRG_START+$10000,a1
	bra.s	LoadFile

; -------------------------------------------------------------------------
; Load RAM program file
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to file name
; -------------------------------------------------------------------------

LoadRAMProgram:
	lea	SUB_WORD_START_2M,a1				; Load file
	bsr.s	LoadFile

	lea	WORD_START,a0					; Copy to RAM program space
	lea	RAMProgram(pc),a1
	move.w	COMM_STAT_2+2,d0
	lsr.w	#4,d0
	subq.w	#1,d0

.Copy:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	dbf	d0,.Copy

	rts

; -------------------------------------------------------------------------
; Load file (asynchronous)
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to file name
;	a1.l - Read address in Sub CPU space
; -------------------------------------------------------------------------

LoadFileAsync:
	move.l	a2,-(sp)					; Save registers

	GIVE_WORD_ACCESS					; Swap Word RAM access

	lea	COMM_CMD_0,a2					; Set file name
	move.l	(a0)+,(a2)
	move.l	(a0)+,4(a2)
	move.l	(a0)+,8(a2)
	move.l	(a0)+,$C(a2)

	moveq	#1,d0						; Start command
	bsr.s	StartSubCmd

.WaitAddress:
	cmpi.b	#'A',SUB_FLAG					; Wait for the Sub CPU to request the read address
	bne.s	.WaitAddress

	move.l	a1,(a2)						; Set read address
	move.b	#'A',MAIN_FLAG

	move.l	(sp)+,a2					; Restore registers
	rts

; -------------------------------------------------------------------------
; Finish asynchronous file load
; -------------------------------------------------------------------------

FinishAsyncFileLoad:
.WaitDone:
	cmpi.b	#'D',SUB_FLAG					; Wait for the file to be read
	bne.s	.WaitDone

	bra.w	FinishSubCmd					; Finish command

; -------------------------------------------------------------------------
; Play CDDA
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Track ID
; -------------------------------------------------------------------------

PlayCDDA:
	move.w	d0,COMM_CMD_0
	moveq	#2,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Loop CDDA
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Track ID
; -------------------------------------------------------------------------

LoopCDDA:
	move.w	d0,COMM_CMD_0
	moveq	#3,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Stop CDDA
; -------------------------------------------------------------------------

StopCDDA:
	moveq	#4,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Pause CDDA
; -------------------------------------------------------------------------

PauseCDDA:
	moveq	#5,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Unpause CDDA
; -------------------------------------------------------------------------

UnpauseCDDA:
	moveq	#6,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Run Sub CPU module
; -------------------------------------------------------------------------

RunSubModule:
	moveq	#7,d0
	bra.w	StartSubCmd

; -------------------------------------------------------------------------
; Write a byte to Sub CPU memory
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Value to write
;	a1.l - Address in Sub CPU memory to write to
; -------------------------------------------------------------------------

WriteSubByte:
	move.l	a1,COMM_CMD_0
	move.b	d0,COMM_CMD_2
	moveq	#8,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Write a word to Sub CPU memory
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Value to write
;	a1.l - Address in Sub CPU memory to write to
; -------------------------------------------------------------------------

WriteSubWord:
	move.l	a1,COMM_CMD_0
	move.w	d0,COMM_CMD_2
	moveq	#9,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Write a longword to Sub CPU memory
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Value to write
;	a1.l - Address in Sub CPU memory to write to
; -------------------------------------------------------------------------

WriteSubLong:
	move.l	a1,COMM_CMD_0
	move.w	d0,COMM_CMD_2
	moveq	#10,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Make the Sub CPU call a function
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Parameter 1
;	a1.l - Address of function to call
; -------------------------------------------------------------------------

CallSubFunction:
	move.l	a1,COMM_CMD_0
	move.w	d0,COMM_CMD_2
	moveq	#11,d0
	bsr.w	StartSubCmd
	bra.w	FinishSubCmd

; -------------------------------------------------------------------------
; Check if CDDA is playing
; -------------------------------------------------------------------------
; RETURNS:
;	eq/ne - Not playing/Playing
; -------------------------------------------------------------------------

CheckCDDA:
	moveq	#12,d0
	bsr.w	StartSubCmd
	bsr.w	FinishSubCmd
	tst.b	COMM_STAT_0
	rts

; -------------------------------------------------------------------------
