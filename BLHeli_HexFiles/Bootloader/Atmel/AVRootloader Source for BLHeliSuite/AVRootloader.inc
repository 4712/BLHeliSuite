; copyright HR

.equ	RX_DDR			= RX_PORT -1
.equ	RX_PIN			= RX_PORT -2
.equ	TX_DDR			= TX_PORT -1
.equ	TX_PIN			= TX_PORT -2

.if UseRS485
.equ	DE_DDR			= DE_PORT -1
.endif

.if RX_PORT == TX_PORT && RX == TX
.set	Use1Wire		= 1
.else
.set	Use1Wire		= 0
.endif ; .if RX_PORT == TX_PORT && RX == TX

.equ	UartLoop		= 29 			; don't change, except timing of putc, getc are changed
.equ	BaudTolerance	= 3

.if !UseAutobaud
.set	Baudrate		= XTAL / BootBaudrate - UartLoop
.endif ; .if !UseAutobaud

.set	SUCCESS			= 0x30
.set	ERRORVERIFY		= 0xC0
.set	ERRORCOMMAND	= 0xC1
.set	ERRORCRC		= 0xC2
.set	ERRORBOUNDS		= 0xC3
.set	ERRORCRYPT		= 0xC4
.set	ERRORPROG		= 0xC5
.set	ERRORVERSION	= 0xC6

.if UseCrypt
.set	SUCCESS			= SUCCESS | 0x01
.if UseCryptFLASH
.set	SUCCESS			= SUCCESS | 0x02
.endif ; .if UseCryptFLASH
.if UseCryptE2
.set	SUCCESS			= SUCCESS | 0x04
.endif ; .if UseCryptE2
.endif ; .if UseCrypt
.if UseVersioning
.set	SUCCESS			= SUCCESS | 0x08
.endif ; .if UseVersioning

.equ	POLYNOM			= 0xA001		; CRC Polynom

.def	feedl			= r4			; feedback pointer
.def	feedh			= r5
.def	zx				= r7			; RAMPZ			
.def	crcl			= r8			; CRC 16Bit
.def	crch			= r9
.def	zerol			= r10			; zero
.def	zeroh			= r11
.def	baudl			= r12			; baudrate
.def	baudh			= r13
.def	sraml			= r14			; SRAM buffer start 
.def	sramh			= r15
.def	paral			= r16			; params for UART
.def	parah			= r17
.def	polyl			= r18			; Polynom CRC
.def	polyh			= r19
.def	cnt				= r20			; counter in UART loops
.def	flag			= r21			; flag for crypto
.def	cmdl			= r22			; commands
.def	cmdh			= r23
.def	cntl			= r24			; temp/baudrate
.def	cnth			= r25

.if FlashEnd > 0x7FFF
.set	BigMega			= 1				; ATMega with big FLASH
.else
.set	BigMega			= 0
.endif ; .if FlashEnd > 0x7FFF

.ifdef FirstBootStart
.set	BLS				= 1				; Bootloader Section supported
.else
.set	BLS				= 0
.endif ; .ifdef FirstBootStart

; calculate Bootloader start address
.ifdef FirstBootStart
.set	FirstBoot		= FirstBootStart
.else
.set	FirstBoot		= FlashEnd +1
.endif ; .ifdef FirstBootStart

.ifdef SecondBootStart
.set	SecondBoot		= SecondBootStart
.else
.set	SecondBoot		= FlashEnd +1
.endif ; .ifdef SecondBootStart

.ifdef ThirdBootStart
.set	ThirdBoot		= ThirdBootStart
.else
.set	ThirdBoot		= FlashEnd +1
.endif ; .ifdef ThirdBootStart

.ifdef FourthBootStart
.set	FourthBoot		= FourthBootStart
.else
.set	FourthBoot		= FlashEnd +1
.endif ; .ifdef FourthBootStart

