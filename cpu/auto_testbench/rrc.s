;; Contains tests for:
;; RRC m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    rrc B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    rrc D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    rrc H
    
    halt