; ===========================================================================
; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w	; is debug mode	being used?
		beq.s	Sonic_Normal	; if not, branch
		jmp	(DebugMode).l
; ===========================================================================

Sonic_Normal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================
Sonic_Index:	dc.w Sonic_Main-Sonic_Index
		dc.w Sonic_Control-Sonic_Index
		dc.w Sonic_Hurt-Sonic_Index
		dc.w Sonic_Death-Sonic_Index
		dc.w Sonic_ResetLevel-Sonic_Index
		dc.w Sonic_Popped-Sonic_Index
		dc.w Sonic_PopReset-Sonic_Index
; ===========================================================================

Sonic_Main:	; Routine 0
		move.b	#$C,(v_top_solid_bit).w	; MJ: set collision to 1st
		move.b	#$D,(v_lrb_solid_bit).w	; MJ: set collision to 1st
		addq.b	#2,obRoutine(a0)
		move.b	#SONIC_HEIGHT,obHeight(a0)
		move.b	#SONIC_WIDTH,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.w	#v_spritequeue+$100,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)

Sonic_Control:	; Routine 2
		tst.w	(f_debugmode).w	; is debug cheat enabled?
		beq.s	loc_12C58	; if not, branch
		btst	#bitB,(v_jpadpress1).w ; is button B pressed?
		beq.s	loc_12C58	; if not, branch
		move.w	#1,(v_debuguse).w ; change Sonic into a ring/item
		clr.b	(f_lockctrl).w
		rts	
; ===========================================================================

loc_12C58:
		tst.b	(f_lockctrl).w	; are controls locked?
		bne.s	loc_12C64	; if yes, branch
		move.w	(v_jpadhold1).w,(v_jpadhold2).w ; enable joypad control

loc_12C64:
		btst	#0,(f_lockmulti).w ; are controls locked?
		bne.s	loc_12C7E	; if yes, branch
		
		btst	#6,obStatus(a0)
		beq.s	.normal
		bsr.w	Sonic_Submarine
		bra.s	loc_12C7E
		
	.normal:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)
		bsr.w	Sonic_HandleSounds

loc_12C7E:
		cmpi.w	#-$100,(v_limittop2).w
		bne.s	.NoYWrap
		andi.w	#$7FF,obY(a0)

.NoYWrap:
		bsr.s	Sonic_Display
		bsr.w	Sonic_Super
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Water
		move.b	(v_anglebuffer).w,$36(a0)
		move.b	(v_anglebuffer+2).w,$37(a0)
		tst.b	(f_wtunnelmode).w
		beq.s	loc_12CA6
		tst.b	obAnim(a0)
		bne.s	loc_12CA6
		move.b	obNextAni(a0),obAnim(a0)

loc_12CA6:
		bsr.w	Sonic_Animate
		tst.b	(f_lockmulti).w
		bmi.s	loc_12CB6
		jsr	(ReactToItem).l

loc_12CB6:
		bsr.w	Sonic_Loops
		jmp	Sonic_LoadGfx
; ===========================================================================
Sonic_Modes:	dc.w Sonic_MdNormal-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes
		dc.w Sonic_MdRoll-Sonic_Modes
		dc.w Sonic_MdJump2-Sonic_Modes
; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	flashtime(a0),d0
		beq.s	.display
		subq.w	#1,flashtime(a0)
		lsr.w	#3,d0
		bcc.s	.chkinvincible

	.display:
		jsr	(DisplaySprite).l

	.chkinvincible:
		tst.b	(v_shoes).w	; does Sonic have speed	shoes?
		beq.s	.exit		; if not, branch
		tst.w	shoetime(a0)	; check	time remaining
		beq.s	.exit
		subq.w	#1,shoetime(a0)	; subtract 1 from time
		bne.s	.exit
		clr.b	(v_shoes).w	; cancel speed shoes

	.exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	record Sonic's previous positions for invincibility stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RecordPosition:
		move.w	(v_trackpos).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	obX(a0),(a1)+
		move.w	obY(a0),(a1)+
		addq.b	#4,(v_trackbyte).w
		rts	
; End of function Sonic_RecordPosition

; ===========================================================================

Sonic_GetSubSpeed:
		move.w	#$280,d6
		move.w	#$50,d5
		move.w	#$30,d4
		
		tst.b	(superFlag).w
		bne.s	.done

		move.w	#$180,d6
		moveq	#$30,d5
		move.w	#$80,d4

	.done:
		rts

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

Sonic_Water:
		cmpi.b	#1,(v_zone).w	; is level LZ?
		beq.s	.islabyrinth	; if yes, branch

	.exit:
		rts	
; ===========================================================================

	.islabyrinth:
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is Sonic above the water?
		bge.s	.abovewater	; if yes, branch
		bset	#6,obStatus(a0)
		bne.s	.exit

		bclr	#0,obStatus(a0)
		tst.w	obVelX(a0)
		bpl.s	.slowy
		bset	#0,obStatus(a0)

