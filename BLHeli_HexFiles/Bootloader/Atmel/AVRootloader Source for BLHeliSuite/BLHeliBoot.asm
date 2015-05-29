; copyright HR
; changes for BLHeli bootloader by 4712
.nolist

.equ Revision = 4

.if Revision==1
.equ BLHeli_WaitStartOnRXHigh 	= 0
.equ	UseAutobaud				= 1			; Baudrate detection
.equ	UseVerify				= 0			; Verify FLASH command (FLASH write/erase have implicit verify, can be deactivated)
.equ	UseFlashRead			= 0			; FLASH read command
.equ	UseResetDelay			= 1       ; Reset the boot delay everytime if any activity is detected on RX pin.
.set	BootCodeSize			= 504		; set to 0, compile and set to value in [.cseg] Used, compile again
.endif
.if Revision==2
.equ BLHeli_WaitStartOnRXHigh 	= 1
.equ	UseAutobaud				= 1			; Baudrate detection
.equ	UseVerify				= 0			; Verify FLASH command (FLASH write/erase have implicit verify, can be deactivated)
.equ	UseFlashRead			= 0			; FLASH read command
.equ	UseResetDelay			= 1       ; Reset the boot delay everytime if any activity is detected on RX pin.
.set	BootCodeSize			= 508		; set to 0, compile and set to value in [.cseg] Used, compile again
.endif
.if Revision==3
.equ BLHeli_WaitStartOnRXHigh 	= 1
.equ	UseAutobaud				= 0			; Baudrate detection
.equ	UseVerify				= 1			; Verify FLASH command (FLASH write/erase have implicit verify, can be deactivated)
.equ	UseFlashRead			= 0			; FLASH read command
.equ	UseResetDelay			= 1       ; Reset the boot delay everytime if any activity is detected on RX pin.
.set	BootCodeSize			= 494		; set to 0, compile and set to value in [.cseg] Used, compile again
.endif

.if Revision==4
.equ BLHeli_WaitStartOnRXHigh 	= 1
.equ	UseAutobaud				= 0			; Baudrate detection
.equ	UseVerify				= 1			; Verify FLASH command (FLASH write/erase have implicit verify, can be deactivated)
.equ	UseFlashRead			= 1			; FLASH read command
.equ	UseResetDelay			= 0       ; Reset the boot delay everytime if any activity is detected on RX pin.
.set	BootCodeSize			= 510		; set to 0, compile and set to value in [.cseg] Used, compile again
.endif

;#define BLHeli_m8
;#define _16
;#define _PD2


#ifdef BLHeli_m8
.include "m8Adef.inc"					; ATmega8A
#endif
#ifdef BLHeli_m168
.include "m168def.inc"	
#endif
#ifdef BLHeli_m168PA
.include "m168PAdef.inc"	
#endif
#ifdef _8
.set	XTAL				= 8000000	;
#endif
#ifdef _16
.set	XTAL				= 16000000	;
#endif
#ifdef _PB0
.equ	RX_PORT		  = PORTB		; Receive port and pin
.equ	RX					= PB0  
#endif
#ifdef _PB4
.equ	RX_PORT		  = PORTB		; Receive port and pin
.equ	RX					= PB4  
#endif
#ifdef _PD2
.equ	RX_PORT		  = PORTD		; Receive port and pin
.equ	RX					= PD2  
#endif
#ifdef _PD5
.equ	RX_PORT		  = PORTD		; Receive port and pin
.equ	RX					= PD5  
#endif


