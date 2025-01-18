; ---------------------------------------------------------------------------
; Subroutine to	update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HUD_Update:
		lea	VDP_DATA,a6

		bsr.w	HUD_UpdateHealth

		tst.w	(f_debugmode).w	; is debug mode	on?
		bne.w	HudDebug	; if yes, branch
		tst.b	(f_scorecount).w ; does the score need updating?
		beq.s	.chkrings	; if not, branch

		clr.b	(f_scorecount).w
		VDP_CMD move.l,$DC80,VRAM,WRITE,d0	; set VRAM address
		move.l	(v_score).w,d1	; load score
		bsr.w	Hud_Score

	.chkrings:
		tst.b	(f_ringcount).w	; does the ring	counter	need updating?
		beq.s	.chktime	; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_LoadZero	; reset rings to 0 if Sonic is hit
		bra.s	.chktime

	.notzero:
		VDP_CMD move.l,$DF40,VRAM,WRITE,d0	; set VRAM address
		moveq	#0,d1
		move.w	(v_rings).w,d1	; load number of rings
		bsr.w	Hud_Rings

	.chktime:
		clr.b	(f_ringcount).w
		tst.b	(f_lifecount).w ; does the lives counter need updating?
		beq.s	.chkbonus	; if not, branch
		clr.b	(f_lifecount).w
		bsr.w	Hud_Lives

	.chkbonus:
		tst.b	(f_endactbonus).w ; do time/ring bonus counters need updating?
		beq.s	.finish		; if not, branch
		clr.b	(f_endactbonus).w
		VDP_CMD move.l,$AE00,VRAM,WRITE,VDP_CTRL
		moveq	#0,d1
		move.w	(v_timebonus).w,d1 ; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1 ; load ring bonus
		bsr.w	Hud_TimeRingBonus

	.finish:
		rts	
; ===========================================================================

HudDebug:
		bsr.w	HudDb_XY
		tst.b	(f_ringcount).w	; does the ring	counter	need updating?
		beq.s	.objcounter	; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_LoadZero	; reset rings to 0 if Sonic is hit
		bra.s	.objcounter

	.notzero:
		clr.b	(f_ringcount).w
		VDP_CMD move.l,$DF40,VRAM,WRITE,d0	; set VRAM address
		moveq	#0,d1
		move.w	(v_rings).w,d1	; load number of rings
		bsr.w	Hud_Rings

	.objcounter:
		tst.b	(f_lifecount).w ; does the lives counter need updating?
		beq.s	.chkbonus	; if not, branch
		clr.b	(f_lifecount).w
		bsr.w	Hud_Lives

	.chkbonus:
		tst.b	(f_endactbonus).w ; does the ring/time bonus counter need updating?
		beq.s	.finish		; if not, branch
		clr.b	(f_endactbonus).w
		VDP_CMD move.l,$AE00,VRAM,WRITE,VDP_CTRL
		moveq	#0,d1
		move.w	(v_timebonus).w,d1 ; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1 ; load ring bonus
		bsr.w	Hud_TimeRingBonus

	.finish:
		rts	
; End of function HUD_Update

; ---------------------------------------------------------------------------
; Subroutine to	load "0" on the	HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_LoadZero:
		VDP_CMD move.l,$DF40,VRAM,WRITE,VDP_CTRL
		lea	Hud_TilesZero(pc),a2
		move.w	#3-1,d2
		bra.s	loc_1C83E
; End of function Hud_LoadZero

; ---------------------------------------------------------------------------
; Subroutine to	load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Base:
		lea	VDP_DATA,a6
		bsr.w	Hud_Lives
		VDP_CMD move.l,$DC40,VRAM,WRITE,VDP_CTRL
		lea	Hud_TilesBase(pc),a2
		move.w	#$F-1,d2

loc_1C83E:
		lea	Art_HudNums,a1

loc_1C842:
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_1C85E
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_1C852:
		move.l	(a3)+,(a6)
		dbf	d1,loc_1C852

loc_1C858:
		dbf	d2,loc_1C842

		rts	
; ===========================================================================

loc_1C85E:
		move.l	#0,(a6)
		dbf	d1,loc_1C85E

		bra.s	loc_1C858
; End of function Hud_Base

; ===========================================================================
Hud_TilesBase:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF,	0
		dc.b $FF, $FF, $FF, $FF
Hud_TilesZero:	dc.b $FF, $FF, 0
		even
; ---------------------------------------------------------------------------
; Subroutine to	load debug mode	numbers	patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HudDb_XY:
		VDP_CMD move.l,$DC40,VRAM,WRITE,VDP_CTRL
		move.w	(v_screenposx).w,d1 ; load camera x-position
		swap	d1
		move.w	(v_player+obX).w,d1 ; load Sonic's x-position
		bsr.s	HudDb_XY2
		move.w	(v_screenposy).w,d1 ; load camera y-position
		swap	d1
		move.w	(v_player+obY).w,d1 ; load Sonic's y-position
; End of function HudDb_XY


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HudDb_XY2:
		moveq	#7,d6
		lea	(Art_Text).l,a1

