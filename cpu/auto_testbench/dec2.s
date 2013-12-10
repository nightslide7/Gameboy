;; Contains tests for:
;; DEC ss

main:
    ld BC, #0x00
    dec BC
    
    ld DE, #0xff
    dec DE
    
    ld HL, #0xf0
    dec HL
    
    halt