.slowy:
		asr	obVelX(a0)
		asr	obVelY(a0)
		beq.s	.exit
		
		move.b	#id_Splash,(v_objspace+$300).w ; load splash object
		move.w	#sfx_Splash,d0
		jmp	(PlaySound_Special).l	 ; play splash sound
; ===========================================================================

.abovewater:
		btst	#6,obStatus(a0)
		beq.s	.exit
		btst	#3,obStatus(a0)
		bne.s	.leavewater
		btst	#1,obStatus(a0)
		beq.s	.leavewater
		
		bsr.w	Sonic_GetSubSpeed
		neg.w	d6
		cmp.w	obVelY(a0),d6
		bge.s	.leavewater
		move.w	d0,obY(a0)
		rts

.leavewater:
		bclr	#6,obStatus(a0)

		move.b	#1,$3C(a0)
		clr.b	$38(a0)
		move.b	#id_Spring,obAnim(a0)
		bclr	#0,obStatus(a0)
		or.b	#%110,obStatus(a0)
		
		asl	obVelY(a0)
		asl	obVelY(a0)
		beq.w	.Exit
		
		cmpi.w	#-$1000,obVelY(a0)
		bgt.s	.belowmaxspeed
		move.w	#-$1000,obVelY(a0) ; set maximum speed on leaving water

.belowmaxspeed:
		move.b	#id_Splash,(v_objspace+$300).w ; load splash object
		move.w	#sfx_Splash,d0
		jmp	(PlaySound_Special).l	 ; play splash sound
; End of function Sonic_Water

; ===========================================================================
; ---------------------------------------------------------------------------
; Submarine mode
; ---------------------------------------------------------------------------

Sonic_Submarine:
		bsr.w	Sonic_GetSubSpeed

		moveq	#0,d0
		lea	cbpcmMotorMode,a1
		jsr	WriteSubByte
		moveq	#0,d0
		lea	cbpcmHonk,a1
		jsr	WriteSubByte
		
		btst	#3,obStatus(a0)
		bne.s	.CheckY
		bset	#1,obStatus(a0)
		
; ---------------------------------------------------------------------------

.CheckY:
		move.w	obVelY(a0),d0

		btst	#0,v_jpadhold2.w
		beq.s	.NoUp
		move.w	d6,d1
		neg.w	d1
		
		bclr	#3,obStatus(a0)
		beq.s	.AccelUp
		bset	#1,obStatus(a0)
		move.w	d1,d0
		asr.w	#2,d0
		
.AccelUp:
		sub.w	d5,d0
		cmp.w	d1,d0
		bgt.s	.SetYVel
		move.w	d1,d0
		bra.s	.SetYVel
		
.NoUp:
		btst	#1,v_jpadhold2.w
		beq.s	.SlowY
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	.SetYVel
		move.w	d6,d0
		bra.s	.SetYVel
		
; ---------------------------------------------------------------------------

.SlowY:
		tst.w	d0
		bmi.s	.SlowUp
		sub.w	d4,d0
		bpl.s	.SetYVel
		moveq	#0,d0
		bra.s	.SetYVel
		
.SlowUp:
		add.w	d4,d0
		bmi.s	.SetYVel
		moveq	#0,d0

.SetYVel:
		move.w	d0,obVelY(a0)
	
; ---------------------------------------------------------------------------

.CheckHoriz:
		move.w	obVelX(a0),d0
		
		btst	#2,v_jpadhold2.w
		beq.s	.NoLeft
		move.w	d6,d1
		neg.w	d1

		bset	#0,obStatus(a0)
		sub.w	d5,d0
		cmp.w	d1,d0
		bgt.s	.SetXVel
		move.w	d1,d0
		bra.s	.SetXVel
		
.NoLeft:
		btst	#3,v_jpadhold2.w
		beq.s	.SlowX
		bclr	#0,obStatus(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	.SetXVel
		move.w	d6,d0
		bra.s	.SetXVel
		
; ---------------------------------------------------------------------------

.SlowX:
		tst.w	d0
		bmi.s	.SlowLeft
		sub.w	d4,d0
		bpl.s	.SetXVel
		moveq	#0,d0
		bra.s	.SetXVel
		
.SlowLeft:
		add.w	d4,d0
		bmi.s	.SetXVel
		moveq	#0,d0
		
.SetXVel:
		move.w	d0,obVelX(a0)
	
; ---------------------------------------------------------------------------
	
.Update:
		btst	#bitC,(v_jpadpress2).w
		beq.s	.NoSuper
		bsr.w	Sonic_CheckSuper
		
.NoSuper:
		bsr.w	Sonic_LevelBound
		jsr	SpeedToPos
		jmp	Sonic_Floor

; ===========================================================================
; ---------------------------------------------------------------------------
; Modes	for controlling	Sonic
; ---------------------------------------------------------------------------

Sonic_MdNormal:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	SpeedToPos
		bsr.w	Sonic_AnglePos
		jmp	Sonic_SlopeRepel