; supported devices
;.include "can128def.inc"				; AT90CAN128
;.include "can32def.inc"				; AT90CAN32
;.include "can64def.inc"				; AT90CAN64
;.include "m1280def.inc"				; ATmega1280
;.include "m1281def.inc"				; ATmega1281
;.include "m1284Pdef.inc"				; ATmega1284P
;.include "m128Adef.inc"				; ATmega128A
;.include "m128def.inc"					; ATmega128
;.include "m161def.inc"					; ATmega161  
;.include "m162def.inc"					; ATmega162
;.include "m163def.inc"					; ATmega163  
;.include "m164PAdef.inc"				; ATmega164PA
;.include "m164Pdef.inc"				; ATmega164P 
;.include "m165def.inc"					; ATmega165  
;.include "m165Pdef.inc"				; ATmega165P 
;.include "m168def.inc"					; ATmega168  
;.include "m168PAdef.inc"				; ATmega168PA
;.include "m168Pdef.inc"				; ATmega168P 
;.include "m169def.inc"					; ATmega169
;.include "m169Pdef.inc"				; ATmega169P 
;.include "m16Adef.inc"					; ATmega16A  
;.include "m16def.inc"					; ATmega16   
;.include "m16HVAdef.inc"				; ATmega16HVA
;.include "m16M1def.inc"				; ATmega16M1 
;.include "m16U2def.inc"				; ATmega16U2 
;.include "m16U4def.inc"				; ATmega16U4 
;.include "m2560def.inc"				; ATmega2560 
;.include "m2561def.inc"				; ATmega2561 
;.include "m323def.inc"					; ATmega323  
;.include "m324PAdef.inc"				; ATmega324PA
;.include "m324Pdef.inc"				; ATmega324P 
;.include "m3250def.inc"				; ATmega3250 
;.include "m3250Pdef.inc"				; ATmega3250P
;.include "m325def.inc"					; ATmega325  
;.include "m325Pdef.inc"				; ATmega325P 
;.include "m328Pdef.inc"				; ATmega328P 
;.include "m3290def.inc"				; ATmega3290 
;.include "m3290Pdef.inc"				; ATmega3290P
;.include "m329def.inc"					; ATmega329  
;.include "m329Pdef.inc"				; ATmega329P 
;.include "m32Adef.inc"					; ATmega32A  
;.include "m32C1def.inc"				; ATmega32C1 
;.include "m32def.inc"					; ATmega32   
;.include "m32HVBdef.inc"				; ATmega32HVB
;.include "m32M1def.inc"				; ATmega32M1 
;.include "m32U2def.inc"				; ATmega32U2 
;.include "m32U4def.inc"				; ATmega32U4 
;.include "m32U6def.inc"				; ATmega32U6
;.include "m406def.inc"					; ATmega406  
;.include "m48def.inc"					; ATmega48   
;.include "m48PAdef.inc"				; ATmega48PA 
;.include "m48Pdef.inc"					; ATmega48P  
;.include "m640def.inc"					; ATmega640  
;.include "m644def.inc"					; ATmega644  
;.include "m644Pdef.inc"				; ATmega644P 
;.include "m6450def.inc"				; ATmega6450 
;.include "m645def.inc"					; ATmega645  
;.include "m6490def.inc"				; ATmega6490 
;.include "m649def.inc"					; ATmega649  
;.include "m64Adef.inc"					; ATmega64A  
;.include "m64C1def.inc"				; ATmega64C1 
;.include "m64def.inc"					; ATmega64   
;.include "m64M1def.inc"				; ATmega64M1 
;.include "m8515def.inc"				; ATmega8515 
;.include "m8535def.inc"				; ATmega8535 
;.include "m88def.inc"					; ATmega88   
;.include "m88PAdef.inc"				; ATmega88PA 
;.include "m88Pdef.inc"					; ATmega88P 
;.include "m8Adef.inc"					; ATmega8A
;.include "m8def.inc"					; ATmega8    
;.include "m8HVAdef.inc"				; ATmega8HVA 
;.include "pwm216def.inc"				; AT90PWM216 
;.include "pwm2Bdef.inc"				; AT90PWM2B  
;.include "pwm2def.inc"					; AT90PWM2   
;.include "pwm316def.inc"				; AT90PWM316 
;.include "pwm324def.inc"				; AT90PWM324 
;.include "pwm3Bdef.inc"				; AT90PWM3B  
;.include "pwm3def.inc"					; AT90PWM3   
;.include "tn13Adef.inc"				; ATtiny13A   ATTENTION! small FLASH space, not all feature can be used
;.include "tn13def.inc"					; ATtiny13    ATTENTION! small FLASH space, not all feature can be used
;.include "tn167def.inc"				; ATtiny167  
;.include "tn2313def.inc"				; ATtiny2313
;.include "tn24Adef.inc"				; ATtiny24A  
;.include "tn24def.inc"					; ATtiny24   
;.include "tn25def.inc"					; ATtiny25   
;.include "tn261def.inc"				; ATtiny261  
;.include "tn43Udef.inc"				; ATtiny43U  
;.include "tn44Adef.inc"				; ATtiny44A  
;.include "tn44def.inc"					; ATtiny44   
;.include "tn45def.inc"					; ATtiny45   
;.include "tn461def.inc"				; ATtiny461  
;.include "tn48def.inc"					; ATtiny48   
; include "tn84def.inc"					; ATtiny84   
;.include "tn85def.inc"					; ATtiny85   
;.include "tn861def.inc"				; ATtiny861  
;.include "tn87def.inc"					; ATtiny87
;.include "tn88def.inc"					; ATtiny88
;.include "usb1286def.inc"				; AT90USB1286
;.include "usb1287def.inc"				; AT90USB1287
;.include "usb162def.inc"				; AT90USB162
;.include "usb646def.inc"				; AT90USB646
;.include "usb647def.inc"				; AT90USB647
;.include "usb82def.inc"				; AT90USB82

