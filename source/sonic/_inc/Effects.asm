; -------------------------------------------------------------------------
; Effects
; -------------------------------------------------------------------------

UpdateEffects:
	tst.b	levelEnded.w
	bne.s	StopEffects
	cmpi.b	#6,v_player+obRoutine.w
	bcc.s	StopEffects
	jsr	UpdateLSDMode
	jmp	UpdateRaveMode
	
; -------------------------------------------------------------------------

PlayEffectMusic:
	moveq	#0,d0
	move.b	effectFlags.w,d0
	beq.s	.Stop
	addq.b	#1,d0
	jmp	LoopCDDA
	
.Stop:
	jmp	PlayStageMusic
	
; -------------------------------------------------------------------------
; Stop effects
; -------------------------------------------------------------------------

StopEffects:
	tst.b	effectFlags.w
	beq.s	.End
	clr.b	effectFlags.w
	clr.b	effectTriggers.w
	move.w	#$8B03,VDP_CTRL
	bra.s	PlayEffectMusic

.End:
	rts

; -------------------------------------------------------------------------
; Update effect timers
; -------------------------------------------------------------------------

UpdateEffectTimers:
	tst.w	f_pause.w
	bne.s	.End
	bsr.w	UpdateRaveTimer
	bra.w	UpdateLSDTimer
	
.End:
	rts

; -------------------------------------------------------------------------

	include	"source/sonic/_inc/LSD Mode.asm"
	include	"source/sonic/_inc/Rave Mode.asm"

; -------------------------------------------------------------------------
