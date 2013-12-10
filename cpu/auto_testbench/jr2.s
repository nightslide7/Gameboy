;; Contains tests for:
;; jr

jp main
    
b1:
    add #0x01
    jp j2
    halt
    
b2:
    add #0x02
    jp j3
    halt
    
b3:
    add #0x04
    jp j4
    halt
    
main:
    jr nz, b1
    halt
j2:
    jr b2
    halt
j3:
    jr b3
    halt
j4:
    jr nz, b4
    halt
j5:
    jr b5
    halt
j6:
    jr z, b6
    halt

b4:
    add #0x08
    jp j5
    halt
    
b5:
    add #0x10
    jp j6
    halt
    
b6:
    add #0x20
    ld C, #0x42
    halt
    
error_zone:
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    halt
    