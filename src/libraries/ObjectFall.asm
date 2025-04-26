; ---------------------------------------------------------------------------
; Subroutine to	make an	object fall downwards, increasingly fast
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjectFall:
		movem.w	obVelX(a0),d0-d1
		asl.l	#8,d0
		asl.l	#8,d1
		add.l	d0,obX(a0)
		add.l	d1,obY(a0)
		addi.w	#$38,obVelY(a0)	; increase vertical speed
		rts	

; End of function ObjectFall