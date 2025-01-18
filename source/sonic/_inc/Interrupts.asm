; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		REQUEST_INT2
		tst.b	(v_vbla_routine).w
		beq.w	VBla_00
		lea	VDP_CTRL,a5
		move.w	(a5),d0
		
		btst	#LSD_MODE,effectFlags.w
		bne.s	.lsd
		move.l	#$40000010,(a5)
		move.l	(v_scrposy_dup).w,-4(a5) ; send screen y-axis pos. to VSRAM
		bra.s	.chkPAL
		
	.lsd:
		STOP_Z80
		DMA_68K lsdVScroll,0,$50,VSRAM,(a5)
		START_Z80
	
	.chkPAL:
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	.notPAL		; if not, branch

		move.w	#$700,d0
	.waitPAL:
		dbf	d0,.waitPAL ; wait here in a loop doing nothing for a while...

	.notPAL:
		move.b	(v_vbla_routine).w,d0
		move.b	#0,(v_vbla_routine).w
		move.w	#1,(f_hbla_pal).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Music:
		jsr	UpdateSound
		
VBla_Exit:
		jsr	UpdateEffectTimers
		addq.l	#1,(v_vbla_count).w
		movem.l	(sp)+,d0-a6
		rte	
; ===========================================================================
VBla_Index:	dc.w VBla_00-VBla_Index, VBla_02-VBla_Index
		dc.w VBla_04-VBla_Index, VBla_06-VBla_Index
		dc.w VBla_08-VBla_Index, VBla_0A-VBla_Index
		dc.w VBla_0C-VBla_Index, VBla_0E-VBla_Index
		dc.w VBla_10-VBla_Index, VBla_12-VBla_Index
		dc.w VBla_14-VBla_Index, VBla_16-VBla_Index
		dc.w VBla_0C-VBla_Index
; ===========================================================================

VInt_UpdatePal:
		tst.b	effectFlags.w
		bne.s	.effect
		tst.b	(f_wtr_state).w	
		bne.s	.water
		DMA_68K v_pal_dry,0,$80,CRAM,(a5)
		rts

.water:
		DMA_68K v_pal_water,0,$80,CRAM,(a5)
		rts
		
.effect:
		tst.b	(f_wtr_state).w	
		bne.s	.watereffect
		DMA_68K effectPalette,0,$80,CRAM,(a5)
		rts

.watereffect:
		DMA_68K effectWaterPal,0,$80,CRAM,(a5)
		rts
; ===========================================================================

VBla_00:
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ ?
		bne.w	VBla_Music	; if not, branch

		move.w	(VDP_CTRL).l,d0
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	.notPAL		; if not, branch

		move.w	#$700,d0
	.waitPAL:
		dbf	d0,.waitPAL

	.notPAL:
		move.w	#1,(f_hbla_pal).w ; set HBlank flag
		STOP_Z80
		
		lea	VDP_CTRL,a5
		bsr.w	VInt_UpdatePal
		move.w	(v_hbla_hreg).w,(a5)
		START_Z80
		bra.w	VBla_Music
; ===========================================================================

VBla_02:
		bsr.w	sub_106E

VBla_14:
		tst.w	(v_demolength).w
		beq.w	.end
		subq.w	#1,(v_demolength).w

	.end:
VBla_04:
VBla_06:
VBla_0A:
VBla_0E:
VBla_16:
		rts		
; ===========================================================================

VBla_10:
VBla_08:
		STOP_Z80
		jsr	ReadJoypads
		
		lea	VDP_CTRL,a5
		bsr.w	VInt_UpdatePal
		move.w	(v_hbla_hreg).w,(a5)
		DMA_68K v_hscrolltablebuffer,vram_hscroll,$380,VRAM,(a5)
		DMA_68K v_spritetablebuffer,vram_sprites,$280,VRAM,(a5)
		jsr	ProcessDMAQueue
		START_Z80
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		cmpi.b	#96,(v_hbla_line).w
		bhs.s	Demo_Time
		move.b	#1,(f_hint_updates).w
		addq.l	#4,sp
		bra.w	VBla_Exit

; ---------------------------------------------------------------------------
; Subroutine to	run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Demo_Time:
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		jsr	ProcessDPLC2
		tst.w	(v_demolength).w ; is there time left on the demo?
		beq.w	.end		; if not, branch
		subq.w	#1,(v_demolength).w ; subtract 1 from time left

	.end:
		rts	
; End of function Demo_Time

; ===========================================================================

VBla_0C:
		STOP_Z80
		jsr	ReadJoypads
		
		lea	VDP_CTRL,a5
		bsr.w	VInt_UpdatePal
		move.w	(v_hbla_hreg).w,(a5)
		DMA_68K v_hscrolltablebuffer,vram_hscroll,$380,VRAM,(a5)
		DMA_68K v_spritetablebuffer,vram_sprites,$280,VRAM,(a5)
		jsr	ProcessDMAQueue
		START_Z80
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		jmp	sub_1642
; ===========================================================================

VBla_12:
		bsr.w	sub_106E
		move.w	(v_hbla_hreg).w,(a5)
		jmp	sub_1642	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_106E:
		STOP_Z80
		jsr	ReadJoypads
		lea	VDP_CTRL,a5
		bsr.w	VInt_UpdatePal
		DMA_68K v_spritetablebuffer,vram_sprites,$280,VRAM,(a5)
		DMA_68K v_hscrolltablebuffer,vram_hscroll,$380,VRAM,(a5)
		jsr	ProcessDMAQueue
		START_Z80
		rts	
; End of function sub_106E

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HBlank:
		disable_ints
		tst.w	(f_hbla_pal).w	; is palette set to change?
		beq.s	.nochg		; if not, branch
		move.w	#0,(f_hbla_pal).w
		movem.l	a0-a1,-(sp)
		lea	(VDP_DATA).l,a1
		lea	(v_pal_water).w,a0 ; get palette from RAM
		tst.b	effectFlags.w
		beq.s	.pal
		lea	(effectWaterPal).w,a0
		
	.pal:
		move.l	#$C0000000,4(a1) ; set VDP to CRAM write
		move.l	(a0)+,(a1)	; move palette to CRAM
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.w	#$8A00+223,4(a1) ; reset HBlank register
		movem.l	(sp)+,a0-a1
		tst.b	(f_hint_updates).w
		bne.s	loc_119E

	.nochg:
		rte	
; ===========================================================================

loc_119E:
		clr.b	(f_hint_updates).w
		movem.l	d0-a6,-(sp)
		bsr.w	Demo_Time
		jsr	UpdateSound
		movem.l	(sp)+,d0-a6
		rte	
; End of function HBlank