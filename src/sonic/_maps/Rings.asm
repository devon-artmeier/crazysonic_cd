; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
Map_Ring_internal:
		dc.w @front-Map_Ring_internal
		dc.w @angle1-Map_Ring_internal
		dc.w @edge-Map_Ring_internal
		dc.w @angle2-Map_Ring_internal
		dc.w @sparkle1-Map_Ring_internal
		dc.w @sparkle2-Map_Ring_internal
		dc.w @sparkle3-Map_Ring_internal
		dc.w @sparkle4-Map_Ring_internal
		dc.w @blank-Map_Ring_internal
@front:		dc.w 1
		dc.w $F805, $0000, $FFF8	; ring front
@angle1:	dc.w 1
		dc.w $F805, $0004, $FFF8	; ring angle
@edge:		dc.w 1
		dc.w $F801, $0008, $FFFC	; ring perpendicular
@angle2:	dc.w 1
		dc.w $F805, $0804, $FFF8	; ring angle
@sparkle1:	dc.w 1
		dc.w $F805, $000A, $FFF8	; sparkle
@sparkle2:	dc.w 1
		dc.w $F805, $180A, $FFF8 ; sparkle
@sparkle3:	dc.w 1
		dc.w $F805, $080A, $FFF8	;sparkle
@sparkle4:	dc.w 1
		dc.w $F805, $100A, $FFF8 ; sparkle
@blank:		dc.w 0
		even