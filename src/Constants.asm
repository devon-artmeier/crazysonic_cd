; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

; Sound driver constants
TrackPlaybackControl:	equ 0		; All tracks
TrackVoiceControl:	equ 1		; All tracks
TrackTempoDivider:	equ 2		; All tracks
TrackDataPointer:	equ 4		; All tracks (4 bytes)
TrackTranspose:		equ 8		; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		equ 9		; FM/PSG only
TrackAMSFMSPan:		equ $A		; FM/DAC only
TrackVoiceIndex:	equ $B		; FM/PSG only
TrackVolEnvIndex:	equ $C		; PSG only
TrackStackPointer:	equ $D		; All tracks
TrackDurationTimeout:	equ $E		; All tracks
TrackSavedDuration:	equ $F		; All tracks
TrackSavedDAC:		equ $10		; DAC only
TrackFreq:		equ $10		; FM/PSG only (2 bytes)
TrackNoteTimeout:	equ $12		; FM/PSG only
TrackNoteTimeoutMaster:equ $13		; FM/PSG only
TrackModulationPtr:	equ $14		; FM/PSG only (4 bytes)
TrackModulationWait:	equ $18		; FM/PSG only
TrackModulationSpeed:	equ $19		; FM/PSG only
TrackModulationDelta:	equ $1A		; FM/PSG only
TrackModulationSteps:	equ $1B		; FM/PSG only
TrackModulationVal:	equ $1C		; FM/PSG only (2 bytes)
TrackDetune:		equ $1E		; FM/PSG only
TrackPSGNoise:		equ $1F		; PSG only
TrackFeedbackAlgo:	equ $1F		; FM only
TrackVoicePtr:		equ $20		; FM SFX only (4 bytes)
TrackLoopCounters:	equ $24		; All tracks (multiple bytes)
TrackGoSubStack:	equ TrackSz	; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses TrackSz)

TrackSz:	equ $30

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sonic:	equ $F000	; Sonic graphics
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Game modes
id_Title:	equ $00
id_Level:	equ $04
id_Special:	equ $08
id_Ending:	equ $0C
id_CrazyBus3D:	equ $10
id_HongKong97:	equ $14
id_ImgGallery:	equ $18

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SecretZ:	equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obActWid:	equ $14	; action width
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obInertia:	equ $20	; potential speed (2 bytes)
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; Object variables used by Sonic
flashtime:	equ $30	; time between flashes after getting hit
invtime:	equ $32	; time left for invincibility
shoetime:	equ $34	; time left for speed shoes
standonobject:	equ $3D	; object Sonic stands on

; Sonic size
SONIC_WIDTH	equ 9
SONIC_HEIGHT	equ $C

SONIC_SOLID_X	equ SONIC_WIDTH+2

; Hazard types
HAZARD_NONE	equ $00
HAZARD_NORMAL	equ $01
HAZARD_SPIKE	equ $02
HAZARD_BURN	equ $03
HAZARD_SPECIAL	equ $04

; Object variables (Sonic 2 disassembly nomenclature)
render_flags:	equ 1	; bitfield for x/y flip, display mode
art_tile:	equ 2	; palette line & VRAM setting (2 bytes)
mappings:	equ 4	; mappings address (4 bytes)
x_pos:		equ 8	; x-axis position (2-4 bytes)
y_pos:		equ $C	; y-axis position (2-4 bytes)
x_vel:		equ $10	; x-axis velocity (2 bytes)
y_vel:		equ $12	; y-axis velocity (2 bytes)
width_pixels:	equ $14	; action width
y_radius:	equ $16	; height/2
x_radius:	equ $17	; width/2
priority:	equ $18	; sprite stack priority -- 0 is front
mapping_frame:	equ $1A	; current frame displayed
anim_frame:	equ $1B	; current frame in animation script
anim:		equ $1C	; current animation
next_anim:	equ $1D	; next animation
anim_frame_duration: equ $1E ; time to next frame
collision_flags: equ $20 ; collision response type
collision_property: equ $21 ; collision extra property
status:		equ $22	; orientation or mode
respawn_index:	equ $23	; respawn list index number
routine:	equ $24	; routine number
routine_secondary: equ $25 ; secondary routine number
angle:		equ $26	; angle
subtype:	equ $28	; object subtype