; ===========================================================================

Sonic_MdJump:
Sonic_MdJump2:
		bsr.w	Sonic_DoubleJump
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	ObjectFall
		cmpi.w	#$FC0,obVelY(a0)
		ble.s	loc_12E5C
		move.w	#$FC0,obVelY(a0)

loc_12E5C:
		bsr.w	Sonic_JumpAngle
		jmp	Sonic_Floor
; ===========================================================================

Sonic_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	SpeedToPos
		bsr.w	Sonic_AnglePos
		jmp	Sonic_SlopeRepel
; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Move:
		bsr.w	Sonic_GetMoveSpeed
		
		tst.b	(f_jumponly).w
		bne.w	loc_12FEE
		tst.w	$3E(a0)
		bne.w	Sonic_ResetScr
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	.notleft	; if not, branch
		bsr.w	Sonic_MoveLeft
		bra.s	Sonic_ResetScr

	.notleft:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	.notright	; if not, branch
		bsr.w	Sonic_MoveRight
		bra.s	Sonic_ResetScr

	.notright:
		bclr	#5,obStatus(a0)

		move.b	#id_Walk,obAnim(a0) ; use "standing" animation
		clr.w	obInertia(a0)

Sonic_ResetScr:
		cmpi.w	#$60,(v_lookshift).w ; is screen in its default position?
		beq.s	loc_12FEE	; if yes, branch
		bcc.s	loc_12FBE
		addq.w	#4,(v_lookshift).w ; move screen back to default

loc_12FBE:
		subq.w	#2,(v_lookshift).w ; move screen back to default

loc_12FEE:
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)

loc_1300C:
		move.b	obAngle(a0),d0
		addi.b	#$40,d0
		bmi.s	locret_1307C
		move.b	#$40,d1
		tst.w	obInertia(a0)
		beq.s	locret_1307C
		bmi.s	loc_13024
		neg.w	d1

loc_13024:
		move.b	obAngle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_1307C
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_13078
		cmpi.b	#$40,d0
		beq.s	loc_13066
		cmpi.b	#$80,d0
		beq.s	loc_13060
		add.w	d1,obVelX(a0)
		bset	#5,obStatus(a0)
		move.w	#0,obInertia(a0)
		rts	
; ===========================================================================

loc_13060:
		sub.w	d1,obVelY(a0)
		rts	
; ===========================================================================

loc_13066:
		sub.w	d1,obVelX(a0)
		bset	#5,obStatus(a0)
		move.w	#0,obInertia(a0)
		rts	
; ===========================================================================

loc_13078:
		add.w	d1,obVelY(a0)

locret_1307C:
		rts	
; End of function Sonic_Move

; ===========================================================================

Sonic_GetMoveSpeed:
Sonic_GetAirSpeed:
		move.w	#$A00,d6
		move.w	#$60,d5
		move.w	#$100,d4
		
		tst.b	(superFlag).w
		bne.s	.done

		move.w	#$180,d6
		moveq	#$30,d5
		move.w	#$80,d4
		
		tst.b	(v_shoes).w
		beq.s	.done
		
		move.w	#$300,d6
		moveq	#$60,d5

	.done:
		rts
		
; ===========================================================================

Sonic_GetRollSpeed:
		move.w	#$1000,d6
		moveq	#$10,d5
		moveq	#$20,d4
		
		tst.b	(superFlag).w
		bne.s	.done

		move.w	#$C00,d6
		moveq	#6,d5
		
		tst.b	(v_shoes).w
		beq.s	.done
		
		move.w	#$1000,d6
		moveq	#$C,d5

	.done:
		rts
	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_13086
		bpl.s	loc_130B2

loc_13086:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_130A6
		add.w	d5,d0
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_130A6
		move.w	d1,d0

loc_130A6:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0) ; use walking animation
		rts	
; ===========================================================================

loc_130B2:
		sub.w	d4,d0
		bcc.s	loc_130A6
		move.w	#-$80,d0
		bra.s	loc_130A6
; End of function Sonic_MoveLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_13118
		
loc_13104:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_1310C
		sub.w	d5,d0
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_1310C
		move.w	d6,d0

loc_1310C:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0) ; use walking animation
		rts	

loc_13118:
		add.w	d4,d0
		bcc.s	loc_1310C
		move.w	#$80,d0
		bra.s	loc_1310C
; End of function Sonic_MoveRight

; ---------------------------------------------------------------------------
; Subroutine to handle bus honking
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HandleSounds:
		moveq	#3,d0

		tst.b	f_lockmulti.w
		bne.s	.SetMotor

		move.b	obStatus(a0),d1
		andi.b	#%110,d1
		bne.s	.SetMotor
		
		move.b	v_jpadhold2.w,d1
		andi.b	#%1100,d1
		beq.s	.SetMotor
		
		moveq	#2,d0
		btst	#2,d1
		beq.s	.SetMotor
		moveq	#1,d0

