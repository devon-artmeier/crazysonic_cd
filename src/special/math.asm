; -------------------------------------------------------------------------
; Get sine or cosine of a value
; -------------------------------------------------------------------------
; PARAMETERS:
;	d3.w - Value
; RETURNS:
;	d3.w - Sine/cosine of value
; -------------------------------------------------------------------------

GetCosine:
	addi.w	#$80,d3

GetSine:
	andi.w	#$1FF,d3
	add.w	d3,d3
	move.w	SineTable(pc,d3.w),d3
	rts

; -------------------------------------------------------------------------

SineTable:
	dc.w	$0000, $0003, $0006, $0009, $000C, $000F, $0012, $0016
	dc.w	$0019, $001C, $001F, $0022, $0025, $0028, $002B, $002F
	dc.w	$0032, $0035, $0038, $003B, $003E, $0041, $0044, $0047
	dc.w	$004A, $004D, $0050, $0053, $0056, $0059, $005C, $005F
	dc.w	$0062, $0065, $0068, $006A, $006D, $0070, $0073, $0076
	dc.w	$0079, $007B, $007E, $0081, $0084, $0086, $0089, $008C
	dc.w	$008E, $0091, $0093, $0096, $0099, $009B, $009E, $00A0
	dc.w	$00A2, $00A5, $00A7, $00AA, $00AC, $00AE, $00B1, $00B3
	dc.w	$00B5, $00B7, $00B9, $00BC, $00BE, $00C0, $00C2, $00C4
	dc.w	$00C6, $00C8, $00CA, $00CC, $00CE, $00D0, $00D1, $00D3
	dc.w	$00D5, $00D7, $00D8, $00DA, $00DC, $00DD, $00DF, $00E0
	dc.w	$00E2, $00E3, $00E5, $00E6, $00E7, $00E9, $00EA, $00EB
	dc.w	$00EC, $00EE, $00EF, $00F0, $00F1, $00F2, $00F3, $00F4
	dc.w	$00F5, $00F6, $00F7, $00F7, $00F8, $00F9, $00FA, $00FA
	dc.w	$00FB, $00FB, $00FC, $00FC, $00FD, $00FD, $00FE, $00FE
	dc.w	$00FE, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $0100
	
	dc.w	$0100, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FE
	dc.w	$00FE, $00FE, $00FD, $00FD, $00FC, $00FC, $00FB, $00FB
	dc.w	$00FA, $00FA, $00F9, $00F8, $00F7, $00F7, $00F6, $00F5
	dc.w	$00F4, $00F3, $00F2, $00F1, $00F0, $00EF, $00EE, $00EC
	dc.w	$00EB, $00EA, $00E9, $00E7, $00E6, $00E5, $00E3, $00E2
	dc.w	$00E0, $00DF, $00DD, $00DC, $00DA, $00D8, $00D7, $00D5
	dc.w	$00D3, $00D1, $00D0, $00CE, $00CC, $00CA, $00C8, $00C6
	dc.w	$00C4, $00C2, $00C0, $00BE, $00BC, $00B9, $00B7, $00B5
	dc.w	$00B3, $00B1, $00AE, $00AC, $00AA, $00A7, $00A5, $00A2
	dc.w	$00A0, $009E, $009B, $0099, $0096, $0093, $0091, $008E
	dc.w	$008C, $0089, $0086, $0084, $0081, $007E, $007B, $0079
	dc.w	$0076, $0073, $0070, $006D, $006A, $0068, $0065, $0062
	dc.w	$005F, $005C, $0059, $0056, $0053, $0050, $004D, $004A
	dc.w	$0047, $0044, $0041, $003E, $003B, $0038, $0035, $0032
	dc.w	$002F, $002B, $0028, $0025, $0022, $001F, $001C, $0019
	dc.w	$0016, $0012, $000F, $000C, $0009, $0006, $0003, $0000
	
	dc.w	-$0000, -$0003, -$0006, -$0009, -$000C, -$000F, -$0012, -$0016
	dc.w	-$0019, -$001C, -$001F, -$0022, -$0025, -$0028, -$002B, -$002F
	dc.w	-$0032, -$0035, -$0038, -$003B, -$003E, -$0041, -$0044, -$0047
	dc.w	-$004A, -$004D, -$0050, -$0053, -$0056, -$0059, -$005C, -$005F
	dc.w	-$0062, -$0065, -$0068, -$006A, -$006D, -$0070, -$0073, -$0076
	dc.w	-$0079, -$007B, -$007E, -$0081, -$0084, -$0086, -$0089, -$008C
	dc.w	-$008E, -$0091, -$0093, -$0096, -$0099, -$009B, -$009E, -$00A0
	dc.w	-$00A2, -$00A5, -$00A7, -$00AA, -$00AC, -$00AE, -$00B1, -$00B3
	dc.w	-$00B5, -$00B7, -$00B9, -$00BC, -$00BE, -$00C0, -$00C2, -$00C4
	dc.w	-$00C6, -$00C8, -$00CA, -$00CC, -$00CE, -$00D0, -$00D1, -$00D3
	dc.w	-$00D5, -$00D7, -$00D8, -$00DA, -$00DC, -$00DD, -$00DF, -$00E0
	dc.w	-$00E2, -$00E3, -$00E5, -$00E6, -$00E7, -$00E9, -$00EA, -$00EB
	dc.w	-$00EC, -$00EE, -$00EF, -$00F0, -$00F1, -$00F2, -$00F3, -$00F4
	dc.w	-$00F5, -$00F6, -$00F7, -$00F7, -$00F8, -$00F9, -$00FA, -$00FA
	dc.w	-$00FB, -$00FB, -$00FC, -$00FC, -$00FD, -$00FD, -$00FE, -$00FE
	dc.w	-$00FE, -$00FF, -$00FF, -$00FF, -$00FF, -$00FF, -$00FF, -$0100
	
	dc.w	-$0100, -$00FF, -$00FF, -$00FF, -$00FF, -$00FF, -$00FF, -$00FE
	dc.w	-$00FE, -$00FE, -$00FD, -$00FD, -$00FC, -$00FC, -$00FB, -$00FB
	dc.w	-$00FA, -$00FA, -$00F9, -$00F8, -$00F7, -$00F7, -$00F6, -$00F5
	dc.w	-$00F4, -$00F3, -$00F2, -$00F1, -$00F0, -$00EF, -$00EE, -$00EC
	dc.w	-$00EB, -$00EA, -$00E9, -$00E7, -$00E6, -$00E5, -$00E3, -$00E2
	dc.w	-$00E0, -$00DF, -$00DD, -$00DC, -$00DA, -$00D8, -$00D7, -$00D5
	dc.w	-$00D3, -$00D1, -$00D0, -$00CE, -$00CC, -$00CA, -$00C8, -$00C6
	dc.w	-$00C4, -$00C2, -$00C0, -$00BE, -$00BC, -$00B9, -$00B7, -$00B5
	dc.w	-$00B3, -$00B1, -$00AE, -$00AC, -$00AA, -$00A7, -$00A5, -$00A2
	dc.w	-$00A0, -$009E, -$009B, -$0099, -$0096, -$0093, -$0091, -$008E
	dc.w	-$008C, -$0089, -$0086, -$0084, -$0081, -$007E, -$007B, -$0079
	dc.w	-$0076, -$0073, -$0070, -$006D, -$006A, -$0068, -$0065, -$0062
	dc.w	-$005F, -$005C, -$0059, -$0056, -$0053, -$0050, -$004D, -$004A
	dc.w	-$0047, -$0044, -$0041, -$003E, -$003B, -$0038, -$0035, -$0032
	dc.w	-$002F, -$002B, -$0028, -$0025, -$0022, -$001F, -$001C, -$0019
	dc.w	-$0016, -$0012, -$000F, -$000C, -$0009, -$0006, -$0003, -$0000

