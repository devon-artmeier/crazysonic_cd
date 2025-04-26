; ---------------------------------------------------------------------------
; Subroutine to	initialise joypads
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


JoypadInit:
		STOP_Z80
		moveq	#$40,d0
		move.b	d0,(IO_CTRL_1).l	; init port 1 (joypad 1)
		move.b	d0,(IO_CTRL_2).l	; init port 2 (joypad 2)
		move.b	d0,(IO_CTRL_3).l	; init port 3 (expansion/extra)
		START_Z80
		rts	
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to	read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReadJoypads:
		lea	(v_jpadhold1).w,a0 ; address where joypad states are written
		lea	(IO_DATA_1).l,a1	; first	joypad port
		bsr.s	.read		; do the first joypad
		addq.w	#2,a1		; do the second	joypad

	.read:
		move.b	#0,(a1)
		nop	
		nop	
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop	
		nop	
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts	
; End of function ReadJoypads