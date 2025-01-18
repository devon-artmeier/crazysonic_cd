; -------------------------------------------------------------------------
; Special stage results
; -------------------------------------------------------------------------

id_SSResult	EQU	$01
id_SSRChaos	EQU	$02

; -------------------------------------------------------------------------

SpecStageResults:
	clr.l	v_buildrings.w					; Don't draw HUD or rings
	clr.l	v_buildhud.w
	
	move.l	#ObjIndex,v_objindex.w				; Set object index

	move	#$2700,sr					; Clear screen
	bsr.w	ClearScreen

	lea	VDP_CTRL,a0					; Set up VDP registers
	
.WaitVBlank:
	move	(a0),ccr
	bpl.s	.WaitVBlank
	move.w	#$8C81,(a0)

	lea	v_objspace.w,a1					; Clear objects
	moveq	#0,d0
	move.w	#$7FF,d1

.ClearObjects:
	move.l	d0,(a1)+
	dbf	d1,.ClearObjects

	move	#$2300,sr					; Enable interrupts

	lea	Pal_SSResult(pc),a0				; Load palette
	lea	v_pal_dry_dup.w,a1
	moveq	#$80/4-1,d0

.LoadPal:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPal
	
	VDP_CMD move.l,$A820,VRAM,WRITE,VDP_CTRL		; Load chaos tires\ art
	lea	Art_ResultEm(pc),a0
	bsr.w	NemDec
	
	VDP_CMD move.l,$B000,VRAM,WRITE,VDP_CTRL		; Load title card art
	lea	Art_TitleCard(pc),a0
	bsr.w	NemDec
	
	VDP_CMD move.l,$D940,VRAM,WRITE,VDP_CTRL		; Load HUD art
	lea	Art_HUD(pc),a0
	bsr.w	NemDec
	
	bsr.w	Hud_Base					; Initialize HUD elements

	move.b	#1,f_scorecount.w				; Update score counter
	move.b	#1,f_endactbonus.w				; Update time bonus counter

	moveq	#0,d0						; Set time bonus
	move.b	timer,d0
	mulu.w	#10,d0
	move.w	d0,v_timebonus.w

	move	#$2700,sr					; Set V-BLANK interrupt
	move.l	#SSResultsVInt,_LEVEL6+2.w

	jsr	PaletteWhiteIn					; Fade from white
	
	move.b	#id_SSResult,v_objspace+$5C0.w			; Spawn results
	
; -------------------------------------------------------------------------

.Loop:
	st	v_vbla_routine.w				; VSync
	bsr.w	WaitForVBla
	
	bsr.w	ExecuteObjects					; Update objects
	bsr.w	BuildSprites					; Draw sprites

	tst.b	f_restart.w					; Are we done?
	beq.s	.Loop						; If not, loop

; -------------------------------------------------------------------------

.Exit:
	move.w	#sfx_EnterSS,d0					; Fade out
	bsr.w	PlaySound_Special
	bsr.w	PaletteWhiteOut
	bsr.w	PaletteFadeOut

	move	#$2700,sr					; Exit to level
	bsr.w	VDPSetupGame
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr
	move.b	#id_Level,v_gamemode.w
	rts

; -------------------------------------------------------------------------
; Vertical blank interrupt
; -------------------------------------------------------------------------

SSResultsVInt:
	move	#$2700,sr					; Disable interrupts
	movem.l	d0-a6,-(sp)					; Save registers
	
	REQUEST_INT2						; Request Sub CPU interrupt
	clr.b	v_vbla_routine.w				; Clear VSync flag
	
	lea	VDP_CTRL,a0					; VDP control port
	move.w	(a0),d0
	
	STOP_Z80						; Update VDP memory
	DMA_68K v_pal_dry,0,$80,CRAM,(a0)
	DMA_68K v_spritetablebuffer,vram_sprites,$280,VRAM,(a0)
	START_Z80
	
	bsr.w	HUD_Update					; Update HUD elements
	bsr.w	UpdateSound					; Update sound driver
	
	movem.l	(sp)+,d0-a6					; Restore registers
	rte
	
; -------------------------------------------------------------------------
; Object index
; -------------------------------------------------------------------------

ObjIndex:
	dc.l	SSResult
	dc.l	SSRChaos
	
; -------------------------------------------------------------------------
; Update HUD
; -------------------------------------------------------------------------

hudVRAM macro loc
	move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),d0
	endm

; -------------------------------------------------------------------------