; -------------------------------------------------------------------------
; Get angle between 2 points
; -------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Point 1 X
;	d1.w - Point 1 Y
;	d4.w - Point 2 X
;	d5.w - Point 2 Y
; RETURNS:
;	d1.w - Angle
;	d2.w - Angle quadrant flags
;	       0 = Left quadrant
;	       1 = Top quadrant
;	       2 = Inner corner quadrant
; -------------------------------------------------------------------------

GetAngle:
	moveq	#0,d2				; Reset flags

	move.w	d0,d3				; Get sign difference between X points
	eor.w	d4,d3
	sub.w	d4,d0				; Get X distance
	bcc.s	.X2Less				; If x2 < x1, unsigned wise, branch

.X2Greater:
	andi.w	#$8000,d3			; Are the signs different?
	bne.s	.CheckY				; If so, branch

.FlipX:
	bset	#0,d2				; Use left quadrant
	neg.w	d0				; Get absolute value of X distance
	bra.s	.CheckY

.X2Less:
	andi.w	#$8000,d3			; Are the signs different?
	bne.s	.FlipX				; If so, branch

.CheckY:
	sub.w	d5,d1				; Get Y distance
	bpl.s	.Y2Above			; If it's positive, branch
	tst.w	d5				; Was y2 negative?
	bmi.s	.Y2Above			; If so, branch
	; BUG: If both y1 and y2 and negative, and y1 < y2, then it'll fail
	; to properly get the absolute value, and thus return a massive
	; distance after being interpreted as unsigned
	bset	#1,d2				; Use top quadrant
	neg.w	d1				; Get absolute value of Y distance

