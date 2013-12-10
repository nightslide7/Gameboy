;; Contains tests for the following:
;; LD A, (C)
;; LD (C), A

main:
    ld C, #0x00
    ld A, #0x01
    ld (FF00+C), A
    xor A
    ld A, (C)
    ld B, A
    
    ld C, #0xff
    ld A, #0x02
    ld (C), A
    xor A
    ld A, (C)
    ld D, A
    
    halt