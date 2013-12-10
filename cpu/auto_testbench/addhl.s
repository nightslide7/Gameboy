;; Tests for the following:
;; ADD HL, ss
;;

main:
    ; Setup stack
    ld SP, #0xc040
    
    ; Attempt to set 0 flag, carry, half-carry
    ld BC, #0x0001
    ld HL, #0xffff
    add HL, BC
    ld B, H
    ld C, L
    
    ; Set some random flags
    ld DE, #0x0e0f
    ld HL, #0x0613
    add HL, DE
    ld D, H
    ld E, L
    
    ; Add HL to itself because why not
    ld HL, #0xbeef
    add HL, HL
    
    halt