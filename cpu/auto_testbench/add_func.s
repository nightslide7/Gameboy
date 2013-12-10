;; Contains tests for:
;; ADD A, (HL)
;; ADD A, n
;;

main:
    ; Setup stack
    ld SP, #0xc040
    
    ld HL, #0xc041
    ld (HL), #0x0f
    ld A, #0x0e
    add A, (HL)
    push AF
    pop BC
    
    ld A, #0x10
    add A, #0x05
    
    halt