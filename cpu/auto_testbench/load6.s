;; Contains tests for:
;; LD A, (n)
;; LD (n), A

main:
    ld A, #0x01
    ldh (#0x15), A
    xor A
    ldh A, (#0x15)
    ld D, A
    
    ld A, #0x02
    ldh (#0xf0), A
    xor A
    ldh A, (#0xf0)
    ld E, A
    
    halt