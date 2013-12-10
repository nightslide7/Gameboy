;; Contains tests for:
;; LD A, (HLI)
;; LD (HLI), A
;; LD A, (HLD)
;; LD (HLD), A

main:
    ld HL, #0xc010
    ld A, #0x01
    ld (HLI), A
    ld A, #0x02
    ld (HL), A
    
    xor A
    
    ld A, (HLD)
    ld B, A
    ld A, (HL)
    ld C, A
    
    ld HL, #0xc020
    ld A, #0x04
    ld (HLD), A
    ld A, #0x03
    ld (HL), A
    
    xor A
    
    ld A, (HLI)
    ld D, A
    ld A, (HLI)
    ld E, A
    halt