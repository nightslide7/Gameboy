;; Contains tests for:
;; LD r, (HL)
;; LD (HL), r
;; LD (HL), n
;; LD A, (nn)
;; LD (nn), A
;;

main:
    ld B, #0x01
    ld HL, #0xC010
    ld (HL), B
    ld C, (HL)
    
    inc HL
    ld (HL), #0x02
    ld D, (HL)
    
    ld A, #0x05
    ld (#0xC012), A
    xor A
    ld A, (#0xC012)
    halt