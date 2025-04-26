; -------------------------------------------------------------------------
; Sign object
; -------------------------------------------------------------------------

ObjSign:
	move.l	#ObjSign_Main,oAddr(a0)
	move.w	#$4000|(VRAM_SIGN/$20),oTile(a0)
	move.l	#Map_Sign,oMap(a0)
	move.w	playerObject+oZ,oZ(a0)
	
; -------------------------------------------------------------------------

ObjSign_Main:
	bsr.w	CheckRunOver
	cmpi.l	#ObjRunOver,oAddr(a0)
	bne.s	.NoRunOver
	
	moveq	#5,d0
	jsr	PlayPCM
	
.NoRunOver
	lea	ObjSign_Frames(pc),a1
	bra.w	DrawObject3D

; -------------------------------------------------------------------------

ObjSign_Frames:
	dc.b	0, 0, 0, 0
	dc.b	1, 1
	dc.b	2, 2, 2
	dc.b	3, 3, 3, 3
	dc.b	4, 4, 4, 4
	dc.b	5, 5, 5, 5
	dc.b	6, 6, 6, 6
	dc.b	7, 7, 7, 7
	dc.b	8, 8, 8, 8
	dc.b	9, 9, 9, 9
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A, $A, $A, $A
	dc.b	$A, $A, $A, $A, $A
	even

; -------------------------------------------------------------------------
; Data
; -------------------------------------------------------------------------

Map_Sign:
	include	"src/special/objects/sign_mappings.asm"
	even
	
; -------------------------------------------------------------------------
