; -----------------------------------------
; Shake camera depending on animation timer
; d0.W contains the timer value
SUB_TRAIN_SHAKE_CAM:
    ; if timer % 4 == 0, shake cam depending on timer & 4
    MOVE.W  d0, d1
    ANDI.W  #3, d1
    BNE     @SHAKE_CAM_RET
        LEA.L   SCROLL_Y, a0
        MOVE.L  (a0), d1
        ; if timer & 4 == 1, shake down
        BTST    #2, d0
        BNE     @SHAKE_CAM_DOWN
            ; shake up
            ADD.L   #$10001, d1
            MOVE.L  d1, (a0)
            BRA     @SHAKE_CAM_RET
@SHAKE_CAM_DOWN:
            ; shake down
            SUB.L   #$10001, d1
            MOVE.L  d1, (a0)
@SHAKE_CAM_RET:
    RTS

; --------------------------------
; Update player's sprite on screen
SUB_TRAIN_PLAYER_SPRITE:
    LEA.L   PLAYER1_X, a0   ; a0 points to PLAYER1_X
    ; d0 = floor(x pos)
    ; d1 = floor(y pos)
    MOVE.W  (a0)+, d0
    ASR.W   #4, d0
    MOVE.W  (a0)+, d1
    ASR.W   #4, d1

    ; adjust player's y position by same rules as camera shake
        ; (see above subroutine for more info)
    ;MOVE.L  GAME_TICK, d2
    ;ANDI.W  #$0004, d2
    ;LSR.W   #2, d2
    ;ADD.W   d2, d1

    ; save data to sprite buffer
    LEA.L   BUFF_SPRITES, a0
    MOVE.W  d1, (a0)+           ; ypos
    MOVE.W  #$0700, (a0)+       ; 4x2 size, link = 0
    ; get direction flag for HFLIP
    MOVE.W  (PLAYER1_FLAGS), d2
    ANDI.W  #$0800, d2          ; hflip
    ORI.W   #$0001, d2          ; graphics start at char 1
    MOVE.W  d2, (a0)+           ; also sets palette to 0
    MOVE.W  d0, (a0)            ; xpos

    RTS

; ----------------------------------------------
; Update first entry of HSCROLL_A based on MAP_X
SUB_TRAIN_SCROLL_A:
    ; HSCROLL_A will be based on MAP_X
    MOVE.L  MAP_X, d0
    NEG.L   d0
    ASR.L   #4, d0
    LEA.L   BUFF_HSCROLLA, a0

    ; 28 rows of cells on screen
    MOVEQ   #27, d1
@SUB_TRAIN_SCROLL_A_LOOP:
        MOVE.W  d0, (a0)+
        DBRA    d1, @SUB_TRAIN_SCROLL_A_LOOP
    
    RTS


SUB_TRAIN_SCROLL_B:
    ; get current tracks scroll value
    MOVE.W  (BUFF_HSCROLLB+54), d0
    ; scroll left by 16px
    SUB.W   #16, d0     ; d0 holds tracks scroll value
    MOVE.W  d0, d1
    LSR.W   #7, d1      ; d1 holds sky scroll value (moves 1/128 the speed of tracks)

    LEA.L   BUFF_HSCROLLB, a0

    MOVEQ   #25, d2     ; first 26 rows are sky, move at slower speed
@SCROLL_B_LOOP:
    MOVE.W  d1, (a0)+
    DBRA    d2, @SCROLL_B_LOOP

    ; last 2 rows are tracks, move at faster speed
    MOVE.W  d0, (a0)+
    MOVE.W  d0, (a0)+

    RTS

