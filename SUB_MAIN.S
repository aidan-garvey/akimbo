; *********************
;   MAIN  SUBROUTINES
; ---------------------
; Different subroutines
; that can be executed
; once per frame by the
; game's main loop
; *********************

; Note for memory use: addresses
; $FF1BA0 - $FF2000 are currently free space

; **********
; CINEMATICS
; **********

; ===================================
; Train Cinematic
; -----------------------------------
; 1) Camera pans down to train tracks
; 2) Train speeds by screen
; 3) Camera begins following train
; 4) Back of train comes into view
; ===================================

CIN_TRAIN_TIMER = $FF1C00
; offsets in BUFF_PLANE for top-left of each
; train car (add $80 to jump a whole row)
BUFF_TRAINCAR_1 = BUFF_PLANE+$C00
BUFF_TRAINCAR_2 = BUFF_PLANE+$C20
BUFF_TRAINCAR_3 = BUFF_PLANE+$C40
BUFF_TRAINCAR_4 = BUFF_PLANE+$C60

; Initialize memory for cinematic
CIN_TRAIN_INIT:
    MOVE.L  #CIN_TRAIN_1, MAIN_VECTOR
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
        MOVE.L  #CIN_TRAIN_2, MAIN_VECTOR

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
    
CIN_TRAIN_2:
    ; TODO: depending on timer, load a new train car in
    
    ; scroll the train (plane A) to the right
    LEA.L   BUFF_HSCROLL, a0
    MOVE.W  (a0),d1
    ADD.W   #14,d1
    MOVE.W  #27,d0
@CIN_TRAIN_2_LOOP:
        MOVE.W  d1, (a0)+
        SUB.W   #1, d1      ; slant train to the right to create speed effect
        DBRA    d0, @CIN_TRAIN_2_LOOP
    
    ; scroll the tracks (plane B) to the left
    ;ADD.L   #52, a0
    ;MOVE.W  (a0),d1
    ;SUB.W   #14,d1
    ;MOVE.W  d1, (a0)+
    ;MOVE.W  d1, (a0)+
    
    RTS
    