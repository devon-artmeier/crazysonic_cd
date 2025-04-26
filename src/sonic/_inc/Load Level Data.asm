; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelDataLoad:
		lea	(LevelHeaders).l,a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a1	; RAM address for 16x16 mappings
		move.w	#0,d0
		jsr	EniDec
		addq.l	#4,a2
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; is level SBZ3 (LZ4) ?
		bne.s	.notSBZ3	; if not, branch
		moveq	#palid_SBZ3,d0	; use SB3 palette

	.notSBZ3:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2?
		beq.s	.isSBZorFZ	; if yes, branch
		cmpi.w	#(id_SBZ<<8)+2,(v_zone).w ; is level FZ?
		bne.s	.normalpal	; if not, branch

	.isSBZorFZ:
		moveq	#palid_SBZ2,d0	; use SBZ2/FZ palette

	.normalpal:
		jsr	PalLoad1	; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.skipPLC	; if 2nd PLC is 0 (i.e. the ending sequence), branch
		jsr	AddPLC		; load pattern load cues

	.skipPLC:
		rts	
; End of function LevelDataLoad

; ---------------------------------------------------------------------------
; Level	layout loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; This method now releases free ram space from A408 - A7FF

LevelLayoutLoad:
	moveq	#0,d0
	move.b	(v_act).w,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	(Level_Index).l,a1
	movea.l	(a1,d0.w),a1
	addq.w	#8,a1
	
	lea	(levelLayout).w,a0
	move.w	#$FF8/4-1,d0

.Load:
	move.l	(a1)+,(a0)+
	dbf	d0,.Load
	rts
; End of function LevelLayoutLoad