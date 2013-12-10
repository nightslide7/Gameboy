;; Contains tests for:
;; ldhl, SP+e

main:
    ld SP, #0x24D2
    
    ldhl SP, #0x37
    
    halt