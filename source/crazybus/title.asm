; -------------------------------------------------------------------------
; Crazy Bus title screen
; -------------------------------------------------------------------------

CrazyBusTitle:
	move	#$2700,sr					; Disable interrupts

	clr.l	v_cheatbutton.w
	
	lea	CBPCM_Init,a1					; Initialize sound driver
	jsr	CallSubFunction
	
	jsr	ClearScreen					; Clear screen
	lea	VDP_CTRL,a5					; VDP control port
	move.w	#$8004,(a5)					; Disable horizontal interrupt
	move.w	#$8ADF,(a5)
	move.w	#$8134,(a5)					; Disable screen
	move.w	#$8720,(a5)					; Set background color

	VDP_CMD move.l,0,VRAM,WRITE,VDP_CTRL			; Load font
	lea	Art_CrazyBusFont,a0
	jsr	NemDec

	VDP_CMD move.l,$B000,VRAM,WRITE,VDP_CTRL		; Load logo graphics
	lea	Art_HackLogo,a0
	jsr	NemDec

	lea	Map_HackLogo,a0					; Decompress logo mappings
	lea	decompBuffer,a1
	move.w	#$4580,d0
	jsr	EniDec

	VDP_CMD move.l,vram_fg+$412,VRAM,WRITE,d0		; Draw logo mappings	
	moveq	#$15-1,d1
	moveq	#5-1,d2
	jsr	TilemapToVRAM

	lea	Pal_CrazyBus,a0					; Load default palette
	lea	v_pal_dry.w,a1
	moveq	#$20/4-1,d0

.LoadPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPal

	lea	Pal_HackLogo,a0					; Load logo palette
	lea	v_pal_dry+$40.w,a1
	moveq	#$20/4-1,d0

.LoadLogoPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadLogoPal

	lea	Txt_HackTitle,a0				; Draw text
	VDP_CMD move.l,vram_fg+$706,VRAM,WRITE,d0
	moveq	#0,d1
	jsr	DrawText

	moveq	#4,d0						; Draw cover bus
	bsr.w	DrawCoverBus2

	moveq	#CBID_TITLE,d0					; Play "music"
	lea	CBPCM_Play,a1
	jsr	CallSubFunction

; -------------------------------------------------------------------------

.Loop:
	st	v_vbla_routine.w				; VSync
	jsr	WaitForVBla

	btst	#0,v_cheatactive.w
	bne.s	.NoLevelSelect
	
	lea	.LevSelCheat(pc),a1
	lea	v_cheatbutton.w,a2
	jsr	CheckCheat
	beq.s	.NoLevelSelect
	bset	#0,v_cheatactive.w
	clr.w	v_cheatbutton.w

.NoLevelSelect:
	cmpi.b	#7,v_emeralds.w
	beq.s	.NoTires
	btst	#1,v_cheatactive.w
	bne.s	.NoTires

	lea	.TiresCheat(pc),a1
	lea	v_cheatbutton2.w,a2
	jsr	CheckCheat
	beq.s	.NoTires
	bset	#1,v_cheatactive.w
	clr.w	v_cheatbutton.w
	move.b	#7,v_emeralds.w

.NoTires:
	addq.b	#1,cbTitleCounter				; Update counter
	cmpi.b	#10-1,cbTitleCounter
	bcs.s	.ChangeColor
	clr.b	cbTitleCounter

.ChangeColor:
	move.w	#$8174,VDP_CTRL					; Enable screen
	bsr.w	RandomLogoColor					; Randomize logo color
	
	addq.w	#1,v_demolength.w				; Increase timer
	cmpi.w	#1800,v_demolength.w				; Is it time to load a new cover bus?
	bcs.s	.NoCoverBus					; If not, branch

	bsr.w	DrawCoverBus					; Draw cover bus
	clr.w	v_demolength.w					; Reset timer
	
.NoCoverBus:
	lea	Txt_PressStartBlank,a0				; Draw "press start" text
	moveq	#0,d0
	move.w	v_demolength.w,d0
	divu.w	#20,d0
	swap	d0
	cmpi.w	#10,d0
	bcs.s	.DrawStartText
	lea	Txt_PressStart,a0

.DrawStartText:
	VDP_CMD move.l,vram_fg+$8A6,VRAM,WRITE,d0
	moveq	#0,d1
	jsr	DrawText

	tst.b	v_jpadpress1.w					; Has the start button been pressed?
	bpl.w	.Loop						; If not, loop
	
	jsr	PaletteFadeOut					; Fade to black
	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	move	#$2700,sr					; Disable interrupts
	rts

