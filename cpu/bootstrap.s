    LD SP,#0xfffe		; #0x0000  Setup Stack

	XOR A			    ; #0x0003  Zero the memory from #0x8000-#0x9FFF (VRAM)
	LD HL,#0x9fff		; #0x0004
Addr_0007:
	LD (HL-),A		    ; #0x0007
	BIT 7,H		        ; #0x0008
	JR NZ, Addr_0007	; #0x000a

	LD HL,#0xff26		; #0x000c  Setup Audio
	LD C,#0x11		    ; #0x000f
	LD A,#0x80		    ; #0x0011 
	LD (HL-),A		    ; #0x0013
	LDH (C),A	        ; #0x0014 ;; ------>  LD (C), A  <-------
	INC C			    ; #0x0015
	LD A,#0xf3		    ; #0x0016
	LDH (C),A	        ; #0x0018 ;; ------>  LD (C), A  <-------
	LD (HL-),A		    ; #0x0019
	LD A,#0x77		    ; #0x001a
	LD (HL),A		    ; #0x001c

	LD A,#0xfc		    ; #0x001d  Setup BG palette
	LDH (#0x47),A	    ; #0x001f >>> LD (ff00+n), A <<<

	LD DE,#0x0104		; #0x0021  Convert and load logo data from cart into Video RAM
	LD HL,#0x8010		; #0x0024
Addr_0027:
	LD A,(DE)		    ; #0x0027
	CALL #0x0095		; #0x0028
	CALL #0x0096		; #0x002b
	INC DE		        ; #0x002e
	LD A,E		        ; #0x002f
	CP #0x34		    ; #0x0030
	JR NZ, Addr_0027	; #0x0032

	LD DE,#0x00d8		; #0x0034  Load 8 additional bytes into Video RAM
	LD B,#0x08		    ; #0x0037
Addr_0039:
	LD A,(DE)		    ; #0x0039
	INC DE		        ; #0x003a
	LD (HL+),A		    ; #0x003b
	INC HL		        ; #0x003c
	DEC B			    ; #0x003d
	JR NZ, Addr_0039	; #0x003e

	LD A,#0x19		    ; #0x0040  Setup background tilemap
	LD (#0x9910),A	    ; #0x0042
	LD HL,#0x992f		; #0x0045
Addr_0048:
	LD C,#0x0c		    ; #0x0048
Addr_004A:
	DEC A			    ; #0x004a
	JR Z, Addr_0055	    ; #0x004b
	LD (HL-),A		    ; #0x004d
	DEC C			    ; #0x004e
	JR NZ, Addr_004A	; #0x004f
	LD L,#0x0f		    ; #0x0051
	JR Addr_0048	    ; #0x0053

	; === Scroll logo on screen, and play logo sound===

Addr_0055:
	LD H,A		        ; #0x0055  Initialize scroll count, H=0
	LD A,#0x64		    ; #0x0056
	LD D,A		        ; #0x0058  set loop count, D=#0x64
	LDH (#0x42),A	    ; #0x0059  Set vertical scroll register >>> LD (ff00+n), A <<<
	LD A,#0x91		    ; #0x005b
	LDH (#0x40),A	    ; #0x005d  Turn on LCD, showing Background >>> LD (ff00+n), A <<<
	INC B			    ; #0x005f  Set B=1
Addr_0060:
	LD E,#0x02		    ; #0x0060
Addr_0062:
	LD C,#0x0c		    ; #0x0062
Addr_0064:
	LDH A,(#0x44)	    ; #0x0064  wait for screen frame  >>> LD (ff00+n), A <<<
	CP #0x90		    ; #0x0066
	JR NZ, Addr_0064	; #0x0068
	DEC C			    ; #0x006a
	JR NZ, Addr_0064	; #0x006b
	DEC E			    ; #0x006d
	JR NZ, Addr_0062	; #0x006e

	LD C,#0x13		    ; #0x0070
	INC H			    ; #0x0072  increment scroll count
	LD A,H		        ; #0x0073
	LD E,#0x83		    ; #0x0074
	CP #0x62		    ; #0x0076  #0x62 counts in, play sound #1
	JR Z, Addr_0080	    ; #0x0078
	LD E,#0xc1		    ; #0x007a
	CP #0x64		    ; #0x007c
	JR NZ, Addr_0086	; #0x007e  #0x64 counts in, play sound #2
Addr_0080:
	LD A,E		        ; #0x0080  play sound
	LDH (C),A	        ; #0x0081 ;; ------>  LD (C), A  <-------
	INC C			    ; #0x0082
	LD A,#0x87		    ; #0x0083
	LDH (C),A       	; #0x0085 ;; ------>  LD (C), A  <-------
Addr_0086:
	LDH A,(#0x42)	    ; #0x0086  >>> LD (ff00+n), A <<<
	SUB B			    ; #0x0088
	LDH (#0x42),A	    ; #0x0089  scroll logo up if B=1  >>> LD (ff00+n), A <<<
	DEC D			    ; #0x008b  
	JR NZ, Addr_0060	; #0x008c

	DEC B			    ; #0x008e  set B=0 first time
	JR NZ, Addr_00E0	; #0x008f    ... next time, cause jump to "Nintendo Logo check"

	LD D,#0x20		    ; #0x0091  use scrolling loop to pause
	JR Addr_0060	    ; #0x0093

	; ==== Graphic routine ====

	LD C,A		        ; #0x0095  "Double up" all the bits of the graphics data
	LD B,#0x04		    ; #0x0096     and store in Video RAM
Addr_0098:
	PUSH BC		        ; #0x0098
	RL C			    ; #0x0099
	RLA			        ; #0x009b
	POP BC		        ; #0x009c
	RL C			    ; #0x009d
	RLA			        ; #0x009f
	DEC B			    ; #0x00a0
	JR NZ, Addr_0098	; #0x00a1
	LD (HL+),A		    ; #0x00a3
	INC HL		        ; #0x00a4
	LD (HL+),A		    ; #0x00a5
	INC HL		        ; #0x00a6
	RET			        ; #0x00a7

Addr_00A8:
	;Nintendo Logo
	.DB #0xCE,#0xED,#0x66,#0x66,#0xCC,#0x0D,#0x00,#0x0B,#0x03,#0x73,#0x00,#0x83,#0x00,#0x0C,#0x00,#0x0D 
	.DB #0x00,#0x08,#0x11,#0x1F,#0x88,#0x89,#0x00,#0x0E,#0xDC,#0xCC,#0x6E,#0xE6,#0xDD,#0xDD,#0xD9,#0x99 
	.DB #0xBB,#0xBB,#0x67,#0x63,#0x6E,#0x0E,#0xEC,#0xCC,#0xDD,#0xDC,#0x99,#0x9F,#0xBB,#0xB9,#0x33,#0x3E 

Addr_00D8:
	;More video data
	.DB #0x3C,#0x42,#0xB9,#0xA5,#0xB9,#0xA5,#0x42,#0x3C

	; ===== Nintendo logo comparison routine =====

Addr_00E0:	
	LD HL,#0x0104		; #0x00e0	; point HL to Nintendo logo in cart
	LD DE,#0x00a8		; #0x00e3	; point DE to Nintendo logo in DMG rom

Addr_00E6:
	LD A,(DE)		    ; #0x00e6
	INC DE		        ; #0x00e7
	CP (HL)		        ; #0x00e8	;compare logo data in cart to DMG rom
	JR NZ,#0xfe		    ; #0x00e9	;if not a match, lock up here
	INC HL		        ; #0x00eb
	LD A,L		        ; #0x00ec
	CP #0x34		    ; #0x00ed	;do this for #0x30 bytes
	JR NZ, Addr_00E6	; #0x00ef

	LD B,#0x19		    ; #0x00f1
	LD A,B		        ; #0x00f3
Addr_00F4:
	ADD (HL)		    ; #0x00f4
	INC HL		        ; #0x00f5
	DEC B			    ; #0x00f6
	JR NZ, Addr_00F4	; #0x00f7
	ADD (HL)		    ; #0x00f9
	JR NZ,#0xfe		    ; #0x00fa	; if #0x19 + bytes from #0x0134-#0x014D  don't add to #0x00
						;  ... lock up

	LD A,#0x01		    ; #0x00fc
	LDH (#0x50),A	    ; #0x00fe	;turn off DMG rom >>> LD (ff00+n), A <<<