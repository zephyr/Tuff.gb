; DMA Setup Routine -----------------------------------------------------------
core_setup_dma: ; c = target address, b = byte count, hl = data

    ; copy the DMA transfer code into highram so we can execute it from
    ; the interrupt handler
    ld      c,$80
    ld      b,10
    ld      hl,core_DMADataOAM
.loop:
    ld      a,[hli]
    ld      [c],a
    inc     c
    dec     b
    jr      nz,.loop
    ret

; transfer 160 bytes in 40 cycles(32 bits per cycle) from C000-C09F to FE00-FE9F
core_DMADataOAM: 
    ;    ld a,$C0 
    ;    ld [$ff46],a   
    ;    ld a,$28       
    ;
    ;.loop:                
    ;    dec a          
    ;    jr nz,.loop
    DB      $3E, $C0, $E0, $46, $3E
    DB      $28, $3D, $20, $FD, $C9

