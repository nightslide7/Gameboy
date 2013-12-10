;; Contains tests for:
;; SLA m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    sla B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    sla D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    sla H
    
    halt