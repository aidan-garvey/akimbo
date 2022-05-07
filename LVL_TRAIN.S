
LVL_TRAIN_INIT:
    MOVE.L  #0, GAME_TICK

    ;; set MAP_X to current scroll value for plane A
    ;MOVEQ   #0, d0
    ;MOVE.W  BUFF_HSCROLLA, d0
    ;LSL.L   #4, d0
    ;NEG.L   d0
    ;MOVE.L  d0, MAP_X
    
    ; start MAP_X at lowest positive number that is
    ; aligned with current horizontal scroll value
    MOVE.L  #MAP_X_START, MAP_X

    ; Initialize Player 1's data
    LEA.L   PLAYER1_X, a0
    MOVE.W  #$70<<4, (a0)+  ; x: 112.0
    MOVE.W  #$70<<4, (a0)+  ; y: 112.0
    MOVE.W  #64, (a0)+      ; x vel: 2.0 (right)
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

    ADDI.L  #$10001, (SCROLL_Y)

    RTS

LVL_TRAIN_1:
    MOVE.L  GAME_TICK, d0
    ADDQ    #1, d0
    MOVE.L  d0, GAME_TICK

    ; apply constant scrolling effects
    ; JSR     SUB_TRAIN_SHAKE_CAM
    JSR     SUB_TRAIN_SCROLL_B

    ; handle player movement
    JSR     MOVE_PLAYER
    ; update player sprite position
    JSR     SUB_TRAIN_PLAYER_SPRITE
    ; scroll the map
    JSR     SUB_TRAIN_SCROLL_A
    ; load in new cars if needed
    JSR     SUB_TRAIN_UPDATE_MAP
    
    RTS
