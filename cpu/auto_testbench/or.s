;; Contains tests for:
;; OR s
;;
;; ZNHC
;;

main:
    ; setup stack
    ld SP, #0xc040
    
    ; Zero flags result
    ld A, #0x00
    ld B, #0x00
    or B
    push AF
    pop BC
    
    ; Non-zero flags result
    ld A, #0xaa
    ld D, #0xef
    or D
    push AF
    pop DE
    
    ; Another non-zero flags result
    ld A, #0x66
    ld H, #0x7f
    or H

    halt