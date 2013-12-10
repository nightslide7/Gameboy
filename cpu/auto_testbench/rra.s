;; Contains tests for:
;; RRA

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld A, #0xa3
    rra
    push AF
    pop HL
    ld B, H
    ld C, L
    
    rra
    push AF
    pop HL
    ld D, H
    ld E, L
    
    rra
    push AF
    pop HL
    
    rra
    halt