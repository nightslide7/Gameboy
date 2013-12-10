    LD SP, #0xfffe
    LD HL, #0xC0ff
    LD DE, #0x0104
    LD A, #0x03
    XOR A
    LD A, #0x01
Loop1:
    LD (HL-), A
    BIT #1, L
    JR NZ, Loop1
    
    INC HL
    LD A, (HL+)
    LD B, A
    LD A, (HL)
    LD C, A
    
    halt
    
    ;LD C, #0x11
    ;LD (#0xff00+C), A
    ;LD A, #0x02
    ;LD (#0xff00+#0x12), A