; -------------------------------------------------------------------------
; Destination object
; -------------------------------------------------------------------------

ObjDestination:
	movea.l	curCustomer,a5				; Check if customer picked up
	cmpi.l	#ObjCustomer_Bus,oAddr(a5)
	bne.s	.End

	cmp.l	curDestination,a0			; Check if current destination
	bne.s	.End

	bsr.w	CheckCustomerArea			; Check drop off area
	bcs.s	.End

	move.w	oX(a0),oCustDestX(a5)			; Drop off at destination
	move.w	oY(a0),oCustDestY(a5)

	bset	#7,oFlags(a6)				; Lock controls
	bset	#2,arrowObject+oFlags			; Hide arrow
	move.l	#ObjCustomer_GetOff,oAddr(a5)		; Get off
	st	timerPaused				; Pause timer
	move.b	#5,timerInc				; Increment timer

	clr.l	oAddr(a0)				; Done

.End:
	rts

; -------------------------------------------------------------------------

.Frames:
	dc.b	0, 0, 0, 0
	dc.b	1, 1
	dc.b	2, 2, 2
	dc.b	3, 3, 3, 3
	dc.b	4, 4, 4, 4
	dc.b	5, 5, 5, 5
	dc.b	6, 6, 6, 6
	dc.b	7, 7, 7, 7
	dc.b	8, 8, 8, 8
	dc.b	9, 9, 9, 9
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A
	even

; -------------------------------------------------------------------------
