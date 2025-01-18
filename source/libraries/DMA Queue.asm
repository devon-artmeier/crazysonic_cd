; ---------------------------------------------------------------------------
; MACRO ResetDMAQueue
; Clears the DMA queue, discarding all previously-queued DMAs.
; ---------------------------------------------------------------------------
; Convenience macros, for increased maintainability of the code.
; Like vdpComm, but starting from an address contained in a register
vdpCommReg macro reg,clr
	lsl.l	#2,\reg							; Move high bits into (word-swapped) position, accidentally moving everything else
	addq.w	#1,\reg							; Add upper access type bits
	ror.w	#2,\reg							; Put upper access type bits into place, also moving all other bits into their correct (word-swapped) places
	swap	\reg							; Put all bits in proper places
	if (\clr)<>0
		andi.w	#3,\reg						; Strip whatever junk was in upper word of reg
	endif
	tas.b	\reg							; Add in the DMA flag -- tas fails on memory, but works on registers
	endm
; ---------------------------------------------------------------------------
	rsreset
DMAEntry.Reg94:		rs.b	1
DMAEntry.Size:		rs.b	0
DMAEntry.SizeH:		rs.b	1
DMAEntry.Reg93:		rs.b	1
DMAEntry.Source:	rs.b	0
DMAEntry.SizeL:		rs.b	1
DMAEntry.Reg97:		rs.b	1
DMAEntry.SrcH:		rs.b	1
DMAEntry.Reg96:		rs.b	1
DMAEntry.SrcM:		rs.b	1
DMAEntry.Reg95:		rs.b	1
DMAEntry.SrcL:		rs.b	1
DMAEntry.Command:	rs.l	1
DMAEntry.ManualCmd:	rs.l	1
DMAEntry.ManualSrc:	rs.l	1
DMAEntry.len		rs.b	0
; ---------------------------------------------------------------------------
QueueSlotCount = (VDP_Command_Buffer_Slot-VDP_Command_Buffer)/DMAEntry.len
; ---------------------------------------------------------------------------
ResetDMAQueue macro
	move.w	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	endm
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand:
Add_To_DMA_Queue:
QueueDMATransfer:
	move.w	sr,-(sp)						; Save current interrupt mask
	move	#$2700,sr						; Mask off interrupts
	movea.w	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	.done							; Return if there's no more room in the buffer

	move.l	d1,DMAEntry.ManualSrc(a1)				; Set manual write source
	lsr.l	#1,d1							; Source address is in words for the VDP registers
	bclr.l	#23,d1							; Make sure bit 23 is clear (68k->VDP DMA flag)
	
	cmpi.l	#WORD_START/2,d1
	bcs.s	.notwordram
	cmpi.l	#WORD_END_2M/2,d1
	bcc.s	.notwordram
	addq.w	#1,d1
	movep.l	d1,DMAEntry.Source(a1)					; Write source address; the useless top byte will be overwritten later
	subq.w	#1,d1
	bra.s	.srcdone

.notwordram:
	movep.l	d1,DMAEntry.Source(a1)					; Write source address; the useless top byte will be overwritten later

.srcdone:
	moveq	#0,d0							; We need a zero on d0

	; Detect if transfer crosses 128KB boundary
	; Using sub+sub instead of move+add handles the following edge cases:
	; (1) d3.w = 0 => 128kB transfer
	;   (a) d1.w = 0 => no carry, don't split the DMA
	;   (b) d1.w != 0 => carry, need to split the DMA
	; (2) d3.w != 0
	;   (a) if there is carry on d1.w + d3.w
	;     (* ) if d1.w + d3.w = 0 => transfer comes entirely from current 128kB block, don't split the DMA
	;     (**) if d1.w + d3.w != 0 => need to split the DMA
	;   (b) if there is no carry on d1.w + d3.w => don't split the DMA
	; The reason this works is that carry on d1.w + d3.w means that
	; d1.w + d3.w >= $10000, whereas carry on (-d3.w) - (d1.w) means that
	; d1.w + d3.w > $10000.
	sub.w	d3,d0							; Using sub instead of move and add allows checking edge cases
	sub.w	d1,d0							; Does the transfer cross over to the next 128kB block?
	bcs.s	.doubletransfer						; Branch if yes
	
	; It does not cross a 128kB boundary. So just finish writing it.
	movep.w	d3,DMAEntry.Size(a1)					; Write DMA length, overwriting useless top byte of source address

.finishxfer:
	; Command to specify destination address and begin DMA
	move.w	d2,d0							; Use the fact that top word of d0 is zero to avoid clearing on vdpCommReg
	vdpCommReg d0,0							; Convert destination address to VDP DMA command
	lea	DMAEntry.Command(a1),a1					; Seek to correct RAM address to store VDP DMA command
	move.l	d0,(a1)+						; Write VDP DMA command for destination address
	andi.b	#$7F,d0
	move.l	d0,(a1)+
	addq.w	#4,a1
	move.w	a1,(VDP_Command_Buffer_Slot).w				; Write next queue slot

