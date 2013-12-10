;; Contains tests for:
;; SLA (HL)

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld HL, #0xc041
    ld (HL), #0xaa
    
    SLA (HL)
    push AF
    pop BC
    ld B, (HL)
    
    SLA (HL)
    push AF
    pop DE
    ld D, (HL)
    
    SLA (HL)
    ld A, (HL)
    
    halt