; unsupported devices, no self programming or sram to small
;.include "1200def.inc"					; AT90S1200
;.include "2313def.inc"					; AT90S2313
;.include "2323def.inc"					; AT90S2323
;.include "2343def.inc"					; AT90S2343
;.include "4414def.inc"					; AT90S4414
;.include "4433def.inc"					; AT90S4433
;.include "4434def.inc"					; AT90S4434
;.include "8515def.inc"					; AT90S8515
;.include "8535def.inc"					; AT90S8535
;.include "AT86RF401def.inc"			; AT86RF401
;.include "ATxmega128A1def.inc"			; ATxmega128A1
;.include "ATxmega128A3def.inc"			; ATxmega128A3
;.include "ATxmega256A3Bdef.inc"		; ATxmega256A3B
;.include "ATxmega256A3def.inc"			; ATxmega256A3
;.include "ATxmega16A4def.inc"			; ATxmega16A4
;.include "ATxmega32A4def.inc"			; ATxmega32A4
;.include "ATxmega64A1def.inc"			; ATxmega64A1
;.include "ATxmega64A3def.inc"			; ATxmega64A3
;.include "m103def.inc"					; ATmega103
;.include "tn10def.inc"					; ATtiny10
;.include "tn11def.inc"					; ATtiny11
;.include "tn12def.inc"					; ATtiny12
;.include "tn15def.inc"					; ATtiny15
;.include "tn22def.inc"					; ATtiny22
;.include "tn26def.inc"					; ATtiny26
;.include "tn28def.inc"					; ATtiny28


.ifndef PageSize
.error "Device don't support Bootloader !"
.else

#message "compile for" __PART_NAME__


; set follow equ to 0/1 to de/activate....
.equ	UseBootMode			= 0			; 0 = start bootloader always
										; 1 = start on power up reset or by call from application
										; 2 = start on external reset or by call from application
										; 3 = start on watchdog reset or by call from application
										; 4 = start on USB reset or by call from application (only USB Devices)
										; 5 = start only by call from application (not recommended)
										; with these bootmodes you can shorten startup time for application

.equ	UseWDR				= 0			; Watchdog support (2 sec timeout, remember to deactivate WDT in your application if not needed)
.equ	UseSaveMCUSR		= 1			; save MCUSR on stack (RAMEND) for access by application (on UseWDR=1 MCUSR must be cleared)

.equ	UseE2Write			= 1			; EEPROM write command (have implicit verify)
.equ	UseE2Read			= 1			; EEPROM read command

;4712
;.equ	UseFlashRead		= 1			; FLASH read command
;

.equ	UseCrypt			= 0			; cryptography (crypt.inc)
.equ	UseCryptFLASH   	= 0			; explicit use of cryptography for writing to FLASH
.equ	UseCryptE2			= 0			; explicit use of cryptography for writing to EEPROM

;4712 .equ	UseVerify			= 0			; Verify FLASH command (FLASH write/erase have implicit verify, can be deactivated)
.equ	UseVersioning		= 0			; Versioning for application software (stored 4/6 bytes before BootStart)
.equ	UseSRAM				= 0			; SRAM read/write commands (attention! can be a security risk)

