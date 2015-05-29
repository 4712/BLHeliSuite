; copyright HR
; decryption code, XTEA with special double CBC ciphermode to get a CMAC, cipher message authentication code
.nolist

.undef	feedl
.undef	feedh
.undef	crcl
.undef	crch
.undef	paral
.undef	parah
.undef	polyl
.undef	polyh
.undef	zx
.undef	cmdl
.undef	cmdh
.undef	cntl
.undef	cnth

.def	a0				= r0
.def	a1				= r1
.def	a2				= r2
.def	a3				= r3 
.def	b0				= r4			; feedl				
.def	b1				= r5			; feedh
.def	b2				= r6			
.def	b3				= r7			; zx
.def	t0				= r8			; crcl
.def	t1				= r9			; crch
;.def	zerol			= r10			; zerol
;.def	zeroh			= r11			; zeroh
;.def	baudl			= r12			; baudl
;.def	baudh			= r13			; baudl
;.def	sraml			= r14			; SRAM buffer start
;.def	sramh			= r15
.def	s0				= r16			; paral
.def	s1				= r17			; parah
.def	s2				= r18			; polyl, restored
.def	s3				= r19			; polyh, restored
;.def	cnt				= r20			; cnt
;.def	flag			= r21			; flag
.def	round			= r22			; cmdl
.def	t4				= r23			; cmdh
.def	t2				= r24			; cntl
.def	t3				= r25			; cnth
;.def	XL				= r26			; buffer_endl
;.def	XH				= r27			; buffer_endh
;.def	YL				= r28			; unused	
;.def	YH				= r29			; unused	
;.def	ZL				= r30			; overwritten Address
;.def	ZH				= r31			; 	
.list


; XTEA decryption with spezial CBC feedback modus, final checksum/signature block with 24 Bit FLASH Address setup
; SRAML points to start of buffer, SRAML-16 points to feedback, SRAML-8 points to buffer of next used feedback
; X points after buffer
; T flag = 0 = CMDL = 0xFE = decryption init, = 1 = CMDL = 0xFF = normal data decryption
; cycles:
; 698 * 8 Bytes -1 = 5583 one data block
; + 98 for CMDL=0xFE=init
; + 76 for CMDL=0xFF=data
; thus average throughput by 8Mhz is 11kByte/sec

decrypt:
		movw	yl, sraml
		sbiw	yl, 16
		movw	sraml, yl
		sbiw	xl, 16
.if BigMega
		ldi		cnt, byte3(BootKey * 2)
		xout	RAMPZ, cnt
.endif ; .if BigMega

tea1:	ldi		cnt, 8
		movw	zl, zerol				; zerol, z points to register file r0-r7 = a,b
tea2:	ldd		t0, y +0				; buffer = feedback xor cipherblock
		ldd     t1, y +16				; in next round buffer is feedback
		eor		t0, t1
		std		y +8, t0
		st		z+, t1					; setup a,b = cipherblock
		adiw	yl, 1
		dec		cnt
		brne	tea2

		ldi		s0, 0x20				; sum = 32 * delta
		ldi		s1, 0x37
		ldi		s2, 0xef
		ldi		s3,	0xc6

		rcall	teadec					; first 16 rounds

tea3:	ld		t0, z					; ciphertext = ciphertext xor feedback
		ld		t1, y+
		eor		t0, t1
		st		z+, t0
		dec		cnt
		brne	tea3

		rcall	teadec					; second 16 rounds

tea4:	ld		t0, z+					; plaintext = ciphertext xor feedback
		ld		t1, y
		eor		t0, t1
		st		y+, t0
		dec		cnt
		brne	tea4 

		cp		yl, xl					; sram buffer end reached ?
		cpc		yh, xh
		brlo	tea1
		ldi		s0, ERRORCRYPT			
		brcs	tea7					; overflow, datasize not a multiple of 8

		sbiw	yl, 8					; points to signature + dummy + address