.if BootCodeSize
.if BLS
.set 	FlashSize		= FlashEnd +1
.if FlashSize - FirstBoot >= BootCodeSize >> 1
.equ 	BootStart		= FirstBoot
.message "Please program Boot Fuse to First Boot Start !"
.elif FlashSize - SecondBoot >= BootCodeSize >> 1
.equ 	BootStart		= SecondBoot
.message "Please program Boot Fuse to Second Boot Start !"
.elif FlashSize - ThirdBoot >= BootCodeSize >> 1
.equ 	BootStart		= ThirdBoot
.message "Please program Boot Fuse to Third Boot Start !"
.elif FlashSize - FourthBoot >= BootCodeSize >> 1
.equ 	BootStart		= FourthBoot
.message "Please program Boot Fuse to Fourth Boot Start !"
.else
.equ 	BootStart		= 0
.error "BootStart is undefinied !"
.endif ; .if FlashSize ...
.else
.set 	FlashSize		= ((FlashEnd +1) * 2 - BootCodeSize) >> 1
.equ 	BootStart		= FlashSize - FlashSize % PageSize
.message "Compile Bootloader without Boot Section !"
.endif ; .if BLS
.else
.if (FLASHEND > 1023)
.equ 	BootStart		= ((FlashEnd +1) * 2 - 2048) / 2
.else
.equ 	BootStart		= 0
.endif
.message "Please set used CSEG to BootSize !"
.endif ; .if BootCodeSize

; fix bug with parsing HEX files in AVRStudio 4.16
.if BootCodeSize
.org 0
.db		0xFF, 0xFF
.endif

.set	BootPages		= (FlashEnd +1 - BootStart) / PageSize

.if UseVersioning  
.if BLS
.set	AppVerAddr		= BootStart * 2 - 4		
.else
.set	AppVerAddr		= BootStart * 2 - 6
.endif ; .if BLS
.endif ; .if UseVersioning  

; examine special handling for SPM
.if BLS && (SIGNATURE_000 == 0x1e)
.if (SIGNATURE_001 == 0x94) && (SIGNATURE_002 == 0x01)  ; ATmega161
.set	SPMspecial		= 1
.endif
.if (SIGNATURE_001 == 0x94) && (SIGNATURE_002 == 0x02)  ; ATmega163
.set	SPMspecial		= 2
.endif
.if (SIGNATURE_001 == 0x95) && (SIGNATURE_002 == 0x01)  ; ATmega323
.set	SPMspecial		= 3
.endif
.endif

; BootMode flags
.if UseBootMode == 1
.set	BootModeFlag	= PORF
.elif UseBootMode == 2
.set	BootModeFlag	= EXTRF
.elif UseBootMode == 3
.set	BootModeFlag	= WDRF
.elif UseBootMode == 4
.ifndef USBRF
.error "Device provable do not support USB reset, take a look into datasheet and include file if USBRF is defined"
.else
.set	BootModeFlag	= USBRF
.endif
.endif 

.set ResetFlags = (1 << PORF) | (1 << EXTRF) | (1 << WDRF)
.ifdef BORF
.set ResetFlags = ResetFlags | (1 << BORF)
.endif
.ifdef JTRF
.set ResetFlags = ResetFlags | (1 << JTRF)
.endif
.ifdef BODRF
.set ResetFlags = ResetFlags | (1 << BODRF)
.endif
.ifdef OCDRF
.set ResetFlags = ResetFlags | (1 << OCDRF)
.endif
.ifdef USBRF
.set ResetFlags = ResetFlags | (1 << USBRF)
.endif


; some redefinition of register names or bits
.ifndef	MCUSR
.ifndef MCUCSR
.error "no definition for MCU Control Status Register found, look into AVRootloader.inc"
.else
.equ	MCUSR			= MCUCSR
.endif
.endif ; .ifndef	MCUCSR

.ifndef	WDCE
.ifndef WDDE
.equ	WDCE			= WDTOE	
.else
.equ	WDCE			= WDDE
.endif ; .ifndef WDDE
.endif ; .ifndef WDCE

.ifndef	WDTCR
.equ	WDTCR			= WDTCSR
.endif ; .ifndef WDTCR