HUD_Update:
	tst.b	f_scorecount.w ; does the score need updating?
	beq.s	.chkrings	; if not, branch
	clr.b	f_scorecount.w
	hudVRAM	$DC80		; set VRAM address
	move.l	v_score.w,d1	; load score
	bsr.w	Hud_Score

.chkrings:
	tst.b	f_endactbonus.w ; do time/ring bonus counters need updating?
	beq.s	.finish		; if not, branch
	clr.b	f_endactbonus.w
	VDP_CMD move.l,$AF00,VRAM,WRITE,VDP_CTRL
	moveq	#0,d1
	move.w	v_timebonus.w,d1 ; load time bonus
	bra.w	Hud_TimeRingBonus

.finish:
	rts	

; -------------------------------------------------------------------------

Hud_LoadZero:
	VDP_CMD move.l,$DF40,VRAM,WRITE,VDP_CTRL
	lea	Hud_TilesZero(pc),a2
	move.w	#2,d2
	bra.s	loc_1C83E

; -------------------------------------------------------------------------

Hud_Base:
	lea	VDP_DATA,a6
	VDP_CMD move.l,$DC40,VRAM,WRITE,VDP_CTRL
	lea	Hud_TilesBase(pc),a2
	move.w	#$E,d2

loc_1C83E:
	lea	Art_HudNums(pc),a1

loc_1C842
	move.w	#$F,d1
	move.b	(a2)+,d0
	bmi.s	loc_1C85E
	ext.w	d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a3

loc_1C852:
	move.l	(a3)+,(a6)
	dbf	d1,loc_1C852

loc_1C858:
	dbf	d2,loc_1C842

	rts

loc_1C85E:
	move.l	#0,(a6)
	dbf	d1,loc_1C85E

	bra.s	loc_1C858

; -------------------------------------------------------------------------

Hud_TilesBase:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF,	0, 0, $14, 0, 0
Hud_TilesZero:	dc.b $FF, $FF, 0, 0

; -------------------------------------------------------------------------

Hud_Score:
	lea	(Hud_100000).l,a2
	moveq	#5,d6

Hud_LoadArt:
	moveq	#0,d4
	lea	Art_HudNums(pc),a1

Hud_ScoreLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_1C8EC:
	sub.l	d3,d1
	bcs.s	loc_1C8F4
	addq.b	#1,d2
	bra.s	loc_1C8EC

loc_1C8F4:
	add.l	d3,d1
	tst.b	d2
	beq.s	loc_1C8FE
	moveq	#1,d4

loc_1C8FE:
	tst.b	d4
	beq.s	.zero
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
	moveq	#16-1,d2

.Load:
	move.l	(a3)+,(a6)
	dbf	d2,.Load
	bra.s	loc_1C92C
	
.zero:
	move.l	d0,4(a6)
	moveq	#16-1,d3

.Fill:
	move.l	d2,(a6)
	dbf	d3,.Fill

loc_1C92C:
	addi.l	#$400000,d0
	dbf	d6,Hud_ScoreLoop
	rts

; -------------------------------------------------------------------------

Hud_100000:	dc.l 100000
Hud_10000:	dc.l 10000
Hud_1000:	dc.l 1000
Hud_100:	dc.l 100
Hud_10:		dc.l 10
Hud_1:		dc.l 1
		dc.l 0

; -------------------------------------------------------------------------

Hud_TimeRingBonus:
	lea	(Hud_1000).l,a2
	moveq	#3,d6
	moveq	#0,d4
	lea	Art_HudNums(pc),a1

Hud_BonusLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_1CA1E:
	sub.l	d3,d1
	bcs.s	loc_1CA26
	addq.w	#1,d2
	bra.s	loc_1CA1E

loc_1CA26:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_1CA30
	move.w	#1,d4

loc_1CA30:
	tst.w	d4
	beq.s	Hud_ClrBonus
	
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
	moveq	#16-1,d2

.Load:
	move.l	(a3)+,(a6)
	dbf	d2,.Load

loc_1CA5A:
	dbf	d6,Hud_BonusLoop ; repeat 3 more times

	rts

Hud_ClrBonus:
	moveq	#$F,d5

Hud_ClrBonusLoop:
	move.l	#0,(a6)
	dbf	d5,Hud_ClrBonusLoop

	bra.s	loc_1CA5A

; -------------------------------------------------------------------------

	include	"source/sonic/_incObj/sub AddPoints.asm"

