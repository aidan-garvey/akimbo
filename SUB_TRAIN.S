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

    ; DEBUG: place tile in top-left depending on which car this is
    LSL.W   #8, d1      ; d1 will be colour palette...
    ADD.W   #$0105, d1  ; ...for TRAIN_STRIPES pattern
    MOVE.W  d1, -(a0)
    ADDQ    #2, a0

    ; need 13 of TOP_ROOF
    MOVE.W  (a1), d1
    SWAP    d1
    MOVE.W  (a1)+, d1

    ; do 12 in a loop
    MOVEQ   #5, d3
@LOAD_CAR_ROOF_LOOP:
        MOVE.L  d1, (a0)+
        DBRA    d3, @LOAD_CAR_ROOF_LOOP
    ; do last copy of TOP_ROOF
    MOVE.W  d1, (a0)+
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
        MOVE.W  (a1), d1
        SWAP    d1
        MOVE.W  (a1)+, d1
        ; do 12 in a loop
        MOVEQ   #5, d3
@LOAD_CAR_MIDMID_LOOP:
            MOVE.L  d1, (a0)+
            DBRA    d3, @LOAD_CAR_MIDMID_LOOP
        ; last copy of MID_MID
        MOVE.W  d1, (a0)+
        ; do MID_RIGHT
        MOVE.W  (a1)+, (a0)+
        ; blank tile
        MOVE.W  #0, (a0)+

        ; jump to next row
        ADD.L   d4, a0
        DBRA    d5, @LOAD_CAR_MIDROW_LOOP

    ; ** ROW 7 **
    ; need 15 copies of caution stripes
    MOVE.W  (a1), d1
    SWAP    d1
    MOVE.W  (a1)+, d1

    ; do 14 in a loop
    MOVEQ   #6, d3
@LOAD_CAR_CAUTION_LOOP:
        MOVE.L  d1, (a0)+
        DBRA    d3, @LOAD_CAR_CAUTION_LOOP
    ; do last copy
    MOVE.W  d1, (a0)+
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
    PUSH    d0

    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    POP     d0

    RTS
