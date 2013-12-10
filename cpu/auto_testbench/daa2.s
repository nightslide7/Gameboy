;; Contains tests for:
;; DAA

main:
    ld A, #0x89
    ld B, #0x71
    add B
    daa
    ld C, A
    
    ld A, #0x89
    ld B, #0x69
    add B
    daa
    ld D, A
    
    ld A, #0x89
    ld B, #0x77
    sub B
    daa
    ld E, A
    
    ld A, #0x80
    ld B, #0x15
    sub B
    daa
    ld H, A
    
    ld A, #0x00
    ld B, #0x33
    sub B
    daa
    ld L, A
    
    halt