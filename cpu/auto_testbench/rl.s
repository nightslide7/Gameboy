;; Contains tests for:
;; RL m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    rl B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    rl D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    rl H
    
    halt