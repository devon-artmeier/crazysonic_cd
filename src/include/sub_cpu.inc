; -------------------------------------------------------------------------
; Sub CPU definitions and macros
; -------------------------------------------------------------------------

	include	"src/include/common.inc"

; -------------------------------------------------------------------------
; Memory map
; -------------------------------------------------------------------------

; Program RAM
PRG_START		EQU	$000000				; Program RAM area start
PRG_SIZE		EQU	$80000				; Program RAM area size
PRG_END			EQU	PRG_START+PRG_SIZE		; Program RAM area end

; Word RAM
WORD_START_2M		EQU	$080000				; Word RAM area start (2M)
WORD_START_1M		EQU	$0C0000				; Word RAM area start (1M/1M)
WORD_SIZE_2M		EQU	$40000				; Word RAM area size (2M)
WORD_SIZE_1M		EQU	$20000				; Word RAM area size (1M/1M)
WORD_END_2M		EQU	WORD_START_2M+WORD_SIZE_2M	; Word RAM area end (2M)
WORD_END_1M		EQU	WORD_START_1M+WORD_SIZE_1M	; Word RAM area end (1M/1M)

; Word RAM image
IMAGE_START		EQU	$080000				; Word RAM image area start (1M/1M)
IMAGE_SIZE		EQU	$20000				; Word RAM image area size (1M/1M)
IMAGE_END		EQU	IMAGE_START+IMAGE_SIZE		; Word RAM image area end (1M/1M)

; PCM registers
PCM_REGS		EQU	$FF0000				; PCM chip base
PCM_ENV			EQU	PCM_REGS+($0000*2+1)		; Volume
PCM_PAN			EQU	PCM_REGS+($0001*2+1)		; Pan
PCM_FDL			EQU	PCM_REGS+($0002*2+1)		; Frequency (low)
PCM_FDH			EQU	PCM_REGS+($0003*2+1)		; Frequency (high)
PCM_LSL			EQU	PCM_REGS+($0004*2+1)		; Wave memory stop address (low)
PCM_LSH			EQU	PCM_REGS+($0005*2+1)		; Wave memory stop address (high)
PCM_ST			EQU	PCM_REGS+($0006*2+1)		; Wave memory start address
PCM_CTRL		EQU	PCM_REGS+($0007*2+1)		; Control
PCM_ENABLE		EQU	PCM_REGS+($0008*2+1)		; On/Off
PCM_ADDR		EQU	PCM_REGS+($0010*2+1)		; Wave address
PCM_ADDR_1L		EQU	PCM_ADDR			; PCM1 address (low)
PCM_ADDR_1H		EQU	PCM_ADDR+2			; PCM1 address (high)
PCM_ADDR_2L		EQU	PCM_ADDR+4			; PCM2 address (low)
PCM_ADDR_2H		EQU	PCM_ADDR+6			; PCM2 address (high)
PCM_ADDR_3L		EQU	PCM_ADDR+8			; PCM2 address (low)
PCM_ADDR_3H		EQU	PCM_ADDR+$A			; PCM2 address (high)
PCM_ADDR_4L		EQU	PCM_ADDR+$C			; PCM2 address (low)
PCM_ADDR_4H		EQU	PCM_ADDR+$E			; PCM2 address (high)
PCM_ADDR_5L		EQU	PCM_ADDR+$10			; PCM2 address (low)
PCM_ADDR_5H		EQU	PCM_ADDR+$12			; PCM2 address (high)
PCM_ADDR_6L		EQU	PCM_ADDR+$14			; PCM2 address (low)
PCM_ADDR_6H		EQU	PCM_ADDR+$16			; PCM2 address (high)
PCM_ADDR_7L		EQU	PCM_ADDR+$18			; PCM2 address (low)
PCM_ADDR_7H		EQU	PCM_ADDR+$1A			; PCM2 address (high)
PCM_ADDR_8L		EQU	PCM_ADDR+$1C			; PCM2 address (low)
PCM_ADDR_8H		EQU	PCM_ADDR+$1E			; PCM2 address (high)

; PCM wave RAM
WAVE_START		EQU	PCM_REGS+($1000*2+1)		; Wave RAM start
WAVE_SIZE		EQU	$1000				; Wave RAM size
WAVE_END		EQU	WAVE_START+(WAVE_SIZE*2)-1	; Wave RAM end

; Gate array registers
GATE_ARRAY		EQU	$FFFF8000			; Gate array registers start
LED_CTRL		EQU	GATE_ARRAY+0			; LED control
	BIT_LEDR:		EQU	0
	BIT_LEDG:		EQU	1
CD_RESET		EQU	GATE_ARRAY+1			; Reset
	BIT_RES0:		EQU	0
PROTECT			EQU	GATE_ARRAY+2			; Sub CPU memory protection
MEMORY_MODE		EQU	GATE_ARRAY+3			; Memory mode
	BIT_RET:		EQU	0
	BIT_DMNA:		EQU	1
	BIT_MODE:		EQU	2
	BIT_PM0:		EQU	3
	BIT_PM1:		EQU	4
