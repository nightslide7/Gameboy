;; Contains tests for:
;; RRCA

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld A, #0xa3
    rrca
    push AF
    pop HL
    ld B, H
    ld C, L
    
    rrca
    push AF
    pop HL
    ld D, H
    ld E, L
    
    rrca
    push AF
    pop HL
    
    rrca
    halt