.Y2Above:
	cmp.w	d0,d1				; Is the X distance larger than the Y distance?
	bcs.s	.PrepareDivide			; If not, branch
	bset	#2,d2				; If so, use inner corner quadrant
	exg	d0,d1				; Do x/y instead of y/x

.PrepareDivide:
	ext.l	d1				; Perform the division
	lsl.l	#6,d1
	tst.w	d0
	bne.s	.Divide
	moveq	#0,d1
	bra.s	.Cap

.Divide:
	divu.w	d0,d1

.Cap:
	andi.w	#$FF,d1				; Cap within quadrant
	cmpi.b	#$40,d1
	bcs.s	.End
	move.b	#$3F,d1

.End:
	rts

; -------------------------------------------------------------------------
; Convert angle and flags to linear angle
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Angle
;	d2.w - Angle quadrant flags
; RETURNS:
;	d1.w - Angle
; -------------------------------------------------------------------------

GetLinearAngle:
	lea	.AngleConv(pc),a1
	add.w	d2,d2
	add.w	d2,d2
	move.w	(a1,d2.w),d3
	eor.w	d3,d1
	add.w	2(a1,d2.w),d1
	rts
	
; -------------------------------------------------------------------------

.AngleConv:
	dc.w	$00, $000
	dc.w	$3F, $0C0
	dc.w	$3F, $1C0
	dc.w	$00, $100
	dc.w	$3F, $040
	dc.w	$00, $080
	dc.w	$00, $180
	dc.w	$3F, $140

; -------------------------------------------------------------------------
; Get the trajectory between 2 points
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Angle
;	d2.w - Angle quadrant flags
;	d3.w - Trajectory multiplier
; RETURNS:
;	d0.w - X trajectory
;	d1.w - Y trajectory
; -------------------------------------------------------------------------

GetTrajectory:
	lea	TrajectoryTable(pc),a1		; Trajectory table

	andi.w	#$FF,d1				; Get table offset
	add.w	d1,d1
	add.w	d1,d1
	bne.s	.Angled				; If we are on an angle, branch
	move.w	#0,d0				; If not, skip unnecessary math
	move.w	d3,d1
	bra.s	.CheckCornerQuad

.Angled:
	adda.w	d1,a1				; Get X anad Y trajectories based on angle
	move.w	(a1)+,d0
	move.w	(a1),d1
	mulu.w	d3,d0
	swap	d0
	mulu.w	d3,d1
	swap	d1

.CheckCornerQuad:
	btst	#2,d2				; Are we in an inner corner quadrant?
	beq.s	.CheckYQuad			; If not, branch
	exg	d0,d1				; If so, swap X and Y trajectories

.CheckYQuad:
	btst	#1,d2				; Are we in a top quadrant?
	beq.s	.SetYTrajectory			; If not, branch
	neg.w	d0				; If so, make the Y trajectory face the other way

.SetYTrajectory:
	swap	d0				; Shift Y trajectory down
	move.w	#0,d0
	asr.l	#8,d0

	btst	#0,d2				; Are we in a left quadrant?
	beq.s	.SetXTrajectory			; If not, branch
	neg.w	d1				; If so, make the X trajectory face the other way

.SetXTrajectory:
	swap	d1				; Shift X trajectory down
	move.w	#0,d1
	asr.l	#8,d1

	exg	d0,d1				; Have d0 store the X trajectory, and d1 store the Y trajectory
	rts

; -------------------------------------------------------------------------
; Get the distance between 2 points
; -------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Angle quadrant flags
;	d3.w - Point 1 X
;	d4.w - Point 1 Y
;	d5.w - Point 2 X
;	d6.w - Point 2 Y
; RETURNS:
;	d0.l - Distance
; -------------------------------------------------------------------------

GetDistance:
	lea	DistanceTable(pc),a1		; Get distance table entry
	andi.w	#$FF,d1
	add.w	d1,d1
	adda.w	d1,a1
	move.w	#0,d0
	move.w	#0,d1
	move.w	(a1),d0

	btst	#2,d2				; Are we in an inner corner qudrant?
	beq.s	.OuterCorner			; If not, branch

.InnerCorner:
	move.w	d6,d1				; Use Y points	 
	move.w	d4,d2
	bra.s	.GetDistance

