;; Contains tests for:
;; RST
;; JP (HL)

Addr_00:
    jr nz, code_area
    add #0x01
    ret
    nop
    nop
    nop
    nop
    
Addr_08:
    ld HL, #0x0020 ; rst10
    jp (HL)
    ld D, #0x03
    nop
    nop

Addr_10:
    ret
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
Addr_18:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
   
Addr_20:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
Addr_28:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
Addr_30:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
Addr_38:
    nop
    nop
    nop
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
end:
    halt