CDC_MODE		EQU	GATE_ARRAY+4			; CDC mode
	BIT_UBR:		EQU	5
	BIT_DSR:		EQU	6
	BIT_EDT:		EQU	7
	DD_MAIN_READ:		EQU	2
	DD_SUB_READ:		EQU	3
	DD_PCM_DMA:		EQU	4
	DD_PRG_DMA:		EQU	5
	DD_WORD_DMA:		EQU	7
CDC_RS0			EQU	GATE_ARRAY+5			; CDC register address
CDC_RS1			EQU	GATE_ARRAY+7			; CDC register data
CDC_HOST		EQU	GATE_ARRAY+8			; CDC host data
CDC_DMA			EQU	GATE_ARRAY+$A			; CDC DMA address
STOP_WATCH		EQU	GATE_ARRAY+$C			; Stop watch
COMM_FLAGS		EQU	GATE_ARRAY+$E			; Communication flags
MAIN_FLAG		EQU	GATE_ARRAY+$E			; Main CPU communication flag
SUB_FLAG		EQU	GATE_ARRAY+$F			; Sub CPU communication flag
COMM_CMDS		EQU	GATE_ARRAY+$10			; Communication commands
COMM_CMD_0		EQU	GATE_ARRAY+$10			; Communication command 0
COMM_CMD_1		EQU	GATE_ARRAY+$12			; Communication command 1
COMM_CMD_2		EQU	GATE_ARRAY+$14			; Communication command 2
COMM_CMD_3		EQU	GATE_ARRAY+$16			; Communication command 3
COMM_CMD_4		EQU	GATE_ARRAY+$18			; Communication command 4
COMM_CMD_5		EQU	GATE_ARRAY+$1A			; Communication command 5
COMM_CMD_6		EQU	GATE_ARRAY+$1C			; Communication command 6
COMM_CMD_7		EQU	GATE_ARRAY+$1E			; Communication command 7
COMM_STATS		EQU	GATE_ARRAY+$20			; Communication statuses
COMM_STAT_0		EQU	GATE_ARRAY+$20			; Communication status 0
COMM_STAT_1		EQU	GATE_ARRAY+$22			; Communication status 1
COMM_STAT_2		EQU	GATE_ARRAY+$24			; Communication status 2
COMM_STAT_3		EQU	GATE_ARRAY+$26			; Communication status 3
COMM_STAT_4		EQU	GATE_ARRAY+$28			; Communication status 4
COMM_STAT_5		EQU	GATE_ARRAY+$2A			; Communication status 5
COMM_STAT_6		EQU	GATE_ARRAY+$2C			; Communication status 6
COMM_STAT_7		EQU	GATE_ARRAY+$2E			; Communication status 7
INT3_TIME		EQU	GATE_ARRAY+$31 			; Level 3 interrupt time
INT_MASK		EQU	GATE_ARRAY+$33 			; Interrupt mask
	BIT_IEN1:		EQU	1
	BIT_IEN2:		EQU	2
	BIT_IEN3:		EQU	3
	BIT_IEN4:		EQU	4
	BIT_IEN5:		EQU	5
	BIT_IEN6:		EQU	6
CDD_FADER		EQU	GATE_ARRAY+$34 			; Fader control
	BIT_EFDT:		EQU	7
	BIT_DEF0:		EQU	2
	BIT_DEF1:		EQU	3
CDD_TYPE		EQU	GATE_ARRAY+$36 			; CDD data type
CDD_CTRL		EQU	GATE_ARRAY+$37 			; CDD control
	BIT_DTS:		EQU	0
	BIT_DRS:		EQU	1
	BIT_HOCK:		EQU	2
CDD_COMM		EQU	GATE_ARRAY+$38 			; CDD communication
CDD_STATUS		EQU	GATE_ARRAY+$38 			; CDD receive statuses
CDD_COMMANDS		EQU	GATE_ARRAY+$42 			; CDD transfer commands
BPP_COLOR		EQU	GATE_ARRAY+$4C			; BPP conversion color
BPP_IN			EQU	GATE_ARRAY+$4E			; BPP conversion input data
BPP_OUT			EQU	GATE_ARRAY+$56			; BPP conversion output data
GFX_CTRL		EQU	GATE_ARRAY+$58			; Graphics operation control
	BIT_GRON:		EQU	7
	BIT_RPT:		EQU	0
	BIT_STS:		EQU	1
	BIT_SMS:		EQU	2
GFX_MAP			EQU	GATE_ARRAY+$5A			; Graphics operation stamp map address
GFX_STRIDE		EQU	GATE_ARRAY+$5C			; Graphics operation canvas stride (in tiles)
GFX_CANVAS		EQU	GATE_ARRAY+$5E			; Graphics operation canvas address
GFX_OFFSET		EQU	GATE_ARRAY+$60			; Graphics operation object draw offset
GFX_WIDTH		EQU	GATE_ARRAY+$62			; Graphics operation object draw width
GFX_HEIGHT		EQU	GATE_ARRAY+$64			; Graphics operation object draw height
GFX_TRACE		EQU	GATE_ARRAY+$66			; Graphics operation trace table address
SUBCODE_ADDR		EQU	GATE_ARRAY+$68			; Subcode address
SUBCODE_DATA		EQU	GATE_ARRAY+$100			; Subcode data

