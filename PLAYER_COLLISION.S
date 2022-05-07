; -----------------------------------------------
; Detect a collision between the upwards-facing
; lines and the bottom of the player.
;   * d0.W = new Y position of the player.
;   * d3.L = X position to check
;   * a2 = player's flags
;   
;   After execution:
;   * d0.W = new Y position of the player,
;       adjusted for collisions if applicable
DETECT_COLLISION_UP:
    PUSH d1-d7/a0
    ; d0 is in subpixel precision, collision lines are in pixel precision
    ; preserve subpixel precision in upper word
    ANDI.L  #$0000FFFF, d0
    ROR.L   #4, d0
    ; d1 := old Y position of the player
    MOVE.W  PLAYER1_Y, d1
    LSR.W   #4, d1
    ; calculate current collision slot
    ; MOVE.L  (MAP_X), d3
    ; ADD.W   (PLAYER1_X), d3
    ; LSR.W   #4, d3  ; change to pixel precision
    ; d4 := X coordinate within slot
    MOVE.W  d3, d4
    ANDI.W  #$007F, d4
    ; d3 := slot number * $100
    ; d3 contains xxxx xxxS STTT TPPP (S = slot, T = tile, P = pixel)
    LSL.W   #1, d3      ; xxxx xxSS TTTT PPP0
    ADDI.W  #$0300, d3  ; actual slot number
    ANDI.W  #$0300, d3  ; 0000 00SS 0000 0000 == slot * $100
    ; a0 := address of collision data header to check
    LEA.L   COLL_0, a0
    ADDA.W  d3, a0
    ; d3's value no longer needed

    ; d2 := [number of up lines, offset of up lines]
    MOVE.L  (a0), d2    ; up lines described in first longword of header
    ; a0 := start of lines list
    ADDA.W  #$10, a0
    ; a0 := start of up lines list
    ADDA.W  d2, a0
    ; d2.W is now the number of up lines
    SWAP    d2
    TST.W   d2  ; if there are 0 lines, return
    BEQ     @DETECT_COLLISION_UP_DONE
    ; subtract 1 for the loop
    SUBQ.W  #1, d2

    ; Status:
    ; d0 = new player Y
    ; d1 = old player Y
    ; d2 = loop counter
    ; d3 = scratch
    ; d4 = player X
@UP_LINES_LOOP:
    ; d5 := line Y coordinate
    MOVE.W  (a0)+, d5
    ; d6 := line X start
    MOVE.W  (a0)+, d6
    ; d7 := line X end
    MOVE.W  (a0)+, d7

    ; if new Y is above the line, we're done (since line list is sorted)
    ; i.e. if d0 < d5, we're done
    CMP.W   d0, d5
    BGT     @DETECT_COLLISION_UP_DONE
    ; if oldY <= lineY && newY >= lineY, there may be a collision
    CMP.W   d1, d5
    BLT     @UP_LINES_STEP
    ; (newY >= lineY was checked already)
    ; if playerX >= lineXStart && playerX <= lineXEnd, there is a collision
    CMP.W   d4, d6
    BGT     @UP_LINES_STEP
    CMP.W   d4, d7
    BLT     @UP_LINES_STEP
    
    ; if we're here, there was a collision
    ; put player's Y at line's Y
    MOVE.W  d5, d0
    ; set onGround for player
    ORI.W   #$8000, (a2)
    BRA     @DETECT_COLLISION_UP_DONE

@UP_LINES_STEP:
    DBRA    d2, @UP_LINES_LOOP

@DETECT_COLLISION_UP_DONE:
    ; restore d0 to subpixel precision
    ROL.L   #4, d0
    POP d1-d7/a0
    ; if onGround was set, set Y speed to 0 and clear subpixel units
    BTST.B  #7, (a2)
    BEQ     @DETECT_COLLISION_UP_RET
    MOVE.W  #0, d1
    ANDI.W  #$FFF0, d0
@DETECT_COLLISION_UP_RET:
    RTS
