;; Contains tests for the following:
;; DAA

main:
    ld SP, #0xc040

    ld A, #0x00
    ld B, #0x00
    add B
    daa
    push AF
    pop BC
    
    ld A, #0x07
    ld B, #0x13
    add B
    daa
    push AF
    pop HL
    ld D, L
    
    ld A, #0x07
    ld B, #0x09
    add B
    daa
    push AF
    pop HL
    ld E, L
    
    ld A, #0x88
    ld B, #0x10
    add B
    daa
    push AF
    pop HL
    
    ld A, #0x99
    ld B, #0x01
    add B
    daa
    
    halt