; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move	#$2300,sr
		endm

; ---------------------------------------------------------------------------
; long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro loc
		bls.s	.nojump
		jmp	loc
	.nojump:
		endm

jcc:		macro loc
		bcs.s	.nojump
		jmp	loc
	.nojump:
		endm

jhs:		macro loc
		jcc	loc
		endm

jls:		macro loc
		bhi.s	.nojump
		jmp	loc
	.nojump:
		endm

jcs:		macro loc
		bcc.s	.nojump
		jmp	loc
	.nojump:
		endm

jlo:		macro loc
		jcs	loc
		endm

jeq:		macro loc
		bne.s	.nojump
		jmp	loc
	.nojump:
		endm

jne:		macro loc
		beq.s	.nojump
		jmp	loc
	.nojump:
		endm

jgt:		macro loc
		ble.s	.nojump
		jmp	loc
	.nojump:
		endm

jge:		macro loc
		blt.s	.nojump
		jmp	loc
	.nojump:
		endm

jle:		macro loc
		bgt.s	.nojump
		jmp	loc
	.nojump:
		endm

jlt:		macro loc
		bge.s	.nojump
		jmp	loc
	.nojump:
		endm

jpl:		macro loc
		bmi.s	.nojump
		jmp	loc
	.nojump:
		endm

jmi:		macro loc
		bpl.s	.nojump
		jmp	loc
	.nojump:
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if (narg=2)
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	obX(a0),d0	; get object position
		endc
		andi.w	#$FF80,d0	; round down to nearest $80
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#128+320+192,d0
		bhi.\0	exit
		endm
		
; ---------------------------------------------------------------------------