.done:
	move.w	(sp)+,sr						; Restore interrupts to previous state
	rts
; ---------------------------------------------------------------------------

.doubletransfer:
	; We need to split the DMA into two parts, since it crosses a 128kB block
	add.w	d3,d0							; Set d0 to the number of words until end of current 128kB block
	movep.w	d0,DMAEntry.Size(a1)					; Write DMA length of first part, overwriting useless top byte of source addres

	cmpa.w	#VDP_Command_Buffer_Slot-DMAEntry.len,a1		; Does the queue have enough space for both parts?
	beq.s	.finishxfer						; Branch if not

	; Get second transfer's source, destination, and length
	sub.w	d0,d3							; Set d3 to the number of words remaining
	add.l	d0,d1							; Offset the source address of the second part by the length of the first part
	add.w	d0,d0							; Convert to number of bytes
	add.w	d2,d0							; Set d0 to the VRAM destination of the second part

	; If we know top word of d2 is clear, the following vdpCommReg can be set to not
	; clear it. There is, unfortunately, no faster way to clear it than this.
	vdpCommReg d2,1							; Convert destination address of first part to VDP DMA command
	move.l	d2,DMAEntry.Command(a1)					; Write VDP DMA command for destination address of first part
	andi.b	#$7F,d2
	move.l	d2,DMAEntry.ManualCmd(a1)

	; Do second transfer
	cmpi.l	#WORD_START/2,d1
	bcs.s	.notwordram2
	cmpi.l	#WORD_END_2M/2,d1
	bcc.s	.notwordram2
	addq.w	#1,d1
	movep.l	d1,DMAEntry.len+DMAEntry.Source(a1)			; Write source address; the useless top byte will be overwritten later
	subq.w	#1,d1
	bra.s	.srcdone2

.notwordram2:
	movep.l	d1,DMAEntry.len+DMAEntry.Source(a1)			; Write source address; the useless top byte will be overwritten later

.srcdone2:
	movep.w	d3,DMAEntry.len+DMAEntry.Size(a1)			; Write DMA length of second part, overwriting useless top byte of source addres

	; Command to specify destination address and begin DMA
	vdpCommReg d0,0							; Convert destination address to VDP DMA command; we know top half of d0 is zero
	lea	DMAEntry.len+DMAEntry.Command(a1),a1			; Seek to correct RAM address to store VDP DMA command of second part
	move.l	d0,(a1)+						; Write VDP DMA command for destination address of second part
	andi.b	#$7F,d0
	move.l	d0,(a1)+

	add.l	d1,d1
	move.l	d1,(a1)+
	
	move.w	a1,(VDP_Command_Buffer_Slot).w				; Write next queue slot
	move.w	(sp)+,sr						; Restore interrupts to previous state
	rts
; End of function QueueDMATransfer

; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA:
Process_DMA_Queue:
ProcessDMAQueue:
	move.w	(VDP_Command_Buffer_Slot).w,d0
	subi.w	#VDP_Command_Buffer,d0
	jmp	.jump_table(pc,d0.w)
; ---------------------------------------------------------------------------
.jump_table:
	rts
	rept (DMAEntry.len-2)/2
		trap	#0						; Just in case
	endr
; ---------------------------------------------------------------------------
	.c: = 1
	rept QueueSlotCount
		lea	(VDP_CTRL).l,a5
		lea	(VDP_Command_Buffer).w,a1
		if .c<>QueueSlotCount
			bra.w	.jump0-(.c*$10)
		endif
		rept	(DMAEntry.len-$E)/2
			nop
		endr
		.c: = .c+1
	endr
; ---------------------------------------------------------------------------
	rept QueueSlotCount
		move.l	(a1)+,(a5)					; Transfer length
		move.l	(a1)+,(a5)					; Source address high
		move.l	(a1)+,(a5)					; Source address low + destination high
		move.w	(a1)+,(a5)					; Destination low, trigger DMA
		move.l	(a1)+,(a5)
		movea.l	(a1)+,a2
		move.l	(a2),-4(a5)
	endr

.jump0:
	ResetDMAQueue
	rts
; End of function ProcessDMAQueue

; ---------------------------------------------------------------------------
; Subroutine for initializing the DMA queue.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

InitDMAQueue:
	lea	(VDP_Command_Buffer).w,a0
	moveq	#$FFFFFF94,d0						; fast-store $94 (sign-extended) in d0
	move.l	#$93979695,d1
	.c: = 0
	rept QueueSlotCount
		move.b	d0,.c+DMAEntry.Reg94(a0)
		movep.l	d1,.c+DMAEntry.Reg93(a0)
		.c: = .c+DMAEntry.len
	endr

	ResetDMAQueue
	rts
; End of function ProcessDMAQueue

