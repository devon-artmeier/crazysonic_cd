; ---------------------------------------------------------------------------
; Object 89 - "SONIC THE HEDGEHOG" text	on the ending sequence
; ---------------------------------------------------------------------------

EndSTH:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ESth_Index(pc,d0.w),d1
		jsr	ESth_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESth_Index:	dc.w ESth_Main-ESth_Index
		dc.w ESth_Move-ESth_Index
		dc.w ESth_GotoCredits-ESth_Index

esth_time:	equ $30		; time until exit
; ===========================================================================

ESth_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#-$20,obX(a0)	; object starts	outside	the level boundary
		move.w	#$D8,obScreenY(a0)
		move.l	#Map_ESth,obMap(a0)
		move.w	#$5C5,obGfx(a0)
		move.b	#0,obRender(a0)
		move.w	#v_spritequeue,obPriority(a0)

ESth_Move:	; Routine 2
		cmpi.w	#$C0,obX(a0)	; has object reached $C0?
		beq.s	ESth_Delay	; if yes, branch
		addi.w	#$10,obX(a0)	; move object to the right
		rts

ESth_Delay:
		addq.b	#2,obRoutine(a0)
		move.w	#300,esth_time(a0) ; set duration for delay (5 seconds)

ESth_GotoCredits:
		; Routine 4
		subq.w	#1,esth_time(a0) ; subtract 1 from duration
		bpl.s	ESth_Wait
		bset	#7,(v_gamemode).w ; exit to credits

	ESth_Wait:
		rts