; ---------------------------------------------------
; LOAD COLLISION DATA FOR A TRAINCAR INTO RAM
; d1.W contains offset from COLL_0 (multiple of $100)
; a1 points to collision data to copy
; THRASHED: d0, a0
SUB_TRAIN_LOAD_COLLISION:
    ; a0 points to destination
    LEA.L   COLL_0, a0
    ADDA.W  d1, a0

    ; d0 will contain the number of lines to copy
    MOVE.W  (a1), d0    ; get up-facing count
    MOVE.L  (a1)+, (a0)+; copy up-facing count and offset
    
    ADD.W   (a1), d0    ; add down-facing count
    MOVE.L  (a1)+, (a0)+; copy down-facing count and offset

    ADD.W   (a1), d0    ; add left-facing count
    MOVE.L  (a1)+, (a0)+; copy down-facing count and offset

    ADD.W   (a1), d0    ; add left-facing count
    MOVE.L  (a1)+, (a0)+; copy down-facing count and offset

    ; copy each line in a loop
    ; subtract one from count for the loop
    SUBQ.W  #1, d0
@SUB_TRAIN_LOAD_COLLISION_LOOP:
        MOVE.L  (a1)+, (a0)+
        MOVE.W  (a1)+, (a0)+
        DBRA    d0, @SUB_TRAIN_LOAD_COLLISION_LOOP
    
    RTS

; -----------------------------------------------
; UPDATE CONTENTS OF PLANE A AND COLLISION BUFFER
SUB_TRAIN_UPDATE_MAP:

    ; load new car whenever we cross scroll value of $000, $080, $100 or $180

    ; calculate this frame and last frame's scroll values

    MOVE.L  MAP_X, d0
    MOVE.L  MAP_X_OLD, d1

    MOVE.L  d0, d2
    MOVE.L  d1, d3

    ANDI.W  #$1800, d2
    ANDI.W  #$1800, d3
    CMP.W   d2, d3

    ; return if we haven't crossed a boundary
    BEQ     @UPDATE_MAP_RET

    ; determine offset in buffer to write traincar to

    ;   d2  -> offset
    ; $0000 -> $60
    ; $0800 -> $00
    ; $1000 -> $20
    ; $1800 -> $40
    
    ; d2>>6 -> offset
    ; $0000 -> $60
    ; $0020 -> $00
    ; $0040 -> $20
    ; $0060 -> $40

    LSR.W   #6, d2
    
    ; d3 := MAP_X
    MOVE.L  d0, d3

    CMP.W   d1, d0
    BLT     @UPDATE_LEFT
    ; (d2>>6 + $60) & $7F = offset
    ADD.W   #$60, d2
    ANDI.W  #$7F, d2
    ; moving right, we know that MAP_X>>4 is greater than or equal to the multiple of $80
    ; so position of car is MAP_X>>4 & 0xFFFF FF80 + $180 (3 cars to the right of the multiple of $80)
    ; carPos = MAP_X & 0xFFFF F800 + $1800
    ADD.L   #$1800, d3
    ; (bitwise AND done after fallthru)
@UPDATE_LEFT:
    ; d2>>6 = offset, so don't change it
    ; moving left, MAP_X>>4 is less than multiple of $80
    ; therefore, car is at MAP_X>>4 & 0xFFFF FF80
    ; carPos = MAP_X & 0xFFFF F800
    ANDI.L  #$FFFFF800, d3
    MOVE.W  d2, d1
    
    ; status:
    ; d0 = MAP_X
    ; d1 = traincar offset
    ; d2 = d1
    ; d3 = traincar position in map coordinates

    ; for now, train will end at MAP_X_START and go on forever
    CMPI.L  #MAP_X_START, d3
    BLT     @UPDATE_UNLOAD

    ; testing loading an interior car
    CMPI.B  #$60, d2
    BNE     @LOAD_EXTERIOR_CAR

    JSR     SUB_TRAIN_LOAD_INT_CAR
    RTS

@LOAD_EXTERIOR_CAR:
    JSR     SUB_TRAIN_LOAD_CAR
    RTS
    ; BRA     @UPDATE_MAP_RET