.SetMotor:
		lea	cbpcmMotorMode,a1
		jsr	WriteSubByte

		moveq	#0,d0
		btst	#bitA,v_jpadhold2.w
		beq.s	.Set
		moveq	#1,d0

.Set:
		lea	cbpcmHonk,a1
		jmp	WriteSubByte

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's speed as he rolls
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollSpeed:
		bsr.w	Sonic_GetRollSpeed
		
		tst.b	(f_jumponly).w
		bne.w	loc_131CC
		tst.w	$3E(a0)
		bne.s	.notright
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	.notleft	; if not, branch
		bsr.w	Sonic_RollLeft

	.notleft:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	.notright	; if not, branch
		bsr.w	Sonic_RollRight

	.notright:
		move.w	obInertia(a0),d0
		beq.s	loc_131AA
		bmi.s	loc_1319E
		sub.w	d5,d0
		bcc.s	loc_13198
		move.w	#0,d0

loc_13198:
		move.w	d0,obInertia(a0)
		bra.s	loc_131AA
; ===========================================================================

loc_1319E:
		add.w	d5,d0
		bcc.s	loc_131A6
		move.w	#0,d0

loc_131A6:
		move.w	d0,obInertia(a0)

loc_131AA:
		tst.w	obInertia(a0)	; is Sonic moving?
		bne.s	loc_131CC	; if yes, branch
		bclr	#2,obStatus(a0)
		move.b	#id_Walk,obAnim(a0) ; use "standing" animation

loc_131CC:
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		cmpi.w	#$1000,d1
		ble.s	loc_131F0
		move.w	#$1000,d1

loc_131F0:
		cmpi.w	#-$1000,d1
		bge.s	loc_131FA
		move.w	#-$1000,d1

loc_131FA:
		move.w	d1,obVelX(a0)
		bra.w	loc_1300C
; End of function Sonic_RollSpeed


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_1320A
		bpl.s	loc_13218

loc_1320A:
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		rts	
; ===========================================================================

loc_13218:
		sub.w	d4,d0
		bcc.s	loc_13220
		move.w	#-$80,d0

loc_13220:
		move.w	d0,obInertia(a0)
		rts	
; End of function Sonic_RollLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_1323A
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		rts	
; ===========================================================================

loc_1323A:
		add.w	d4,d0
		bcc.s	loc_13242
		move.w	#$80,d0

loc_13242:
		move.w	d0,obInertia(a0)
		rts	
; End of function Sonic_RollRight

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's direction while jumping
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpDirection:
		bsr.w	Sonic_GetAirSpeed
		
		move.w	obVelX(a0),d0
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	loc_13278	; if not, branch
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_13278
		add.w	d5,d0		; remove this frame's acceleration change
		cmp.w	d1,d0		; compare speed with top speed
		ble.s	loc_13278	; if speed was already greater than the maximum, branch
		move.w	d1,d0

loc_13278:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	Obj01_JumpMove	; if not, branch
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Obj01_JumpMove
		sub.w	d5,d0		; remove this frame's acceleration change
		cmp.w	d6,d0		; compare speed with top speed
		bge.s	Obj01_JumpMove	; if speed was already greater than the maximum, branch
		move.w	d6,d0

Obj01_JumpMove:
		move.w	d0,obVelX(a0)	; change Sonic's horizontal speed

Obj01_ResetScr2:
		cmpi.w	#$60,(v_lookshift).w ; is the screen in its default position?
		beq.s	loc_132A4	; if yes, branch
		bcc.s	loc_132A0
		addq.w	#4,(v_lookshift).w

loc_132A0:
		subq.w	#2,(v_lookshift).w

