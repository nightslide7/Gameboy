;; Contains tests for:
;; DAA

;; $00,$01,$0F,$10,$1F,$7F,$80,$F0,$FF,$02,$04,$08,$20,$40

main:
    ld SP, #0xC040
    
    ld BC, #0xF0
    push BC
    pop AF
    ld A, #0x10
    daa
    push AF
    pop DE
    
    ld BC, #0xF0
    push BC
    pop AF
    ld A, #0x1F
    daa
    push AF
    pop HL
    
    ld BC, #0xF0
    push BC
    pop AF
    ld A, #0x7F
    daa
    
    halt