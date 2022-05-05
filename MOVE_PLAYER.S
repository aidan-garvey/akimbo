
A_GRAVITY = 8   ; acceleration due to gravity
A_FRICTION = 5  ; acceleration due to friction
A_INPUT_GR = 8  ; acceleration due to input on ground
A_INPUT_AIR = 3 ; acceleration due to input in the air
A_JUMP = -8<<4  ; acceleration due to a jump
V_MAX = 6<<4    ; max player velocity (right)
V_MIN = -6<<4   ; min player velocity (left)
V_STATIC = 6    ; if speed is within this much of 0, player stops due to static friction

SCREEN_X_L = $080       ; x coord for left side of screen
SCREEN_X_R = $1C0       ; x coord for right side of screen
SCROLL_X_BOUND = $40    ; offset from screen edge for scrolling
SCROLL_SPEED = 8<<4     ; max speed the screen can scroll at


; clear onGround
; add gravity to y speed
; add y speed to y position
; if y speed is positive or 0 and player is on/below the floor, set onGround,
    ; move player up to the floor and set y speed to 0
; if y speed is negative, check for collision with ceiling,
    ; adjust position and clear y speed if applicable
; if onGround, decrease x speed (friction)
; if left/right was pressed, update player's direction and x speed
; restrict x speed to range [V_MIN, V_MAX]
; add x speed to x position, check collisions
; if onGround, and player is pressing jump button, and they were not pressing
    ; it last frame, increase y speed accordingly (applies to y position next frame)
; if player is not within designated screen area, move player into area
    ; and change MAP_X/Y by opposite amount

; ---------------------------------------
; MOVE PLAYER BASED ON VELOCITY AND INPUT
MOVE_PLAYER:
    ; d5 will hold player input
    MOVE.W  JOY1, d5

    ; clear onGround
    LEA.L   PLAYER1_FLAGS, a2
    ANDI.W  #$7FFF, (a2)

    ; ** adjust Y position **
    LEA.L   PLAYER1_Y, a0
    LEA.L   PLAYER1_VY, a1
    MOVE.W  (a0), d0
    MOVE.W  (a1), d1
    ; add gravity to y speed
    ADD.W   #A_GRAVITY, d1
    ; apply y speed to y position
    ADD.W   d1, d0

    ; Quick and dirty collision checking: if y pos is below train cars, there is a collision with the ground
    CMPI.W  #$F00, d0
    BLT     @Y_COLLISION_END
    ; if on/below ground:
    MOVE.W  #$F00, d0       ; move player to ground
    ORI.W   #$8000, (a2)    ; set onGround flag
    MOVE.W  #0, d1          ; set vy to 0

    ; if y speed is positive or 0 and player is on/below the floor, set onGround,
        ; move player up to the floor and set y speed to 0
    ;TST.W   d1
    ;BLT     @Y_COLLISION_ABOVE
    ; check for collision with ground (use player y pos + 31 pixels for bottom of sprite)
    ;BRA     @Y_COLLISION_END
@Y_COLLISION_ABOVE:
    ; if y speed is negative, check for collision with ceiling,
        ; adjust position and clear y speed if applicable
    ; ...
@Y_COLLISION_END:
    ; save values for Y, VY
    MOVE.W  d0, (a0)
    MOVE.W  d1, (a1)

    ; ** adjust X position **
    MOVE.W  -(a0), d0   ; d0 contains PLAYER1_X, a0 points to it
    MOVE.W  -(a1), d1   ; d1 contains PLAYER1_VX, a1 points to it

    ; if onGround, decrease x speed (friction)
    BTST.B  #7, (a2)
    BEQ     @NO_FRICTION

    TST.W   d1
    BLT     @FRICTION_LEFT
    BEQ     @NO_FRICTION
@FRICTION_RIGHT:
    ; if 0 < speed <= than static friction, set to 0
    CMPI.W  #V_STATIC, d1
    BGT     @FRICTION_SUB
    MOVE.W  #0, d1
    BRA     @NO_FRICTION
@FRICTION_SUB:
    ; if speed > static friction > 0, subtract accel. due to friction
    SUB.W   #A_FRICTION, d1
    BRA     @NO_FRICTION
@FRICTION_LEFT:
    ; if 0 > speed >= -static friction, set to 0
    CMPI.W  #-V_STATIC, d1
    BLT     @FRICTION_ADD
    MOVE.W  #0, d1
    BRA     @NO_FRICTION
@FRICTION_ADD:
    ; if speed < static friction < 0, add accel. due to friction
    ADD.W   #A_FRICTION, d1
@NO_FRICTION:

