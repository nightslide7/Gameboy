;; Contains tests for:
;; SUB s
;; These tests are functional ALU tests, i.e. they test the ALU more than they
;; test the microcode. These are flags tests.
;;
;; ZNHC
;;

main:
    ; Setup stack
    ld SP, #0xc040

    ; Z flag
    ld A, #0x00
    ld B, #0x00
    sbc B
    push AF
    pop HL
    ld B, L
    
    ; C, H flags
    ld A, #0x11
    ld C, #0xff
    sbc C
    push AF
    pop HL
    ld C, L
    
    ; C flag only
    ld A, #0x1f
    ld D, #0xf0
    sbc D
    push AF
    pop HL
    ld D, L
    
    ; H flag only
    ld A, #0xf1
    ld E, #0x0f
    sbc E
    push AF
    pop HL
    ld E, L
    
    ; No flags (N flag always set however)
    ld A, #0xff
    ld L, #0x01
    sbc L
    
    halt