.if UseVersioning
		brts	tea80			

		ldi		zl, byte1(AppVerAddr)	; check version number
		ldi		zh,	byte2(AppVerAddr)
		ldi		cnt, 4
		sbiw	yl, 4
		ldi		s2, 0xFF
		ldi		s3, 0xFF

tea8:	ld		r0, y+					
		xlpm	r1, z+
		and		s3, r1
		cpse	r0, s2
		cpc		r0, r1
		dec		cnt
		brne	tea8

		ldi		s0, ERRORVERSION
		cpse	s3, s2
		brcs	tea7
		ldi		s0, ERRORCRYPT			
tea80:
.endif ;.if UseVersioning

		ori		flag, 0x02				; success crypt

		ldi		zl, byte1(BootKey * 2)
		ldi		zh, byte2(BootKey * 2)
		movw	xl, yl
		ldi		cnt, 4					; check signature
		brts	tea5
		sbiw	zl, 4
		ldi		cnt, 8					; check BootInfo and signature
tea5:	ld		r0, y+
		xlpm	r1, z+
		cpse	r0, r1
		clr		flag					; signature don't match
		dec		cnt
		brne	tea5

		movw	b0, xl					; feedback

		brtc	tea6
		ldd		s1, y +0				; correct XH:XL = bufferend pointer for non-multiple-of-8 data
		sub		xl, s1
		sbc		xh, zerol
		ldd		b3, y +1				; ZX:ZH:ZL, new FLASH/EEPROM Address, only valid if cmdl = 0xFF
		ldd		zh, y +2
		ldd		zl, y +3		

tea6:	sbrc	flag, 1
		ldi		s0, SUCCESS
tea7:	ldi		s2, byte1(POLYNOM)		; restore CRC polynom
		ldi		s3, byte2(POLYNOM)
		rjmp	mai1


; plain XTEA decryption
teadec:	ldi		round, 32				; 16 round XTEA, r0-r7=a,b ciphertext
		movw	t0, a0
		movw	t2, a2

dec1:   clr		t4						; t = (a shr 4) xor (a shl 5)
		ldi		cnt, 3
dec2:	lsl		t0
		rol		t1
		rol		t2
		rol		t3
		rol		t4
		dec		cnt
		brne	dec2

		lsl		t0
		eor		t0, t1
		rol		t1
		eor		t1, t2
		rol		t2
		eor		t2, t3
		rol		t3
		eor		t3, t4
		
		add		t0, a0					; t = ((a shr 4) xor (a shl 5)) + a
		adc		t1, a1
		adc		t2, a2
		adc		t3, a3

		ldi		zl, low(BootKey *2)
		ldi		zh, high(BootKey *2)

		sbrc	round, 0
		rjmp	dec3

		sbrc	s1, 3					; k = key[(sum shr 11) and 3]
		adiw	zl, 4
		sbrc	s1, 4
		adiw	zl, 8
	
		rjmp	dec4

dec3:	subi	s0, 0xB9				; sum = sum - delta
		sbci	s1, 0x79	
		sbci	s2, 0x37
		sbci	s3, 0x9E

		sbrc	s0, 0					; k = key[sum and 3]
		adiw	zl, 4
		sbrc	s0, 1
		adiw	zl, 8
	
dec4:	xlpm	t4, z+					; t = t xor (sum + k)
		add		t4, s0
		eor		t0, t4
		xlpm	t4, z+
		adc		t4, s1
		eor		t1, t4
		xlpm	t4, z+
		adc		t4, s2
		eor		t2, t4
		xlpm	t4, z+
		adc		t4, s3
		eor		t3, t4

		sub		b0, t0					; b = b - t
		sbc		b1, t1
		sbc		b2, t2
		sbc		b3, t3

		movw	t0, b0					; b = a, a = b
		movw	t2, b2
		movw	b0, a0
		movw	b2, a2
		movw	a0, t0
		movw	a2, t2		
	
		dec		round
		brne	dec1

		ldi		cnt, 8
		movw	zl, zerol
		sbiw	yl, 8

		ret

