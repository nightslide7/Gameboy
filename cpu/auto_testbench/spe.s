;; Contains tests for:
;; ADD SP, e

main:
    ; Attempt to set Z
    ld SP, #0x0000
    add SP, #0
    
    ; Stack overflow! Ahahahahahahahahahahahaha! Hahaha... ha ha ha.
    ld SP, #0xffff
    add SP, #7
    
    ; Negative immediate
    ld SP, #0xffff
    add SP, #-99
    
    halt