; ****************
;   CIN_TRAINS.S
; ----------------
; Subroutines for
; the train level
; intro cinematic.
; ****************

; ======================================
; Train Cinematic
; --------------------------------------
; 1) Camera pans down to train tracks
; 2) Train speeds by screen
; 3) Camera begins following train
; 4) Back of train comes into view
; ======================================
; Subroutines:
; --------------------------------------
; INIT: Set up VDP and RAM buffers
; WAIT_1: Small pause before animation
; 1: Pan camera down to tracks, load in
;   first train car on last frame
; WAIT_2: Shake camera with increasing
;   speed as train approaches
; 2: Scroll train past camera, load in
;   the rest of the cars
; WAIT_3: Keep scrolling train and
;   shaking camera for a bit
; 3: Slow train's scrolling to 0, speed
;   up plane B's scrolling to the left
;   proportionally, un-load last train
;   car near the end
; ======================================

; note: maybe move loading in the car to INIT?

; Initialize memory for cinematic
CIN_TRAIN_INIT:
    MOVE.L  #CIN_TRAIN_WAIT_1, MAIN_VECTOR
    MOVE.L  #0, CIN_TRAIN_TIMER
    ; Full VScroll, Cell-by-cell HScroll
    VDP_REG 11, %00000010
    ; set VScroll to 48 for plane A, 0 for plane B
    MOVE.L  #$00300000, SCROLL_Y
    ; TODO: if necessary, clear BUFF_HSCROLL

    ; clear BUFF_PLANE
    LEA.L   BUFF_PLANE, a0
    MOVEQ   #0, d0

    MOVE.W  #$400, d1
@CIN_TRAIN_INIT_CLEAR:
    MOVE.L  d0, (a0)+
    DBRA    d1, @CIN_TRAIN_INIT_CLEAR
    
    RTS

; -------------------------------------
; HOLD FOR 1 SEC BEFORE ANIMATION PLAYS
CIN_TRAIN_WAIT_1:
    ADD.W   #1, CIN_TRAIN_TIMER
    CMPI.W  #$60, CIN_TRAIN_TIMER
    BLT     @TRAIN_WAIT_1_RET

    MOVE.W  #0, CIN_TRAIN_TIMER
    MOVE.L  #CIN_TRAIN_1, MAIN_VECTOR

@TRAIN_WAIT_1_RET
    RTS

