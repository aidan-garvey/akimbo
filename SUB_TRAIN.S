; -----------------------------------------
; SHAKE CAMERA DEPENDING ON ANIMATION TIMER
; d0.W contains the timer value
SUB_TRAIN_SHAKE_CAM:
    ; if timer % 4 == 0, shake cam depending on timer & 4
    MOVEQ   #0, d1
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
            BRA     @SHAKE_CAM_RET
@SHAKE_CAM_RET:
    RTS

SUB_TRAIN_SCROLL_B:
    ; get current tracks scroll value
    MOVE.W  BUFF_HSCROLLB+54, d0
    ; scroll left by 16px
    SUB.W   #16, d0     ; d0 holds tracks scroll value
    MOVE.W  d0, d1
    LSR.W   #4, d1      ; d1 holds sky scroll value (moves 1/16th the speed of tracks)

    LEA.L   BUFF_HSCROLLB, a0

    MOVE.W  #25, d2     ; first 26 rows
@SCROLL_B_LOOP:
    MOVE.W  d1, (a0)+
    DBRA    d2, @SCROLL_B_LOOP

    ; last 2 rows are tracks
    MOVE.W  d0, (a0)+
    MOVE.W  d0, (a0)+

    RTS

; -----------------------------------------
; UNLOAD A TRAIN CAR FROM BUFF_PLANE
; d1.B contains offset from BUFF_TRAINCAR_1
SUB_TRAIN_UNLOAD_CAR:
    ; point at desired spot for train car
    LEA.L   BUFF_TRAINCAR_1, a0
    ADD.L   d1, a0

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
        ADD.L   d3, a0
        DBRA    d4, @UNLOAD_CAR_ROW

    ; get plane to update
    PUSH    d0-d1

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP     d0-d1

    ; ** clear collision data for train car **
    LEA.L   BUFF_COLLISION, a0
    LSR.B   #4, d1
    ADD.L   d1, a0

    ; need 32 rows of zeroes
    MOVEQ   #0, d3
    MOVEQ   #31, d2
@UNLOAD_COLLISION_ROW:
        MOVE.W  d3, (a0)
        ADDQ    #8, a0
        DBRA    d2, @UNLOAD_COLLISION_ROW

    RTS

; -----------------------------------------
; LOAD A TRAIN CAR INTO BUFF_PLANE
; d1.B contains offset from BUFF_TRAINCAR_1
SUB_TRAIN_LOAD_CAR:
    LEA.L   BUFF_TRAINCAR_1, a0
    ADD.L   d1, a0
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
    ADD.L   d4, a0

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
        ADD.L   d4, a0
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
    ADD.L   d4, a0

    ; ** EIGHTH ROW **
    ; left wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+

    MOVEQ   #14, d4
    ADD.L   d4, a0

    ; right wheel
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    
    ; blank tile
    MOVE.W  #0, (a0)+

    ; queue a DMA transfer
    PUSH    d0-d1

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP     d0-d1

    ; load collision data into BUFF_COLLISION
    LEA.L   BUFF_COLLISION, a0
    LSR.B   #4, d1  ; convert d1 to 0, 2, 4 or 6
    ADD.L   d1, a0  ; a0 points to horizontal offset for current train car
    
    ; we need 24 rows of zeroes
    MOVE.W  #0, d2
    MOVE.W  #23, d3
@COLLISION_EMPTY_LOOP:
    MOVE.W  d2, (a0)
    ; jump to next row
    ADDQ    #8, a0
    DBRA    d3, @COLLISION_EMPTY_LOOP

    ; we need 6 rows of $FFFE
    MOVE.W  #$FFFE, d2
    MOVE.W  #5, d3
@COLLISION_MAIN_LOOP:
    MOVE.W  d2, (a0)
    ADDQ    #8, a0
    DBRA    d3, @COLLISION_MAIN_LOOP

    ; need 2 rows of $FFFF
    MOVE.W  #$FFFF, (a0)
    ADDQ    #8, a0
    MOVE.W  #$FFFF, (a0)

    RTS
