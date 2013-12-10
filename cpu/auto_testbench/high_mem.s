;; Contains a test for high memory access
;;

main:
    ld a, #0x09
    ldh (#0xff00+#0x80), a
    xor a
    ld a, (#0xff00+#0x80)
    halt