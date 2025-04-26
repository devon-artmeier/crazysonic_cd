; -------------------------------------------------------------------------
; Main menu
; -------------------------------------------------------------------------

MainMenu:
	jsr	ClearScreen					; Clear screen

	moveq	#0,d0
	move.w	d0,v_rings.w					; Reset ring count
	move.l	d0,v_time.w					; Reset time
	move.l	d0,v_score.w					; Reset score
	move.b	d0,v_lastspecial.w				; Reset special stage IDs
	move.b	d0,v_continues.w				; Reset contimues
	move.b	d0,v_lastlamp.w					; Reset checkpoint
	move.b	d0,v_debuguse.w					; Reset debug use flag
	move.b	d0,menuSelection				; Reset menu selection
	move.b	d0,health.w					; Reset health
	move.b	d0,secretBoss.w					; Reset secret boss flag
	move.w	d0,v_zone.w					; Reset zone
	move.l	#5000,v_scorelife.w				; Next 1UP is awarded at 50000 points
	move.b	#3,v_lives.w					; Set to 3 lives

	btst	#0,v_cheatactive.w
	beq.w	StartGame

	;move.b	#1,f_debugmode.w				; Enable debug mode
	
	VDP_CMD move.l,$20,VRAM,WRITE,VDP_CTRL			; Load font
	lea	Art_MenuFont(pc),a0
	jsr	NemDec
	
	moveq	#0,d7						; Load menu background
	bsr.w	LoadMenuBG
	
	lea	Pal_MenuFont(pc),a0				; Load font palette
	lea	v_pal_dry_dup+$20.w,a1
	moveq	#(Pal_MenuFontEnd-Pal_MenuFont)/4-1,d0

.LoadPalette:
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadPalette

; -------------------------------------------------------------------------

GoToMainMenu:
	lea	MenuText(pc),a0					; Draw menu
	bsr.w	DrawMenu
	
	moveq	#CBID_MENU,d0					; Play "music"
	lea	CBPCM_Play,a1
	jsr	CallSubFunction

	jsr	PaletteFadeIn					; Fade from black
	
; -------------------------------------------------------------------------

.MainLoop:
	st	v_vbla_routine.w				; VSync
	jsr	WaitForVBla
	
	lea	MenuText(pc),a0					; Update menu
	lea	menuSelection,a1
	lea	MainMenuSelect,a2
	moveq	#24-1,d0
	bsr.w	UpdateMenu
	
	bra.w	.MainLoop					; Loop

; -------------------------------------------------------------------------

StartGame:
	move.b	#id_Level,v_gamemode.w				; Set mode to level
	jsr	PaletteFadeOut					; Fade to black
	
	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	
	move	#$2700,sr					; Only update sound
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr
	rts

; -------------------------------------------------------------------------
; Update menu
; -------------------------------------------------------------------------

UpdateMenu:
	btst	#0,v_jpadpress1.w				; Has up been pressed?
	beq.s	.NoUp						; If not, branch
	subq.b	#1,(a1)						; Move selection up
	bpl.s	.Redraw						; If it hasn't underflowed, branch
	move.b	d0,(a1)						; Wrap to bottom
	bra.s	.Redraw						; Go redraw menu
	
.NoUp:
	btst	#1,v_jpadpress1.w				; Has down been pressed?
	beq.s	.CheckSelect					; If not, branch
	addq.b	#1,(a1)						; Move selection down
	cmp.b	(a1),d0						; Has it overflowed?
	bcc.s	.Redraw						; If not, branch
	clr.b	(a1)						; Wrap to top
	
.Redraw:
	bsr.w	DrawMenu					; Redraw menu
	
.CheckSelect:
	move.b	v_jpadpress1.w,d0				; Has A or start been pressed?
	andi.b	#btnA|btnStart,d0
	beq.s	.End						; If not, branch
	jmp	(a2)						; Handle selection
	
.End:
	rts

; -------------------------------------------------------------------------
; Draw menu
; -------------------------------------------------------------------------

DrawMenu:
	moveq	#0,d4						; Line ID
	VDP_CMD move.l,vram_fg+$110,VRAM,WRITE,d0		; VRAM write command

.Loop:
	cmpa.l	#MenuTextEnd,a0					; Are we at the end?
	bcc.s	.End						; If so, branch
	
	move.w	#$2000-('0'-1),d1				; Not highlighted
	cmp.b	(a1),d4						; Is this line selected?
	bne.s	.Draw						; If not, branch
	move.w	#$4000-('0'-1),d1				; Highlighted
	
.Draw:
	jsr	DrawText					; Draw line
	
	addq.b	#1,d4						; Next line
	bra.s	.Loop						; Loop
	
.End:
	rts

; -------------------------------------------------------------------------
; Handle main menu selection
; -------------------------------------------------------------------------