; -------------------------------
; PAN CAMERA DOWN TO TRAIN TRACKS
CIN_TRAIN_1:
    ; increment timer
    ADD.W   #1, CIN_TRAIN_TIMER
    ; increase Plane B vertical scroll by timer/4
    MOVE.W  CIN_TRAIN_TIMER, d0
    LSR.W   #2, d0
    MOVE.W  d0, SCROLLB_Y
    ; check if we've scrolled 32 pixels
    CMPI.W  #32, d0
    BLT     @CIN_TRAIN_1_RETURN

        ; once we're done scrolling, clear timer and switch to stage 2
        CLR.W   CIN_TRAIN_TIMER
        MOVE.L  #CIN_TRAIN_WAIT_2, MAIN_VECTOR

        ; **** set up stage 2 by loading in front of train ****

        LEA.L   BUFF_TRAINCAR_4, a0
        ; d1 will contain blank patterns
        ; MOVEQ   #0, d1
        ; d2 will contain two very frequently used patterns
        MOVE.L  ENGINE_SIDE_LEFT, d2    ; (lower word is ENGINE_FILL)
        ; d3 will contain two copies of ENGINE_FILL
        MOVE.W  d2, d3
        SWAP    d3
        MOVE.W  d2, d3
        ; a2 will iterate through the rest of the patterns
        LEA.L   ENGINE_ROW_1, a2

        ; ** FIRST ROW **
        MOVE.L  (a2)+, (a0)+
        MOVE.L  (a2)+, (a0)+
        MOVE.L  (a2)+, (a0)+

        ; ** SECOND ROW **
        LEA.L   BUFF_TRAINCAR_4+$80, a0
        ; need 1 SIDE_LEFT and 5 FILLs
        MOVE.L  d2, (a0)+   ; side, 1 fill
        MOVE.L  d3, (a0)+   ; 3 fills
        MOVE.L  d3, (a0)+   ; 5 fills

        ; a2 is pointing at ENGINE_ROW_2
        MOVE.L  (a2)+, (a0)+
        MOVE.W  (a2)+, (a0)+

        ; ** THIRD ROW **
        LEA.L   BUFF_TRAINCAR_4+$100, a0
        ; need 1 SIDE_LEFT and 6 FILLs
        MOVE.L  d2, (a0)+   ; side, 1 fill
        MOVE.L  d3, (a0)+   ; 3 fills
        MOVE.L  d3, (a0)+   ; 5 
        MOVE.W  d3, (a0)+   ; 6 fills

        ; copy ENGINE_ROW_3
        MOVE.L  (a2)+, (a0)+
        MOVE.L  (a2)+, (a0)+
        MOVE.W  (a2)+, (a0)+

        ; ** FOURTH ROW **
        LEA.L   BUFF_TRAINCAR_4+$180, a0
        ; need 1 side and 10 fills
        MOVE.L  d2, (a0)+   ; 1 
        MOVE.L  d3, (a0)+   ; 3
        MOVE.L  d3, (a0)+   ; 5
        MOVE.L  d3, (a0)+   ; 7
        MOVE.L  d3, (a0)+   ; 9
        MOVE.W  d3, (a0)+   ; 10
        ; ENGINE_ROW_4
        MOVE.L  (a2)+, (a0)+
        MOVE.W  (a2)+, (a0)+

        ; ** FIFTH ROW **
        LEA.L   BUFF_TRAINCAR_4+$200, a0
        ; need 1 side and 13 fills
        MOVE.L  d2, (a0)+   ; 1
        MOVE.L  d3, (a0)+   ; 3
        MOVE.L  d3, (a0)+   ; 5
        MOVE.L  d3, (a0)+   ; 7
        MOVE.L  d3, (a0)+   ; 9
        MOVE.L  d3, (a0)+   ; 11
        MOVE.L  d3, (a0)+   ; 13

        MOVE.L  (a2)+, (a0)+

        ; ** SIXTH ROW **
        LEA.L   BUFF_TRAINCAR_4+$280, a0
        ; need 1 side and 14 fills
        MOVE.L  d2, (a0)+   ; 1
        MOVE.L  d3, (a0)+
        MOVE.L  d3, (a0)+   ; 5
        MOVE.L  d3, (a0)+
        MOVE.L  d3, (a0)+   ; 9
        MOVE.L  d3, (a0)+
        MOVE.L  d3, (a0)+   ; 13
        MOVE.W  d3, (a0)+   ; 14

        MOVE.W  (a2)+, (a0)

        ; ** SEVENTH ROW **
        LEA.L   BUFF_TRAINCAR_4+$300, a0
        ; need 15 TRAIN_STRIPES
        ; d2 will have two copies of the pattern
        MOVE.W  TRAIN_STRIPES, d3
        MOVE.W  d3, d2
        SWAP    d2
        MOVE.W  d3, d2

        MOVE.L  d2, (a0)+   ; 2
        MOVE.L  d2, (a0)+   ; 4
        MOVE.L  d2, (a0)+
        MOVE.L  d2, (a0)+   ; 8
        MOVE.L  d2, (a0)+
        MOVE.L  d2, (a0)+   ; 12
        MOVE.L  d2, (a0)+
        MOVE.W  d2, (a0)+   ; 15

        MOVE.W  (a2)+, (a0)+

        ; ** EIGHTH ROW **
        LEA.L   BUFF_TRAINCAR_4+$380, a0
        LEA.L   TRAIN_WHEEL_LEFT, a2
        MOVE.L  (a2)+, (a0)+
        MOVE.L  (a2)+, (a0)+
        ADD.L   #14, a0 ; gap b/w wheels
        ; TRAIN_WHEEL_RIGHT
        MOVE.L  (a2)+, (a0)+
        MOVE.L  (a2)+, (a0)+

        ; queue up DMA for the plane
        MOVE.L  #BUFF_PLANE, d0
        MOVE.W  #$800, d1
        MOVE.W  #VRAM_SCROLLA, d2
        LEA.L   DMA_QUEUE, a0

        JSR     AddToDMAQueue

@CIN_TRAIN_1_RETURN:
    RTS

