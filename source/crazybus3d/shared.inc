; -------------------------------------------------------------------------
; Shared variables
; -------------------------------------------------------------------------

FPS_SRC		EQU	30
	if REGION<>EUROPE
FPS_DEST	EQU	20
	else
FPS_DEST	EQU	17
	endif

; -------------------------------------------------------------------------

sprites		rs.b	$200
bgOffset	rs.w	1
recordSub	rs.w	1

; -------------------------------------------------------------------------

IMG_COPY_1	EQU	IMG_LENGTH/3
IMG_COPY_2	EQU	IMG_LENGTH/3
IMG_COPY_3	EQU	IMG_LENGTH-(IMG_COPY_1+IMG_COPY_2)

IMG_VRAM_11	EQU	$20
IMG_VRAM_12	EQU	IMG_VRAM_11+IMG_COPY_1
IMG_VRAM_13	EQU	IMG_VRAM_12+IMG_COPY_2

IMG_VRAM_21	EQU	IMG_VRAM_11+IMG_LENGTH
IMG_VRAM_22	EQU	IMG_VRAM_21+IMG_COPY_1
IMG_VRAM_23	EQU	IMG_VRAM_22+IMG_COPY_2

IMG_END		EQU	IMG_VRAM_21+IMG_LENGTH

VRAM_CLOUDS	EQU	IMG_END
VRAM_BUS	EQU	VRAM_CLOUDS+$6C0
VRAM_GRADIENT	EQU	VRAM_BUS+$2300
VRAM_FONT	EQU	VRAM_GRADIENT+$60

; -------------------------------------------------------------------------
