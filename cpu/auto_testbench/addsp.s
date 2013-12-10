;; Contains tests for:
;; ADD SP, 1

;;.word $0000,$0001,$000F,$0010,$001F,$007F,$0080,$00FF
;;.word $0100,$0F00,$1F00,$1000,$7FFF,$8000,$FFFF

main:
    ld BC, #0x00F0 ;; Flags
    push BC
    pop AF
    ld SP, #0x000F
    add SP, #0x01
    halt