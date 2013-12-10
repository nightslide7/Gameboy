;; func_test.s
;; Tests the CALL, RETURN, PUSH, and POP instructions.

main:
    ld BC, #0x1122
    ld DE, #0xf0f0
    ld HL, #0x5566
    ld SP, #0xc010
    push BC
    pop HL
    call func
    halt

func:
    ld DE, #0x3344
    ret