HudDb_XYLoop:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_1C8B2
		addq.w	#7,d2

loc_1C8B2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,HudDb_XYLoop	; repeat 7 more	times

		rts	
; End of function HudDb_XY2

; ---------------------------------------------------------------------------
; Subroutine to	load rings numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Rings:
		lea	(Hud_100).l,a2
		moveq	#2,d6
		bra.s	Hud_LoadArt
; End of function Hud_Rings

; ---------------------------------------------------------------------------
; Subroutine to	load score numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Score:
		lea	(Hud_100000).l,a2
		moveq	#5,d6

Hud_LoadArt:
		moveq	#0,d4
		lea	Art_HudNums,a1

Hud_ScoreLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C8EC:
		sub.l	d3,d1
		bcs.s	loc_1C8F4
		addq.b	#1,d2
		bra.s	loc_1C8EC
; ===========================================================================

loc_1C8F4:
		add.l	d3,d1
		tst.b	d2
		beq.s	loc_1C8FE
		moveq	#1,d4

loc_1C8FE:
		tst.b	d4
		beq.s	.zero
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		bra.s	loc_1C92C
	
	.zero:
		move.l	d0,4(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)
		move.l	d2,(a6)

loc_1C92C:
		addi.l	#$400000,d0
		dbf	d6,Hud_ScoreLoop
		rts	

; End of function Hud_Score

; ---------------------------------------------------------------------------
; Update health
; ---------------------------------------------------------------------------

HUD_UpdateHealth:
		lea	v_player.w,a0

		tst.w	f_pause.w
		bne.s	.NoLeak
		tst.b	levelStarted.w
		beq.s	.NoLeak
		tst.b	levelEnded.w
		bne.s	.NoLeak
		tst.b	tireLeak.w
		beq.s	.NoLeak
		btst	#LSD_MODE,effectFlags.w
		bne.s	.NoLeak
		btst	#6,obStatus(a0)
		bne.s	.NoLeak
		
		moveq	#$18,d0
		btst	#RAVE_MODE,effectFlags.w
		beq.s	.CheckDead
		lsr.w	#1,d0
	
	.CheckDead:
		sub.w	d0,tirePressure.w
		bcc.s	.NoLeak
		clr.w	tirePressure.w

		btst	#1,obStatus(a0)
		bne.s	.NoLeak

		move.b	#$A,obRoutine(a0)
		move.b	#id_Wait,obAnim(a0)
		move.w	#60,$3A(a0)
		bsr.w	Sonic_RevertSuper
		
		lea	CBPCM_Stop,a1
		jsr	CallSubFunction
		
		moveq	#$FFFFFF00|sfx_Death,d0
		jsr	PlaySound_Special

	.NoLeak:
		VDP_CMD move.l,$DE40,VRAM,WRITE,4(a6)
		lea	health.w,a0
		bsr.s	HUD_DrawMeter
		
		VDP_CMD move.l,$DEC0,VRAM,WRITE,4(a6)
		lea	tirePressure.w,a0
		
; ---------------------------------------------------------------------------

HUD_DrawMeter:
		moveq	#0,d0
		move.b	(a0),d0
		add.w	d0,d0
		add.w	d0,d0
		lea	.Heights(pc,d0.w),a1

		move.l	#$11111111,d2
		move.l	d2,(a6)

		move.w	(a1)+,d0
		bmi.s	.Bottom
		move.l	#$16666661,d1

	.DrawTop:
		move.l	d1,(a6)
		dbf	d0,.DrawTop

	.Bottom:
		move.w	(a1)+,d0
		bmi.s	.End
		move.l	#$1FFFFFF1,d1
		cmpi.b	#$30,(a0)
		bcc.s	.DrawBottom
		btst	#4,v_vbla_byte.w
		beq.s	.DrawBottom
		move.l	#$1CCCCCC1,d1

	.DrawBottom:
		move.l	d1,(a6)
		dbf	d0,.DrawBottom
		
	.End:
		move.l	d2,(a6)
		rts

; ---------------------------------------------------------------------------

.Heights:
		c: = 0
		rept	256
			h: = ((255-c)*30)/255
			dc.w	h-1, (30-h)-1
			c: = c+1
		endr
		
; ---------------------------------------------------------------------------
; Draw HUD sprites
; ---------------------------------------------------------------------------

BuildHUD:
		tst.b	levelStarted.w
		beq.s	.End
	
		moveq	#0,d1
		tst.w	(v_rings).w
		bne.s	.Draw		; blink ring count if it's 0
		btst	#3,(v_framebyte).w
		bne.s	.Draw		; only blink on certain frames
		moveq	#1,d1		; set mapping frame ring counter blink

.Draw:
		move.w	#128+16,d3	; set X pos
		move.w	#128+136,d2	; set Y pos
		lea	Map_HUD,a1
		movea.w	#$6CA,a3	; set art tile and flags
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	.End
		jmp	BuildSpr_Normal

.End:
		rts

; ---------------------------------------------------------------------------