; -------------------------------------------------------------------------
; BIOS function codes
; -------------------------------------------------------------------------

MSCSTOP			EQU	$02				; Stop CD audio
MSCPAUSEON		EQU	$03				; Pause CD audio
MSCPAUSEOFF		EQU	$04				; Resume CD audio
MSCSCANFF		EQU	$05				; Fast forward
MSCSCANFR		EQU	$06				; Fast reverse
MSCSCANOFF		EQU	$07				; Return to normal speed
ROMPAUSEON		EQU	$08				; Pause reading into CDC
ROMPAUSEOFF		EQU	$09				; Resume reading into CDC
DRVOPEN			EQU	$0A				; Open CD drive
DRVINIT			EQU	$10				; Close CD drive and read TOC
MSCPLAY			EQU	$11				; Play CD audio starting at track
MSCPLAY1		EQU	$12				; Play CD audio track
MSCPLAYR		EQU	$13				; Loop CD audio track
MSCPLAYT		EQU	$14				; Play CD audio starting at time
MSCSEEK			EQU	$15				; Seek to track and play CD audio from there
MSCSEEKT		EQU	$16				; Seek to time and play CD audio from there
ROMREAD			EQU	$17				; Begin CD read
ROMSEEK			EQU	$18				; Seek to CD sector
MSCSEEK1		EQU	$19				; Seek to track and play CD audio track
ROMREADN		EQU	$20				; Begin reading number of CD sectors
ROMREADE		EQU	$21				; Begin reading between 2 CD sectors
CDBCHK			EQU	$80				; Query BIOS status
CDBSTAT			EQU	$81				; Get BIOS status table
CDBTOCWRITE		EQU	$82				; Write TOC data
CDBTOCREAD		EQU	$83				; Get track time from TOC
CDBPAUSE		EQU	$84				; Set pause to standby delay time
FDRSET			EQU	$85				; Set CD audio volume
FDRCHG			EQU	$86				; Fade towards CD audio volume
CDCSTART		EQU	$87				; Start reading into CDC
CDCSTOP			EQU	$89				; Stop reading into CDC
CDCSTAT			EQU	$8A				; Query CDC buffer
CDCREAD			EQU	$8B				; Begin sending CDC buffer into destination
CDCTRN			EQU	$8C				; Manually transfer data into destination
CDCACK			EQU	$8D				; Acknowledge CDC read
SCDINIT			EQU	$8E				; Initialize subcode read
SCDSTART		EQU	$8F				; Start reading subcode data
SCDSTOP			EQU	$90				; Stop reading subcode data
SCDSTAT			EQU	$91				; Get subcode error status
SCDREAD			EQU	$92				; Read R-W subcode channels
SCDPQ			EQU	$93				; Read P & Q subcode channels
SCDPQL			EQU	$94				; Read last P & Q subcode channels
LEDSET			EQU	$95				; Control front LEDs
CDCSETMODE		EQU	$96				; Set CD read mode

; -------------------------------------------------------------------------
; Backup RAM function codes
; -------------------------------------------------------------------------

BRMINIT			EQU	$00				; Initialize Backup RAM handling
BRMSTAT			EQU	$01				; Get Backup RAM status
BRMSERCH		EQU	$02				; Search Backup RAM
BRMREAD			EQU	$03				; Read from Backup RAM
BRMWRITE		EQU	$04				; Write to Backup RAM
BRMDEL			EQU	$05				; Delete data from Backup RAM
BRMFORMAT		EQU	$06				; Format Backup RAM
BRMDIR			EQU	$07				; Get directory in Backup RAM
BRMVERIFY		EQU	$08				; Verify Backup RAM data

; -------------------------------------------------------------------------
; BIOS addresses
; -------------------------------------------------------------------------