.OuterCorner:
	move.w	d5,d1				; Use X points
	move.w	d3,d2

.GetDistance:
	sub.w	d2,d1				; Get distance
	bpl.s	.NotNeg
	neg.w	d1

.NotNeg:
	mulu.w	d1,d0
	lsr.l	#8,d0
	rts

; -------------------------------------------------------------------------

TrajectoryTable:
	dc.w	$00FF, $FFFF
	dc.w	$0400, $FFF8
	dc.w	$07FF, $FFE0
	dc.w	$0BFD, $FFB8
	dc.w	$0FF8, $FF80
	dc.w	$13F0, $FF39
	dc.w	$17E5, $FEE2
	dc.w	$1BD6, $FE7B
	dc.w	$1FC1, $FE06
	dc.w	$23A6, $FD81
	dc.w	$2785, $FCEE
	dc.w	$2B5D, $FC4D
	dc.w	$2F2E, $FB9E
	dc.w	$32F6, $FAE0
	dc.w	$36B5, $FA16
	dc.w	$3A6B, $F93F
	dc.w	$3E17, $F85B
	dc.w	$41B9, $F76C
	dc.w	$4550, $F670
	dc.w	$48DB, $F56A
	dc.w	$4C5C, $F459
	dc.w	$4FD0, $F33E
	dc.w	$5338, $F219
	dc.w	$5694, $F0EA
	dc.w	$59E3, $EFB3
	dc.w	$5D25, $EE74
	dc.w	$605A, $ED2D
	dc.w	$6382, $EBDF
	dc.w	$669C, $EA89
	dc.w	$69A9, $E92E
	dc.w	$6CA8, $E7CC
	dc.w	$6F99, $E665
	dc.w	$727D, $E4F9
	dc.w	$7552, $E389
	dc.w	$781B, $E214
	dc.w	$7AD5, $E09B
	dc.w	$7D82, $DF20
	dc.w	$8021, $DDA1
	dc.w	$82B3, $DC1F
	dc.w	$8537, $DA9C
	dc.w	$87AE, $D916
	dc.w	$8A18, $D78F
	dc.w	$8C75, $D607
	dc.w	$8EC5, $D47E
	dc.w	$9108, $D2F4
	dc.w	$933F, $D16A
	dc.w	$9569, $CFE0
	dc.w	$9787, $CE56
	dc.w	$999A, $CCCD
	dc.w	$9BA0, $CB44
	dc.w	$9D9B, $C9BC
	dc.w	$9F8A, $C835
	dc.w	$A16F, $C6AF
	dc.w	$A348, $C52B
	dc.w	$A516, $C3A9
	dc.w	$A6DA, $C228
	dc.w	$A894, $C0A9
	dc.w	$AA43, $BF2C
	dc.w	$ABE9, $BDB1
	dc.w	$AD84, $BC39
	dc.w	$AF17, $BAC3
	dc.w	$B0A0, $B94F
	dc.w	$B220, $B7DF
	dc.w	$B397, $B670
	dc.w	$B505, $B505
	
DistanceTable:
	dc.w	$00FF, $0100, $0100, $0100, $0100
	dc.w	$0100, $0101, $0101, $0101, $0102
	dc.w	$0103, $0103, $0104, $0105, $0106
	dc.w	$0106, $0107, $0108, $0109, $010B
	dc.w	$010C, $010D, $010E, $0110, $0111
	dc.w	$0112, $0114, $0115, $0117, $0119
	dc.w	$011A, $011C, $011E, $0120, $0121
	dc.w	$0123, $0125, $0127, $0129, $012B
	dc.w	$012D, $0130, $0132, $0134, $0136
	dc.w	$0138, $013B, $013D, $0140, $0142
	dc.w	$0144, $0147, $0149, $014C, $014E
	dc.w	$0151, $0154, $0156, $0159, $015C
	dc.w	$015E, $0161, $0164, $0167, $016A

; -------------------------------------------------------------------------
; Get a random number
; -------------------------------------------------------------------------
; RETURNS:
;	d0.l - Random number
; -------------------------------------------------------------------------

Random:
	move.l	d1,-(sp)
	move.l	rngSeed,d1			; Get RNG seed
	bne.s	.GotSeed			; If it's set, branch
	move.l	#$2A6D365A,d1			; Reset RNG seed otherwise

.GotSeed:
	move.l	d1,d0				; Get random number
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1
	move.l	d1,rngSeed			; Update RNG seed
	move.l	(sp)+,d1
	rts

; -------------------------------------------------------------------------