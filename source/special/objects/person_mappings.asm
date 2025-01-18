; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_TWeKd:	
		dc.w SME_TWeKd_16-SME_TWeKd, SME_TWeKd_21-SME_TWeKd	
		dc.w SME_TWeKd_2C-SME_TWeKd, SME_TWeKd_32-SME_TWeKd	
		dc.w SME_TWeKd_38-SME_TWeKd, SME_TWeKd_3E-SME_TWeKd	
		dc.w SME_TWeKd_44-SME_TWeKd, SME_TWeKd_4A-SME_TWeKd	
		dc.w SME_TWeKd_50-SME_TWeKd, SME_TWeKd_56-SME_TWeKd	
		dc.w SME_TWeKd_5C-SME_TWeKd	
SME_TWeKd_16:	dc.b 2	
		dc.b $E0, 7, 0, 0, $F8	
		dc.b 0, 4, 0, 8, $F8	
SME_TWeKd_21:	dc.b 2	
		dc.b $E0, 7, 0, $A, $F8	
		dc.b 0, 4, 0, $12, $F8	
SME_TWeKd_2C:	dc.b 1	
		dc.b $E8, 7, 0, $14, $F8	
SME_TWeKd_32:	dc.b 1	
		dc.b $E8, 7, 0, $1C, $F8	
SME_TWeKd_38:	dc.b 1	
		dc.b $F0, 2, 0, $24, $FC	
SME_TWeKd_3E:	dc.b 1	
		dc.b $F0, 2, 0, $27, $FC	
SME_TWeKd_44:	dc.b 1	
		dc.b $F8, 1, 0, $2A, $FC	
SME_TWeKd_4A:	dc.b 1	
		dc.b $F8, 1, 0, $2C, $FC	
SME_TWeKd_50:	dc.b 1	
		dc.b 0, 0, 0, $2E, $FC	
SME_TWeKd_56:	dc.b 1	
		dc.b 0, 0, 0, $2F, $FC	
SME_TWeKd_5C:	dc.b 0	
		even