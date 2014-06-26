; Horizontal Player Movement --------------------------------------------------
player_move:

    ; check for landing frames
    ld      a,[playerLandingFrames]
    cp      0
    jp      nz,.landing

    ; are we moving at all?
    ld      a,[playerSpeedLeft]
    ld      b,a
    ld      a,[playerSpeedRight]
    add     a,b
    cp      0
    jp      z,.stopped

    ; set walking animation only when on ground
    ld      a,[playerOnGround]
    cp      1
    jr      nz,.not_on_ground

    ld      a,PLAYER_ANIMATION_WALKING
    ld      [playerAnimation],a
    
.not_on_ground:

    ld      a,[playerInWater]
    cp      0
    jr      z,.not_in_water

    ; half speed when in water
    ld      a,[playerMoveTick]
    cp      1
    jp      nz,.delay
    ld      a,0
    ld      [playerMoveTick],a

.not_in_water:

    ; load x position
    ld      a,[playerX]
    ld      d,a

    ; move right -----------------------------------
.move_right:
    ld      a,[playerSpeedRight]
    cp      0
    jr      z,.move_left
    ld      e,a

    ; reset wall flag
    ld      a,0
    ld      [playerDirectionWall],a

.loop_right:

    call    player_collision_right
    cp      0
    jr      z,.not_blocked_right

    ; set wall flag
    ld      a,PLAYER_DIRECTION_RIGHT
    ld      [playerDirectionWall],a

    ; set pushing animation when not in water
    ld      a,[playerInWater]
    cp      0
    jr      z,.pushing_right
    jr      .idle_right

.pushing_right:
    call    player_collision_right_all
    cp      0
    jr      z,.idle_right
    ld      a,[playerOnGround]
    cp      1
    jr      nz,.idle_right
    ld      a,PLAYER_ANIMATION_PUSHING
    ld      [playerAnimation],a
    jr      .move_left

.idle_right:
    ld      a,PLAYER_ANIMATION_IDLE
    ld      [playerAnimation],a
    jr      .move_left

.not_blocked_right:
    ld      a,[playerInWater]
    cp      1
    jr      nz,.not_in_water_right
    ld      a,PLAYER_ANIMATION_SWIMMING
    ld      [playerAnimation],a

.not_in_water_right:
    inc     d
    ld      a,d
    ld      [playerX],a
    dec     e
    jr      nz,.loop_right


    ; move left ------------------------------------
.move_left:
    ld      a,[playerSpeedLeft]
    cp      0
    jr      z,.moved
    ld      e,a

    ; reset wall flag
    ld      a,0
    ld      [playerDirectionWall],a

.loop_left:

    call    player_collision_left
    cp      0
    jr      z,.not_blocked_left

    ; set wall flag
    ld      a,PLAYER_DIRECTION_LEFT
    ld      [playerDirectionWall],a

    ; set pushing animation when not in water
    ld      a,[playerInWater]
    cp      0
    jr      z,.pushing_left
    jr      .idle_left

.pushing_left:
    call    player_collision_left_all
    cp      0
    jr      z,.idle_left
    ld      a,[playerOnGround]
    cp      1
    jr      nz,.idle_left
    ld      a,PLAYER_ANIMATION_PUSHING
    ld      [playerAnimation],a
    jr      .moved

.idle_left:
    ld      a,PLAYER_ANIMATION_IDLE
    ld      [playerAnimation],a
    jr      .moved

.not_blocked_left:
    ld      a,[playerInWater]
    cp      1
    jr      nz,.not_in_water_left
    ld      a,PLAYER_ANIMATION_SWIMMING
    ld      [playerAnimation],a

.not_in_water_left:
    dec     d
    ld      a,d
    ld      [playerX],a
    dec     e
    jr      nz,.loop_left


    ; moved ----------------------------------------
.moved:
    ld      a,d
    ld      [playerX],a
    ret     z

.stopped: 

    ; reset wall flag when no direction is pressed
    ld      a,[coreInput]
    and     BUTTON_RIGHT | BUTTON_LEFT
    jr      nz,.reset
    ld      a,0
    ld      [playerDirectionWall],a

    ; reset to idle animation if on ground
.reset:
    ld      a,[playerOnGround]
    cp      0
    jr      z,.stopped_water

    ld      a,PLAYER_ANIMATION_IDLE
    ld      [playerAnimation],a
    ret

.stopped_water:
    ld      a,[playerInWater]
    cp      0
    ret     z

    ld      a,PLAYER_ANIMATION_IDLE
    ld      [playerAnimation],a
    ret

.delay:
    inc     a
    ld      [playerMoveTick],a
    ret

.landing:
    dec     a
    ld      [playerLandingFrames],a
    cp      0
    ret     nz

    ld      a,PLAYER_ANIMATION_IDLE
    ld      [playerAnimation],a
    ret


; Horizontal Acceleration -----------------------------------------------------
player_accelerate:

    ; skip during wall jump with forced horizontal movement
    ld      a,[playerWallJumpTick]
    cp      0
    ret     nz

    ; if both directions are pressed at the same time ignore input
    ld      a,[coreInput]
    and     BUTTON_LEFT | BUTTON_RIGHT
    cp      BUTTON_LEFT | BUTTON_RIGHT
    ret     z

    ; check which direction is pressed
    ld      a,[coreInput]
    and     BUTTON_LEFT
    cp      BUTTON_LEFT
    jr      z,.acc_left

    ld      a,[coreInput]
    and     BUTTON_RIGHT
    cp      BUTTON_RIGHT
    jr      z,.acc_right

    ret ; not moving in any direction

.acc_right:
    ld      hl,playerSpeedRight

    ; set player direction
    ld      a,PLAYER_DIRECTION_RIGHT
    ld      [playerDirection],a
    jr      .accelerate

.acc_left:
    ld      hl,playerSpeedLeft

    ; set player direction
    ld      a,PLAYER_DIRECTION_LEFT
    ld      [playerDirection],a

.accelerate:
    ld      a,[playerIsRunning]
    cp      1
    jr      z,.running

    ; load speed from corresponding direction variable 
    ld      a,[hl]
    cp      PLAYER_SPEED_MAX ; check if at max speed
    ret     z
    jr      .increase

.running:

    ; load speed from corresponding direction variable 
    ld      a,[hl]
    cp      PLAYER_SPEED_MAX_RUNNING ; check if at max running speed
    ret     z

    ; if not increase
.increase:
    inc     a
    ld      [hl],a
    ret


player_decelerate:

    ; only decelerate on every 10th frame
    ; this introduces "lag" or a sliding when turning rapidly
    ld      a,[playerDecTick]
    inc     a
    cp      10
    jr      z,.decrease_right

    ; if not on 10th frame store frame count and return
    ld      [playerDecTick],a
    ret

.decrease_right:

    ; check if right direction is still pressed
    ld      a,[coreInput]
    and     BUTTON_RIGHT
    jr      nz,.decrease_left

    ; right
    ld      a,[playerSpeedRight]
    cp      0
    jr      z,.decrease_left
    dec     a
    ld      [playerSpeedRight],a

.decrease_left:

    ; check if left direction is still pressed
    ld      a,[coreInput]
    and     BUTTON_LEFT
    jr      nz,.no_decrease

    ; left
    ld      a,[playerSpeedLeft]
    cp      0
    jr      z,.no_decrease ; if it reached zero we're done

    dec     a
    ld      [playerSpeedLeft],a

.no_decrease:
    ld      a,0
    ld      [playerDecTick],a
    ret
