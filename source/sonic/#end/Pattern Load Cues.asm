; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_GameOver:
ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Ending:		dc.w PLC_Ending-ArtLoadCues
ptr_PLC_TryAgain:	dc.w PLC_TryAgain-ArtLoadCues

plcm:	macro gfx,vram
	dc.l gfx
	dc.w vram
	endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main-2)/6)-1
		plcm	Nem_Ring, $F640 	; rings
	PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - ending sequence
; ---------------------------------------------------------------------------
PLC_Ending:	dc.w ((PLC_Endingend-PLC_Ending-2)/6)-1
		plcm	Nem_GHZ_1st,0		; GHZ main patterns
		plcm	Nem_GHZ_2nd, $39A0	; GHZ secondary	patterns
		plcm	Nem_Stalk, $6B00	; flower stalk
		plcm	Nem_EndFlower, $7400	; flowers
		plcm	Nem_EndEm, $78A0	; emeralds
		plcm	Nem_Rabbit, $AA60	; rabbit
		plcm	Nem_Chicken, $ACA0	; chicken
		plcm	Nem_BlackBird, $AE60	; blackbird
		plcm	Nem_Seal, $B0A0		; seal
		plcm	Nem_Pig, $B260		; pig
		plcm	Nem_Flicky, $B4A0	; flicky
		plcm	Nem_Squirrel, $B660	; squirrel
		plcm	Nem_EndStH, $B8A0	; "SONIC THE HEDGEHOG"
	PLC_Endingend:
; ---------------------------------------------------------------------------
; Pattern load cues - "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
PLC_TryAgain:	dc.w ((PLC_TryAgainend-PLC_TryAgain-2)/6)-1
		plcm	Nem_EndEm, $78A0	; emeralds
		plcm	Nem_TryAgain, $7C20	; Eggman
		plcm	Nem_CreditText, $B400	; credits alphabet
	PLC_TryAgainend:

; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		equ (ptr_PLC_Main-ArtLoadCues)/2	; 0
plcid_GameOver:		equ (ptr_PLC_GameOver-ArtLoadCues)/2	; 3
plcid_Ending:		equ (ptr_PLC_Ending-ArtLoadCues)/2	; $1C
plcid_TryAgain:		equ (ptr_PLC_TryAgain-ArtLoadCues)/2	; $1D