@INPUT_X_RIGHT:
    ; if left/right was pressed, update player's direction and x speed
    ; right: direction = 0 (positive)
    BTST    #3, d5
    BEQ     @INPUT_X_LEFT
    ; set direction to right
    ANDI.B  #%11110111, (a2)
    ; speed depends on player being in the air
    BTST.B  #7, (a2)
    BEQ     @INPUT_X_RIGHT_AIR
    ; if on ground, add A_INPUT_GR to speed
    ADD.W   #A_INPUT_GR, d1
    BRA     @INPUT_X_NONE
@INPUT_X_RIGHT_AIR:
    ; if in the air, add A_INPUT_AIR to speed
    ADD.W   #A_INPUT_AIR, d1
    BRA     @INPUT_X_NONE
@INPUT_X_LEFT:
    ; left: direction = 1 (negative)
    BTST    #2, d5
    BEQ     @INPUT_X_NONE
    ; set direction to left
    ORI.B   #%00001000, (a2)
    ; speed depends on player being in the air
    BTST.B  #7, (a2)
    BEQ     @INPUT_X_LEFT_AIR
    ; if on ground, subtract A_INPUT_GR from speed
    SUB.W   #A_INPUT_GR, d1
    BRA     @INPUT_X_NONE
@INPUT_X_LEFT_AIR:
    ; if in the air, subtract A_INPUT_AIR from speed
    SUB.W   #A_INPUT_AIR, d1
@INPUT_X_NONE:

    ; restrict x speed to range [V_MIN, V_MAX]
    CMPI.W  #V_MIN, d1
    BGT     @LIMIT_VX_UPPER
    MOVE.W  #V_MIN, d1
    BRA     @LIMIT_DONE
@LIMIT_VX_UPPER:
    CMPI.W  #V_MAX, d1
    BLE     @LIMIT_DONE
    MOVE.W  #V_MAX, d1
@LIMIT_DONE:

    ; add x speed to x position, check collisions
    ADD.W   d1, d0


    ; save x pos and speed
    MOVE.W  d0, (a0)+   ; a0 now points at y pos
    MOVE.W  d1, (a1)+   ; a1 now points at vy

    ; if onGround, and player is pressing jump button, and they were not pressing
        ; it last frame, increase y speed accordingly (applies to y position next frame)
    
    ; check onGround
    BTST.B  #7, (a2)
    BEQ     @JUMP_DONE
    ; check A button
    BTST    #6, d5
    BEQ     @JUMP_DONE
    ; check if A was pressed last frame
    MOVE.W  JOY1_OLD, d6
    BTST    #6, d6
    BNE     @JUMP_DONE
    ; change vy to jump value
    MOVE.W  #A_JUMP, d1
    MOVE.W  d1, (a1)
@JUMP_DONE:

    ; if player is not within designated screen area, move player into area
        ; and change MAP_X/Y by corresponding amount
        ; for now, only x scrolling
    
    MOVEQ   #0, d0
    ; load x and vx into d0 and d1
    MOVE.W  -(a0), d0
    MOVE.W  -(a1), d1
    ; load MAP_X into a4
    LEA.L   MAP_X, a4
    ; save value in MAP_X_OLD before overwriting
    MOVE.L  (a4), MAP_X_OLD
    ; load BUFF_HSCROLLA into a3
    LEA.L   BUFF_HSCROLLA, a3

    ; determine scroll direction based on speed
    TST.W   d1
    BLT     @SCROLL_X_LEFT
    BGT     @SCROLL_X_RIGHT
    ; if speed is zero, scrolling depends on direction player is facing
    BTST.B  #3, (a2)
    BNE     @SCROLL_X_LEFT
@SCROLL_X_RIGHT:
    ; if x > SCREEN_X_L + SCROLL_X_BOUND, scroll by SCREEN_X_L + SCROLL_X_BOUND - x
    SUBI.L  #(SCREEN_X_L+SCROLL_X_BOUND)<<4, d0
    BLE     @SCROLL_X_DONE
    ; limit scroll amount to SCROLL_SPEED
    MINI.L  #SCROLL_SPEED, d0
    ; scroll left by difference (to move the camera to the right)
    SUB.W   d0, (a0)
    ADD.L   d0, (a4)
    BRA     @SCROLL_X_DONE
@SCROLL_X_LEFT:
    ; if x < SCREEN_X_R - SCROLL_X_BOUND, scroll by SCREEN_X_R - SCROLL_X_BOUND - x
    SUBI.L  #(SCREEN_X_R-SCROLL_X_BOUND)<<4, d0
    BGT     @SCROLL_X_DONE
    ; limit scroll amount to -SCROLL_SPEED
    MAXI.L  #-SCROLL_SPEED, d0
    ; scroll right by difference (to move the camera to the right)
    SUB.W   d0, (a0)
    ADD.L   d0, (a4)
@SCROLL_X_DONE:
    
    RTS
