;; Contains tests for:
;; RLCA

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld A, #0xa3
    rlca
    push AF
    pop BC
    
    rlca
    push AF
    pop DE
    
    rlca
    push AF
    pop HL
    
    rlca
    halt