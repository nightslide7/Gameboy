;; Contains tests for:
;; LD HL, SP+e

main:
    ld SP, #0xdfe2
    ldhl SP, #14
    ld b, h
    ld c, l
    push af
    pop de
    
    ld SP, #0x0100
    ldhl SP, #-7

    halt