; -----------------------------------------------------------------------
; wait for train to pass screen, camera shake
; camera shake will be moving the vertical scroll up+down by 1 unit
; will go from changing every 16 frames to every 4 frames over 128 frames
    ; 1/16 for 32 frames
    ; 2/16 for 32 frames
    ; 3/16 for 32 frames
    ; 4/16 for 32 frames
CIN_TRAIN_WAIT_2:
    ; increment timer
    MOVE.W  CIN_TRAIN_TIMER, d0
    ADDQ    #1, d0
    ; if animation is done, get next stage ready
    CMPI.W  #$80, d0
    BGE     @TRAIN_WAIT_2_NEXT

        ; save new timer
        MOVE.W  d0, CIN_TRAIN_TIMER

        ; pseudocode for what the following code will do:

        ; if timer <= 32 && timer & $1F == 0
            ; plane_y += timer & $20 ? 1, -1

        ; elif timer <= 64 && timer & $F == 0
            ; plane_y += timer & $10 ? 1, -1

        ; elif timer <= 96 && timer & $7 == 0
            ; plane_y += timer & $8 ? 1, -1

        ; elif timer & $3 == 0
            ; plane_y += timer & $4 ? 1, -1

        ; we will bitshift the timer to the left so bit checks can always be the same
        ; if timer & %0010 0000, shift once
        ; if timer & %0100 0000, shift twice
        ; if timer & %0110 0000, shift 3x
        MOVE.W  d0, d1
        LSR.W   #5, d1  ; d1[1..0] = d0[6..5]
        LSL.W   d1, d0
        ; result in d0:
        ; %00Nx xxxx -> %00 00Nx xxxx
        ; %001N xxxx -> %00 01Nx xxx0
        ; %010x Nxxx -> %01 0xNx xx00
        ; %011x xNxx -> %11 xxNx x000
        ; N: bit we need to check to determine motion

        ; if d0 & $1F == 0, shake screen
        MOVE.W  d0, d1
        ANDI.W  #$1F, d1
        BNE     @TRAIN_WAIT_2_RET

        LEA.L   SCROLL_Y, a0
        MOVE.L  (a0), d1
        ; use bit d0[5] to check motion
        ; BTST    #5, d2
        BTST    #5, d0
        BEQ     @W2_SHAKE_CAM_DOWN
            ; shake cam up:
            ADD.L   #$10001, d1
            MOVE.L  d1, (a0)
            BRA     @TRAIN_WAIT_2_RET
@W2_SHAKE_CAM_DOWN:
            SUB.L   #$10001, d1
            MOVE.L  d1, (a0)
            BRA     @TRAIN_WAIT_2_RET

@TRAIN_WAIT_2_NEXT:
    CLR.W   CIN_TRAIN_TIMER
    MOVE.L  #CIN_TRAIN_2, MAIN_VECTOR

@TRAIN_WAIT_2_RET:
    RTS
    
; -----------------------------------------------------------
; SCROLL TRAIN PAST SCREEN, KEEP SHAKING CAMERA, LOAD IN CARS
CIN_TRAIN_2:
    ; increment timer
    MOVE.L  CIN_TRAIN_TIMER, d0
    ADDQ    #1, d0
    MOVE.L  d0, CIN_TRAIN_TIMER
    ; compare timer, load next stage of animation if applicable
    CMPI.W  #512/TRAIN_MAXSPEED, d0
    BGT     @CIN_TRAIN_2_NEXT
    
    ; every 128 pixels of HSCROLL, load in a new traincar
    MOVE.W  d0, d1
    ANDI.B  #(128/TRAIN_MAXSPEED)-1, d1
    BNE     @CIN_TRAIN_2_HSCROLL

        ; which car we load will depend on bits [3..2] of the timer
        MOVEQ   #0, d1
        MOVE.W  d0, d1
        LSR.W   #2, d1
        ; need to convert d1 = {%01, %10, %11, %00} -> dn = {$40, $20, $0, $60}
        ; NOT:
        ; d1 = {%01, %10, %11, %00} -> d1 = {%10, %01, %00, %11}
        ; LSL by 5
        ; d1 = {%10, %01, %00, %11} -> d1 = {$40, $20, $0, $60}

        ; (note %01 occurs first, not %00, because timer is incremented on the first frame)
        
        NOT.W   d1
        ANDI.W  #%11, d1
        LSL.W   #5, d1
        ; JSR     CIN_TRAIN_2_LOAD_CAR
        JSR     SUB_TRAIN_LOAD_CAR

