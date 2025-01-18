

; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SignpostArtLoad:
		tst.w	(v_debuguse).w	; is debug mode	being used?
		bne.w	.exit		; if yes, branch
		cmpi.b	#2,(v_act).w	; is act number 02 (act 3)?
		beq.s	.exit		; if yes, branch

		move.w	(v_screenposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0		; has Sonic reached the	edge of	the level?
		blt.s	.exit		; if not, branch
		cmp.w	(v_limitleft2).w,d1
		ble.s	.exit
		move.w	d1,(v_limitleft2).w ; move left boundary to current screen position
		moveq	#plcid_Signpost,d0
		jmp	NewPLC		; load signpost	patterns

	.exit:
		rts	
; End of function SignpostArtLoad