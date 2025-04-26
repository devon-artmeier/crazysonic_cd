; ===========================================================================
; ----------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; This is a version ported from Sonic 3 & Knuckles
; ----------------------------------------------------------------------------

; loc_16F88:
RingsManager:
	moveq	#0,d0
	move.b	(Rings_manager_routine).w,d0
	move.w	RingsManager_States(pc,d0.w),d0
	jmp	RingsManager_States(pc,d0.w)
; ===========================================================================
; off_16F96:
RingsManager_States:
	dc.w RingsManager_Init-RingsManager_States
	dc.w RingsManager_Main-RingsManager_States
; ===========================================================================
; loc_16F9A:
RingsManager_Init:
	addq.b	#2,(Rings_manager_routine).w ; => RingsManager_Main
	bsr.w	RingsManager_Setup	; perform initial setup

RingsManager_Reset:
	bsr.w	RingsManager_InitRingPos

	movea.l	(Ring_start_addr_ROM).w,a1
	lea	(Ring_Positions).w,a2
	move.w	(v_screenposx).w,d4
	subq.w	#8,d4
	bhi.s	.GetLeft
	moveq	#1,d4	; no negative values allowed
	bra.s	.GetLeft

.NextLeft:
	addq.w	#4,a1	; load next ring 
	addq.w	#2,a2

.GetLeft:
	cmp.w	(a1),d4		; is the X pos of the ring < camera X pos?
	bhi.s	.NextLeft	; if it is, check next ring
	move.l	a1,(Ring_start_addr_ROM).w	; set start addresses in both ROM and RAM
	move.w	a2,(Ring_start_addr_RAM).w
	addi.w	#320+16,d4	; advance by a screen
	bra.s	.GetRight

.NextRight:
	addq.w	#4,a1	; load next ring

.GetRight:
	cmp.w	(a1),d4		; is the X pos of the ring < camera X + 336?
	bhi.s	.NextRight	; if it is, check next ring
	move.l	a1,(Ring_end_addr_ROM).w	; set end addresses
	rts
; ===========================================================================
; loc_16FDE:
RingsManager_Main:
	lea	(Ring_consumption_table).w,a2
	move.w	(a2)+,d1
	subq.w	#1,d1		; are any rings currently being consumed?
	bcs.s	.NoConsume	; if not, branch

.ConsumeLoop:
	move.w	(a2)+,d0	; is there a ring in this slot?
	beq.s	.ConsumeLoop	; if not, branch
	movea.w	d0,a1		; load ring address
	subq.b	#1,(a1)		; decrement timer
	bne.s	.NextConsume	; if it's not 0 yet, branch
	move.b	#6,(a1)		; reset timer
	addq.b	#1,1(a1)	; increment frame
	cmpi.b	#8,1(a1)	; is it destruction time yet?
	bne.s	.NextConsume	; if not, branch
	move.w	#-1,(a1)	; destroy ring
	move.w	#0,-2(a2)	; clear ring entry
	subq.w	#1,(Ring_consumption_table).w	; subtract count

.NextConsume:
	dbf	d1,.ConsumeLoop	; repeat for all rings in table

.NoConsume:
	; update ring start addresses
	movea.l	(Ring_start_addr_ROM).w,a1
	movea.w	(Ring_start_addr_RAM).w,a2
	move.w	(v_screenposx).w,d4
	subq.w	#8,d4
	bhi.s	.GetLeft1
	moveq	#1,d4
	bra.s	.GetLeft1

.NextLeft1:
	addq.w	#4,a1
	addq.w	#2,a2

.GetLeft1:
	cmp.w	(a1),d4
	bhi.s	.NextLeft1
	bra.s	.GetLeft2

.NextLeft2:
	subq.w	#4,a1
	subq.w	#2,a2

.GetLeft2:
	cmp.w	-4(a1),d4
	bls.s	.NextLeft2
	move.l	a1,(Ring_start_addr_ROM).w	; update start addresses
	move.w	a2,(Ring_start_addr_RAM).w
	
	movea.l	(Ring_end_addr_ROM).w,a2	; set end address
	addi.w	#320+16,d4	; advance by a screen
	bra.s	.GetRight

.NextRight:
	addq.w	#4,a2

.GetRight:
	cmp.w	(a2),d4
	bhi.s	.NextRight
	bra.s	.GetRight2

.NextRight2:
	subq.w	#4,a2

.GetRight2:
	cmp.w	-4(a2),d4
	bls.s	.NextRight2
	move.l	a2,(Ring_end_addr_ROM).w	; update end address
	rts

; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_170BA:
Touch_Rings:
	movea.l	(Ring_start_addr_ROM).w,a1	; load start and end addresses
	movea.l	(Ring_end_addr_ROM).w,a2
	cmpa.l	a1,a2	; are there no rings in this area?
	beq.w	Touch_Rings_Done	; if so, return
	movea.w	(Ring_start_addr_RAM).w,a4	; load start address
	
	cmpi.w	#90,flashtime(a0)
	bcc.w	Touch_Rings_Done

	move.w	obX(a0),d2	; get character's position
	move.w	obY(a0),d3
	subi.w	#8,d2	; assume X radius to be 8
	moveq	#0,d5
	move.b	obHeight(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3	; subtract (Y radius - 3) from Y pos
	move.w	#6,d1	; set ring radius
	move.w	#$C,d6	; set ring diameter
	move.w	#$10,d4	; set character's X diameter
	add.w	d5,d5	; set Y diameter

Touch_Rings_Loop:
	tst.w	(a4)	; has this ring already been collided with?
	bne.w	Touch_NextRing	; if it has, branch
	move.w	(a1),d0		; get ring X pos
	sub.w	d1,d0		; get ring left edge X pos
	sub.w	d2,d0		; subtract character's left edge X pos
	bcc.s	.CheckX		; if character's to the left of the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	.GetY		; if character's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring

.CheckX:
	cmp.w	d4,d0		; has character crossed the ring?
	bhi.w	Touch_NextRing	; if they have, branch

.GetY:
	move.w	2(a1),d0	; get ring Y pos
	sub.w	d1,d0		; get ring top edge pos
	sub.w	d3,d0		; subtract character's top edge pos
	bcc.s	.CheckY		; if character's above the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	.TouchRing	; if character's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring

.CheckY:
	cmp.w	d5,d0		; has character crossed the ring?
	bhi.w	Touch_NextRing	; if they have, branch

.TouchRing:
	move.w	#$604,(a4)		; set frame and destruction timer
	bsr.s	Touch_ConsumeRing
	lea	(Ring_consumption_table+2).w,a3

.FindSlot:
	tst.w	(a3)+		; is this slot free?
	bne.s	.FindSlot	; if not, repeat until you find one
	move.w	a4,-(a3)	; set ring address
	addq.w	#1,(Ring_consumption_table).w	; increase count

Touch_NextRing:
	addq.w	#4,a1
	addq.w	#2,a4
	cmpa.l	a1,a2		; are we at the last ring for this area?
	bne.w	Touch_Rings_Loop	; if not, branch

Touch_Rings_Done:
	rts
; ===========================================================================

Touch_ConsumeRing:
	;subq.w	#1,(Perfect_rings_left).w
	jmp	CollectRing

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


BuildRings:
	tst.b	levelStarted.w
	beq.s	.End
		
	movea.l	(Ring_start_addr_ROM).w,a0
	move.l	(Ring_end_addr_ROM).w,d7
	sub.l	a0,d7		; are there any rings on-screen?
	bne.s	.Start		; if there are, branch
	
.End:
	rts			; otherwise, return

.Start:
	movea.w	(Ring_start_addr_RAM).w,a4	; load start address
	lea	(v_screenposx).w,a3		; load camera x position

BuildRings_Loop:
	tst.w	(a4)+		; has this ring been consumed?
	bmi.w	BuildRings_NextRing	; if it has, branch
	
	move.w	(a0),d3		; get ring X pos
	sub.w	(a3),d3		; subtract camera X pos
	addi.w	#128,d3		; screen top is 128x128 not 0x0
	
	move.w	2(a0),d2	; get ring Y pos
	sub.w	4(a3),d2	; subtract camera Y pos
	addq.w	#8,d2
	andi.w	#$7FF,d2
	cmpi.w	#224+16,d2
	bhs.s	BuildRings_NextRing	; if the ring is not on-screen, branch
	
	addi.w	#128-8,d2
	lea	Map_Ring,a1
	moveq	#0,d1
	move.b	-1(a4),d1	; get ring frame
	bne.s	.GotFrame	; if this ring is using a specific frame, branch
	move.b	(v_ani1_frame).w,d1	; use global frame

.GotFrame:
	add.w	d1,d1
	adda.w	(a1,d1.w),a1	; get frame data address
	addq.w	#2,a1
	
	move.b	(a1)+,d0	; get Y offset
	ext.w	d0
	add.w	d2,d0		; add Y offset to Y pos
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0	; get art tile
	addi.w	#$27B2,d0	; add base art tile
	move.w	d0,(a2)+	; set art tile and flags
	move.w	(a1)+,d0	; get X offset
	add.w	d3,d0		; add base X pos
	move.w	d0,(a2)+	; set X pos

BuildRings_NextRing:
	addq.w	#4,a0
	subq.w	#4,d7
	bne.w	BuildRings_Loop
	rts

; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


RingsManager_Setup:
	lea	(Ring_Positions).w,a1
	moveq	#0,d0
	move.w	#$240/2-1,d1

.Clear:
	move.l	d0,(a1)+
	dbf	d1,.Clear
	rts

RingsManager_InitRingPos:
	moveq	#0,d5
	moveq	#0,d0
	move.b	(v_act).w,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	RingPos_Index,a1	; get the rings for the act
	movea.l	(a1,d0.w),a1
	move.l	a1,(Ring_start_addr_ROM).w
	addq.w	#4,a1
	moveq	#0,d5
	move.w	#511-1,d0	

.Count:
	tst.l	(a1)+		; get the next ring
	bmi.s	.Done		; if there's no more, carry on
	addq.w	#1,d5		; increment perfect counter
	dbf	d0,.Count

.Done:
	;move.w	d5,(Perfect_rings_left).w	; set the perfect ring amount for the act
	;move.w	#0,(Perfect_rings_flag).w	; clear the perfect ring flag
	rts
; ===========================================================================
