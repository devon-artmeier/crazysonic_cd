; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:		dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:	dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:	dc.w PLC_GameOver-ArtLoadCues
ptr_PLC_SBZ:		dc.w PLC_SBZ-ArtLoadCues
ptr_PLC_SBZ2:		dc.w PLC_SBZ2-ArtLoadCues
ptr_PLC_TitleCard:	dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:		dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:	dc.w PLC_Signpost-ArtLoadCues
ptr_PLC_SBZAnimals:	dc.w PLC_SBZAnimals-ArtLoadCues
ptr_PLC_EggmanSBZ2:	dc.w PLC_EggmanSBZ2-ArtLoadCues
ptr_PLC_FZBoss:		dc.w PLC_FZBoss-ArtLoadCues

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
; Pattern load cues - Scrap Brain
; ---------------------------------------------------------------------------
PLC_SBZ:	dc.w ((PLC_SBZ2-PLC_SBZ-2)/6)-1
		plcm	Nem_SBZ,0		; SBZ main patterns
		plcm	Nem_Stomper, $5800	; moving platform and stomper
		plcm	Nem_SbzDoor1, $5D00	; door
		plcm	Nem_Girder, $5E00	; girder
		plcm	Nem_BallHog, $6040	; ball hog enemy
		plcm	Nem_SbzWheel1, $6880	; spot on large	wheel
		plcm	Nem_SbzWheel2, $6900	; wheel	that grabs Sonic
		plcm	Nem_SyzSpike1, $7220	; large	spikeball
		plcm	Nem_Cutter, $76A0	; pizza	cutter
		plcm	Nem_FlamePipe, $7B20	; flaming pipe
		plcm	Nem_SbzFloor, $7EA0	; collapsing floor
		plcm	Nem_SbzBlock, $9860	; vanishing block

PLC_SBZ2:	dc.w ((PLC_SBZ2end-PLC_SBZ2-2)/6)-1
		plcm	Nem_Cater, $5600	; caterkiller enemy
		plcm	Nem_Bomb, $8000		; bomb enemy
		plcm	Nem_Orbinaut, $8520	; orbinaut enemy
		plcm	Nem_SlideFloor, $8C00	; floor	that slides away
		plcm	Nem_SbzDoor2, $8DE0	; horizontal door
		plcm	Nem_Electric, $8FC0	; electric orb
		plcm	Nem_TrapDoor, $9240	; trapdoor
		plcm	Nem_SbzFloor, $7F20	; collapsing floor
		plcm	Nem_SpinPform, $9BE0	; small	spinning platform
		plcm	Nem_LzSwitch, $A1E0	; switch
		plcm	Nem_Spikes, $A360	; spikes
		plcm	Nem_HSpring, $A460	; horizontal spring
		plcm	Nem_VSpring, $A660	; vertical spring
	PLC_SBZ2end:
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
		plcm	Nem_SlzSpike, $A300	; spikeball ((SBZ boss)
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
; Pattern load cues - SBZ animals
; ---------------------------------------------------------------------------
PLC_SBZAnimals:	dc.w ((PLC_SBZAnimalsend-PLC_SBZAnimals-2)/6)-1
		plcm	Nem_Rabbit, $B000		; rabbit
		plcm	Nem_Chicken, $B240	; chicken
	PLC_SBZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - Eggman on SBZ 2
; ---------------------------------------------------------------------------
PLC_EggmanSBZ2:	dc.w ((PLC_EggmanSBZ2end-PLC_EggmanSBZ2-2)/6)-1
		plcm	Nem_SbzBlock, $A300	; block
		plcm	Nem_Sbz2Eggman, $8000	; Eggman
		plcm	Nem_LzSwitch, $9400	; switch
	PLC_EggmanSBZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - final boss
; ---------------------------------------------------------------------------
PLC_FZBoss:	dc.w ((PLC_FZBossend-PLC_FZBoss-2)/6)-1
		plcm	Nem_FzEggman, $7400	; Eggman after boss
		plcm	Nem_FzBoss, $6000	; FZ boss
		plcm	Nem_Eggman, $8000	; Eggman main patterns
		plcm	Nem_Sbz2Eggman, $8E00	; Eggman without ship
		plcm	Nem_Exhaust, $A540	; exhaust flame
	PLC_FZBossend:
		even

; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		equ (ptr_PLC_Main-ArtLoadCues)/2	; 0
plcid_Main2:		equ (ptr_PLC_Main2-ArtLoadCues)/2	; 1
plcid_Explode:		equ (ptr_PLC_Explode-ArtLoadCues)/2	; 2
plcid_GameOver:		equ (ptr_PLC_GameOver-ArtLoadCues)/2	; 3
plcid_Level:		equ (ptr_PLC_SBZ-ArtLoadCues)/2		; 4
plcid_Level2:		equ (ptr_PLC_SBZ2-ArtLoadCues)/2	; 5
plcid_TitleCard:	equ (ptr_PLC_TitleCard-ArtLoadCues)/2	; $10
plcid_Boss:		equ (ptr_PLC_Boss-ArtLoadCues)/2	; $11
plcid_Signpost:		equ (ptr_PLC_Signpost-ArtLoadCues)/2	; $12
plcid_Animals:		equ (ptr_PLC_SBZAnimals-ArtLoadCues)/2	; $15
plcid_EggmanSBZ2:	equ (ptr_PLC_EggmanSBZ2-ArtLoadCues)/2	; $1E
plcid_FZBoss:		equ (ptr_PLC_FZBoss-ArtLoadCues)/2	; $1F
