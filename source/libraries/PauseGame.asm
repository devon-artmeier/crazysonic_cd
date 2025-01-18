; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		nop	
		tst.b	(v_lives).w	; do you have any lives	left?
		beq.w	Unpause		; if not, branch
		tst.w	(f_pause).w	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.w	Pause_DoNothing	; if not, branch

Pause_StopGame:
		move.w	#1,(f_pause).w	; freeze time
		move.b	#1,(v_snddriver_ram+f_pausemusic).w ; pause music
		jsr	PauseCDDA
		lea	CBPCM_Pause,a1
		jsr	CallSubFunction

Pause_Loop:
		move.b	#$10,(v_vbla_routine).w
		bsr.w	WaitForVBla

		cmpi.b	#id_Level,v_gamemode.w
		bne.s	.NoSKip
		cmpi.b	#id_SecretZ,v_zone.w
		bne.s	.NoSkip

		tst.b	v_cheatactive.w
		bne.s	.NoSkip
		
		lea	SkipToBossCheat(pc),a1
		lea	v_cheatbutton.w,a2
		jsr	CheckCheat
		beq.s	.NoSkip
		st	v_cheatactive.w

		move.l	#$26800273,warpX.w
		bra.s	Pause_EndMusic

.NoSkip:
		tst.b	(f_slomocheat).w ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_jpadpress1).w ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.b	#id_Title,(v_gamemode).w ; set game mode to 4 (title screen)
		nop	
		bra.s	Pause_EndMusic
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_jpadhold1).w ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_jpadpress1).w ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	Pause_Loop	; if not, branch

Pause_EndMusic:
		move.b	#$80,(v_snddriver_ram+f_pausemusic).w	; unpause the music

Unpause:
		move.w	#0,(f_pause).w	; unpause the game
		jsr	UnpauseCDDA
		lea	CBPCM_Unpause,a1
		jsr	CallSubFunction

Pause_DoNothing:
		rts	
; ===========================================================================

Pause_SlowMo:
		move.w	#1,(f_pause).w
		move.b	#$80,(v_snddriver_ram+f_pausemusic).w	; Unpause the music
		rts	
; End of function PauseGame

; -------------------------------------------------------------------------

SkipToBossCheat:
	dc.b	btnUp, btnDn, btnL, btnR, 0
	even

; -------------------------------------------------------------------------