loc_132A4:
		cmpi.w	#-$400,obVelY(a0) ; is Sonic moving faster than -$400 upwards?
		blo.s	locret_132D2	; if yes, branch
		move.w	obVelX(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_132D2
		bmi.s	loc_132C6
		sub.w	d1,d0
		bcc.s	loc_132C0
		move.w	#0,d0

loc_132C0:
		move.w	d0,obVelX(a0)
		rts	
; ===========================================================================

loc_132C6:
		sub.w	d1,d0
		bcs.s	loc_132CE
		move.w	#0,d0

loc_132CE:
		move.w	d0,obVelX(a0)

locret_132D2:
		rts	
; End of function Sonic_JumpDirection

; ---------------------------------------------------------------------------
; Subroutine to	prevent	Sonic leaving the boundaries of	a level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LevelBound:
		movem.w	obVelX(a0),d1-d2
		asl.l	#8,d1
		asl.l	#8,d2
		add.l	obX(a0),d1
		add.l	obY(a0),d2
		swap	d1
		swap	d2
		
		move.w	(v_limitleft2).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bhi.s	.sides		; if yes, branch
		move.w	(v_limitright2).w,d0
		addi.w	#$128,d0
		tst.b	(f_lockscreen).w
		bne.s	.screenlocked
		addi.w	#$40,d0

	.screenlocked:
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bls.s	.sides		; if yes, branch
		
	.chktop:
		move.w	(v_limittop2).w,d0
		bmi.s	.chkbottom
		tst.w	obVelY(a0)
		bpl.s	.chkbottom
		cmp.w	d2,d0
		blt.s	.chkbottom
		move.w	d0,obY(a0)
		clr.w	obY+2(a0)
		clr.w	obVelY(a0)

	.chkbottom:
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has Sonic touched the	bottom boundary?
		blt.s	.bottom		; if yes, branch

	.end:
		rts	
; ===========================================================================

.bottom:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2 ?
		bne.s	.killsonic
		cmpi.w	#$2000,(v_player+obX).w
		bcs.s	.killsonic
		clr.b	(v_lastlamp).w	; clear	lamppost counter
		st	(f_restart).w ; restart the level
		move.w	#(id_LZ<<8)+3,(v_zone).w ; set level to SBZ3 (LZ4)
		rts	
; ===========================================================================

.sides:
		move.w	d0,obX(a0)
		clr.w	obX+2(a0)
		clr.w	obVelX(a0)	; stop Sonic moving
		clr.w	obInertia(a0)
		bra.s	.chktop
; ===========================================================================

.killsonic:
		jmp	(KillSonic).l	; MJ: Fix out-of-range branch
; End of function Sonic_LevelBound

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		tst.b	(f_jumponly).w
		bne.s	.noroll
		move.w	obInertia(a0),d0
		bpl.s	.ispositive
		neg.w	d0

	.ispositive:
		cmpi.w	#$80,d0		; is Sonic moving at $80 speed or faster?
		bcs.s	.noroll		; if not, branch
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0	; is left/right	being pressed?
		bne.s	.noroll		; if yes, branch
		btst	#bitDn,(v_jpadhold2).w ; is down being pressed?
		bne.s	Sonic_ChkRoll	; if yes, branch

	.noroll:
		rts	
; ===========================================================================

Sonic_ChkRoll:
		btst	#2,obStatus(a0)	; is Sonic already rolling?
		beq.s	.roll		; if not, branch
		rts	
; ===========================================================================

.roll:
		bset	#2,obStatus(a0)
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		move.w	#sfx_Roll,d0
		jsr	(PlaySound_Special).l	; play rolling sound
		tst.w	obInertia(a0)
		bne.s	.ismoving
		move.w	#$200,obInertia(a0) ; set inertia if 0

	.ismoving:
		rts	
; End of function Sonic_Roll

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnB|btnC,d0	; is A, B or C pressed?
		beq.w	locret_1348E	; if not, branch
		moveq	#0,d0
		move.b	obAngle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_14D48
		cmpi.w	#6,d1
		blt.w	locret_1348E
		
		move.w	#$680,d2
		tst.b	(superFlag).w
		beq.s	loc_1341C
		move.w	#$800,d2

loc_1341C:
		moveq	#0,d0
		move.b	obAngle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,obVelX(a0)	; make Sonic jump
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,obVelY(a0)	; make Sonic jump
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		clr.b	$38(a0)
		moveq	#$FFFFFF00|sfx_Jump,d0
		jsr	PlaySound_Special
		move.b	#id_Roll,obAnim(a0) ; use "jumping" animation
		bset	#2,obStatus(a0)

locret_1348E:
		rts	
; End of function Sonic_Jump

; ---------------------------------------------------------------------------
; Double jump
; ---------------------------------------------------------------------------

Sonic_DoubleJump:
		btst	#bitC,(v_jpadpress2).w
		beq.s	.NoSuper
		bsr.w	Sonic_CheckSuper
		bne.s	.End

.NoSuper:
		cmpi.b	#2,$3C(a0)
		beq.s	.End

		move.b	(v_jpadpress2).w,d0
		andi.b	#btnB|btnC,d0
		beq.s	.End
		
		move.w	#-$600,obVelY(a0)
		move.b	#id_Roll,obAnim(a0)
		move.b	#2,$3C(a0)
		
		moveq	#$FFFFFF00|sfx_Jump,d0
		jmp	PlaySound_Special

.End:
		rts

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic's jump height/duration
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpHeight:
		cmpi.b	#id_Roll,obAnim(a0)
		beq.s	.Check
		bra.s	loc_134C4

.Check:
		tst.b	$3C(a0)
		beq.s	loc_134C4
		
		move.w	#-$400,d1
		btst	#6,obStatus(a0)
		beq.s	loc_134AE
		move.w	#-$200,d1

loc_134AE:
		cmp.w	obVelY(a0),d1
		ble.s	.End
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnB|btnC,d0	; is A, B or C pressed?
		bne.s	.End		; if yes, branch
		move.w	d1,obVelY(a0)

.End
		rts
; ===========================================================================

loc_134C4:
		cmpi.w	#-$FC0,obVelY(a0)
		bge.s	locret_134D2
		move.w	#-$FC0,obVelY(a0)

locret_134D2:
		rts	
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope	while he's rolling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRepel:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#-$40,d0
		bcc.s	locret_13544
		move.b	obAngle(a0),d0
		jsr	CalcSine
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		bmi.s	loc_1353A
		tst.w	d0
		bpl.s	loc_13534
		asr.l	#2,d0

loc_13534:
		add.w	d0,obInertia(a0)
		rts	
; ===========================================================================

loc_1353A:
		tst.w	d0
		bmi.s	loc_13540
		asr.l	#2,d0

loc_13540:
		add.w	d0,obInertia(a0)

locret_13544:
		rts	
; End of function Sonic_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeRepel:
		tst.w	$3E(a0)
		beq.s	locret_13580
		subq.w	#1,$3E(a0)

locret_13580:
		rts	
; End of function Sonic_SlopeRepel

; ---------------------------------------------------------------------------
; Subroutine to	return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpAngle:
		move.b	obAngle(a0),d0	; get Sonic's angle
		beq.s	locret_135A2	; if already 0,	branch
		bpl.s	loc_13598	; if higher than 0, branch

		addq.b	#2,d0		; increase angle
		bcc.s	loc_13596
		moveq	#0,d0

loc_13596:
		bra.s	loc_1359E
; ===========================================================================

loc_13598:
		subq.b	#2,d0		; decrease angle
		bcc.s	loc_1359E
		moveq	#0,d0

loc_1359E:
		move.b	d0,obAngle(a0)

locret_135A2:
		rts	
; End of function Sonic_JumpAngle

; ---------------------------------------------------------------------------
; Sonic	when he	gets hurt
; ---------------------------------------------------------------------------

Sonic_Hurt:	; Routine 4
		jsr	SpeedToPos
		bsr.w	Sonic_HurtStop
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Water
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jmp	(DisplaySprite).l

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic falling after he's been hurt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HurtStop:
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0
		blt.w	KillSonic
		bsr.w	Sonic_Floor
		btst	#1,obStatus(a0)
		bne.s	locret_13860
		moveq	#0,d0
		move.w	d0,obVelY(a0)
		move.w	d0,obVelX(a0)
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0)
		subq.b	#2,obRoutine(a0)
		move.w	#$78,$30(a0)

