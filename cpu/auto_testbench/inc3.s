;; Contains tests for:
;; INC ss

main:
    ld BC, #0xff
    inc BC
    
    ld DE, #0x03
    inc DE
    
    ld HL, #0x0f
    inc HL
    
    halt
    