; -------------------------------------------------------------------------
; Objects
; -------------------------------------------------------------------------
	
	include	"source/sonic/_incObj/7E Special Stage Results.asm"
	include	"source/sonic/_incObj/7F SS Result Chaos Emeralds.asm"

Map_SSR:
	dc.w M_SSR_Chaos-Map_SSR
	dc.w M_SSR_Score-Map_SSR
	dc.w byte_CD0D-Map_SSR
	dc.w M_Card_Oval-Map_SSR
	dc.w byte_CD6B-Map_SSR
	dc.w byte_CDA8-Map_SSR
M_SSR_Chaos:
	dc.w $B			; "CHAOS TIRES"
	dc.w $F805, $0008, $FFAC
	dc.w $F805, $001C, $FFBC
	dc.w $F805, $0000, $FFCC
	dc.w $F805, $0032, $FFDC
	dc.w $F805, $003E, $FFEC
	dc.w $F800, $0056, $FFFC
	dc.w $F805, $0042, $000C
	dc.w $F801, $0020, $001C
	dc.w $F805, $003A, $0024
	dc.w $F805, $0010, $0034
	dc.w $F805, $003E, $0044
M_SSR_Score:
	dc.w 6			; "SCORE"
	dc.w $F80D, $014A, $FFB0
	dc.w $F801, $0162, $FFD0
	dc.w $F809, $0164, $0018
	dc.w $F80D, $016A, $0030
	dc.w $F704, $006E, $FFCD
	dc.w $FF04, $186E, $FFCD
byte_CD0D:
	dc.w 7
	dc.w $F80D, $0152, $FFB0
	dc.w $F80D, $0066, $FFD9
	dc.w $F801, $014A, $FFF9
	dc.w $F704, $006E, $FFF6
	dc.w $FF04, $186E, $FFF6
	dc.w $F80D, $FFF8, $0028
	dc.w $F801, $0170, $0048
byte_CD6B:
	dc.w $C			; "SPECIAL STAGE"
	dc.w $F805, $003E, $FF9C
	dc.w $F805, $0036, $FFAC
	dc.w $F805, $0010, $FFBC
	dc.w $F805, $0008, $FFCC
	dc.w $F801, $0020, $FFDC
	dc.w $F805, $0000, $FFE4
	dc.w $F805, $0026, $FFF4
	dc.w $F805, $003E, $0014
	dc.w $F805, $0042, $0024
	dc.w $F805, $0000, $0034
	dc.w $F805, $0018, $0044
	dc.w $F805, $0010, $0054
byte_CDA8:
	dc.w $C			; "GOT THEM ALL"
	dc.w $F805, $0018, $FFA0
	dc.w $F805, $0032, $FFB0
	dc.w $F805, $0042, $FFC0
	dc.w $F800, $0056, $FFD0
	dc.w $F805, $0042, $FFE0
	dc.w $F805, $001C, $FFF0
	dc.w $F805, $0010, $0000
	dc.w $F805, $002A, $0010
	dc.w $F800, $0056, $0020
	dc.w $F805, $0000, $0030
	dc.w $F805, $0026, $0040
	dc.w $F805, $0026, $0050
M_Card_Oval:
	dc.w $D			; Oval
	dc.w $E40C, $0070, $FFF4
	dc.w $E402, $0074, $0014
	dc.w $EC04, $0077, $FFEC
	dc.w $F405, $0079, $FFE4
	dc.w $140C, $1870, $FFEC
	dc.w $0402, $1874, $FFE4
	dc.w $0C04, $1877, $0004
	dc.w $FC05, $1879, $000C
	dc.w $EC08, $007D, $FFFC
	dc.w $F40C, $007C, $FFF4
	dc.w $FC08, $007C, $FFF4
	dc.w $040C, $007C, $FFEC
	dc.w $0C08, $007C, $FFEC
	even

Map_SSRC:
	include	"source/sonic/_maps/SS Result Chaos Emeralds.asm"

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Pal_SSResult:
	incbin	"source/sonic/palette/Special Stage Results.bin"
	even
Art_TitleCard:
	incbin	"source/sonic/artnem/Title Cards.bin"
	even
Art_ResultEm:
	incbin	"source/sonic/artnem/Special Result Emeralds.bin"
	even
Art_Hud:
	incbin	"source/special/data/results_hud.nem"
	even
Art_HudNums:
	incbin	"source/sonic/artunc/HUD Numbers.bin"
	even

; -------------------------------------------------------------------------
