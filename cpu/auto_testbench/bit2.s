;; Contains tests for the following:
;; BIT b, (HL)

main:
    ld HL, #0xc040
    ld (HL), #0xff
    bit #5, (HL)
    push AF
    pop BC
    
    ld HL, #0xc041
    ld (HL), #0xf0
    bit #3, (HL)
    push AF
    pop DE
    
    ld HL, #0xc042
    ld (HL), #0xfe
    bit #0, (HL)
    
    halt