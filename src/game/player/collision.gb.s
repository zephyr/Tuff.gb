; Player Collision Detectiion -------------------------------------------------


; UP --------------------------------------------------------------------- UP -
player_collision_far_up:

    ; different height when diving
    ld      a,[playerUnderWater]
    cp      0
    jr      nz,.diving
    ld      e,PLAYER_HEIGHT + 3
    jr      _player_col_up

.diving:
    ld      e,PLAYER_HEIGHT + 5
    jr      _player_col_up


player_collision_up:
    ; different height when diving
    ld      a,[playerUnderWater]
    cp      0
    jr      nz,.diving
    ld      e,PLAYER_HEIGHT
    jr      _player_col_up

.diving:
    ld      e,PLAYER_HEIGHT + 2

_player_col_up:
    ; middle
    ld      a,[playerY]
    sub     e
    ld      c,a

    ld      a,[playerX]
    ld      b,a
    call    map_get_collision
    ret     c

    ; right half
    ld      a,[playerY]
    sub     e
    ld      c,a

    ld      a,[playerX]
    add     PLAYER_HALF_WIDTH - 3
    ld      b,a
    call    map_get_collision
    ret     c

    ; left half
    ld      a,[playerY]
    sub     e
    ld      c,a

    ld      a,[playerX]
    sub     PLAYER_HALF_WIDTH - 2
    ld      b,a
    call    map_get_collision
    ret


; DOWN ----------------------------------------------------------------- DOWN -
player_collision_down:

    ; different height when diving
    ld      a,[playerUnderWater]
    cp      0
    jr      nz,.diving
    ld      e,0
    jr      .check

.diving:
    ld      e,2

.check:

    ; check for normal block collision
    ld      h,1
    call    _player_col_check_down
    ret     c

    ; if pounding check for breaking blocks
    ld      a,[playerIsPounding]
    cp      0
    jr      nz,.pounding

    ; otherwise check for collision with breakable blocks
.col_breakable:
    ld      h,5
    call    _player_col_check_down
    ret

.pounding:
    call    player_pounding_collision
    ret

.platform:
    scf
    ret


_player_col_check_down:
    ; middle
    ld      a,[playerY]
    add     e
    ld      c,a

    ld      a,[playerX]
    ld      b,a
    call    map_get_collision
    cp      h
    jr      z,.col

    ; right half
    ld      a,[playerY]
    add     e
    ld      c,a

    ld      a,[playerX]
    add     PLAYER_HALF_WIDTH - 3
    ld      b,a
    call    map_get_collision
    cp      h
    jr      z,.col

    ; left half
    ld      a,[playerY]
    add     e
    ld      c,a

    ld      a,[playerX]
    sub     PLAYER_HALF_WIDTH - 2
    ld      b,a
    call    map_get_collision
    cp      h
    jr      z,.col

    and     a
    ret

.col:
    scf
    ret


; LEFT ----------------------------------------------------------------- LEFT -
player_collision_far_left:
    ld      h,8
    jr      _player_col_left

player_collision_left:
    ld      h,PLAYER_HALF_WIDTH - 1

_player_col_left:
    ; middle
    ld      a,[playerY]
    sub     a,7
    ld      c,a

    ld      a,[playerX]
    sub     h
    ld      b,a
    call    map_get_collision
    ret     c

    ; upper half
    ld      a,[playerY]
    sub     a,PLAYER_HEIGHT - 1
    ld      c,a

    ld      a,[playerX]
    sub     h
    ld      b,a
    call    map_get_collision
    ret     c

    ; lower half
    ld      a,[playerY]
    sub     1
    ld      c,a

    ld      a,[playerX]
    sub     h
    ld      b,a
    call    map_get_collision
    ret

player_collision_left_all:

    ; middle
    ld      a,[playerY]
    sub     a,7
    ld      c,a
    ld      a,[playerX]
    sub     PLAYER_HALF_WIDTH - 1
    ld      b,a
    call    map_get_collision
    ret     nc

    ; check we leave the upper screen edge
    ld      a,[playerY]
    sub     a,PLAYER_HEIGHT - 1; will underflow if we leave the top screen edge
    cp      128
    jr      nc,.top_of_screen; playerTop >=128
    ld      c,a

    ; upper half
    ld      a,[playerX]
    sub     PLAYER_HALF_WIDTH - 1
    ld      b,a
    call    map_get_collision
    ret     nc

    ; lower half
.top_of_screen:
    ld      a,[playerY]
    sub     1
    ld      c,a

    ld      a,[playerX]
    sub     PLAYER_HALF_WIDTH - 1
    ld      b,a
    call    map_get_collision
    ret


; RIGHT  -------------------------------------------------------------- RIGHT -
player_collision_far_right:
    ld      h,7
    jr      _player_col_right

player_collision_right:
    ld      h,PLAYER_HALF_WIDTH - 2

_player_col_right:
    ; middle
    ld      a,[playerY]
    sub     a,7
    ld      c,a

    ld      a,[playerX]
    add     h
    ld      b,a
    call    map_get_collision
    ret     c

    ; upper half
    ld      a,[playerY]
    sub     a,PLAYER_HEIGHT - 1
    ld      c,a

    ld      a,[playerX]
    add     h
    ld      b,a
    call    map_get_collision
    ret     c

    ; lower half
    ld      a,[playerY]
    sub     1
    ld      c,a

    ld      a,[playerX]
    add     h
    ld      b,a
    call    map_get_collision
    ret

player_collision_right_all:

    ; middle
    ld      a,[playerY]
    sub     a,7
    ld      c,a

    ld      a,[playerX]
    add     PLAYER_HALF_WIDTH - 2
    ld      b,a
    call    map_get_collision
    ret     nc

    ; check we leave the upper screen edge
    ld      a,[playerY]
    sub     a,PLAYER_HEIGHT - 1; will underflow if we leave the top screen edge
    cp      128
    jr      nc,.top_of_screen; playerTop >=128
    ld      c,a

    ; upper half
    ld      a,[playerX]
    add     PLAYER_HALF_WIDTH - 2
    ld      b,a
    call    map_get_collision
    ret     nc

    ; lower half
.top_of_screen:
    ld      a,[playerY]
    sub     1
    ld      c,a

    ld      a,[playerX]
    add     PLAYER_HALF_WIDTH - 2
    ld      b,a
    call    map_get_collision
    ret