MainMenuSelect:
	moveq	#0,d0						; Get selection
	move.b	(a1),d0
	add.w	d0,d0
	move.w	.Selections(pc,d0.w),d0
	bmi.s	.Special					; If it's a special selection, branch

	move.w	d0,v_zone.w					; Set zone ID
	move.b	#id_Level,v_gamemode.w				; Set mode to level
	jsr	PaletteFadeOut					; Fade to black
	
.ExitMenu:
	lea	CBPCM_Stop,a1					; Stop sound
	jsr	CallSubFunction
	
	move	#$2700,sr					; Only update sound
	move.l	#VInt_Sound,_LEVEL6+2.w
	move	#$2300,sr

	addq.w	#4,sp						; Exit menu
	rts

; -------------------------------------------------------------------------

.Selections:
	dc.w	(id_GHZ<<8)|0
	dc.w	(id_GHZ<<8)|1
	dc.w	(id_GHZ<<8)|2
	dc.w	(id_MZ<<8)|0
	dc.w	(id_MZ<<8)|1
	dc.w	(id_MZ<<8)|2
	dc.w	(id_SYZ<<8)|0
	dc.w	(id_SYZ<<8)|1
	dc.w	(id_SYZ<<8)|2
	dc.w	(id_LZ<<8)|0
	dc.w	(id_LZ<<8)|1
	dc.w	(id_LZ<<8)|2
	dc.w	(id_SLZ<<8)|0
	dc.w	(id_SLZ<<8)|1
	dc.w	(id_SLZ<<8)|2
	dc.w	(id_SBZ<<8)|0
	dc.w	(id_SBZ<<8)|1
	dc.w	(id_LZ<<8)|3
	dc.w	(id_SBZ<<8)|2
	dc.w	(id_SecretZ<<8)|0
	dc.w	-1
	dc.w	-2
	dc.w	-3
	dc.w	-4

; -------------------------------------------------------------------------

.Special:
	neg.w	d0						; Handle special selection
	add.w	d0,d0
	add.w	d0,d0
	jmp	.SpecialSelections-4(pc,d0.w)
	
; -------------------------------------------------------------------------

.SpecialSelections:
	bra.w	.SpecialStage
	bra.w	.CrazyBus3D
	bra.w	.HongKong97
	bra.w	.ImageGallery
	
; -------------------------------------------------------------------------
	
.SpecialStage:
	clr.w	v_zone.w					; Reset to GHZ1
	clr.b	v_emeralds.w					; Reset emerald count
	move.b	#id_Special,v_gamemode.w			; Go to special stage
	
	lea	CBPCM_Stop,a1					; Fade to white
	jsr	CallSubFunction
	move.w	#sfx_EnterSS,d0
	jsr	PlaySound_Special
	jsr	PaletteWhiteOut

	bra.w	.ExitMenu					; Exit menu
	
; -------------------------------------------------------------------------
	
.CrazyBus3D:
	move.b	#id_CrazyBus3D,v_gamemode.w			; Go to CrazyBus 3D
	jsr	PaletteFadeOut					; Fade to black
	bra.w	.ExitMenu					; Exit menu
	
; -------------------------------------------------------------------------

.HongKong97:
	move.b	#id_HongKong97,v_gamemode.w			; Go to Hong Kong 97
	jsr	PaletteFadeOut					; Fade to black
	bra.w	.ExitMenu					; Exit menu

; -------------------------------------------------------------------------

.ImageGallery:
	move.b	#id_ImgGallery,v_gamemode.w			; Go to image gallery
	jsr	PaletteFadeOut					; Fade to black
	bra.w	.ExitMenu					; Exit menu

; -------------------------------------------------------------------------

MenuText:
	dc.b	"GREEN HILL ZONE    ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"MARBLE ZONE        ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"SPRING YARD ZONE   ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"LABYRINTH ZONE     ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"STAR LIGHT ZONE    ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"SCRAP BRAIN ZONE   ACT 1", -1, 0
	dc.b	"                   ACT 2", -1, 0
	dc.b	"                   ACT 3", -1, 0
	dc.b	"FINAL ZONE", -1, 0
	dc.b	"SECRET ZONE", -1, 0
	dc.b	"SPECIAL STAGE", -1, 0
	dc.b	"PLAY BETTER GAME 1", -1, 0
	dc.b	"PLAY BETTER GAME 2", -1, 0
	dc.b	"CRAPPY IMAGE GALLERY", 0
MenuTextEnd:
	even
	
; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

	include	"src/crazybus/menu_bg_data.asm"

Art_MenuFont:
	incbin	"src/title/data/menu_font_art.nem"
	even
Pal_MenuFont:
	incbin	"src/title/data/menu_font_pal.bin"
Pal_MenuFontEnd:
	even
	
; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

menuSelection:
	dc.b	0
	even
	
; -------------------------------------------------------------------------
