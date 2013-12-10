;; Contains tests for:
;; RLA

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld A, #0xa3
    rla
    push AF
    pop HL
    ld B, H
    ld C, L
    
    rla
    push AF
    pop HL
    ld D, H
    ld E, L
    
    rla
    push AF
    pop HL
    
    rla
    halt