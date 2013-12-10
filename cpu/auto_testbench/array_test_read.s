jp code_area
my_array:
    ; Starts at 0x0003
    nop                 ; 00            03
    ld BC, #0x0302      ; 01, 02, 03    04
    inc b               ; 04            07
    dec b               ; 05            08
    ld b, #0x07         ; 06, 07        09
    ld (#0x0a09), SP    ; 08, 09, 0a    0b
    dec BC              ; 0b            0e
    inc C               ; 0c            0f
    dec C               ; 0d            10
    ld C, #0x0f         ; 0e, 0f        11
    rst #0x38           ; ff            13
    stop                ; 10, 00        14
    jr NZ, #0x30        ; 20, 30        16
    ld B, B             ; 40            18
    ld D, B             ; 50            19
    ld H, B             ; 60            1a
    ld (HL), B          ; 70            1b
    add A, B            ; 80            1c
    sub B               ; 90            1d
    and B               ; a0            1e
    or B                ; b0            1f
    ret NZ              ; c0            20
    ret NC              ; d0            21
    ldh (#0x00f0), A    ; e0, f0, 00    22
    ; Last element at 0x0024
    
code_area:
    ld L, #0x11
    ld H, #0x00
    ld B, (HL)
    inc HL
    ld C, (HL)
    inc HL
    ld D, (HL)
    inc HL
    ld E, (HL)
    halt