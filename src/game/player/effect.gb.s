player_effect_dust:
    push    de
    push    hl
    ld      a,[playerX]
    add     c
    ld      c,a
    ld      a,[playerY]
    add     b
    ld      b,a
    ld      a,EFFECT_DUST_CLOUD
    call    effect_create
    pop     hl
    pop     de
    ret

player_effect_dust_small:
    ld      a,[playerY]
    add     2
    sub     b
    ld      b,a
    ld      a,[playerX]
    add     a,4
    ld      c,a
    ld      a,EFFECT_DUST_CLOUD_SMALL
    call    effect_create
    ret

player_effect_water_splash:; d = Water effect offset
    ; Left
    ld      a,[playerX]
    ld      c,a
    ld      a,[playerY]
    add     2
    add     d
    ld      b,a
    ld      a,EFFECT_WATER_SPLASH_IN_LEFT
    add     d
    push    de
    call    effect_create
    pop     de

    ; Right
    ld      a,[playerX]
    add     a,8
    ld      c,a
    ld      a,[playerY]
    add     2
    add     d
    ld      b,a
    ld      a,EFFECT_WATER_SPLASH_IN_RIGHT
    add     d
    call    effect_create
    ret

