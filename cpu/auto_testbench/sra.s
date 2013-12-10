;; Contains tests for:
;; SRA m

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld B, #0xa3
    sra B
    push AF
    pop HL
    ld C, L
    
    ld D, B
    sra D
    push AF
    pop HL
    ld E, L
    
    ld H, D
    sra H
    
    halt