;; Contains tests for:
;; ADD A, r
;; These tests are functional ALU tests, i.e. they test the ALU more than
;; the microcode. These are result tests.
;;
;; ZNHC

main:
    ; Setup SP
    ld SP, #0xc040

    ld A, #0x00
    ld B, #0x0f
    ld C, #0x01
    
    ; No flags set
    add B
    push AF
    pop HL
    ld B, H
    
    ; H flag set
    add C
    push AF
    pop HL
    ld C, H
    
    ; C flag set
    ld A, #0xfe
    ld D, #0xe0
    add D
    push AF
    pop HL
    ld D, H
    
    ; C, H, Z flag set
    ld A, #0xfe
    ld E, #0x02
    add E
    push AF
    pop HL
    ld E, H
    
    ; Z flag set
    ld A, #0x00
    ld L, #0x00
    add L
    
    halt