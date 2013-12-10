;; Contains tests for:
;; INC r
;; These tests are functional ALU tests, i.e. they test the ALU more than
;; the microcode.
;;
;; ZNHC

main:
    ; Setup SP
    ld SP, #0xc040
    
    ; No flags set
    ld A, #0x0e
    inc A
    push AF
    pop HL
    ld B, H
    ld C, L
    
    ; H flag set
    ld A, #0x0f
    inc A
    push AF
    pop HL
    ld D, H
    ld E, L
    
    ; Z flag set
    ld A, #0xff
    inc A
    push AF
    pop HL
    
    halt