A_GRAVITY = 8   ; acceleration due to gravity
A_FRICTION = 8  ; acceleration due to friction
A_INPUT = 1<<4  ; acceleration due to input
A_JUMP = -8<<4  ; acceleration due to a jump
V_MAX = 64      ; max player speed (right)
V_MIN = -64     ; min player speed (left)

LVL_TRAIN_INIT:
    MOVE.L  #0, GAME_TICK

    ; Initialize Player 1's data
    LEA.L   PLAYER1_X, a0
    MOVE.W  #$70<<4, (a0)+  ; x: 112.0
    MOVE.W  #$70<<4, (a0)+  ; y: 112.0
    MOVE.W  #V_MAX, (a0)+   ; x vel: 2.0 (right)
    MOVE.W  #-8<<4, (a0)+   ; y vel: -8.0 (up)
    MOVE.W  #0, (a0)+       ; flags: 0

    ; Initialize Player 1's sprite
    LEA.L   BUFF_SPRITES, a0
    MOVE.W  #$70, (a0)+     ; vertical pos
    MOVE.W  #$0700, (a0)+   ; 4x2, link = 0
    MOVE.W  #$0001, (a0)+   ; pal 0, no flip, pattern #1
    MOVE.W  #$70, (a0)+     ; horizontal pos

    ; TODO: helicopter sprite to drop off player

    ; start game loop next frame
    MOVE.L  #LVL_TRAIN_1, MAIN_VECTOR

    RTS

LVL_TRAIN_1:
    MOVE.L  GAME_TICK, d0
    ADDQ    #1, d0
    MOVE.L  d0, GAME_TICK
    ; apply constant scrolling effects
    JSR     SUB_TRAIN_SHAKE_CAM
    JSR     SUB_TRAIN_SCROLL_B

    ; **** PLAYER CONTROL ****
    JSR     READJOY
    ; JOY1/2, JOY1/2_OLD are now updated

    ; d5 will contain joypad 1 data in lower byte
    ; (upper is empty): {ST A C B R L D U}
    MOVE.W  JOY1, d5

    ; **** PLAYER MOVEMENT ****

    ; clear onGround flag
    LEA.L   PLAYER1_FLAGS, a2
    ANDI.W  #$7FFF, (a2)

    ; ** adjust Y speed, position **
    LEA.L   PLAYER1_Y, a0
    LEA.L   PLAYER1_VY, a1
    MOVE.W  (a0), d0
    MOVE.W  (a1), d1
    ; add gravity to Y speed
    ADD.W   #A_GRAVITY, d1
    ; apply VY to player's Y position
    ADD.W   d1, d0

    ; TODO: if moving up, check for collision with ceiling
    ; TODO: otherwise, check for collision with ground (set onGround)
    
    ; Quick and dirty collision checking: if y pos is below train cars, there is a collision with the ground
    CMPI.W  #$F00, d0
    BLT     @SKIP_GROUND
    ; if on/below ground:
    MOVE.W  #$F00, d0      ; move player to ground
    ORI.W   #$8000, (a2)    ; set onGround flag
    MOVE.W  #0, d1          ; set vy to 0
@SKIP_GROUND:

    ; save y pos and speed
    MOVE.W  d0, (a0)
    MOVE.W  d1, (a1)


    ; ** adjust X speed, position **
    MOVE.W  -(a0), d0   ; d0 contains PLAYER1_X, a0 points to it
    MOVE.W  -(a1), d1   ; d1 contains PLAYER1_VX, a1 points to it

    ; if left or right was pressed, update direction flag
    ; right: dir = 0 (positive)
    BTST    #3, d5
    BEQ     @DIR_LEFT
    ANDI.B  #%11110111, (a2)
    BRA     @DIR_NONE
    ; left: dir = 1 (negative)
@DIR_LEFT:
    BTST    #2, d5
    BEQ     @DIR_NONE
    ORI.B   #%00001000, (a2)
@DIR_NONE:

    ; if onGround, decrease horizontal speed (friction)
    BTST.B  #7, (a2)
    BEQ     @APPLY_X

    TST.W   d1
    BLT     @FRICTION_ADD
    BEQ     @FRICTION_NONE
    SUB.W   #A_FRICTION, d1
    BRA     @FRICTION_NONE
@FRICTION_ADD:
    ADD.W   #A_FRICTION, d1
@FRICTION_NONE:

    ; if onGround and player moves L/R, adjust vx
    ; right:
    BTST    #3, d5
    BEQ     @INPUT_LEFT
    ADD.W   #A_INPUT, d1
    BRA     @APPLY_X
@INPUT_LEFT:
    ; left:
    BTST    #2, d5
    BEQ     @APPLY_X
    SUB.W   #A_INPUT, d1

@APPLY_X:
    ; restrict vx to range [-16, 16]
    CMPI.W  #V_MIN, d1
    BGT     @LIMIT_VX_UPPER
    MOVE.W  #V_MIN, d1
    BRA     @LIMIT_DONE
@LIMIT_VX_UPPER:
    CMPI.W  #V_MAX, d1
    BLE     @LIMIT_DONE
    MOVE.W  #V_MAX, d1
@LIMIT_DONE:

    ; add vx to player's x position
    ADD.W   d1, d0

    ; TODO: if player hits a wall, move them back

    ; save x pos and x speed
    MOVE.W  d0, (a0)+
    MOVE.W  d1, (a1)+


    ; if onGround and player jumps, add jump value to vy (takes effect next frame)
    ; IDEA: 1- or 2-frame windup animation for jumps?

    ;MOVE.W  (a1), d1    ; d1 = y speed
    ; check onGround
    BTST.B  #7, (a2)
    BEQ     @UPDATE_PLAYER
    ; check A button
    BTST    #6, d5
    BEQ     @UPDATE_PLAYER
    ; change vy to jump value
    MOVE.W  #A_JUMP, d1
    MOVE.W  d1, (a1)

@UPDATE_PLAYER:
    SUBQ    #2, a0      ; a0 points to PLAYER1_X
    ; d0 = floor(x pos)
    ; d1 = floor(y pos)
    MOVE.W  (a0)+, d0
    ASR.W   #4, d0
    MOVE.W  (a0)+, d1
    ASR.W   #4, d1

    ; save data to sprite buffer
    LEA.L   BUFF_SPRITES, a0
    MOVE.W  d1, (a0)+           ; ypos
    MOVE.W  #$0700, (a0)+       ; 4x2 size, link = 0
    ; get direction flag for HFLIP
    MOVE.W  (a2), d2
    ANDI.W  #$0800, d2          ; hflip
    ORI.W   #$0001, d2          ; starts at tile 1
    MOVE.W  d2, (a0)+           ; also sets palette 0
    MOVE.W  d0, (a0)            ; xpos

    RTS
