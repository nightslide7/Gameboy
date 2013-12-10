;; Contains tests for:
;; xor s
;;
;; ZNHC
;;

main:
    ; setup stack
    ld SP, #0xc040
    
    ; Zero flags result
    ld A, #0xe1
    ld B, #0xe1
    xor B
    push AF
    pop HL
    ld B, H
    ld C, L
    
    ; Non-zero flags result
    ld A, #0xaa
    ld D, #0xef
    xor D
    push AF
    pop HL
    ld D, H
    ld E, L
    
    ; Another non-zero flags result
    ld A, #0x66
    ld H, #0x7f
    xor H

    halt