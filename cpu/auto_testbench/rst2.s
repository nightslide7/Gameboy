;; Contains tests for:
;; RST

Addr_00:
    jr nz, code_area
    add #0x01
    ret
    nop
    nop
    nop
    
Addr_08:
    add #0x02
    ret
    nop
    nop
    nop
    nop
    nop

Addr_10:
    add #0x04
    ret
    nop
    nop
    nop
    nop
    nop
    
Addr_18:
    add #0x08
    ret
    nop
    nop
    nop
    nop
    nop
   
Addr_20:
    add #0x10
    ret
    nop
    nop
    nop
    nop
    nop
    
Addr_28:
    add #0x20
    ret
    nop
    nop
    nop
    nop
    nop
    
Addr_30:
    add #0x40
    ret
    nop
    nop
    nop
    nop
    nop
    
Addr_38:
    add #0x80
    ret
    nop
    nop
    nop
    nop
    nop
    
code_area:
rst00:
    add A, #0x00
    ld HL, #0xc030
    ld SP, HL
    rst #0x00
rst08:
    rst #0x08
rst10:
    rst #0x10
rst18:
    rst #0x18
rst20:
    rst #0x20
rst28:
    rst #0x28
rst30:
    rst #0x30
rst38:
    rst #0x38
end:
    halt