_ADRERR			EQU	$5F40				; Address error
_BOOTSTAT		EQU	$5EA0				; Boot status
_BURAM			EQU	$5F16				; Internal Backup RAM handler
_CDBIOS			EQU	$5F22				; BIOS function
_CDBOOT			EQU	$5F1C				; BOOT function
_CDSTAT			EQU	$5E80				; BIOS status
_CHKERR			EQU	$5F52				; CHK exception
_CODERR			EQU	$5F46				; Illegal instruction
_DIVERR			EQU	$5F4C				; Division by zero
_LEVEL1			EQU	$5F76				; Graphics operation interrupt
_LEVEL2			EQU	$5F7C				; User interrupt
_LEVEL3			EQU	$5F82				; Timer interrupt
_LEVEL4			EQU	$5F88				; CDD interrupt
_LEVEL5			EQU	$5F8E				; CDC interrupt
_LEVEL6			EQU	$5F94				; Subcode interrupt
_LEVEL7			EQU	$5F9A				; Undefined interrupt
_NOCOD0			EQU	$5F6A				; Line A emulator
_NOCOD1			EQU	$5F70				; Line F emulator
_SETJMPTBL		EQU	$5F0A				; Switch module
_SPVERR			EQU	$5F5E				; Privilege violation
_TRACE			EQU	$5F64				; TRACE exception
_TRAP00			EQU	$5FA0				; TRAP #00
_TRAP01			EQU	$5FA6				; TRAP #01
_TRAP02			EQU	$5FAC				; TRAP #02
_TRAP03			EQU	$5FB2				; TRAP #03
_TRAP04			EQU	$5FB8				; TRAP #04
_TRAP05			EQU	$5FBE				; TRAP #05
_TRAP06			EQU	$5FC4				; TRAP #06
_TRAP07			EQU	$5FCA				; TRAP #07
_TRAP08			EQU	$5FD0				; TRAP #08
_TRAP09			EQU	$5FD6				; TRAP #09
_TRAP10			EQU	$5FDC				; TRAP #10
_TRAP11			EQU	$5FE2				; TRAP #11
_TRAP12			EQU	$5FE8				; TRAP #12
_TRAP13			EQU	$5FEE				; TRAP #13
_TRAP14			EQU	$5FF4				; TRAP #14
_TRAP15			EQU	$5FFA				; TRAP #15
_TRPERR			EQU	$5F58				; TRAPV exception
_USERCALL0		EQU	$5F28				; Initialization routine
_USERCALL1		EQU	$5F2E				; Main routine
_USERCALL2		EQU	$5F34				; User interrupt routine
_USERCALL3		EQU	$5F3A				; Undefined routine
_WAITVSYNC		EQU	$5F10				; VSync
SP_START		EQU	$6000				; System program start

; -------------------------------------------------------------------------
; Give Word RAM access to the Sub CPU (2M)
; -------------------------------------------------------------------------

GIVE_WORD_ACCESS macro
.Give\@:
	bset	#BIT_RET,MEMORY_MODE
	beq.s	.Give\@
	endm

; -------------------------------------------------------------------------
; Check Word RAM access (2M)
; 0 = No access
; 1 = Access
; -------------------------------------------------------------------------

CHECK_WORD_ACCESS macro
	btst	#BIT_DMNA,MEMORY_MODE
	endm

; -------------------------------------------------------------------------
; Wait for Word RAM access (2M)
; -------------------------------------------------------------------------

WAIT_WORD_ACCESS macro
.Wait\@:
	CHECK_WORD_ACCESS
	beq.s	.Wait\@
	endm

; -------------------------------------------------------------------------
; Check Word RAM bank access (1M/1M)
; 0 = Bank 1
; 1 = Bank 0
; -------------------------------------------------------------------------

CHECK_WORD_BANK macro
	btst	#BIT_RET,MEMORY_MODE
	endm

; -------------------------------------------------------------------------
; Give Word RAM bank 0 access to the Main CPU (1M/1M)
; -------------------------------------------------------------------------

GIVE_WORD_BANK_0 macro
.Wait\@:
	bclr	#BIT_RET,MEMORY_MODE
	bne.s	.Wait\@
	endm

; -------------------------------------------------------------------------
; Give Word RAM bank 1 access to the Main CPU (1M/1M)
; -------------------------------------------------------------------------

GIVE_WORD_BANK_1 macro
.Wait\@:
	bset	#BIT_RET,MEMORY_MODE
	beq.s	.Wait\@
	endm

; -------------------------------------------------------------------------
; Swap Word RAM banks (1M/1M)
; -------------------------------------------------------------------------

SWAP_WORD_BANKS macro
	CHECK_WORD_BANK
	beq.s	.Bank1\@
	GIVE_WORD_BANK_0
	bra.s	.Done\@

.Bank1\@:
	GIVE_WORD_BANK_1

.Done\@:
	endm

; -------------------------------------------------------------------------
; Check if 2M mode
; 0 = 2M mode
; 1 = 1M/1M mode
; -------------------------------------------------------------------------

CHECK_2M_MODE macro
	btst	#BIT_MODE,MEMORY_MODE
	endm

; -------------------------------------------------------------------------
; Set to 2M mode
; -------------------------------------------------------------------------

SET_2M_MODE macro
.Set\@:
	bclr	#BIT_MODE,MEMORY_MODE
	bne.s	.Set\@
	endm

; -------------------------------------------------------------------------
; Set to 1M/1M mode
; -------------------------------------------------------------------------

SET_1M_MODE macro
.Set\@:
	bset	#BIT_MODE,MEMORY_MODE
	beq.s	.Set\@
	endm

; -------------------------------------------------------------------------
; Check if a graphics operation is running
; 0 - Not running
; 1 - Running
; -------------------------------------------------------------------------

CHECK_GFX macro
	btst	#BIT_GRON,GFX_CTRL
	endm

; -------------------------------------------------------------------------
; Wait for a graphics operation to finish
; -------------------------------------------------------------------------

WAIT_GFX macro
.Wait\@:
	CHECK_GFX
	bne.s	.Wait\@
	endm

; -------------------------------------------------------------------------
; Calls the BIOS function handler with a specified function number
; Assumes that all preparatory and cleanup work is done externally
; -------------------------------------------------------------------------
; PARAMETERS:
;	fcode - BIOS function code
; -------------------------------------------------------------------------

