;; Contains tests for:
;; LD SP, HL
;; LDHL SP, e
;; LD (nn), SP

main:
    ldhl SP, #-128
    ld SP, HL
    ld (#0xc010), SP
    ld A, (#0xc010)
    ld C, A
    ld A, (#0xc011)
    ld B, A
    
    ldhl SP, #127
    ld D, H
    ld E, L
    inc hl
    ld SP, HL
    ldhl SP, #127
    halt