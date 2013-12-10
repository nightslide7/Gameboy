;; Contains tests for:
;; AND s
;;
;; ZNHC
;;

main:
    ; setup stack
    ld SP, #0xc040
    
    ; Zero flags result
    ld A, #0x1e
    ld B, #0xe1
    and B
    push AF
    pop HL
    ld B, H
    ld C, L
    
    ; Non-zero flags result
    ld A, #0xaa
    ld D, #0xef
    and D
    push AF
    pop HL
    ld D, H
    ld E, L
    
    ; Another non-zero flags result
    ld A, #0x66
    ld H, #0x7f
    and H

    halt