;; Contains a test for:
;; jr z

main:
    ;;24D0: 28 37          jr z, 2509
    ld HL, #0x24D0
    ld A, #0x28
    ld (HL+), A
    ld A, #0x37
    ld (HL+), A
    ld A, #0x76
    ld (HL), A
    
    ld HL, #0x2509
    ld (HL), #0x76
    
    ld HL, #0x24D0
    
    ld A, #0x00
    and A
    
    jp (HL)
    
    halt