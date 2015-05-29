.nolist
; copyright HR
; special functions to provide for application code access to FLASH
; can be expanded with own functions and place a rjmp vector at end of this file

; First calculate size of code to align code at end of FLASH, better solution possible ?

; Align all follow function at end of FLASH get us to posibility to reprogram a new bootloader.
; For minimal solutions use UseSpecialBootVect=1 to include a rjmp bootstart, rjmp dospm
; vector and the dospm function at end of bootloader section. This cost 16 bytes of FLASH and
; thus the last FLASH page should be always unchanged. With a own application and help of
; dospm function can the remaining bootloader section repogrammed. Please remember that
; all stuff like ISR blocking, waiting for EEPROM write finish and so on must be done in own
; application that wants to update the bootloader (including sanity checks not to overwrite last FLASH page)
; For more comfortable solution set UseSpecialWrite=1 and UseSpecialWriteBoot=1. Now with function
; write_flash() a ways exists to write from SRAM buffer to any address on FLASH without to consider
; page aligment or data size. If the application read access to bootloader section is prohibited by lockbits 
; then set UseSpecialRead=1. Now with read_flash() it's possible to read the entire full flash.
; These feature are only usefull on AVRs with bootloader sections. On Tiny AVRs there is always the possibility to
; use SPM in application code.


.set SpecialSize = 0

.if UseSpecialWrite
.set SpecialSize = SpecialSize +48
.if UseSpecialWriteBoot
.set SpecialSize = SpecialSize +5
.endif
.if BigMega
.set SpecialSize = SpecialSize +4
.endif
.if BLS
.set SpecialSize = SpecialSize +5
.ifdef SPMSpecial
.set SpecialSize = SpecialSize +3
.endif
.ifdef RWWSRE
.set SpecialSize = SpecialSize +2
.endif
.else
.set SpecialSize = SpecialSize +8
.endif
.if UseWDR
.set SpecialSize = SpecialSize +1
.endif
.endif

.if UseSpecialRead
.set SpecialSize = SpecialSize +9
.if BigMega
.set SpecialSize = SpecialSize +1
.endif
.endif

.if UseSpecialMsg
.set SpecialSize = SpecialSize +5
.endif

; rjmp vector table
.if UseSpecialWrite || UseSpecialRead || UseSpecialMsg
.set SpecialSize = SpecialSize +5
.elif UseSpecialBootVect
.set SpecialSize = SpecialSize +1
.if BLS
.set SpecialSize = SpecialSize +1
.endif
.endif

; dospm
.if SpecialSize > 0
.if BLS
.set SpecialSize = SpecialSize +6
.ifdef SPMSpecial
.set SpecialSize = SpecialSize +3
.endif
.endif

; align follow code at flash end
.if BootCodeSize
.org (FLASHEND +1) - SpecialSize
.endif
.endif ; .if SpecialSize > 0

; end of size calculation
.list


.if UseSpecialMsg
getbootmsg:
; return address and size of BootMsg, can be used in application to read out BootMsg and follow datas
		ldi		r22, byte1(BootMsg * 2)
		ldi		r23, byte2(BootMsg * 2)
		ldi		r24, byte3(BootMsg * 2)
		ldi		r25, (BootInfo - BootMsg) * 2
		ret
.endif ;.if UseSpecialMsg


.if UseSpecialRead
readflash:
; void readflash(uint32_t address, uint16_t size, const uint8_t* buffer);
; r25:r24:r23:r22, r21:r20, r19:r18
.if BigMega
		xout	RAMPZ, r24
.endif	
		movw	zl, r22
		movw	xl, r18
		movw	r24, r20
rf1:	sbiw	r24, 1
		brcs	rf2
		xlpm	r23, z+
		st		x+, r23
		rjmp	rf1
rf2:	ret
.endif ;.if UseSpecialRead


.if UseSpecialWrite
writeflash:
; void write_flash(uint32_t address, uint16_t size, const uint8_t* buffer);
; r25:r24:r23:r22, r21:r20, r19:r18

.if PageSize * 2 > 256
.error "PageSize is greater as 256 bytes, check programing loops"
.endif

		movw	zl, r22									; address to r24:Z
		movw	xl, r18									; SRAM buffer to X
		movw	r18, yl									; save Y to r18
		movw	yl, r20									; size to Y
		movw	r20, r16								; save r17:r16 to r21:r20
		movw	r16, r24								;
		xin		r23, SREG								; save SREG to r23
		cli												; disable IRQs
