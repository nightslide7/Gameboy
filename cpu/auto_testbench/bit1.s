;; Contains tests for the following:
;; BIT b, r

main:
    ld A, #0x0f
    bit #3, A
    push AF
    pop BC
    
    ld D, #0x0f
    bit #6, D
    push AF
    pop DE
    
    ld H, #0x00
    bit #7, H
    
    halt