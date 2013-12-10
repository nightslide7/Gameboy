;; Contains tests for:
;; ADC A, r
;; These tests are functional ALU tests, i.e. they test the ALU more than
;; the microcode. These are flags tests.
;;
;; ZNHC

main:
    ; Setup SP
    ld SP, #0xc040

    ld A, #0x00
    ld B, #0x0f
    ld C, #0x01
    
    ; No flags set
    adc B
    push AF
    pop HL
    ld B, L
    
    ; H flag set
    adc C
    push AF
    pop HL
    ld C, L
    
    ; C flag set
    ld A, #0xfe
    ld D, #0xe0
    adc D
    push AF
    pop HL
    ld D, L
    
    ; C, H, Z flag set
    ld A, #0xfe
    ld E, #0x02
    adc E
    push AF
    pop HL
    ld E, L
    
    ; Z flag set
    ld A, #0x00
    ld H, #0x00
    adc H
    
    halt