.if UseSpecialWriteBoot
		clt												; set T flag if MSB of address is a magic to deactivate 
		cpi		r17, 0xAC								; write cheks to bootloader section	
		brne	wf1
		set		
.endif ; .if UseSpecialWriteBoot

wf1:	sbic 	EECR, EEWE								; wait for EEPROM
		rjmp 	wf1

		andi	r22, PageSize *2 -1						; align address
		sub		zl, r22

wf2:	ldi		r17, PageSize
.if UseSpecialWriteBoot
		brts	wf3										; if T flag is set ignore sanity check
.endif
		cpi		zl, byte1(BootStart *2)					; sanity check to ensure not to overwrite bootloader
		ldi		r24, byte2(BootStart *2)				
		cpc		zh, r24
.if BigMega
		ldi		r24, byte3(BootStart * 2)
		cpc		r16, r24
.endif
		brsh	wf8

wf3:	ldi		r24, (1 << SPMEN)
.if BigMega
		xout	RAMPZ, r16
.endif
wf4:	xlpm	r0, z+									; first load word from FLASH
		xlpm	r1, z
		sbiw	z, 1
		sbiw	yl, 0									; size = 0 ?
		breq	wf7
		cpi		r22, 1
		brlo	wf5
		breq	wf6
		subi	r22, 2
		rjmp	wf7
wf5:	ld		r0, x+			
		sbiw	yl, 1
		breq	wf7
wf6:	ld		r1, x+
		sbiw	yl, 1
		clr		r22
wf7:	xwdr
.if BLS
		rcall	dospm									; fill FLASH buffer
.else
		xout	SPMCSR, r24
		spm
.endif
		adiw	z, 2		
		dec		r17										; PageSize
		brne	wf4

		subi	zl, byte1(PageSize *2)
		sbci	zh, byte2(PageSize *2)
.if BLS
		ldi		r24, (1 << PGERS) | (1 << SPMEN)		; erase FLASH page
		rcall	dospm
		ldi		r24, (1 << PGWRT) | (1 << SPMEN)		; program FLASH page
		rcall	dospm
.ifdef RWWSRE
		ldi		r24, (1 << RWWSRE) | (1 << SPMEN)		; unlock FLASH page
		rcall	dospm
.endif
.else
		ldi		r24, (1 << PGERS) | (1 << SPMEN)		; erase FLASH page
		xout	SPMCSR, r24
		spm
		ldi		r24, (1 << PGWRT) | (1 << SPMEN)		; program FLASH page
		xout	SPMCSR, r24
		spm
.endif
		subi	zl, byte1(-PageSize *2)
		sbci	zh, byte2(-PageSize *2)
.if BigMega
		sbci	r16, byte3(-PageSize *2)
.endif
		sbiw	yl, 0									; size = 0 ?
		brne	wf2

wf8:	clr		r1										; restore r1=zero
		movw	yl, r18									; restore Y
		movw	r16, r20								; restore r17:r16
		xout	SREG, r23								; restore SREG
		ret												
.endif ;.if UseSpecialWrite


; SPM helper function, put in here to support updates of bootloader code, programmed into last FLASH page
; r25=cnth destroyed, r24=cntl unchanged
.if BLS
dospm:	xout	SPMCSR, r24
		spm
.ifdef SPMspecial
.dw		$FFFF
		nop
.endif
dspm1:	xin		r25, SPMCSR
		sbrc	r25, SPMEN
		rjmp	dspm1
		ret
.endif ; .if BLS


.if UseSpecialWrite || UseSpecialRead || UseSpecialMsg
; rjmp vectors for support from application code
; can be expanded with own vectors to own code, look into AVRootloader.h how to call
; please don't reorder this jump table, but you can expand it to own code
; if you expand it remember to update above SpecialSize calculation
		bjmp	getbootmsg, UseSpecialMsg				; rjmp getbootmsg if UseSpecial else ret
		bjmp	readflash, UseSpecialRead
		bjmp	writeflash, UseSpecialWrite
		bjmp	dospm, BLS
		rjmp	bootstart
.elif UseSpecialBootVect
.if BLS
		rjmp	dospm
.endif
		rjmp	bootstart
.endif
