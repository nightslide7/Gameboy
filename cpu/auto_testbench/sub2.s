;; Contains tests for:
;; SUB s
;; These tests are functional ALU tests, i.e. they test the ALU more than they
;; test the microcode. These are result tests.
;;
;; ZNHC
;;

main:
    ; Setup stack
    ld SP, #0xc040

    ; Z flag
    ld A, #0x00
    ld B, #0x00
    sub B
    push AF
    pop HL
    ld B, H
    
    ; C, H flags
    ld A, #0x11
    ld C, #0xff
    sub C
    push AF
    pop HL
    ld C, H
    
    ; C flag only
    ld A, #0x1f
    ld D, #0xf0
    sub D
    push AF
    pop HL
    ld D, H
    
    ; H flag only
    ld A, #0xf1
    ld E, #0x0f
    sub E
    push AF
    pop HL
    ld E, H
    
    ; No flags (N flag always set however)
    ld A, #0xff
    ld L, #0x01
    sub L
    
    halt