@UPDATE_UNLOAD:
    JSR     SUB_TRAIN_UNLOAD_CAR
@UPDATE_MAP_RET:
    RTS


; -----------------------------------------
; UNLOAD A TRAIN CAR FROM BUFF_PLANE
; d1.B contains offset from BUFF_TRAINCAR_1
SUB_TRAIN_UNLOAD_CAR:
    ; point at desired spot for train car
    LEA.L   BUFF_TRAINCAR_1, a0
    ANDI.W  #$00FF, d1
    ADDA.W  d1, a0

    MOVEQ   #0, d2
    MOVEQ   #$60, d3
    ; eight rows
    MOVEQ   #7, d4
@UNLOAD_CAR_ROW:
        ; 16 tiles, 2 tiles/longword
        MOVEQ   #7, d5
@UNLOAD_CAR_TILE:
            MOVE.L  d2, (a0)+
            DBRA    d5, @UNLOAD_CAR_TILE
        ADDA.W  d3, a0
        DBRA    d4, @UNLOAD_CAR_ROW

    ; get plane to update
    PUSH    d1-d2

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP d1-d2

    ; clear collision data for train car

    ; we'll fill the memory with zeroes that are in d2
    
    ; convert d1 from multiple of $20 to multiple of $100
    LSL.W   #3, d1
    ; get offset in collision data for train car
    LEA.L   COLL_0, a0
    ADDA.W  d1, a0
    ; we'll copy $D0 bytes = $34 longwords
    MOVEQ   #$33, d0
@UNLOAD_CAR_COLL_LOOP:
    MOVE.L  d2, (a0)+
    DBRA    d0, @UNLOAD_CAR_COLL_LOOP

    RTS