CDBIOS macro fcode
	if (\fcode)<$80
		moveq	#\fcode,d0
	else
		move.w	#\fcode,d0
	endif
	jsr	_CDBIOS.w
	endm

; -------------------------------------------------------------------------
; Calls the Backup RAM handler with a specified function number
; Assumes that all preparatory and cleanup work is done externally
; -------------------------------------------------------------------------
; PARAMETERS:
;	fcode - Backup RAM function code
; -------------------------------------------------------------------------

BURAM macro fcode
	if (\fcode)<$80
		moveq	#\fcode,d0
	else
		move.w	#\fcode,d0
	endif
	jsr	_BURAM.w
	endm

; -------------------------------------------------------------------------
; Closes the disk tray and reads the TOC from the CD
; Pauses for 2 seconds after reading the TOC. If bit 7 of the TOC track
; is set, the BIOS starts playing the first track automatically. Waits
; for a DRVOPEN request if there is no disk in the drive
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of initialization parameters:
;	       dc.b	$01	; Track # to read TOC from (normally $01)
;	       dc.b	$FF	; Last track # ($FF = read all tracks)
; -------------------------------------------------------------------------

BIOS_DRVINIT macro
	CDBIOS	DRVINIT
	endm

; -------------------------------------------------------------------------
; Opens the drive
; -------------------------------------------------------------------------

BIOS_DRVOPEN macro
	CDBIOS	DRVOPEN
	endm

; -------------------------------------------------------------------------
; Stops playing a track if it's currently playing
; -------------------------------------------------------------------------

BIOS_MSCSTOP macro
	CDBIOS	MSCSTOP
	endm

; -------------------------------------------------------------------------
; Starts playing at a specified track. Continues playing
; through subsequent tracks
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of 16-bit track number
; -------------------------------------------------------------------------

BIOS_MSCPLAY macro
	CDBIOS	MSCPLAY
	endm

; -------------------------------------------------------------------------
; Plays a track once and pauses
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 16-bit track number
; -------------------------------------------------------------------------

BIOS_MSCPLAY1 macro
	CDBIOS	MSCPLAY1
	endm

; -------------------------------------------------------------------------
; Plays the designated track repeatedly
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 16-bit track number
; -------------------------------------------------------------------------

BIOS_MSCPLAYR macro
	CDBIOS	MSCPLAYR
	endm

; -------------------------------------------------------------------------
; Starts playing from a specified time
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 32-bit BCD time code in the format mm:ss:ff:00
; -------------------------------------------------------------------------

BIOS_MSCPLAYT macro
	CDBIOS	MSCPLAYT
	endm

; -------------------------------------------------------------------------
; Seeks to the beginning of the selected track and pauses
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 16-bit track number
; -------------------------------------------------------------------------

BIOS_MSCSEEK macro
	CDBIOS	MSCSEEK
	endm

; -------------------------------------------------------------------------
; Seeks to the beginning of the selected track and pauses
; Once the BIOS detects a pause state, it plays the track once
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 16-bit track number
; -------------------------------------------------------------------------

BIOS_MSCSEEK1 macro
	CDBIOS	MSCSEEK1
	endm

; -------------------------------------------------------------------------
; Seeks to a specified time
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 32-bit BCD time code in the format mm:ss:ff:00
; -------------------------------------------------------------------------

BIOS_MSCSEEKT macro
	CDBIOS	MSCSEEKT
	endm

; -------------------------------------------------------------------------
; Pauses the drive when a track is playing. If the
; drive is left paused it will stop after a programmable delay
; (See CDBPAUSE)
; -------------------------------------------------------------------------

BIOS_MSCPAUSEON macro
	CDBIOS	MSCPAUSEON
	endm

; -------------------------------------------------------------------------
; Resumes playing a track after a pause. If the drive
; has timed out and stopped, the BIOS will seek to the pause time
; (with the attendant delay) and resume playing
; -------------------------------------------------------------------------

BIOS_MSCPAUSEOFF macro
	CDBIOS	MSCPAUSEOFF
	endm

; -------------------------------------------------------------------------
; Starts playing from the current position in fast forward
; -------------------------------------------------------------------------

BIOS_MSCSCANFF macro
	CDBIOS	MSCSCANFF
	endm

; -------------------------------------------------------------------------
; Same as MSCSCANFF, but backwards
; -------------------------------------------------------------------------

BIOS_MSCSCANFR macro
	CDBIOS	MSCSCANFR
	endm

; -------------------------------------------------------------------------
; Returns to normal play mode. If the drive was
; paused before the scan was initiated, it will be returned to pause
; -------------------------------------------------------------------------

BIOS_MSCSCANOFF macro
	CDBIOS	MSCSCANOFF
	endm

; -------------------------------------------------------------------------
; Begins reading data from the CD-ROM at the designated
; logical sector. Executes a CDCSTART to begin the read, but doesn't
; stop automatically
; Note - ROMREAD actually pre-seeks by 2 sectors, but doesn't start
; passing data to the CDC until the desired sector is reached
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 32-bit logical sector number
; -------------------------------------------------------------------------

BIOS_ROMREAD macro
	CDBIOS	ROMREAD
	endm

