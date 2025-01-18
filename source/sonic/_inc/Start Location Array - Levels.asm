; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------

		incbin	"source/sonic/startpos/ghz1.bin"
		incbin	"source/sonic/startpos/ghz2.bin"
		incbin	"source/sonic/startpos/ghz3.bin"
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/lz1.bin"
		incbin	"source/sonic/startpos/lz2.bin"
		incbin	"source/sonic/startpos/lz3.bin"
		incbin	"source/sonic/startpos/sbz3.bin"

		incbin	"source/sonic/startpos/mz1.bin"
		incbin	"source/sonic/startpos/mz2.bin"
		incbin	"source/sonic/startpos/mz3.bin"
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/slz1.bin"
		incbin	"source/sonic/startpos/slz2.bin"
		incbin	"source/sonic/startpos/slz3.bin"
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/syz1.bin"
		incbin	"source/sonic/startpos/syz2.bin"
		incbin	"source/sonic/startpos/syz3.bin"
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/sbz1.bin"
		incbin	"source/sonic/startpos/sbz2.bin"
		incbin	"source/sonic/startpos/fz.bin"
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/end1.bin"
		incbin	"source/sonic/startpos/end2.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8

		incbin	"source/sonic/startpos/secret.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8

		even
