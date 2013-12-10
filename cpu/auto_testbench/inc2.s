;; Contains tests for:
;; INC (HL)
;;
;; ZNHC

main:
    ; Setup SP
    ld SP, #0xc040
    
    ; No flags set
    ld A, #0x0e
    ld HL, #0xc060
    ld (HL), A
    inc (HL)
    ld A, (HL)
    push AF
    pop BC
    
    ; H flag set
    ld A, #0x0f
    ld HL, #0xc061
    ld (HL), A
    inc (HL)
    ld A, (HL)
    push AF
    pop DE
    
    ; Z flag set
    ld A, #0xff
    ld HL, #0xc062
    ld (HL), A
    inc (HL)
    ld A, (HL)
    push AF
    pop HL
    
    halt