; -------------------------------------------------------------------------
; Same as ROMREAD, but stops after reading the requested
; number of sectors
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 32-bit sector number and 32-bit sector count
;	       dc.l	$00000001	; First sector to read
;	       dc.l	$00001234	; Number of sectors to read
; -------------------------------------------------------------------------

BIOS_ROMREADN macro
	CDBIOS	ROMREADN
	endm

; -------------------------------------------------------------------------
; Same as ROMREAD, but reads between two logical sectors
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of table of 32-bit logical sector numbers
;	       dc.l	$00000001	; First sector to read
;	       dc.l	$00000123	; Last sector to read
; -------------------------------------------------------------------------

BIOS_ROMREADE macro
	CDBIOS	ROMREADE
	endm

; -------------------------------------------------------------------------
; Seeks to the designated logical sector and pauses
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a 32-bit logical sector number
; -------------------------------------------------------------------------

BIOS_ROMSEEK macro
	CDBIOS	ROMSEEK
	endm

; -------------------------------------------------------------------------
; Stops reading data into the CDC and pauses
; -------------------------------------------------------------------------

BIOS_ROMPAUSEON macro
	CDBIOS	ROMPAUSEON
	endm

; -------------------------------------------------------------------------
; Resumes reading data into the CDC from the current logical sector
; -------------------------------------------------------------------------

BIOS_ROMPAUSEOFF macro
	CDBIOS	ROMPAUSEOFF
	endm

; -------------------------------------------------------------------------
; Querys the BIOS on the status of the last command
; Returns success if the command has been executed, not if it's complete
; This means that CDBCHK will return success on a seek command once the
; seek has started, NOT when the seek is actually finished
; -------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Executed/Busy
; -------------------------------------------------------------------------

BIOS_CDBCHK macro
	CDBIOS	CDBCHK
	endm

; -------------------------------------------------------------------------
; Get BIOS status table
; -------------------------------------------------------------------------
; RETURNS:
;	a0.l - Address of BIOS status table
; -------------------------------------------------------------------------

BIOS_CDBSTAT macro
	CDBIOS	CDBSTAT
	endm

; -------------------------------------------------------------------------
; Gets the time for the specified track from the TOC
; If the track isn't in the TOC, the BIOS will either return the time of
; the last track read or the beginning of the disk. Don't call this
; function while the BIOS is loading the TOC (see DRVINIT)
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - 16-bit track number
; RETURNS:
;	d0.l - BCD time of requested track in mm:ss:ff:## format where ##
;	       is the requested track number or 00 if there was an error
;	d1.b - Track type:
;	       $00 = CD-DA track
;	       $FF = CD-ROM track
; -------------------------------------------------------------------------

BIOS_CDBTOCREAD macro
	CDBIOS	CDBTOCREAD
	endm

; -------------------------------------------------------------------------
; Writes data to the TOC in memory. Don't write to
; the TOC while the BIOS is performing a DRVINIT
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of a table of TOC entries to write to the TOC. Format
;	       of the entries is mm:ss:ff:## where ## is the track number
; -------------------------------------------------------------------------

BIOS_CDBTOCWRITE macro
	CDBIOS	CDBTOCWRITE
	endm

; -------------------------------------------------------------------------
; Sets the delay time before the BIOS switches from
; pause to standby. Normal ranges for this delay time are $1194 - $FFFE
; A delay of $FFFF prevents the drive from stopping, but can damage the
; drive if used improperly
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - 16-bit delay time
; -------------------------------------------------------------------------

BIOS_CDBPAUSE macro
	CDBIOS	CDBPAUSE
	endm

; -------------------------------------------------------------------------
; Sets the audio volume. If bit 15 of the volume parameter
; is 1, sets the master volume level. There's a delay of up to 13ms
; before the volume begins to change and another 23ms for the new volume
; level to take effect. The master volume sets a maximum level which the
; volume level can't exceed
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - 16-bit volume	    ($0000 = min, $0400 = max)
;	       16-bit master volume ($8000 = min, $8400 = max)
; -------------------------------------------------------------------------

BIOS_FDRSET macro
	CDBIOS	FDRSET
	endm

; -------------------------------------------------------------------------
; Ramps the audio volume from its current level to a new
; level at the requested rate. As in FDRSET, there's a delay of up to
; 13ms before the change starts
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.l - 32-bit volume change
;	       high word: new 16-bit volume ($0000 = min, $0400 = max)
;	       low word:  16-bit rate in steps/vblank
;	                  $0001 = slow
;	                  $0200 = fast
;	                  $0400 = set immediately
; -------------------------------------------------------------------------

BIOS_FDRCHG macro
	CDBIOS	FDRCHG
	endm

