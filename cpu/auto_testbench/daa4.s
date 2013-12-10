;; Contains tests for the following:
;; DAA

main:
    ld SP, #0xc040

    ld A, #0x89
    ld B, #0x71
    add B
    daa
    push AF
    pop BC
    
    ld A, #0x89
    ld B, #0x69
    add B
    daa
    push AF
    pop HL
    ld D, L
    
    ld A, #0x89
    ld B, #0x77
    sub B
    daa
    push AF
    pop HL
    ld E, L
    
    ld A, #0x80
    ld B, #0x15
    sub B
    daa
    push AF
    pop HL
    
    ld A, #0x00
    ld B, #0x33
    sub B
    daa
    
    halt