locret_13860:
		rts	
; End of function Sonic_HurtStop

; ---------------------------------------------------------------------------
; Sonic	when he	dies
; ---------------------------------------------------------------------------

Sonic_Death:	; Routine 6
		bsr.w	Sonic_RevertSuper
		bsr.w	Sonic_RecordPosition

		subq.b	#1,obTimeFrame(a0)	; subtract 1 from frame duration
		bpl.s	.display
		move.b	#7,obTimeFrame(a0)	; set frame duration to 7 frames
		addq.b	#1,obFrame(a0)		; next frame
		cmpi.b	#5,obFrame(a0)		; is the final frame (05) displayed?
		beq.s	GameOver		; if yes, branch

	.display:
		jsr	DisplaySprite
		jmp	Sonic_Super
		
; ---------------------------------------------------------------------------

Sonic_Popped:	; Routine $A
		bsr.w	Sonic_RevertSuper
		clr.b	tireleak.w
		bsr.w	Sonic_RecordPosition
		clr.b	obAnim(a0)
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jsr	DisplaySprite
		jsr	Sonic_Super

		subq.w	#1,$3A(a0)
		beq.s	GameOver
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


GameOver:
		addq.b	#2,obRoutine(a0)
		addq.b	#1,(f_lifecount).w ; update lives counter
		subq.b	#1,(v_lives).w	; subtract 1 from number of lives
		bne.s	loc_138D4
		clr.w	$3A(a0)
		st	(gameOverFlag).w
		rts
; ===========================================================================

loc_138D4:
		move.w	#60,$3A(a0)	; set time delay to 1 second
		rts	
; End of function GameOver

; ---------------------------------------------------------------------------
; Sonic	when the level is restarted
; ---------------------------------------------------------------------------

Sonic_PopReset:	; Routine $C
		clr.b	obAnim(a0)
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jsr	DisplaySprite
		jsr	Sonic_Super