; -------------------------------------------------------------------------
; Starts reading data from the current logical sector
; into the CDC. The BIOS pre-seeks by 2 to 4 sectors and data read
; actually begins before the requested sector. It's up to the caller
; to identify the correct starting sector (usually by checking the time
; codes in the headers as they're read from the CDC buffer)
; -------------------------------------------------------------------------

BIOS_CDCSTART macro
	CDBIOS	CDCSTART
	endm

; -------------------------------------------------------------------------
; Stops reading data into the CDC. If a sector is being
; read when CDCSTOP is called, it's lost
; -------------------------------------------------------------------------

BIOS_CDCSTOP macro
	CDBIOS	CDCSTOP
	endm

; -------------------------------------------------------------------------
; Queries the CDC buffer. If no sector is ready for read,
; the carry bit will be cleared. Up to 5 sectors can be buffered in
; the CDC buffer
; -------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Available/Not available
; -------------------------------------------------------------------------

BIOS_CDCSTAT macro
	CDBIOS	CDCSTAT
	endm

; -------------------------------------------------------------------------
; If a sector is ready in the CDC buffer, the BIOS
; prepares to send the sector to the current device destination. Make
; sure to set the device destination BEFORE calling CDCREAD. If a
; sector is ready, the carry bit will be cleared on return and it's
; necessary to respond with a call to CDCACK
; -------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Ready/Not ready
;	d0.l  - Sector header in BCD mm:ss:ff:md format where md is sector mode
;	        $00 = CD-DA
;	        $01 = CD-ROM mode 1
;	        $02 = CD-ROM mode 2
; -------------------------------------------------------------------------

BIOS_CDCREAD macro
	CDBIOS	CDCREAD
	endm

; -------------------------------------------------------------------------
; Uses the Sub-CPU to read one sector into RAM. The
; device destination must be set to SUB-CPU read before calling CDCTRN
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Address of sector destination buffer (at least 2336 bytes)
;	a1.l  - Address of header destination buffer (at least 4 bytes)
; RETURNS:
;	cc/cs - Success/Failure
;	a0.l  - Next sector destination address (a0 + 2336)
;	a1.l  - Next header destination address (a1 + 4)
; -------------------------------------------------------------------------

BIOS_CDCTRN macro
	CDBIOS	CDCTRN
	endm

; -------------------------------------------------------------------------
; Informs the CDC that the current sector has been read
; and the caller is ready for the next sector
; -------------------------------------------------------------------------

BIOS_CDCACK macro
	CDBIOS	CDCACK
	endm

; -------------------------------------------------------------------------
; Tells the BIOS which mode to read the CD in. Accepts
; bit flags that allow selection of the three basic CD modes as follows:
; Mode 0 (CD-DA)                              2
; Mode 1 (CD-ROM with full error correction)  0
; Mode 2 (CD-ROM with CRC only)               1
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - FEDCBA9876543210
;			   ||||
;			   |||+--> CD Mode 2
;			   ||+---> CD-DA mode
;			   |+----> Transfer error block with data
;			   +-----> Re-read last data
; -------------------------------------------------------------------------

BIOS_CDCSETMODE macro
	CDBIOS	CDCSETMODE
	endm

; -------------------------------------------------------------------------
; Initializes the BIOS for subcode reads
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of scratch buffer (at least $750 long)
; -------------------------------------------------------------------------

BIOS_SCDINIT macro
	CDBIOS	SCDINIT
	endm

; -------------------------------------------------------------------------
; Enables reading of subcode data by the CDC
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Subcode processing mode
;	       0: --------
;	       1: --RSTUVW
;	       2: PQ------
;	       3: PQRSTUVW
; -------------------------------------------------------------------------

BIOS_SCDSTART macro
	CDBIOS	SCDSTART
	endm

; -------------------------------------------------------------------------
; Disables reading of subcode data by the CDC
; -------------------------------------------------------------------------

BIOS_SCDSTOP macro
	CDBIOS	SCDSTOP
	endm

; -------------------------------------------------------------------------
; Checks subcode error status
; -------------------------------------------------------------------------
; RETURNS:
;	d0.l - errqcodecrc/errpackcirc/scdflag/restrcnt
;	d1.l - erroverrun/errpacketbufful/errqcodefufful/errpackfufful
; -------------------------------------------------------------------------

BIOS_SCDSTAT macro
	CDBIOS	SCDSTAT
	endm

; -------------------------------------------------------------------------
; Reads R through W subcode channels
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Address of subcode buffer (24 bytes minimum)
; RETURNS:
;	cc/cs - Success/Failure
;	a0.l  - Address of next subcode buffer (a0.l + 24)
; -------------------------------------------------------------------------

BIOS_SCDREAD macro
	CDBIOS	SCDREAD
	endm

; -------------------------------------------------------------------------
; Gets P & Q codes from subcode
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Address of Q code buffer (12 bytes minimum)
; RETURNS:
;	cc/cs - Success/Failure
;	a0.l  - Address of next Q code buffer (a0.l + 12)
; -------------------------------------------------------------------------

BIOS_SCDPQ macro
	CDBIOS	SCDPQ
	endm

; -------------------------------------------------------------------------
; Gets the last P & Q codes
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Address of Q code buffer (12 bytes minimum)
; RETURNS:
;	cc/cs - Success/Failure
;	a0.l  - Address of next Q code buffer (a0.l + 12)
; -------------------------------------------------------------------------

BIOS_SCDPQL macro
	CDBIOS	SCDPQL
	endm

; -------------------------------------------------------------------------
; Controls the Ready and Access LEDs on the front panel
; of the CD unit
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.w	Mode	Ready (green)	Access (red)	System Indication
;	-----------------------------------------------------------------
;			off		off		only at reset
;	LEDREADY (0)	on		blink		CD ready/no disk
;	LEDDISCIN (1)	on		off		CD ready/disk ok
;	LEDACCESS (2)	on		on		CD accessing
;	LEDSTANDBY (3)	blink		off		standby mode
;	LEDERROR (4)	blink		blink		reserved
;	LEDMODE5 (5)	blink		on		reserved
;	LEDMODE6 (6)	off		blink		reserved
;	LEDMODE7 (7)	off		on		reserved
;	LEDSYSTEM (?)					return control
; -------------------------------------------------------------------------

BIOS_LEDSET macro
	CDBIOS	LEDSET
	endm

; -------------------------------------------------------------------------
; Prepares to write into and read from Backup RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to scratch ram (size $640 bytes)
;	a1.l  - Pointer to the buffer for display strings (size: 12 bytes)
; RETURNS:
;	cc/cs - Formatted/Not formatted
;	d0.w  - Size of Backup RAM
;	        $2(000) ~ $100(000) bytes
;	d1.w  - 0: No RAM
;	        1: Not formatted
;	        2: Other Format
;	a1.l  - Pointer to display strings
; -------------------------------------------------------------------------

BIOS_BRMINIT macro
	BURAM BRMINIT
	endm

; -------------------------------------------------------------------------
; Returns how much Backup RAM has been used
; -------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Pointer to display string buffer (size: 12 bytes)
; RETURNS:
;	d0.w - Number of blocks of free area
;	d1.w - Number of files in directory
; -------------------------------------------------------------------------

BIOS_BRMSTAT macro
	BURAM BRMSTAT
	endm

; -------------------------------------------------------------------------
; Searches for the desired file in Backup RAM. The file
; names are 11 ASCII characters terminated with a 0
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to parameter (file name) table
;	        File name = 11 ASCII chars [0~9 A~Z_], 0 terminated
; RETURNS:
;	cc/cs - Found/Not found
;	d0.w  - Number of blocks
;	d1.b  - Mode
;	         0 Normal
;	        -1 : Data protected (with protect function)
;	a0.l  - Backup RAM start address for search
; -------------------------------------------------------------------------

BIOS_BRMSERCH macro
	BURAM BRMSERCH
	endm

; -------------------------------------------------------------------------
; Reads data from Backup RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to parameter (file name) table
;	a1.l  - Pointer to write buffer
; RETURNS:
;	cc/cs - Success/Failure
;	d0.w  - Number of blocks
;	d1.b  - Mode
;	         0: Normal
;	        -1: Data protected
; -------------------------------------------------------------------------

BIOS_BRMREAD macro
	BURAM BRMREAD
	endm

; -------------------------------------------------------------------------
; Writes data in Backup RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l         - Pointer to parameter (file name) table
;	flag.b       - $00: Normal
;	               $FF: Encoded (with protect function)
;	block_size.w - $00: 1 block = $40 bytes
;	               $FF: 1 block = $20 bytes
;	a1.l         - Pointer to save data
; RETURNS:
;	cc/cs        - Success/Failure
; -------------------------------------------------------------------------

BIOS_BRMWRITE macro
	BURAM BRMWRITE
	endm

; -------------------------------------------------------------------------
; Deletes data on Backup RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to parameter (file name) table
; RETURNS:
;	cc/cs - Deleted/Not found
; -------------------------------------------------------------------------

BIOS_BRMDEL macro
	BURAM BRMDEL
	endm

; -------------------------------------------------------------------------
; First initializes the directory and then formats the Backup RAM
; Call BIOS_BRMINIT before calling this function
; -------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Success/Failure
; -------------------------------------------------------------------------

BIOS_BRMFORMAT macro
	BURAM BRMFORMAT
	endm

; -------------------------------------------------------------------------
; Reads directory
; -------------------------------------------------------------------------
; PARAMETERS:
;	d1.l  - H: Number of files to skip when all files cannot be read in one try
;	        L: Size of directory buffer (# of files that can be read in the 
;	           directory buffer)
;	a0.l  - Pointer to parameter (file name) table
;	a1.l  - Pointer to directory buffer
; RETURNS:
;	cc/cs - Okay/Full
; -------------------------------------------------------------------------

BIOS_BRMDIR macro
	BURAM BRMDIR
	endm

; -------------------------------------------------------------------------
; Checks data written on Backup RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l         - Pointer to parameter (file name) table
;	flag.b       - $00: Normal
;	               $FF: Encoded (with protect function)
;	block_size.w - $00: 1 block = $40 bytes
;	               $FF: 1 block = $20 bytes
;	a1.l	     - Pointer to save data
; RETURNS:
;	cc/cs        - Success/Failure
;	d0.w         - Error number
;		       -1: Data does not match
;		        0: File Not found
; -------------------------------------------------------------------------

BIOS_BRMVERIFY macro
	BURAM BRMVERIFY
	endm

; -------------------------------------------------------------------------