; -----------------------------------------
; LOAD A TRAIN CAR INTO BUFF_PLANE
; d1.B contains offset from BUFF_TRAINCAR_1
SUB_TRAIN_LOAD_CAR:
    LEA.L   BUFF_TRAINCAR_1, a0
    ; ANDI.L  #$000000FF, d1
    ; ADD.L   d1, a0
    ANDI.W  #$00FF, d1
    ADDA.W  d1, a0
    LEA.L   TRAIN_TOP_LEFT, a1

    MOVEQ   #$60, d4    ; d4 will hold the offset to jump to the next row

    ; ** FIRST ROW **

    ; load TOP_LEFT
    MOVE.W  (a1)+, (a0)+

    ; need 13 of TOP_ROOF
    MOVE.W  (a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; do 12 in a loop
    MOVEQ   #5, d3
@LOAD_CAR_ROOF_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d3, @LOAD_CAR_ROOF_LOOP
    ; do last copy of TOP_ROOF
    MOVE.W  d2, (a0)+
    ; do TOP_RIGHT
    MOVE.W  (a1)+, (a0)+
    ; do blank tile
    MOVE.W  #0, (a0)+

    ; jump to next row
    ADDA.W  d4, a0

    ; ** ROWS 2-6 **
    MOVEQ   #4, d5
@LOAD_CAR_MIDROW_LOOP:
        LEA.L   TRAIN_MID_LEFT, a1
        MOVE.W  (a1)+, (a0)+
        MOVE.W  (a1), d2
        SWAP    d2
        MOVE.W  (a1)+, d2
        ; do 12 in a loop
        MOVEQ   #5, d3
@LOAD_CAR_MIDMID_LOOP:
            MOVE.L  d2, (a0)+
            DBRA    d3, @LOAD_CAR_MIDMID_LOOP
        ; last copy of MID_MID
        MOVE.W  d2, (a0)+
        ; do MID_RIGHT
        MOVE.W  (a1)+, (a0)+
        ; blank tile
        MOVE.W  #0, (a0)+

        ; jump to next row
        ADDA.W  d4, a0
        DBRA    d5, @LOAD_CAR_MIDROW_LOOP

    ; ** ROW 7 **
    ; need 15 copies of caution stripes
    MOVE.W  (a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; do 14 in a loop
    MOVEQ   #6, d3
@LOAD_CAR_CAUTION_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d3, @LOAD_CAR_CAUTION_LOOP
    ; do last copy
    MOVE.W  d2, (a0)+
    ; copy connector
    MOVE.W  (a1)+, (a0)+

    ; jump to next row
    ADDA.W  d4, a0

    ; ** EIGHTH ROW **
    ; left wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+

    MOVEQ   #14, d4
    ADDA.W  d4, a0

    ; right wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    
    ; blank tile
    MOVE.W  #0, (a0)+

    ; queue a DMA transfer
    PUSH    d1

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP     d1

    ; transfer collision data from COLL_TRAIN to RAM

    ; d1 is $00, $20, $40 or $60
    ; in RAM, collision slots separated by $100
    LSL.W   #3, d1
    ; a1 points to collision data to copy
    LEA.L   COLL_TRAIN_EXT, a1

    JSR     SUB_TRAIN_LOAD_COLLISION

;    ; a0 points to destination
;    LEA.L   COLL_0, a0
;    ADDA.W  d1, a0
;    ; we will copy over $D0 bytes, $34 longwords
;    MOVEQ   #$33, d0
;@LOAD_CAR_COLL_LOOP:
;    MOVE.L  (a1)+, (a0)+
;    DBRA    d0, @LOAD_CAR_COLL_LOOP
;
    RTS

; ---------------------------------------------
; LOAD A TRAINCAR WITH INTERIOR INTO BUFF_PLANE
; d1.B contains offset from BUFF_TRAINCAR_1
SUB_TRAIN_LOAD_INT_CAR:
    LEA.L   BUFF_TRAINCAR_1, a0
    ANDI.W  #$00FF, d1
    ADDA.W  d1, a0
    LEA.L   TRAIN_INSIDE_TOP_LEFT, a1

    MOVEQ   #$60, d4    ; d4 will hold the offset to jump to the next row
    MOVEQ   #0, d5      ; d5 will hold all zeroes for transparent tiles

    ; ** FIRST ROW **
    ; top left
    MOVE.W  (a1)+, (a0)+
    ; need 13 of TRAIN_INSIDE_ROOF
    MOVE.W  (a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; do 12 in a loop
    MOVEQ   #5, d0
@LOAD_INT_ROOF_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d0, @LOAD_INT_ROOF_LOOP

    ; last one
    MOVE.W  d2, (a0)+
    ; top right
    MOVE.W  (a1)+, (a0)+
    ; blank char
    MOVE.W  d5, (a0)+
    ; jump to next row
    ADDA.W  d4, a0

    ; ** SECOND, THIRD ROWS **
    ; need to repeat the next row twice:
    MOVEQ   #1, d3
    ; save current address so we can return to it for the second row
    MOVE.L  a1, a2
@LOAD_INT_DARK_ROW:
        MOVE.L  a2, a1
        ; left side
        MOVE.W  (a1)+, (a0)+
        ; need 13 of TRAIN_INSIDE_DARK
        MOVE.W  (a1), d2
        SWAP    d2
        MOVE.W  (a1)+, d2

        ; do 12 in a loop
        MOVEQ   #5, d0
@LOAD_INT_DARK_LOOP:
            MOVE.L  d2, (a0)+
            DBRA    d0, @LOAD_INT_DARK_LOOP
        
        ; last one
        MOVE.W  d2, (a0)+
        ; right side
        MOVE.W  (a1)+, (a0)+
        ; blank char
        MOVE.W  d5, (a0)+

        ; jump to next row
        ADDA.W  d4, a0

        BCHG    #0, d3
        BNE     @LOAD_INT_DARK_ROW
    
    ; ** FOURTH ROW **
    
    ; left side
    MOVE.W  (a1)+, (a0)+
    ; 13 of TRAIN_INSIDE_DITHER
    MOVE.W  (a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; 12 in a loop
    MOVEQ   #5, d0
@LOAD_INT_DITHER_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d0, @LOAD_INT_DITHER_LOOP
    
    ; last one
    MOVE.W  d2, (a0)+
    ; right side
    MOVE.W  (a1)+, (a0)+
    ; blank char
    MOVE.W  d5, (a0)+

    ; jump to next row
    ADDA.W  d4, a0

    ; ** FIFTH ROW **
    
    ; left side - save in d3 for next row
    MOVE.W  (a1)+, d3
    MOVE.W  d3, (a0)+
    ; back wall x 2
    MOVE.W  (a1), (a0)+
    MOVE.W  (a1)+, (a0)+
    ; crate spanning two cells
    MOVE.L  (a1), (a0)+
    ; need 9 of INSIDE_LIGHT
    MOVE.W  -(a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; do 8 in a loop
    MOVEQ   #3, d0
@LOAD_INT_LIGHT_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d0, @LOAD_INT_LIGHT_LOOP
    
    ; last one
    MOVE.W  d2, (a0)+
    ; a1 points at CRATE_LEFT, we want pattern 2 words after that
    ADDQ.L  #4, a1
    ; right side
    MOVE.W  (a1)+, (a0)+
    ; blank char
    MOVE.W  d5, (a0)+
    
    ; jump to next row
    ADDA.W  d4, a0

    ; ** SIXTH ROW **
    ; d2 still contains INSIDE_LIGHT
    ; d3 contains INSIDE_LEFT_LIGHT
    ; a1 points to FULL_CRATE

    ; left side
    MOVE.W  d3, (a0)+
    ; 2 x INSIDE_LIGHT
    MOVE.L  d2, (a0)+
    ; 2 x FULL_CRATE
    MOVE.W  (a1), (a0)+
    MOVE.W  (a1), (a0)+
    ; 6 x INSIDE_LIGHT
    MOVE.L  d2, (a0)+
    MOVE.L  d2, (a0)+
    MOVE.L  d2, (a0)+
    ; crate spanning two cells
    LEA.L   TRAIN_HALF_CRATE_LEFT, a2
    MOVE.L  (a2)+, (a0)+
    ; full crate
    MOVE.W  (a1), (a0)+
    ; right side
    MOVE.W  (a2), (a0)+
    ; blank char
    MOVE.W  d5, (a0)+

    ; jump to next row
    ADDA.W  d4, a0

    ; ** SEVENTH ROW **

    ; next two rows same as the other train car
    LEA.L   TRAIN_STRIPES, a1
    MOVE.W  (a1), d2
    SWAP    d2
    MOVE.W  (a1)+, d2

    ; need 15 of stripes
    ; do 14 in a loop
    MOVEQ   #6, d0
@LOAD_INT_CAUTION_LOOP:
        MOVE.L  d2, (a0)+
        DBRA    d0, @LOAD_INT_CAUTION_LOOP
    ; last one
    MOVE.W  d2, (a0)+
    ; connector
    MOVE.W  (a1)+, (a0)+

    ; jump to next row
    ADDA.W  d4, a0

    ; ** EIGTH ROW **

    ; left wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    ; 7 blanks
    MOVE.L  d5, (a0)+
    MOVE.L  d5, (a0)+
    MOVE.L  d5, (a0)+
    MOVE.W  d5, (a0)+
    ; right wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    ; 1 blank
    MOVE.W  d5, (a0)

    ; queue a DMA transfer
    PUSH    d1

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP     d1

    ; transfer collision data from COLL_TRAIN to RAM

    ; d1 is $00, $20, $40 or $60
    ; in RAM, collision slots separated by $100
    LSL.W   #3, d1
    ; a1 points to collision data to copy
    LEA.L   COLL_TRAIN_INT, a1
    
    JSR     SUB_TRAIN_LOAD_COLLISION

    RTS

