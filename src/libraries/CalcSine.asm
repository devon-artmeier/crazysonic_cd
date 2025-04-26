; ---------------------------------------------------------------------------
; Subroutine calculate a sine

; input:
;	d0 = angle

; output:
;	d0 = sine
;	d1 = cosine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


CalcSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	Sine_Data(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	Sine_Data(pc,d0.w),d0
		rts	
; End of function CalcSine

; ===========================================================================

Sine_Data:
		dc.w $0000, $0006, $000C, $0012, $0019, $001F
		dc.w $0025, $002B, $0031, $0038, $003E, $0044
		dc.w $004A, $0050, $0056, $005C, $0061, $0067
		dc.w $006D, $0073, $0078, $007E, $0083, $0088
		dc.w $008E, $0093, $0098, $009D, $00A2, $00A7
		dc.w $00AB, $00B0, $00B5, $00B9, $00BD, $00C1
		dc.w $00C5, $00C9, $00CD, $00D1, $00D4, $00D8
		dc.w $00DB, $00DE, $00E1, $00E4, $00E7, $00EA
		dc.w $00EC, $00EE, $00F1, $00F3, $00F4, $00F6
		dc.w $00F8, $00F9, $00FB, $00FC, $00FD, $00FE
		dc.w $00FE, $00FF, $00FF, $00FF, $0100, $00FF
		dc.w $00FF, $00FF, $00FE, $00FE, $00FD, $00FC
		dc.w $00FB, $00F9, $00F8, $00F6, $00F4, $00F3
		dc.w $00F1, $00EE, $00EC, $00EA, $00E7, $00E4
		dc.w $00E1, $00DE, $00DB, $00D8, $00D4, $00D1
		dc.w $00CD, $00C9, $00C5, $00C1, $00BD, $00B9
		dc.w $00B5, $00B0, $00AB, $00A7, $00A2, $009D
		dc.w $0098, $0093, $008E, $0088, $0083, $007E
		dc.w $0078, $0073, $006D, $0067, $0061, $005C
		dc.w $0056, $0050, $004A, $0044, $003E, $0038
		dc.w $0031, $002B, $0025, $001F, $0019, $0012
		dc.w $000C, $0006, $0000, $FFFA, $FFF4, $FFEE
		dc.w $FFE7, $FFE1, $FFDB, $FFD5, $FFCF, $FFC8
		dc.w $FFC2, $FFBC, $FFB6, $FFB0, $FFAA, $FFA4
		dc.w $FF9F, $FF99, $FF93, $FF8B, $FF88, $FF82
		dc.w $FF7D, $FF78, $FF72, $FF6D, $FF68, $FF63
		dc.w $FF5E, $FF59, $FF55, $FF50, $FF4B, $FF47
		dc.w $FF43, $FF3F, $FF3B, $FF37, $FF33, $FF2F
		dc.w $FF2C, $FF28, $FF25, $FF22, $FF1F, $FF1C
		dc.w $FF19, $FF16, $FF14, $FF12, $FF0F, $FF0D
		dc.w $FF0C, $FF0A, $FF08, $FF07, $FF05, $FF04
		dc.w $FF03, $FF02, $FF02, $FF01, $FF01, $FF01
		dc.w $FF00, $FF01, $FF01, $FF01, $FF02, $FF02
		dc.w $FF03, $FF04, $FF05, $FF07, $FF08, $FF0A
		dc.w $FF0C, $FF0D, $FF0F, $FF12, $FF14, $FF16
		dc.w $FF19, $FF1C, $FF1F, $FF22, $FF25, $FF28
		dc.w $FF2C, $FF2F, $FF33, $FF37, $FF3B, $FF3F
		dc.w $FF43, $FF47, $FF4B, $FF50, $FF55, $FF59
		dc.w $FF5E, $FF63, $FF68, $FF6D, $FF72, $FF78
		dc.w $FF7D, $FF82, $FF88, $FF8B, $FF93, $FF99
		dc.w $FF9F, $FFA4, $FFAA, $FFB0, $FFB6, $FFBC
		dc.w $FFC2, $FFC8, $FFCF, $FFD5, $FFDB, $FFE1
		dc.w $FFE7, $FFEE, $FFF4, $FFFA
Sine_Data_End:
		dc.w $0000, $0006, $000C, $0012, $0019, $001F
		dc.w $0025, $002B, $0031, $0038, $003E, $0044
		dc.w $004A, $0050, $0056, $005C, $0061, $0067
		dc.w $006D, $0073, $0078, $007E, $0083, $0088
		dc.w $008E, $0093, $0098, $009D, $00A2, $00A7
		dc.w $00AB, $00B0, $00B5, $00B9, $00BD, $00C1
		dc.w $00C5, $00C9, $00CD, $00D1, $00D4, $00D8
		dc.w $00DB, $00DE, $00E1, $00E4, $00E7, $00EA
		dc.w $00EC, $00EE, $00F1, $00F3, $00F4, $00F6
		dc.w $00F8, $00F9, $00FB, $00FC, $00FD, $00FE
		dc.w $00FE, $00FF, $00FF, $00FF, $0100, $00FF
		dc.w $00FF, $00FF, $00FE, $00FE, $00FD, $00FC
		dc.w $00FB, $00F9, $00F8, $00F6, $00F4, $00F3
		dc.w $00F1, $00EE, $00EC, $00EA, $00E7, $00E4
		dc.w $00E1, $00DE, $00DB, $00D8, $00D4, $00D1
		dc.w $00CD, $00C9, $00C5, $00C1, $00BD, $00B9
		dc.w $00B5, $00B0, $00AB, $00A7, $00A2, $009D
		dc.w $0098, $0093, $008E, $0088, $0083, $007E
		dc.w $0078, $0073, $006D, $0067, $0061, $005C
		dc.w $0056, $0050, $004A, $0044, $003E, $0038
		dc.w $0031, $002B, $0025, $001F, $0019, $0012
		dc.w $000C, $0006, $0000, $FFFA, $FFF4, $FFEE
		dc.w $FFE7, $FFE1, $FFDB, $FFD5, $FFCF, $FFC8
		dc.w $FFC2, $FFBC, $FFB6, $FFB0, $FFAA, $FFA4
		dc.w $FF9F, $FF99, $FF93, $FF8B, $FF88, $FF82
		dc.w $FF7D, $FF78, $FF72, $FF6D, $FF68, $FF63
		dc.w $FF5E, $FF59, $FF55, $FF50, $FF4B, $FF47
		dc.w $FF43, $FF3F, $FF3B, $FF37, $FF33, $FF2F
		dc.w $FF2C, $FF28, $FF25, $FF22, $FF1F, $FF1C
		dc.w $FF19, $FF16, $FF14, $FF12, $FF0F, $FF0D
		dc.w $FF0C, $FF0A, $FF08, $FF07, $FF05, $FF04
		dc.w $FF03, $FF02, $FF02, $FF01, $FF01, $FF01
		dc.w $FF00, $FF01, $FF01, $FF01, $FF02, $FF02
		dc.w $FF03, $FF04, $FF05, $FF07, $FF08, $FF0A
		dc.w $FF0C, $FF0D, $FF0F, $FF12, $FF14, $FF16
		dc.w $FF19, $FF1C, $FF1F, $FF22, $FF25, $FF28
		dc.w $FF2C, $FF2F, $FF33, $FF37, $FF3B, $FF3F
		dc.w $FF43, $FF47, $FF4B, $FF50, $FF55, $FF59
		dc.w $FF5E, $FF63, $FF68, $FF6D, $FF72, $FF78
		dc.w $FF7D, $FF82, $FF88, $FF8B, $FF93, $FF99
		dc.w $FF9F, $FFA4, $FFAA, $FFB0, $FFB6, $FFBC
		dc.w $FFC2, $FFC8, $FFCF, $FFD5, $FFDB, $FFE1
		dc.w $FFE7, $FFEE, $FFF4, $FFFA

; ===========================================================================
