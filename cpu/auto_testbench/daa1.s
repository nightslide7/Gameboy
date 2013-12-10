;; Contains tests for the following:
;; DAA

main:
    ld A, #0x00
    ld B, #0x00
    add B
    daa
    ld C, A
    
    ld A, #0x07
    ld B, #0x13
    add B
    daa
    ld D, A
    
    ld A, #0x07
    ld B, #0x09
    add B
    daa
    ld E, A
    
    ld A, #0x88
    ld B, #0x10
    add B
    daa
    ld H, A
    
    ld A, #0x99
    ld B, #0x01
    add B
    daa
    ld L, A
    
    halt