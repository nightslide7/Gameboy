;; Contains tests for:
;; RR m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    rr B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    rr D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    rr H
    
    halt