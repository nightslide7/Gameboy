;; Contains tests for:
;; srl m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    srl B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    srl D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    srl H
    
    halt