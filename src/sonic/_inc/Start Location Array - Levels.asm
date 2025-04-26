; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------

		incbin	"src/sonic/startpos/ghz1.bin"
		incbin	"src/sonic/startpos/ghz2.bin"
		incbin	"src/sonic/startpos/ghz3.bin"
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/lz1.bin"
		incbin	"src/sonic/startpos/lz2.bin"
		incbin	"src/sonic/startpos/lz3.bin"
		incbin	"src/sonic/startpos/sbz3.bin"

		incbin	"src/sonic/startpos/mz1.bin"
		incbin	"src/sonic/startpos/mz2.bin"
		incbin	"src/sonic/startpos/mz3.bin"
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/slz1.bin"
		incbin	"src/sonic/startpos/slz2.bin"
		incbin	"src/sonic/startpos/slz3.bin"
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/syz1.bin"
		incbin	"src/sonic/startpos/syz2.bin"
		incbin	"src/sonic/startpos/syz3.bin"
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/sbz1.bin"
		incbin	"src/sonic/startpos/sbz2.bin"
		incbin	"src/sonic/startpos/fz.bin"
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/end1.bin"
		incbin	"src/sonic/startpos/end2.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8

		incbin	"src/sonic/startpos/secret.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8

		even