Sonic_ResetLevel:; Routine 8
		tst.w	$3A(a0)
		beq.s	locret_13914
		subq.w	#1,$3A(a0)	; subtract 1 from time delay
		bne.s	locret_13914
		move.w	#1,(f_restart).w ; restart the level

	locret_13914:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic run around loops (GHZ/SLZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Loops:
	; The name's a misnomer: loops are no longer handled here, only the windtunnels. Loops are dealt with by pathswappers
	;	cmpi.b	#id_SLZ,(v_zone).w ; is level SLZ ?	; MJ: Commented out, we don't want SLZ having any rolling chunks =P
	;	beq.s	.isstarlight	; if yes, branch
		tst.b	(v_zone).w	; is level GHZ ?
		bne.w	.noloops	; if not, branch

	;.isstarlight:
		move.w	obY(a0),d0
		bmi.w	.noloops
		move.w	obX(a0),d1
		
		lea	(levelLayout).w,a1
		lsr.w	#5,d0
		andi.w	#$3C,d0
		movea.w	(a1,d0.w),a1
		lsr.w	#7,d1
		move.b	(a1,d1.w),d1

		lea	STunnel_Chunks_End(pc),a2			; MJ: lead list of S-Tunnel chunks
		moveq	#(STunnel_Chunks_End-STunnel_Chunks)-1,d2	; MJ: get size of list

.loop:
		cmp.b	-(a2),d1	; MJ: is the chunk an S-Tunnel chunk?
		dbeq	d2,.loop	; MJ: check for each listed S-Tunnel chunk
		beq.w	Sonic_ChkRoll	; MJ: if so, branch

.noloops:
.done:
		rts	
; End of function Sonic_Loops

; ===========================================================================
STunnel_Chunks:		; MJ: list of S-Tunnel chunks
		dc.b	$75,$76,$77,$78
		dc.b	$79,$7A,$7B,$7C
STunnel_Chunks_End

; ---------------------------------------------------------------------------
; Subroutine to	animate	Sonic's sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Animate:
		btst	#6,obStatus(a0)
		beq.s	Sonic_AnimateDo
		
		move.b	#$D,obFrame(a0)
		st	obNextAni(a0)
		
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		rts

Sonic_AnimateDo:
		lea	(Ani_Sonic).l,a1
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0 ; is animation set to restart?
		beq.s	.do		; if not, branch
		move.b	d0,obNextAni(a0) ; set to "no restart"
		move.b	#0,obAniFrame(a0) ; reset animation
		move.b	#0,obTimeFrame(a0) ; reset frame duration

	.do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1	; jump to appropriate animation	script
		move.b	(a1),d0
		bmi.s	.walkrunroll	; if animation is walk/run/roll/jump, branch
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.delay		; if time remains, branch
		move.b	d0,obTimeFrame(a0) ; load frame duration

.loadframe:
		moveq	#0,d1
		move.b	obAniFrame(a0),d1 ; load current frame number
		move.b	1(a1,d1.w),d0	; read sprite number from script
		bmi.s	.end_FF		; if animation is complete, branch

	.next:
		move.b	d0,obFrame(a0)	; load sprite number
		addq.b	#1,obAniFrame(a0) ; next frame number

	.delay:
		rts	
; ===========================================================================

.end_FF:
		addq.b	#1,d0		; is the end flag = $FF	?
		bne.s	.end_FE		; if not, branch
		move.b	#0,obAniFrame(a0) ; restart the animation
		move.b	1(a1),d0	; read sprite number
		bra.s	.next
; ===========================================================================

.end_FE:
		addq.b	#1,d0		; is the end flag = $FE	?
		bne.s	.end_FD		; if not, branch
		move.b	2(a1,d1.w),d0	; read the next	byte in	the script
		sub.b	d0,obAniFrame(a0) ; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0	; read sprite number
		bra.s	.next
; ===========================================================================

.end_FD:
		addq.b	#1,d0		; is the end flag = $FD	?
		bne.s	.end		; if not, branch
		move.b	2(a1,d1.w),obAnim(a0) ; read next byte, run that animation

	.end:
		rts	
; ===========================================================================

.walkrunroll:
		addq.b	#1,d0		; is animation walking/running?
		bne.w	.rolljump	; if not, branch
		
		move.b	v_jpadhold2.w,d0
		andi.b	#%1100,d0
		beq.s	.animatewalk
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.delay		; if time remains, branch
		
	.animatewalk:
		moveq	#0,d1
		move.b	obAngle(a0),d0	; get Sonic's angle
		bmi.s	.checkflip
		beq.s	.checkflip
		subq.b	#1,d0

	.checkflip:
		move.b	obStatus(a0),d2
		andi.b	#1,d2		; is Sonic mirrored horizontally?
		bne.s	.flip		; if yes, branch
		not.b	d0		; reverse angle

	.flip:
		addi.b	#$10,d0		; add $10 to angle
		bpl.s	.noinvert	; if angle is $0-$7F, branch
		moveq	#3,d1

	.noinvert:
		andi.b	#$FC,obRender(a0)
		eor.b	d1,d2
		or.b	d2,obRender(a0)

		lsr.b	#4,d0		; divide angle by $10
		andi.b	#6,d0		; angle	must be	0, 2, 4	or 6
		move.b	d0,d3
		
		lea	SonAni_Walk,a1 ; use running animation
		tst.b	tirePressure.w
		bne.s	.getframe
		lea	SonAni_Flat,a1

	.getframe:
		bsr.w	.loadframe
		move.b	v_jpadhold2.w,d0
		andi.b	#%1100,d0
		bne.s	.setangle
		subq.b	#1,obAniFrame(a0)
	
	.setangle:
		move.b	#3,obTimeFrame(a0)
		add.b	d3,obFrame(a0)	; modify frame number
		rts	
; ===========================================================================

.rolljump:
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.w	.delay		; if time remains, branch
		move.w	obInertia(a0),d2 ; get Sonic's speed
		bpl.s	.nomodspeed2
		neg.w	d2

	.nomodspeed2:
		lea	(SonAni_Roll2).l,a1 ; use fast animation
		cmpi.w	#$600,d2	; is Sonic moving fast?
		bcc.s	.rollfast	; if yes, branch
		lea	(SonAni_Roll).l,a1 ; use slower	animation

	.rollfast:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	.belowmax2
		moveq	#0,d2

	.belowmax2:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0) ; modify frame duration
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	.loadframe
; End of function Sonic_Animate

		include	"source/sonic/_anim/Sonic.asm"

