;; Contains tests for the following:
;; JP (HL)

main:
    ld HL, #0x0007 ; jump1
    jp (HL)
    
    ld B, #0x01
    halt
    
jump1:
    ld HL, #0x000E ; jump2
    jp (HL)
    
    ld C, #0x02
    halt
    
jump2:
    ld D, #0x03
    halt