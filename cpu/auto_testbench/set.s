;; Contains tests for:
;; SET b,r
;; RESET b,r
;;

main:
    ld B, #0x00
    set #4, B
    
    ld C, #0xff
    set #2, C
    
    ld D, #0x00
    res #5, D
    
    ld E, #0xff
    res #1, E
    
    ld HL, #0xc010
    ld (HL), #0x0f
    set #7, (HL)
    res #0, (HL)
    ld A, (HL)
    
    halt