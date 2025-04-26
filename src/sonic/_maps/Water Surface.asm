Map_Surf_internal:
	dc.w	.normal1-Map_Surf_internal
	dc.w	.normal2-Map_Surf_internal
	dc.w	.normal3-Map_Surf_internal
	dc.w	.paused1-Map_Surf_internal
	dc.w	.paused2-Map_Surf_internal
	dc.w	.paused3-Map_Surf_internal

.normal1:	dc.w 3
	dc.w $FD0D, 0, $FFA0
	dc.w $FD0D, 0, $FFE0
	dc.w $FD0D, 0, $20

.normal2:	dc.w 3
	dc.w $FD0D, 8, $FFA0
	dc.w $FD0D, 8, $FFE0
	dc.w $FD0D, 8, $20

.normal3:	dc.w 3
	dc.w $FD0D, $800, $FFA0
	dc.w $FD0D, $800, $FFE0
	dc.w $FD0D, $800, $20

.paused1:	dc.w 6
	dc.w $FD0D, 0, $FFA0
	dc.w $FD0D, 0, $FFC0
	dc.w $FD0D, 0, $FFE0
	dc.w $FD0D, 0, 0
	dc.w $FD0D, 0, $20
	dc.w $FD0D, 0, $40

.paused2:	dc.w 6
	dc.w $FD0D, 8, $FFA0
	dc.w $FD0D, 8, $FFC0
	dc.w $FD0D, 8, $FFE0
	dc.w $FD0D, 8, 0
	dc.w $FD0D, 8, $20
	dc.w $FD0D, 8, $40

.paused3:	dc.w 6
	dc.w $FD0D, $800, $FFA0
	dc.w $FD0D, $800, $FFC0
	dc.w $FD0D, $800, $FFE0
	dc.w $FD0D, $800, 0
	dc.w $FD0D, $800, $20
	dc.w $FD0D, $800, $40

	even