@CIN_TRAIN_2_HSCROLL:
    ; scroll the train (plane A) to the right
    LEA.L   BUFF_HSCROLL, a0
    MOVE.W  (a0),d1
    ADD.W   #TRAIN_MAXSPEED,d1
    MOVE.W  #27,d2
@CIN_TRAIN_2_HLOOP:
        MOVE.W  d1, (a0)+
        SUB.W   #1, d1      ; slant train to the right to create speed effect
        DBRA    d2, @CIN_TRAIN_2_HLOOP
    
    ; JSR     CIN_TRAIN_SHAKE_CAM
    JSR     SUB_TRAIN_SHAKE_CAM
    BRA     @CIN_TRAIN_2_RET
;    ; if timer % 4 == 0, shake cam depending on timer & 4
;    MOVE.W  d0, d1
;    ANDI.W  #3, d1
;    BNE     @CIN_TRAIN_2_RET
;        LEA.L   SCROLL_Y, a0
;        MOVE.L  (a0), d1
;        ; if timer & 4 == 1, shake down
;        BTST    #2, d0
;        BNE     @2_SHAKE_CAM_DOWN
;            ; shake up
;            ADD.L   #$10001, d1
;            MOVE.L  d1, (a0)
;            BRA     @CIN_TRAIN_2_RET
;@2_SHAKE_CAM_DOWN:
;            ; shake down
;            SUB.L   #$10001, d1
;            MOVE.L  d1, (a0)
;            BRA     @CIN_TRAIN_2_RET

    
@CIN_TRAIN_2_NEXT:
    ; todo: load next stage of animation
    MOVE.L  #CIN_TRAIN_3_WAIT, MAIN_VECTOR
    MOVE.L  #0, CIN_TRAIN_TIMER

@CIN_TRAIN_2_RET:
    RTS

; --------------------------------------------------------
; continue shaking camera and scrolling train for 1 second
CIN_TRAIN_3_WAIT:
    MOVEQ   #0, d0
    MOVE.W  CIN_TRAIN_TIMER, d0
    ADD.W    #1, d0
    CMPI.W  #180, d0
    BGT     @CIN_WAIT_3_NEXT
    MOVE.W  d0, CIN_TRAIN_TIMER

    ; scroll the train (plane A) to the right
    LEA.L   BUFF_HSCROLL, a0
    MOVE.W  (a0),d1
    ADD.W   #TRAIN_MAXSPEED,d1
    MOVE.W  #27,d2
@CIN_WAIT_3_HLOOP:
        MOVE.W  d1, (a0)+
        SUB.W   #1, d1      ; slant train to the right to create speed effect
        DBRA    d2, @CIN_WAIT_3_HLOOP

    ; JSR     CIN_TRAIN_SHAKE_CAM
    JSR     SUB_TRAIN_SHAKE_CAM
    BRA     @CIN_WAIT_3_RET
;    ; if timer % 4 == 0, shake cam depending on timer & 4
;    MOVEQ   #0, d1
;    MOVE.W  d0, d1
;    ANDI.W  #3, d1
;    BNE     @CIN_WAIT_3_RET
;        LEA.L   SCROLL_Y, a0
;        MOVE.L  (a0), d1
;        ; if timer & 4 == 1, shake down
;        BTST    #2, d0
;        BNE     @W3_SHAKE_CAM_DOWN
;            ; shake up
;            ADD.L   #$10001, d1
;            MOVE.L  d1, (a0)
;            BRA     @CIN_WAIT_3_RET
;@W3_SHAKE_CAM_DOWN:
;            ; shake down
;            SUB.L   #$10001, d1
;            MOVE.L  d1, (a0)
;            BRA     @CIN_WAIT_3_RET

@CIN_WAIT_3_NEXT:
    ; set up velocity of background and train
    MOVE.W  #TRAIN_MAXSPEED*2, CIN_TRAIN_VEL
    MOVE.W  #0, CIN_BACK_VEL
    MOVE.L  #CIN_TRAIN_3, MAIN_VECTOR
    MOVE.W  #512, CIN_TRAIN_TIMER

