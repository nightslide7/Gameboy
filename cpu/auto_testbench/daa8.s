;; Contains tests for:
;; DAA

;; $00,$01,$0F,$10,$1F,$7F,$80,$F0,$FF,$02,$04,$08,$20,$40

main:
    ld SP, #0xC040
    
    ld A, #0x02
    daa
    push AF
    pop DE
    
    ld A, #0x04
    daa
    push AF
    pop DE
    
    ld A, #0x08
    daa
    push AF
    pop HL
    
    ld A, #0x20
    daa
    
    halt