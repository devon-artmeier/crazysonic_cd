; -------------------------------------------------------------------------
; Load stage map
; -------------------------------------------------------------------------

LoadStageMap:
	lea	Stamps(pc),a0					; Load stamps
	lea	WORD_START_2M,a1
	bsr.w	KosDec

	lea	Map(pc),a0						; Load map
	lea	WORD_START_2M+STAMP_MAP,a1
	bsr.w	KosDec
	
	lea	WORD_START_2M+IMG_BUFFER,a1			; Fill image buffer with noise
	move.w	#(IMG_LENGTH/(IMG_HEIGHT*4*2)),d0
	
.FillNoise:
	lea	WORD_START_2M+$1000,a0
	rept	2
		clr.l	(a1)+
		clr.l	(a1)+
		clr.l	(a1)+
		rept	IMG_HEIGHT-3
			move.l	(a0)+,(a1)+
		endr
	endr
	dbf	d0,.FillNoise
	rts

; -------------------------------------------------------------------------
