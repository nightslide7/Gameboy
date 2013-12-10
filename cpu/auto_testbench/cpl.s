;; Contains tests for:
;; CPL
;;
;; ZNHC
;;

main:
    ; setup stack
    ld SP, #0xc040
    
    ; Zero result
    ld A, #0xff
    cpl
    push AF
    pop BC
    
    ; Non-zero result
    ld A, #0xaa
    cpl
    push AF
    pop DE
    
    ; Another non-zero result
    ld A, #0x66
    cpl

    halt