; -------------------------------------------------------------------------
; Load stage map
; -------------------------------------------------------------------------

LoadStageMap:
	lea	Stamps(pc),a0					; Load stamps
	lea	WORD_START_2M,a1
	bsr.w	KosDec

	lea	Map(pc),a0						; Load map
	lea	WORD_START_2M+STAMP_MAP,a1
	bra.w	KosDec

; -------------------------------------------------------------------------