; Sub sprite data
mainspr_mapframe	equ $B
mainspr_width		equ $E
mainspr_childsprites	equ $F
mainspr_height		equ $14
subspr_data		equ $10
sub2_x_pos		equ $10
sub2_y_pos		equ $12
sub2_mapframe		equ $15
sub3_x_pos		equ $16
sub3_y_pos		equ $18
sub3_mapframe		equ $1B
sub4_x_pos		equ $1C
sub4_y_pos		equ $1E
sub4_mapframe		equ $21
sub5_x_pos		equ $22
sub5_y_pos		equ $24
sub5_mapframe		equ $27
sub6_x_pos		equ $28
sub6_y_pos		equ $2A
sub6_mapframe		equ $2D
sub7_x_pos		equ $2E
sub7_y_pos		equ $30
sub7_mapframe		equ $33
sub8_x_pos		equ $34
sub8_y_pos		equ $36
sub8_mapframe		equ $39
sub9_x_pos		equ $3A
sub9_y_pos		equ $3C
sub9_mapframe		equ $3F
next_subspr		equ $6

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter

; Sound effects
sfx__First:	equ $A0
sfx_Jump:	equ $A0
sfx_Lamppost:	equ $A1
sfx_A2:		equ $A2
sfx_Death:	equ $A3
sfx_Skid:	equ $A4
sfx_A5:		equ $A5
sfx_HitSpikes:	equ $A6
sfx_Push:	equ $A7
sfx_SSGoal:	equ $A8
sfx_SSItem:	equ $A9
sfx_Splash:	equ $AA
sfx_AB:		equ $AB
sfx_HitBoss:	equ $AC
sfx_Bubble:	equ $AD
sfx_Fireball:	equ $AE
sfx_Shield:	equ $AF
sfx_Saw:	equ $B0
sfx_Electric:	equ $B1
sfx_Drown:	equ $B2
sfx_Flamethrower:equ $B3
sfx_Bumper:	equ $B4
sfx_Ring:	equ $B5
sfx_SpikesMove:	equ $B6
sfx_Rumbling:	equ $B7
sfx_B8:		equ $B8
sfx_Collapse:	equ $B9
sfx_SSGlass:	equ $BA
sfx_Door:	equ $BB
sfx_Teleport:	equ $BC
sfx_ChainStomp:	equ $BD
sfx_Roll:	equ $BE
sfx_Continue:	equ $BF
sfx_Basaran:	equ $C0
sfx_BreakItem:	equ $C1
sfx_Warning:	equ $C2
sfx_GiantRing:	equ $C3
sfx_Bomb:	equ $C4
sfx_Cash:	equ $C5
sfx_RingLoss:	equ $C6
sfx_ChainRise:	equ $C7
sfx_Burning:	equ $C8
sfx_Bonus:	equ $C9
sfx_EnterSS:	equ $CA
sfx_WallSmash:	equ $CB
sfx_Spring:	equ $CC
sfx_Switch:	equ $CD
sfx_RingLeft:	equ $CE
sfx_Signpost:	equ $CF
sfx__Last:	equ $CF

; Special sound effects
spec__First:	equ $D0
sfx_Waterfall:	equ $D0
spec__Last:	equ $D0

flg__First:	equ $E0
bgm_Fade:	equ $E0
sfx_Sega:	equ $E1
bgm_Speedup:	equ $E2
bgm_Slowdown:	equ $E3
bgm_Stop:	equ $E4
flg__Last:	equ $E4

id_Walk:	equ 0
id_Run:		equ 1
id_Roll:	equ 2
id_Roll2:	equ 3
id_Push:	equ 4
id_Wait:	equ 5
id_Balance:	equ 6
id_LookUp:	equ 7
id_Duck:	equ 8
id_Warp1:	equ 9
id_Warp2:	equ $A
id_Warp3:	equ $B
id_Warp4:	equ $C
id_Stop:	equ $D
id_Float1:	equ $E
id_Float2:	equ $F
id_Spring:	equ $10
id_Hang:	equ $11
id_Leap1:	equ $12
id_Leap2:	equ $13
id_Surf:	equ $14
id_GetAir:	equ $15
id_Burnt:	equ $16
id_Drown:	equ $17
id_Death:	equ $18
id_Shrink:	equ $19
id_Hurt:	equ $1A
id_WaterSlide:	equ $1B
id_Null:	equ $1C
id_Float3:	equ $1D
id_Float4:	equ $1E
id_Submarine:	equ $1F
id_Flat:	equ $20