@CIN_WAIT_3_RET:
    RTS

; --------------------------------------------------------------
; accelerate plane B to scroll to the left, deaccelerate plane A
; NOTE: timer counts down from 512 for this phase
CIN_TRAIN_3:
    MOVE.W  CIN_TRAIN_TIMER, d0
    SUBQ    #1, d0
    MOVE.W  d0, CIN_TRAIN_TIMER
    CMPI.W  #0, d0
    BLT     @CIN_TRAIN_3_NEXT

    ; shaky cam
    ; JSR     CIN_TRAIN_SHAKE_CAM
    JSR     SUB_TRAIN_SHAKE_CAM

    ; we will use fixed-point numbers for momentum
        ; train: 1 digit after decimal
        ; tracks: 2 digits after decimal
    ; adjust momentum every 8 frames
    MOVE.W  d0, d1
    ANDI.W  #7, d1
    BNE     @CIN_TRAIN_3_HSCROLL
    SUB.W   #1, CIN_TRAIN_VEL
    ADD.W   #1, CIN_BACK_VEL

    ; adjust HScroll
@CIN_TRAIN_3_HSCROLL:
    LEA.L   BUFF_HSCROLLA, a0
    LEA.L   BUFF_HSCROLLB, a1

    ; add current train scroll value to velocity
    MOVE.W  CIN_TRAIN_VEL, d2
    LSR.W   #1, d2      ; 1 digit after the decimal
    ADD.W   (a0), d2    ; d2 holds train scroll value for this frame
    ; subtract tracks velocity from current scroll value
    MOVE.W  BUFF_HSCROLLB+54, d3
    MOVE.W  CIN_BACK_VEL, d4
    LSR.W   #2, d4      ; 2 digits after the decimal
    SUB.W   d4, d3      ; d3 holds tracks scroll val for this frame
    ; make sky scroll at 1/16 the speed of the tracks
    MOVE.W  d3, d4
    LSR.W   #4, d4      ; d4 holds sky scroll val for this frame
    
    ; first 26 rows of cells
    MOVE.W  #25, d1
@CIN_TRAIN_3_HLOOP:
        MOVE.W  d2, (a0)+
        SUBQ    #1, d2  ; slant train to create speed illusion
        MOVE.W  d4, (a1)+
        ;MOVE.W  #0, (a1)+
        DBRA    d1, @CIN_TRAIN_3_HLOOP
    ; last two rows of cells
    MOVE.W  d2, (a0)+
    SUBQ    #1, d2
    MOVE.W  d2, (a0)
    MOVE.W  d3, (a1)+
    MOVE.W  d3, (a1)

    ; ** UNLOAD BACK CAR **
    ; once we're 64 frames away, un-load a car so we see end of train
    CMPI.W  #$40, d0
    BNE     @CIN_TRAIN_3_RET
    ; we'll be doing the fourth car
    LEA.L   BUFF_TRAINCAR_4, a0
    MOVEQ   #0, d3
    MOVEQ   #$60, d4
    ; eight rows
    MOVEQ   #7, d1
@UNLOAD_CAR_ROW:
        ; 16 tiles, 1 long = 2 tiles
        MOVEQ   #7, d2
@UNLOAD_CAR_TILE:
            MOVE.L  d3, (a0)+
            DBRA    d2, @UNLOAD_CAR_TILE
        ADD.L   d4, a0
        DBRA    d1, @UNLOAD_CAR_ROW

    ; get plane to update
    MOVE.L  #BUFF_PLANE, d0
    MOVE.W  #$800, d1
    MOVE.W  #VRAM_SCROLLA, d2
    LEA.L   DMA_QUEUE, a0

    JSR     AddToDMAQueue

    BRA     @CIN_TRAIN_3_RET

@CIN_TRAIN_3_NEXT:
    MOVE.W  #0, CIN_TRAIN_TIMER
    MOVE.L  #LVL_TRAIN_INIT, MAIN_VECTOR

@CIN_TRAIN_3_RET:
    RTS

; -----------------------------------------
; SHAKE CAMERA DEPENDING ON ANIMATION TIMER
; d0.W contains the timer value
CIN_TRAIN_SHAKE_CAM:
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
    ; d1.B element of {$00, $20, $40, $60}
CIN_TRAIN_2_LOAD_CAR:
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