.equ	UseSpecialBootVect	= 0			; use a rjmp BootStart at end of FLASH to start bootloader from application code
.equ	UseSpecialWrite 	= 0			; special function "write_flash" to reprogram FLASH
.equ	UseSpecialWriteBoot = 0			; "write_flash" can write to bootloader section with magic code, only usefull if SPM is allowed by lockbit fuses in BLS
.equ	UseSpecialRead		= 0			; special function "read_flash" to read from FLASH
.equ	UseSpecialMsg		= 0			; special function to return address and size of BootMsg
										; look into AVRootloader.h and M162 test project in folder \test\ for use of special funcs

;4712 .equ	UseAutobaud			= 0			; Baudrate detection
;4712 .equ	UseResetDelay		= 1			; Reset the boot delay everytime if any activity is detected on RX pin.
										; First after BootDelay milliseconds inactivity the application is called.
										; Otherwise the timeout BootDelay defines an overall timeout for connection.

.equ	UseUartInvert		= 1		    ; invert UART levels (for RS232 drivers such as MAX232)
.equ	UseRS485			= 0			; activate RS-485 Data Enable pin
.equ	UseRS485Invert		= 0			; inverted logic of RS-485 DE pin (HIHGH for receive, LOW for transmit)

;4712;.equ	RX_PORT				= PORTD		; Receive port and pin
;4712;.equ	RX					= PD0
;4712 always use 1-wire
.equ	TX_PORT				= RX_PORT	; Transmit port and pin
.equ	TX					= RX		; //must be same as TX for 1-wire!!!

.if UseRS485
.equ	DE_PORT				= PORTB		; DE enable pin of RS-485 
.equ	DE					= PB2		; must be only set if RS485 DE is used
.endif

