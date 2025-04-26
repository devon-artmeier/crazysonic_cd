; -------------------------------------------------------------------------
; Map definitions
; -------------------------------------------------------------------------

TRACE_TABLE		EQU	$1C800
IMG_BUFFER		EQU	$1D000
STAMP_MAP		EQU	$20000

IMG_WIDTH		EQU	256
IMG_HEIGHT		EQU	88

IMG_TILES_X		EQU	IMG_WIDTH/8
IMG_TILES_Y		EQU	IMG_HEIGHT/8

IMG_LENGTH		EQU	IMG_TILES_X*IMG_TILES_Y*$20

; -------------------------------------------------------------------------
