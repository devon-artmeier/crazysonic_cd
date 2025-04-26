; ---------------------------------------------------------------------------
; Object 25 - rings
; ---------------------------------------------------------------------------

Rings:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ring_Index(pc,d0.w),d1
		jmp	Ring_Index(pc,d1.w)
; ===========================================================================
Ring_Index:
ptr_Ring_Main:		dc.w Ring_Main-Ring_Index
ptr_Ring_Animate:	dc.w Ring_Animate-Ring_Index
ptr_Ring_Collect:	dc.w Ring_Collect-Ring_Index
ptr_Ring_Sparkle:	dc.w Ring_Sparkle-Ring_Index
ptr_Ring_Delete:	dc.w Ring_Delete-Ring_Index

id_Ring_Main:		equ ptr_Ring_Main-Ring_Index	; 0
id_Ring_Animate:	equ ptr_Ring_Animate-Ring_Index	; 2
id_Ring_Collect:	equ ptr_Ring_Collect-Ring_Index	; 4
id_Ring_Sparkle:	equ ptr_Ring_Sparkle-Ring_Index	; 6
id_Ring_Delete:		equ ptr_Ring_Delete-Ring_Index	; 8
; ===========================================================================

Ring_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Ring,obMap(a0)
		move.w	#$27B2,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#v_spritequeue+$100,obPriority(a0)
		move.b	#$47,obColType(a0)
		move.b	#8,obActWid(a0)

Ring_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0) ; set frame
		out_of_range.s	Ring_Delete
		jmp	DisplaySprite
; ===========================================================================

Ring_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)
		move.b	#0,obColType(a0)
		move.w	#v_spritequeue+$80,obPriority(a0)
		bsr.s	CollectRing

Ring_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ===========================================================================

Ring_Delete:	; Routine 8
		jmp	DeleteObject

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CollectRing:
		move.w	#sfx_Ring,d0	; play ring sound
		
		cmpi.w	#999,(v_rings).w
		bhs.s	.playsnd
		addq.w	#1,(v_rings).w	; add 1 to rings
		ori.b	#1,(f_ringcount).w ; update the rings counter
		
		cmpi.w	#100,(v_rings).w ; do you have < 100 rings?
		bcs.s	.playsnd	; if yes, branch
		bset	#1,(v_lifecount).w ; update lives counter
		beq.s	.got100
		cmpi.w	#200,(v_rings).w ; do you have < 200 rings?
		bcs.s	.playsnd	; if yes, branch
		bset	#2,(v_lifecount).w ; update lives counter
		bne.s	.playsnd

	.got100:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		move.w	#sfx_Cash,d0 ; play extra life music

	.playsnd:
		jmp	(PlaySound_Special).l
; End of function CollectRing

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 37 - rings flying out of Sonic	when he's hit
; ---------------------------------------------------------------------------

RingLoss:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	RLoss_Index(pc,d0.w),d1
		jmp	RLoss_Index(pc,d1.w)
; ===========================================================================
RLoss_Index:	dc.w RLoss_Count-RLoss_Index
		dc.w RLoss_Bounce-RLoss_Index
		dc.w RLoss_Collect-RLoss_Index
		dc.w RLoss_Sparkle-RLoss_Index
		dc.w RLoss_Delete-RLoss_Index
; ===========================================================================

RLoss_Count:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(v_rings).w,d5	; check number of rings you have
		moveq	#32,d0
		cmp.w	d0,d5		; do you have 32 or more?
		bcs.s	.belowmax	; if not, branch
		move.w	d0,d5		; if yes, set d5 to 32

	.belowmax:
		subq.w	#1,d5
		lea	SpillRingData(pc),a3
		bra.s	.makerings
; ===========================================================================

	.loop:
		bsr.w	FindFreeObj
		bne.w	.resetcounter

.makerings:
		move.b	#id_RingLoss,0(a1) ; load bouncing ring object
		addq.b	#2,obRoutine(a1)
		move.b	#8,obHeight(a1)
		move.b	#8,obWidth(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Ring,obMap(a1)
		move.w	#$27B2,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	#v_spritequeue+$180,obPriority(a1)
		move.b	#$47,obColType(a1)
		move.b	#8,obActWid(a1)
		move.l	(a3)+,obVelX(a1)
		dbf	d5,.loop	; repeat for number of rings (max 31)

.resetcounter:
		move.w	#0,(v_rings).w	; reset number of rings to zero
		move.b	#$80,(f_ringcount).w ; update ring counter
		move.b	#0,(v_lifecount).w
		move.w	#sfx_RingLoss,d0
		jsr	(PlaySound_Special).l	; play ring loss sound

		moveq	#-1,d0                  ; Move #-1 to d0
		move.b	d0,obDelayAni(a0)       ; Move d0 to new timer
		move.b	d0,(v_ani3_time).w      ; Move d0 to old timer (for animated purposes)

RLoss_Bounce:	; Routine 2
		move.b	(v_ani3_frame).w,obFrame(a0)
		jsr	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	.chkdel
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	.chkdel
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	.chkdel
		add.w	d1,obY(a0)
		move.w	obVelY(a0),d0
		asr.w	#2,d0
		sub.w	d0,obVelY(a0)
		neg.w	obVelY(a0)

	.chkdel:
		subq.b  #1,obDelayAni(a0)
		beq.s	RLoss_Delete
		cmpi.w	#-$100,(v_limittop2).w
		beq.s	.display
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object moved below level boundary?
		bcs.s	RLoss_Delete	; if yes, branch

	.display:
		jmp	DisplaySprite
; ===========================================================================

RLoss_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)
		move.b	#0,obColType(a0)
		move.w	#v_spritequeue+$80,obPriority(a0)
		bsr.w	CollectRing

RLoss_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite
; ===========================================================================

RLoss_Delete:	; Routine 8
		jmp	DeleteObject
; ===========================================================================
; ---------------------------------------------------------------------------
; Ring Spawn Array
; ---------------------------------------------------------------------------

SpillRingData:
		dc.w	$FC14,$FF3C, $FC14,$00C4, $FCB0,$FDC8, $FCB0,$0238
		dc.w	$FDC8,$FCB0, $FDC8,$0350, $FF3C,$FC14, $FF3C,$03EC
		dc.w	$00C4,$FC14, $00C4,$03EC, $0238,$FCB0, $0238,$0350
		dc.w	$0350,$FDC8, $0350,$0238, $03EC,$FF3C, $03EC,$00C4
		dc.w	$FE0A,$FF9E, $FE0A,$0062, $FE58,$FEE4, $FE58,$011C
		dc.w	$FEE4,$FE58, $FEE4,$01A8, $FF9E,$FE0A, $FF9E,$01F6
		dc.w	$0062,$FE0A, $0062,$01F6, $011C,$FE58, $011C,$01A8
		dc.w	$01A8,$FEE4, $01A8,$011C, $01F6,$FF9E, $01F6,$0062
; ===========================================================================