;.set	XTAL				= 8000000	; 
.set	BootDelay			= XTAL/4	; about 250ms (don't set to fast to avoid connection problems)
.set	BootBaudrate		= 19200		; only used if no Baudrate detection activated, XTAL is than important
.set	BootVersion			= 6			; Version 6 (must be not changed)

;.set	BootCodeSize		= 508		; set to 0, compile and set to value in [.cseg] Used, compile again
								    	; after this step cseg used is +2 bytes greater, ignore it (AVRStudio 4.16 bugfix)
												
;.equ	RWWSRE				= 4			; activate for ATmega162 in ATmega161 compatibility mode

; now scroll down at end of source to configure BootSign and BootMsg 

.if UseCrypt && (UseSRAM || !UseCryptFLASH || !UseCryptE2|| UseFlashRead)
.message "WARNING: actual settings compromise security !"
.endif 


.include "AVRootloader.inc"
;.listmac
.list

.org BootStart
init:	cli
		xwdr
		clr		zerol

		ldi		cmdl, byte1(RamEnd)
		xout	SPL, cmdl
.ifdef SPH
		ldi		cmdl, byte2(RamEnd)
		xout	SPH, cmdl
.endif ; .if SPH

.if UseSaveMCUSR || UseBootMode
		xin		paral, MCUSR
.if UseSaveMCUSR
		push	paral				; save old MCUSR ontop of stack
.endif ; .if UseSaveMCUSR
.endif ; .if UseSaveMCUSR || UseBootMode

.if UseWDR
;		xin		cmdl, WDTCR
;		ori		cmdl, (1 << WDE) | (1 << WDCE)
		ldi		cmdl, (1 << WDE) | (1 << WDCE)
		ldi		cmdh, (1 << WDE) | (1 << WDP2) | (1 << WDP1) | (1 << WDP0)
		xout    MCUSR, zerol		; WDRF must be explicite cleared to take changes on WDT
		xout	WDTCR, cmdl			; activate Watchdog and set to 2 seconds timeout
		xout	WDTCR, cmdh	
.elif UseBootMode
		xout    MCUSR, zerol
.endif ; .if UseWDR

.if UseBootMode
		andi	paral, ResetFlags
		breq	bm1
.ifdef BootModeFlag
		sbrs	paral, BootModeFlag
.endif
		jmpapp
bm1:
.endif ; .if UseBootMode

; initialize ports
		cbi		RX_DDR, RX
.if UseUartInvert && Use1Wire
		cbi		RX_PORT, RX
.else
		sbi		RX_PORT, RX
.endif ; .if UseUartInvert && Use1Wire
.if !Use1Wire
.if UseUartInvert
		sbi		TX_PORT, TX
.else
		cbi		TX_PORT, TX
.endif ; .if UseUartInvert
		sbi		TX_DDR, TX
.endif ; .if !Use11Wire

.if UseRS485
		sbi		DE_DDR, DE
		de_0
.endif ; .if UseRS485

; initialize crc polynom and RAMPZ
		clr		zeroh
		ldi		polyl, byte1(POLYNOM)
		ldi		polyh, byte2(POLYNOM)
.if BigMega
		ldi		cmdl, byte3(BootSign *2)
		xout	RAMPZ, cmdl
.else
		xout	RAMPZ, zerol
.endif ; .if BigMega		


; baudrate and identifier scanning
.if UseResetDelay		
abd:	
.endif
		ldi		cmdl, byte3(BootDelay / 6)
		ldi		xh, byte2(BootDelay / 6)
		ldi		xl, byte1(BootDelay / 6)
.if !UseResetDelay
abd:	
.endif
		movw	crcl, zerol
		ldi		parah, (BootMsg - BootSign) * 2
		ldi		zl, byte1(BootSign * 2)
		ldi		zh,	byte2(BootSign * 2)

.if BLHeli_WaitStartOnRXHigh  ;4712
wait_low:
		sbic    RX_PIN, RX
		rjmp    wait_low
.endif ;.if BLHeli_WaitStartOnRXHigh

.if UseAutobaud
; baudrate detection
; autobaud based on P.Dannegger with some optimization
; detects 0x0A,0x0B,0x0D,0x0F,0x85,0x87,0xC3,0xE1
		movw	yl, zerol					; scan for 1x baudrate low to high followed with 4x baudrate low
ab1:	add		yl, yl
		adc		yh, yh
		movw	cntl, zerol
ab2:	sbiw	xl, 1					
		sbc		cmdl, zerol
		rx_0
		brne    ab2
		breq    id2				; exit
ab3:	sbiw    yl, 1
		adiw    cntl, 2					
		brcs    exit
		rx_1
		rjmp    ab3
		asr		yl
		sbiw    yl, BaudTolerance
		adiw    yl, BaudTolerance * 2
		movw	yl, cntl
		brcc    ab1
		sbiw	cntl, UartLoop 
		brcs	ab1
		movw    baudl, cntl
.else
; fixed baudrate
		ldi		yl, byte1(Baudrate)
		ldi		yh, byte2(Baudrate)
		movw	baudl, yl
.endif ; .if UseAutobaud

; identifier (BootSign) scanning with timeout and checksum

id1:	sbiw	xl, 1								; UART getc with timeouts
		sbc		cmdl, zerol
		rx_1
		brne	id1
id2:	breq	exit
id3:	sbiw	xl, 1
		sbc		cmdl, zerol
		rx_0
		brne	id3
		breq	exit
		rcall	getx
		xlpm	r0, z+
		cp		r0, paral
		brne	abd
		dec		parah
		brne	id1
		rcall	getw
		brne	abd
	
; send info about chip/bootloader (BootMsg + BootInfo)
info:	ldi		parah, (BootInfo - BootMsg) * 2 +4
in1:	xlpm	paral, z+
		rcall	putc
		dec		parah
		brne	in1

.if UseVersioning
;send application software version (AppVersion)
vers:	ldi		parah, 4
		ldi		zl, byte1(AppVerAddr)
		ldi		zh, byte2(AppVerAddr)
ve1:	xlpm	paral, z+
		rcall	putc
		dec		parah
		brne	ve1
.endif ; .if UseVersioning


; main commandloop
; 0=run/restart 
; 1=program flash, 2=erase flash, 3=verify flash, 4=e2read, 5=e2write, 6=read SRAM (4712) 7=read flash 
; 0xFF=set address, 0xFE=set buffer and decryption, 0xFD=keep alive
main:	ldi		paral, SUCCESS
mai1:	rcall	putc
		movw	crcl, zerol
		rcall	getw
		movw	cmdl, paral
		cpi		cmdh, 0xFE
		brlo	mai2
		rcall	getw
		movw	yl, paral
		sbrc	cmdh, 0
		movw	zl, paral
.if BigMega
		sbrc	cmdh, 0
		mov		zx, cmdl
.endif ; .if BigMega

mai2:	rcall	getw
mai3:	ldi		paral, ERRORCRC
		brne	mai1
		cpi		cmdh, 0xFE
		breq	setbuf
		brsh	main
		cpse	cmdh, zerol
		rjmp	mai4
; run application/restart bootloader
		cpse	cmdl, zerol
exit:	jmpapp
		rjmp	init

; set buffer
setbuf:	
.if UseCrypt										
		clr		flag
		cpi		cmdl, 0xFE
		brlo	set3
		bst		cmdl, 0	
		ldi		cnt, 8								; encrypted data follows, copy last feedback to sraml-16
		ldi		zl, byte1(SRAM_START)
		ldi		zh, byte2(SRAM_START)
		movw	xl, feedl
		adiw	xl, 8								; last feedback
		clr		r0
set1:	brtc	set2
		ld		r0, x+
set2:	st		z+, r0
		dec		cnt
		brne	set1
.endif ; .if UseCrypt

set3:	ldi		xl, byte1(SRAM_START + 16)
		ldi		xh, byte2(SRAM_START + 16)
		movw	sraml, xl
.if UseSRAM
		cpi		cmdl, 1
		brne	set4
		movw	xl, zl
.endif ; .if UseSRAM

set4:	rcall	getc
		st		x+, paral
		sbiw	yl, 1
		brne	set4
.if !UseCrypt
		inc		cmdh
		rjmp	mai2
.else
		rcall	getw
		brne	mai3
		ori		flag, 0x01
set5:
		cpi		cmdl, 0xFE
		brlo	proB								; rjmp main
		rjmp	decrypt
.endif ; .if !UseCrypt

mai4:	cpi		cmdh, 3
		brsh	mai5
; program/erase
		bst		cmdh, 0
prog:	ldi		paral, ERRORPROG
.if UseCrypt
		brtc	pro1
.if UseCryptFLASH
		cpi		flag, 3
.else
		cpi		flag, 1
.endif ; .if UseCryptFLASH
		brlo	pro8
.endif ; .if UseCrypt

pro1:	movw	yl, sraml
pro2:	cpi		zl, byte1(BootStart *2)
		ldi		parah, byte2(BootStart *2)
		cpc		zh, parah
.if BigMega
		xout	RAMPZ, zx
		ldi		parah, byte3(BootStart *2)
		cpc		zx, parah
.endif ; .if BigMega
		brsh	pro8

		ldi		cntl, (1 << PGERS) | (1 << SPMEN)	; erase page
.if BLS
		rcall	dospm
.else
		xout	SPMCSR, cntl
		spm
.endif ; .if BLS

		brtc	pro5

		ldi		cntl, (1 << SPMEN)
		ldi		cnt, pagesize
pro4:	ld		r0, y+
		ld		r1, y+
.if BLS
		rcall	dospm
.else
		xout	SPMCSR, cntl
		spm
.endif ; .if BLS

		adiw	zl, 2
		dec		cnt
		brne	pro4

		subi	zl, byte1(PageSize *2)
		sbci	zh, byte2(PageSize *2)
		subi	yl, byte1(PageSize *2)
		sbci	yh, byte2(PageSize *2)

		ldi		cntl, (1 << PGWRT) | (1 << SPMEN)	; program page
.if BLS
		rcall	dospm
.else
		xout	SPMCSR, cntl
		spm
.endif ; .if BLS

pro5:
.if BLS
.ifdef RWWSRE
		ldi		cntl, (1 << RWWSRE) | (1 << SPMEN)	; unlock section
		rcall	dospm
.endif ; .if RWWSRE
.endif ; .if BLS

.if PageSize * 2 > 256
.error "PageSize is greater as 256 bytes, check programing loops"
.endif

		ldi		cnt, byte1(pagesize * 2)
		ldi		paral, ERRORVERIFY
		ldi		parah, 0xFF
pro6:	xlpm	r0, z+
		brtc	pro7
		ld		parah, y+
pro7:	cpse	parah, r0
pro8:	rjmp	mai1
		dec		cnt
		brne	pro6 

.if BigMega		
		cp		zl, zerol
		cpc		zh, zeroh
		brne	pro9
		inc		zx
.endif ; .if BigMega 

pro9:	brtc	proA
		cp		yl, xl
		cpc		yh,	xh
		brlo	pro2
		brne	pro8
proA:	dec		cmdl
		brne	prog
proB:	rjmp	main

mai5:	
.if !UseVerify && (UseE2Write || UseE2Read || UseSRAM)
		breq	mai8
.elif UseVerify
		brne	mai6
veri:	ldi		paral, ERRORVERIFY
ver1:	movw	yl, sraml
ver2:	ld		r0, y+
.if BigMega
		xout	RAMPZ, zx
		xlpm	r1, z
		adiw	z, 1
		adc		zx, zerol
.else
		xlpm	r1, z+
.endif ; .if BigMega
		cpse	r0, r1
		rjmp	mai1
		cp		yl, xl
		cpc		yh, xh
		brne	ver2
		dec		cmdl
		brne	ver1
		rjmp	main
.endif ; .if UseVerify

mai6:
.if UseE2Read && UseE2Write
		cpi		cmdh, 6
		brsh	mai7
		bst		cmdh, 0
.if UseCrypt
		brtc	ee1
		ldi		paral, ERRORPROG
.if UseCryptE2
		cpi		flag, 3
.else
		cpi		flag, 1	
.endif ; .if UseCryptE2
		brlo	maiZ
.endif ; .if UseCrypt

ee1:	ldi		paral, ERRORVERIFY
		movw	yl, sraml
ee2:	xout	EEARL, zl
		xout	EEARH, zh
		adiw	zl, 1
		brts	ee3		
		sbi 	EECR, EERE
		in 		paral, EEDR
		rcall	putp
		rjmp	ee5
ee3:	ld		r0, y+
		xout	EEDR, r0
		sbi 	EECR, EEMWE
		sbi 	EECR, EEWE
ee4:	xwdr
		sbic 	EECR, EEWE
		rjmp 	ee4
		sbi 	EECR, EERE
		in 		r1, EEDR
		cpse	r1, r0
		rjmp	maiZ
		cp		yl, xl
		cpc		yh, xh
		brne	ee2
ee5:	dec		cmdl
		brne	ee1
		brts	ee6
		rcall	putw	
ee6:	rjmp	main
.elif UseE2Read
		cpi		cmdh, 5
		breq	maiY
		brsh	mai7	
ee1:	xout	EEARL, zl
		xout	EEARH, zh
		adiw	zl, 1
		sbi 	EECR, EERE
		in 		paral, EEDR
		rcall	putp
		dec		cmdl
		brne	ee1
		rcall	putw	
		rjmp	main
.elif UseE2Write
		cpi		cmdh, 5
		brlo	maiY
		brne	mai7
.if UseCrypt
		ldi		paral, ERRORPROG
.if UseCryptE2
		cpi		flag, 3
.else
		cpi		flag, 1
.endif ; .if UseCryptE2
		brlo	maiZ
.endif ; .if UseCrypt

ee1:	ldi		paral, ERRORVERIFY
		movw	yl, sraml
ee2:	xout	EEARL, zl
		xout	EEARH, zh
		adiw	zl, 1
		ld		r0, y+
		xout	EEDR, r0
		sbi 	EECR, EEMWE
		sbi 	EECR, EEWE
ee3:	xwdr
		sbic 	EECR, EEWE
		rjmp 	ee3
		sbi 	EECR, EERE
		in 		r1, EEDR
		cpse	r1, r0
		rjmp	maiZ
		cp		yl, xl
		cpc		yh, xh
		brne	ee2
		dec		cmdl
		brne	ee1
		rjmp	main
.endif ;.elif UseE2Write

mai7:	
.if UseSRAM
.if !UseE2Read || !UseE2Write
		cpi		cmdh, 6
.endif ; .if !UseE2Read || !UseE2Write

		brne	mai8
sram:	ld		paral, z+
		rcall	putp
		dec		cmdl
		brne	sram
		rcall	putw
		rjmp	main
.endif ; .if UseSRAM


mai8:
.if UseFlashRead
		cpi		cmdh, 7
		brne	mai9					; CMD_READ_FLASH? equal or higher ->next
rdfl1:	
		xlpm	paral, z+
		rcall	putp
		dec		cmdl  ; byte count
		brne	rdfl1
		rcall 	putw  ;put CRC 
		rjmp	main
.endif

mai9:
;	here new command #8

maiY:	ldi		paral, ERRORCOMMAND
maiZ:	rjmp	mai1


; send char with crc
.if UseE2Read || UseSRAM || UseFlashRead
putw:	movw	paral, crcl
		rcall	putc
		mov		paral, parah
putp:	eor		crcl, paral		 	
		ldi		cnt, 8
put1:	lsr		crch
		ror		crcl
		brcc	put2
		eor		crch, polyh
		eor		crcl, polyl
put2:	dec		cnt
		brne	put1
.endif ; .if UseE2Read || UseSRAM

; send char
putc:	xwdr
		de_1
		rcall	waitf
		rcall	waitf
		ldi		cnt, 10
		com		paral
put3:	tx_out										; 1
		rcall	waitf								; 15
		lsr		paral								; 1
		brcs	put4								; 1
		tx_0										; 1
put4:	rcall	put5								; 7
		dec		cnt									; 1
		brne	put3								; 2 = 29 + baud
put5:	ret

; receive char/word
getw:	rcall	getc
getm:	mov		parah, paral
getc:	xwdr
		de_0
get5:	rx_1
		rjmp	get5
get1:	rx_0
		rjmp	get1
getx:	ldi		cnt, 8
		movw	cntl, baudl
		lsr		cnth
		ror		cntl
		rcall	waith
get2:	rcall	waitf								; 15 + baud
		lsr		paral								; 1
		rx_0										; 1
		ori		paral, 0x80							; 1
		sbrc	paral, 7							; 1
		eor		crcl, polyl							; 1
		lsr		crch								; 1
		ror		crcl								; 1
		brcc	get3								; 1
		eor		crch, polyh							; 1
get3:	brcc	get4								; 1
		eor		crcl, polyl							; 1
get4:	dec		cnt									; 1
		brne	get2								; 2 = 29 + baud
		eor		crcl, crch
		eor		crcl, crch
		ret

; UART delays										; by P.Dannegger
waitf:	movw	cntl, baudl							; 1
waith:	sbiw	cntl, 4								; 2
		brcc	waith								; 2/1
		cpi		cntl, 0xFD							; 1
		brcs	wait1								; 2/1 (2)
		breq	wait1								; 2/1 (3)
		cpi		cntl, 0xFF							; 1
		breq	wait1								; 2/1 (4/5)
wait1:	tx_1										; 1
		ret											; 4 + 3 (rcall) = 15

.if UseCrypt
.include "Crypt.inc"
.endif ; .if UseCrypt


BootSign:	.db		"BLHeli"; if you change it then change sign in AVRootloader.ini

.if Revision==1
BootMsg:	.db		"4712"	; your own message here, must be shorter as 253 chars
;					Interface-MCU_BootlaoderRevision

.elif Revision==2
BootMsg:	.db		"471a"	; your own message here, must be shorter as 253 chars
;					Interface-MCU_BootlaoderRevision

.elif Revision==3
BootMsg:	.db		"471b"	; your own message here, must be shorter as 253 chars
;					Interface-MCU_BootlaoderRevision

.elif Revision==4
BootMsg:	.db		"471c"	; your own message here, must be shorter as 253 chars
;					Interface-MCU_BootlaoderRevision
.endif
					
BootInfo:	.db		SIGNATURE_001, SIGNATURE_002, BootVersion, BootPages 	; must be not changed

.if UseCrypt
; follow bytes should be keept secret and choosen randomly, 128 Bit Password, first 32 bit used as Signature
BootKey:	.db		$70,$06,$C8,$F7,$06,$AD,$AE,$04,$EE,$83,$3D,$81,$50,$3F,$31,$DC
.endif ; .if UseCrypt


.include "Special.inc"								

.endif ; .ifndef PageSize  -> end of source




