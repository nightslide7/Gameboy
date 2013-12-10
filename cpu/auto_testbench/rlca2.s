;; Contains tests for:
;; RLCA

; .byte $00,$01,$0F,$10,$1F,$7F,$80,$F0,$FF

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld BC, #0xf0
    push BC
    pop AF
    
    ld A, #0x00
    rlca
    push AF
    pop BC
    
    ld DE, #0xf0
    push DE
    pop AF
    
    ld A, #0x01
    rlca
    push AF
    pop DE
    
    ld HL, #0xf0
    push HL
    pop AF
    
    ld A, #0x0f
    rlca
    push AF
    pop HL
    
    rlca
    halt