; -------------------------------------------------------------------------

.LevSelCheat:
	dc.b	btnUp, btnDn, btnL, btnR, 0
	even
.TiresCheat:
	dc.b	btnUp, btnUp, btnDn, btnDn, btnUp, btnUp, btnUp, btnUp, 0
	even

; -------------------------------------------------------------------------
; Generate random logo color
; -------------------------------------------------------------------------

RandomLogoColor:
	tst.b	cbTitleCounter					; Are we on a "music" "beat"?
	bne.s	.End						; If not, branch

	moveq	#2,d0						; Generate blue
	jsr	CB_RandomRange
	addq.w	#6,d0
	andi.w	#7,d0
	ror.w	#7,d0
	move.w	d0,d2
	move.l	d2,-(sp)

	moveq	#2,d0						; Generate green
	jsr	CB_RandomRange
	move.l	(sp)+,d2
	addq.w	#6,d0
	andi.w	#7,d0
	lsl.w	#5,d0
	or.w	d0,d2
	move.l	d2,-(sp)

	moveq	#2,d0						; Generate blue
	jsr	CB_RandomRange
	move.l	(sp)+,d2
	addq.w	#6,d0
	andi.w	#7,d0
	add.w	d0,d0
	or.w	d0,d2
	
	lea	v_pal_dry+$4A.w,a0				; Set color

.SetColor:
	move.w	d2,(a0)

.End:
	rts
	
; -------------------------------------------------------------------------
; Draw cover bus
; -------------------------------------------------------------------------

DrawCoverBus:
	moveq	#5,d0						; Get cover bus
	jsr	CB_RandomRange

DrawCoverBus2:
	lea	CoverBuses,a0
	mulu.w	#$12,d0
	adda.w	d0,a0
	move.w	$10(a0),-(sp)
	move.l	$C(a0),-(sp)
	move.l	8(a0),-(sp)
	move.l	4(a0),-(sp)
	move.l	(a0),-(sp)

	move.w	#$8134,VDP_CTRL					; Hide screen

	move	#$2700,sr					; Only update music during V-INT
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr					; Enable interrupts

	movea.l	(sp)+,a0					; Load graphics
	VDP_CMD move.l,$1B40,VRAM,WRITE,VDP_CTRL
	jsr	NemDec

	movea.l	(sp)+,a0					; Decompress mappings
	lea	decompBuffer,a1
	move.w	#$20DA,d0
	jsr	EniDec
	
	lea	decompBuffer,a1					; Draw mappings
	VDP_CMD move.l,vram_bg,VRAM,WRITE,d0
	moveq	#$28-1,d1
	moveq	#$1C-1,d2
	jsr	TilemapToVRAM

	movea.l	(sp)+,a0					; Load palette
	lea	v_pal_dry+$20,a1
	moveq	#$20/4-1,d0

.LoadPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPal

	movea.l	(sp)+,a0					; Draw text
	VDP_CMD move.l,vram_fg+$C82,VRAM,WRITE,d0
	moveq	#0,d1
	bsr.w	DrawText

	move.w	(sp)+,v_pal_dry+2.w				; Set font color
	
	move	#$2700,sr					; Restore V-INT handler
	move.l	#CrazyBusVInt,_LEVEL6+2.w
	rts

; -------------------------------------------------------------------------
; Cover buses
; -------------------------------------------------------------------------

CoverBuses:
	dc.l	Art_CoverBus1, Map_CoverBus1, Pal_CoverBus1, Txt_CoverBus1
	dc.w	$CE
	dc.l	Art_CoverBus2, Map_CoverBus2, Pal_CoverBus2, Txt_CoverBus2
	dc.w	$EC0
	dc.l	Art_CoverBus3, Map_CoverBus3, Pal_CoverBus3, Txt_CoverBus3
	dc.w	$60E
	dc.l	Art_CoverBus4, Map_CoverBus4, Pal_CoverBus4, Txt_CoverBus4
	dc.w	$EA
	dc.l	Art_CoverBus5, Map_CoverBus5, Pal_CoverBus5, Txt_CoverBus5
	dc.w	$EE
	dc.l	Art_CoverBus6, Map_CoverBus6, Pal_CoverBus6 ,Txt_CoverBus6
	dc.w	$EE0
	
; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

cbTitleCounter:
	dc.b	0
	even

; -------------------------------------------------------------------------