.ifndef	SPMCSR
.equ	SPMCSR			= SPMCR
.endif ; .ifndef SPMCSR

.ifndef	RWWSRE
.ifdef	ASRE
.equ	RWWSRE			= ASRE
.endif ; .ifdef	ASRE
.endif ; .ifndef RWWSRE

.ifndef	SPMEN
.equ	SPMEN			= SELFPRGEN
.endif ; .ifndef SPMEN


.ifndef EEMWE
.equ	EEMWE			= EEMPE
.endif ; .ifndef EEMWE

.ifndef EEWE
.equ	EEWE			= EEPE
.endif ; .ifndef EEWE

.ifndef EEARL
.equ	EEARL			= EEAR	
.endif ; .ifndef EEARL

; macros
.macro	xout
.ifdef @0
.if	@0 > 0x3F
	sts	@0, @1
.else
	out	@0, @1
.endif
.endif
.endmacro

.macro	xin
.ifdef @1
.if	@1 > 0x3F
	lds	@0, @1
.else
	in	@0, @1
.endif
.endif
.endmacro

.macro	xwdr
.if UseWDR
		wdr
.endif ; .if UseWDR
.endmacro

.macro	xlpm
.if BigMega
        elpm    @0, @1
.else
        lpm     @0, @1
.endif
.endmacro

.macro	jmpapp
.if BLS
		rjmp	FLASHEND +1							; run application
.elif BootStart
		rjmp	BootStart -1						; run application
.else
		rjmp	BootStart							; dummy
.endif ; .if BLS
.endmacro

.macro	bjmp
.if @1		
		rjmp	@0
.else
		ret
.endif
.endmacro

.macro  rx_0
.if UseUartInvert
		sbic    RX_PIN, RX			
.else
		sbis    RX_PIN, RX			
.endif ; .if UseUartInvert
.endmacro

.macro  rx_1
.if UseUartInvert
		sbis    RX_PIN, RX			
.else
		sbic    RX_PIN, RX			
.endif ; .if UseUartInvert
.endmacro


.macro tx_1

.if (RX != TX) && (RX_PORT == TX_PORT)
.if UseUartInvert
.set	tx1 = (1 << RX)
.else
.set	tx1 = (1 << TX) | (1 << RX)
.endif ; .if UseUartInvert
.elif UseUartInvert && !Use1Wire
.set	tx1 = 0
.else
.set	tx1 = (1 << TX)
.endif ; .if (RX != TX) && (RX_PORT == TX_PORT)
.ifdef DE_PORT
.if !UseRS485Invert && (DE_PORT == TX_PORT)
.set	tx1 = tx1 | (1 << DE)
.endif 
.endif
		ldi		cnth, tx1
.endmacro

.macro tx_0
.if (RX != TX) && (RX_PORT == TX_PORT)
.if UseUartInvert
.set	tx0 = (1 << TX) | (1 << RX)
.else
.set	tx0 = (1 << RX)
.endif ; .if UseUartInvert
.elif UseUartInvert && !Use1Wire
.set	tx0 = (1 << TX)
.else
.set	tx0 = 0
.endif ; .if (RX != TX) && (RX_PORT == TX_PORT)
.ifdef DE_PORT
.if !UseRS485Invert && (DE_PORT == TX_PORT)
.set	tx0 = tx0 | (1 << DE)
.endif 
.endif
		ldi		cnth, tx0
.endmacro


.macro tx_out
.if Use1Wire
		xout	TX_DDR, cnth						
.else
		xout	TX_PORT, cnth						
.endif ; .if Use1Wire
.endmacro

.macro	de_0
.if UseRS485
.if UseRS485Invert
		sbi		DE_PORT, DE
.else
		cbi		DE_PORT, DE
.endif
.endif
.endmacro

.macro  de_1
.if UseRS485
.if UseRS485Invert
		cbi		DE_PORT, DE
.else
		sbi		DE_PORT, DE
.endif
.endif
.endmacro

