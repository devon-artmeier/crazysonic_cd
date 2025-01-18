; framework/sub/file.inc
; File loading definitions

FILE_INDEX		EQU	PRG_START+$8000			; File index location

; File index header
	rsreset
indexSig		rs.b	16				; Signature
indexTotalSize		rs.l	1				; Index + contents size (in sectors)
indexFileCount		rs.l	1				; File count
indexSize		rs.l	1				; Index size in sectors
indexRemain		rs.l	1				; Remaining sectors in index
indexHeaderSize		rs.b	0				; size of structure

; File entry
	rsreset
fileName		rs.b	16				; File name
fileLocSector		rs.l	1				; File location (in sectors)
fileSizeSector		rs.l	1				; File size (in sectors)
fileLocByte		rs.l	1				; File location (in bytes)
fileSizeByte		rs.l	1				; File size (in bytes)
fileEntrySize		rs.b	0				; Size of structure
