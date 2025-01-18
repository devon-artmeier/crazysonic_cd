; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:		dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:	dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:	dc.w PLC_GameOver-ArtLoadCues
ptr_PLC_GHZ:		dc.w PLC_GHZ-ArtLoadCues
ptr_PLC_GHZ2:		dc.w PLC_GHZ2-ArtLoadCues
ptr_PLC_TitleCard:	dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:		dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:	dc.w PLC_Signpost-ArtLoadCues
ptr_PLC_GHZAnimals:	dc.w PLC_GHZAnimals-ArtLoadCues

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
PLC_GHZ:	dc.w ((PLC_GHZ2-PLC_GHZ-2)/6)-1
		plcm	Nem_GHZ_1st, 0		; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0	; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00	; flower stalk
		plcm	Nem_PplRock, $7A00	; purple rock
		plcm	Nem_Crabmeat, $8000	; crabmeat enemy
		plcm	Nem_Buzz, $8880		; buzz bomber enemy
		plcm	Nem_Chopper, $8F60	; chopper enemy
		plcm	Nem_Newtron, $9360	; newtron enemy
		plcm	Nem_Motobug, $9E00	; motobug enemy
		plcm	Nem_Spikes, $A360	; spikes
		plcm	Nem_HSpring, $A460	; horizontal spring
		plcm	Nem_VSpring, $A660	; vertical spring

PLC_GHZ2:	dc.w ((PLC_GHZ2end-PLC_GHZ2-2)/6)-1
		plcm	Nem_Swing, $7000	; swinging platform
		plcm	Nem_Bridge, $71C0	; bridge
		plcm	Nem_SpikePole, $7300	; spiked pole
		plcm	Nem_Ball, $7540		; giant	ball
		plcm	Nem_GhzWall1, $A1E0	; breakable wall
		plcm	Nem_GhzWall2, $6980	; normal wall
	PLC_GHZ2end:
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
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	dc.w ((PLC_GHZAnimalsend-PLC_GHZAnimals-2)/6)-1
		plcm	Nem_Rabbit, $B000	; rabbit
		plcm	Nem_Flicky, $B240	; flicky
	PLC_GHZAnimalsend:

; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		equ (ptr_PLC_Main-ArtLoadCues)/2	; 0
plcid_Main2:		equ (ptr_PLC_Main2-ArtLoadCues)/2	; 1
plcid_Explode:		equ (ptr_PLC_Explode-ArtLoadCues)/2	; 2
plcid_GameOver:		equ (ptr_PLC_GameOver-ArtLoadCues)/2	; 3
plcid_Level:		equ (ptr_PLC_GHZ-ArtLoadCues)/2		; 4
plcid_Level2:		equ (ptr_PLC_GHZ2-ArtLoadCues)/2	; 5
plcid_TitleCard:	equ (ptr_PLC_TitleCard-ArtLoadCues)/2	; $10
plcid_Boss:		equ (ptr_PLC_Boss-ArtLoadCues)/2	; $11
plcid_Signpost:		equ (ptr_PLC_Signpost-ArtLoadCues)/2	; $12
plcid_Animals:		equ (ptr_PLC_GHZAnimals-ArtLoadCues)/2	; $15
