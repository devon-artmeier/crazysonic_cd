; ---------------------------------------------------------------------------
; Subroutine translating object	speed to update	object position
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SpeedToPos:
		movem.w	obVelX(a0),d0-d1
		asl.l	#8,d0
		asl.l	#8,d1
		add.l	d0,obX(a0)
		add.l	d1,obY(a0)
		rts	

; End of function SpeedToPos