; -------------------------------------------------------------------------
; Special stage variables (Sub CPU)
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; Object variables structure
; -------------------------------------------------------------------------

oSize		EQU	$40					; Size of object structure
c = 0
	rept	oSize						; Stock variables in structure
oVar\$c		EQU	c
		c: = c+1
	endr

	rsreset
oAddr			rs.l	1				; ID
oTile			rs.w	1				; Base tile ID
oMap			rs.l	1				; Mappings
oFlags			rs.b	1				; Flags
oRoutine		rs.b	1				; Routine
oX			rs.l	1				; X position
oY			rs.l	1				; Y position
oZ			rs.l	1				; Z position
oSprX			rs.l	1				; Sprite X position
oSprY			rs.l	1				; Sprite Y position
oXVel			rs.l	1				; X velocity
oYVel			rs.l	1				; Y velocity
oFrame			rs.b	1				; Sprite frame
oSubtype		rs.b	1				; Subtype

; -------------------------------------------------------------------------
; Graphics operation variable structure
; -------------------------------------------------------------------------

	rsreset
gfxCamX			rs.l	1				; Camera X
gfxCamY			rs.l	1				; Camera Y
gfxCamZ			rs.l	1				; Camera Z
gfxPitch		rs.l	1				; Pitch
gfxPitchSin		rs.w	1				; Sine of pitch
gfxPitchCos		rs.w	1				; Cosine of pitch
gfxYaw			rs.l	1				; Yaw
gfxYawSin		rs.w	1				; Sine of yaw
gfxYawCos		rs.w	1				; Cosine of yaw
gfxFOV			rs.w	1				; FOV
gfxCenter		rs.w	1				; Center point
			rs.b	$16
gfxPsYsFOV		rs.l	1				; sin(pitch) * sin(yaw) * FOV
gfxPsYcFOV		rs.l	1				; sin(pitch) * cos(yaw) * FOV
			rs.b	8
gfxPcFOV		rs.l	1				; cos(pitch) * FOV
			rs.b	4
gfxYsFOV		rs.w	1				; sin(yaw) * FOV
			rs.b	2
gfxYcFOV		rs.w	1				; cos(yaw) * FOV
			rs.b	6
gfxCenterX		rs.w	1				; Center point X offset
			rs.b	2
gfxCenterY		rs.w	1				; Center point Y offset
			rs.b	2
gfxPcYs			rs.w	1				; cos(pitch) * sin(yaw)
			rs.b	2
gfxPcYc			rs.w	1				; cos(pitch) * cos(yaw)
gfxSize			rs.b	0				; Size of structure

; -------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------

	rsset	PRG_START+$3C000
VARS_START		rs.b	0

playerObject		rs.b	oSize

cddaParam		rs.w	1
gfxVars			rs.b	gfxSize

curSpriteSlot		rs.l	1
spriteCount		rs.b	1
			rs.b	1

VARS_END		rs.b	0

; -------------------------------------------------------------------------
