;; Contains tests for:
;; RLC m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    rlc B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    rlc D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    rlc H
    
    halt