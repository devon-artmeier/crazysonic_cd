; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:		dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:	dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:	dc.w PLC_GameOver-ArtLoadCues
ptr_PLC_MZ:		dc.w PLC_MZ-ArtLoadCues
ptr_PLC_MZ2:		dc.w PLC_MZ2-ArtLoadCues
ptr_PLC_TitleCard:	dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:		dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:	dc.w PLC_Signpost-ArtLoadCues
ptr_PLC_MZAnimals:	dc.w PLC_MZAnimals-ArtLoadCues

plcm:	macro gfx,vram
	dc.l gfx
	dc.w vram
	endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main-2)/6)-1
		plcm	Nem_Points, $A820	; points from enemy
		plcm	Nem_Lamp, $D800		; lamppost
		plcm	Nem_Hud, $D940		; HUD
		plcm	Nem_Lives, $FA80	; lives	counter
		plcm	Nem_Ring, $F640 	; rings
	PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	dc.w ((PLC_Main2end-PLC_Main2-2)/6)-1
		plcm	Nem_Monitors, $D000	; monitors
	PLC_Main2end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	dc.w ((PLC_Explodeend-PLC_Explode-2)/6)-1
		plcm	Nem_Explode, $B400	; explosion
	PLC_Explodeend:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	dc.w ((PLC_GameOverend-PLC_GameOver-2)/6)-1
	PLC_GameOverend:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_MZ:	dc.w ((PLC_MZ2-PLC_MZ-2)/6)-1
		plcm	Nem_MZ,0		; MZ main patterns
		plcm	Nem_MzMetal, $6000	; metal	blocks
		plcm	Nem_MzFire, $68A0	; fireballs
		plcm	Nem_Swing, $7000	; swinging platform
		plcm	Nem_MzGlass, $71C0	; green	glassy block
		plcm	Nem_Lava, $7500		; lava
		plcm	Nem_Buzz, $8880		; buzz bomber enemy
		plcm	Nem_Yadrin, $8F60	; yadrin enemy
		plcm	Nem_Basaran, $9700	; basaran enemy
		plcm	Nem_Cater, $9FE0	; caterkiller enemy

PLC_MZ2:	dc.w ((PLC_MZ2end-PLC_MZ2-2)/6)-1
		plcm	Nem_MzSwitch, $A260	; switch
		plcm	Nem_Spikes, $A360	; spikes
		plcm	Nem_HSpring, $A460	; horizontal spring
		plcm	Nem_VSpring, $A660	; vertical spring
		plcm	Nem_MzBlock, $5700	; green	stone block
	PLC_MZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	dc.w ((PLC_TitleCardend-PLC_TitleCard-2)/6)-1
		plcm	Nem_TitleCard, $B000
	PLC_TitleCardend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	dc.w ((PLC_Bossend-PLC_Boss-2)/6)-1
		plcm	Nem_Eggman, $8000	; Eggman main patterns
		plcm	Nem_Weapons, $8D80	; Eggman's weapons
		plcm	Nem_Prison, $93A0	; prison capsule
		plcm	Nem_Bomb, $A300		; bomb enemy ((gets overwritten)
		plcm	Nem_SlzSpike, $A300	; spikeball ((SLZ boss)
		plcm	Nem_Exhaust, $A540	; exhaust flame
	PLC_Bossend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	dc.w ((PLC_Signpostend-PLC_Signpost-2)/6)-1
		plcm	Nem_SignPost, $D000	; signpost
		plcm	Nem_Bonus, $96C0	; hidden bonus points
		plcm	Nem_BigFlash, $8C40	; giant	ring flash effect
	PLC_Signpostend:
; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	dc.w ((PLC_MZAnimalsend-PLC_MZAnimals-2)/6)-1
		plcm	Nem_Squirrel, $B000	; squirrel
		plcm	Nem_Seal, $B240		; seal
	PLC_MZAnimalsend:

; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		equ (ptr_PLC_Main-ArtLoadCues)/2	; 0
plcid_Main2:		equ (ptr_PLC_Main2-ArtLoadCues)/2	; 1
plcid_Explode:		equ (ptr_PLC_Explode-ArtLoadCues)/2	; 2
plcid_GameOver:		equ (ptr_PLC_GameOver-ArtLoadCues)/2	; 3
plcid_Level:		equ (ptr_PLC_MZ-ArtLoadCues)/2		; 4
plcid_Level2:		equ (ptr_PLC_MZ2-ArtLoadCues)/2	; 5
plcid_TitleCard:	equ (ptr_PLC_TitleCard-ArtLoadCues)/2	; $10
plcid_Boss:		equ (ptr_PLC_Boss-ArtLoadCues)/2	; $11
plcid_Signpost:		equ (ptr_PLC_Signpost-ArtLoadCues)/2	; $12
plcid_Animals:		equ (ptr_PLC_MZAnimals-ArtLoadCues)/2	; $15
