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
timerSub	rs.w	1
gameOverSub	rs.b	1

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
VRAM_BUILDINGS	EQU	VRAM_CLOUDS+$620
VRAM_BUS	EQU	VRAM_BUILDINGS+$A0
VRAM_PERSON_1	EQU	VRAM_BUS+$2300
VRAM_PERSON_2	EQU	VRAM_PERSON_1+$600
VRAM_PERSON_3	EQU	VRAM_PERSON_2+$600
VRAM_SIGN	EQU	VRAM_PERSON_3+$600
VRAM_TREE	EQU	VRAM_SIGN+$6E0
VRAM_FONT	EQU	VRAM_TREE+$1B40
VRAM_ARROW	EQU	$CE00
VRAM_ARROW_3D	EQU	$EE00

; -------------------------------------------------------------------------
