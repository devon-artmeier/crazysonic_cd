; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
Ani_Sonic:
		dc.w SonAni_Walk-Ani_Sonic
		dc.w SonAni_Run-Ani_Sonic
		dc.w SonAni_Roll-Ani_Sonic
		dc.w SonAni_Roll2-Ani_Sonic
		dc.w SonAni_Push-Ani_Sonic
		dc.w SonAni_Wait-Ani_Sonic
		dc.w SonAni_Balance-Ani_Sonic
		dc.w SonAni_LookUp-Ani_Sonic
		dc.w SonAni_Duck-Ani_Sonic
		dc.w SonAni_Warp1-Ani_Sonic
		dc.w SonAni_Warp2-Ani_Sonic
		dc.w SonAni_Warp3-Ani_Sonic
		dc.w SonAni_Warp4-Ani_Sonic
		dc.w SonAni_Stop-Ani_Sonic
		dc.w SonAni_Float1-Ani_Sonic
		dc.w SonAni_Float2-Ani_Sonic
		dc.w SonAni_Spring-Ani_Sonic
		dc.w SonAni_Hang-Ani_Sonic
		dc.w SonAni_Leap1-Ani_Sonic
		dc.w SonAni_Leap2-Ani_Sonic
		dc.w SonAni_Surf-Ani_Sonic
		dc.w SonAni_GetAir-Ani_Sonic
		dc.w SonAni_Burnt-Ani_Sonic
		dc.w SonAni_Drown-Ani_Sonic
		dc.w SonAni_Death-Ani_Sonic
		dc.w SonAni_Shrink-Ani_Sonic
		dc.w SonAni_Hurt-Ani_Sonic
		dc.w SonAni_WaterSlide-Ani_Sonic
		dc.w SonAni_Null-Ani_Sonic
		dc.w SonAni_Float3-Ani_Sonic
		dc.w SonAni_Float4-Ani_Sonic
		dc.w SonAni_Submarine-Ani_Sonic
		dc.w SonAni_Flat-Ani_Sonic

SonAni_Walk:
SonAni_Run:	dc.b $FF, 1, 2, afEnd, afEnd, afEnd
		even
SonAni_Roll:
SonAni_Spring:
SonAni_Roll2:	dc.b $FE, 1, 9, $A, $B, afEnd
		even
SonAni_Flat:
		dc.b $FE, $E, afEnd, afEnd afEnd, afEnd
		even
SonAni_Push:
SonAni_Wait:
SonAni_Balance:
SonAni_LookUp:
SonAni_Duck:
SonAni_Warp1:
SonAni_Warp2:
SonAni_Warp3:
SonAni_Warp4:
SonAni_Stop:
SonAni_Float1:
SonAni_Float2:
SonAni_Hang:
SonAni_Leap1:
SonAni_Leap2:
SonAni_Surf:
SonAni_GetAir:
SonAni_Burnt:
SonAni_Drown:
SonAni_Death:
SonAni_Shrink:
SonAni_Hurt:
SonAni_WaterSlide:
SonAni_Float3:
SonAni_Float4:	dc.b 1, 1, afEnd
SonAni_Null:	dc.b $77, 0, afEnd
		even
SonAni_Submarine:
		dc.b 1, $D, afEnd
		even
