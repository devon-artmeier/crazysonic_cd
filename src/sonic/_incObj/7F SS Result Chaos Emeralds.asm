; ---------------------------------------------------------------------------
; Object 7F - chaos emeralds from the special stage results screen
; ---------------------------------------------------------------------------

SSRChaos:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SSRC_Index(pc,d0.w),d1
		jmp	SSRC_Index(pc,d1.w)
; ===========================================================================
SSRC_Index:	dc.w SSRC_Main-SSRC_Index
		dc.w SSRC_Flash-SSRC_Index

; ---------------------------------------------------------------------------
; X-axis positions for chaos emeralds
; ---------------------------------------------------------------------------
SSRC_PosData:	dc.w $11C, $134, $104, $14C, $EC, $164, $D4
; ===========================================================================

SSRC_Main:	; Routine 0
		movea.l	a0,a1
		lea	(SSRC_PosData).l,a2
		moveq	#0,d2
		moveq	#0,d1
		move.b	(v_emeralds).w,d1 ; d1 is number of emeralds
		subq.b	#1,d1		; subtract 1 from d1
		bcs.w	DeleteObject	; if you have 0	emeralds, branch

	SSRC_Loop:
		move.b	#id_SSRChaos,0(a1)
		move.w	(a2)+,obX(a1)	; set x-position
		move.w	#$F0,obScreenY(a1) ; set y-position
		addq.b	#2,obRoutine(a1)
		move.l	#Map_SSRC,obMap(a1)
		move.w	#$8541,obGfx(a1)
		move.b	#0,obRender(a1)
		move.w	#v_spritequeue,obPriority(a1)
		lea	$40(a1),a1	; next object
		dbf	d1,SSRC_Loop	; loop for d1 number of	emeralds

SSRC_Flash:	; Routine 2
		bra.w	DisplaySprite