; ---------------------------------------------------------------------------
; Sonic	graphics loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LoadGfx:
		moveq	#0,d0
		move.b	obFrame(a0),d0	; load frame number
		cmp.b	(v_sonframenum).w,d0 ; has frame changed?
		beq.s	.nochange	; if not, branch
		move.b	d0,(v_sonframenum).w

		lea	(SonicDynPLC).l,a2 ; load PLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5	; read "number of entries" value
		subq.w	#1,d5
		bmi.s	.nochange	; if zero, branch
		
		move.w	#$F000,d4
		move.l	#Art_Sonic,d6

	.readentry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.b	-2(a2),d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	d6,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l
		dbf	d5,.readentry	; repeat for number of entries

	.nochange:
		rts	

; End of function Sonic_LoadGfx

; ---------------------------------------------------------------------------
; Check super transformation
; ---------------------------------------------------------------------------

Sonic_CheckSuper:
		cmpi.b	#id_SecretZ,v_zone.w
		beq.s	.End

		tst.b	levelEnded.w
		bne.s	.End
		tst.b	superFlag.w
		bne.s	.End
		cmpi.b	#7,v_emeralds.w
		bcs.s	.End
		cmpi.w	#50,v_rings.w
		bcs.s	.End
		
		moveq	#19,d0
		jsr	LoopCDDA

		moveq	#$FFFFFF00|sfx_EnterSS,d0
		jsr	PlaySound_Special

		move.b	#$81,f_lockmulti.w
		st	superFlag.w
		st	superTransform.w
		move.b	#60-1,superRingTimer.w
		clr.l	superPalIndex.w
		move.b	#id_Roll,obAnim(a0)
		moveq	#1,d0
		rts
	
.End:
		moveq	#0,d0
		rts

; ---------------------------------------------------------------------------
; Handle super mode
; ---------------------------------------------------------------------------

Sonic_Super:
		tst.b	superFlag.w
		beq.s	.Revert
		tst.b	levelEnded.w
		bne.s	.StartRevert
		
		addi.l	#$8800,superPalIndex.w
		
		tst.b	superTransform.w
		beq.s	.CheckPal
		cmpi.w	#.PaletteBright-.Palette,superPalIndex.w
		bcs.s	.CheckPal
		clr.b	f_lockmulti.w
		clr.b	superTransform.w
		
.CheckPal:
		cmpi.w	#.PaletteEnd-.Palette,superPalIndex.w
		bcs.s	.NoPalWrap
		clr.w	superPalIndex.w
		
.NoPalWrap:
		tst.b	superTransform.w
		bne.s	.UpdatePal
		
		subq.b	#1,superRingTimer.w
		bpl.s	.UpdatePal
		move.b	#59-1,superRingTimer.w
		
		move.b	#1,f_ringcount.w
		subq.w	#1,v_rings.w
		bne.s	.UpdatePal
		ori.b	#$80,f_ringcount.w
		bsr.s	Sonic_RevertSuper
		
.UpdatePal:
		move.w	superPalIndex.w,d0
		andi.w	#$FFFE,d0
		move.w	.Palette(pc,d0.w),d0
		move.w	d0,v_pal_dry+$1E.w
		move.w	d0,v_pal_water+$1E.w

.End:
		rts
		
; ---------------------------------------------------------------------------

.StartRevert:
		bsr.s	Sonic_RevertSuper

.Revert:
		tst.l	superPalIndex.w
		beq.s	.End
		subi.l	#$8800,superPalIndex.w
		bcc.s	.UpdatePal
		clr.l	superPalIndex.w
		bra.s	.UpdatePal
		
; ---------------------------------------------------------------------------

.Palette:
		dc.w	$0EE, $2EE, $4EE, $6EE, $8EE, $AEE, $CEE
.PaletteBright:
		dc.w	$EEE, $CEE, $AEE, $6EE, $4EE, $2EE
.PaletteEnd:

; ---------------------------------------------------------------------------

Sonic_RevertSuper:
		tst.b	superFlag.w
		beq.s	.End
		clr.b	superFlag.w
		jsr	PlayStageMusic

.End:
		rts

; ---------------------------------------------------------------------------
