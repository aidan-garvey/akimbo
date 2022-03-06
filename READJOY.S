; ************************
;         READJOY
; ************************
;  Read input from P1 and
; P2 3-button controllers.
; ************************

; ---- LEGEND ----
; A, B, C: Controller face buttons
; U, D, L, R: D-pad up, down, left, right
; ST: START button

; -----------------------
; d6, d7, a5, a6 thrashed
READJOY:
    REMOVE_Z80
    BSR     @READJOY_BOTH
    REPLACE_Z80
    RTS

@READJOY_BOTH:
    ; a5 will point to joypad storage in RAM 
    LEA.L   JOY1, a5
    ; copy data in JOY1&2 to JOY1&2_OLD
    MOVE.L  (a5), 4(a5)
    ; a6 will point to data port for P1
    LEA.L   JOY1_DATA, a6
    ; read for P1
    BSR     @READJOY_READ
    ; a6 will point to data port for P2
    ADDQ    #2, a6
    ; fall-thru to read for P2

@READJOY_READ:
    MOVE.B  #0, (a6)    ; we want values for START and A from data port
    NOP                 ; wait for port
    NOP

    MOVE.B  (a6), d7    ; d7 = {x 0 ST A 0 0 D U}
    LSL.B   #2, d7      ; d7 = {ST A 0 0 D U 0 0}, wait for port
    MOVE.B  #$40, (a6)  ; we want the rest of the buttons from data port
    ANDI.W  #$C0, d7    ; d7 = {ST A 0 0 0 0 0 0}, wait for port
    MOVE.B  (a6), d6    ; d6 = {x 1 C B R L D U}
    ANDI.W  #$3F, d6    ; d6 = {0 0 C B R L D U}
    OR.B    d6, d7      ; d7 = {ST A C B R L D U}
    NOT.B   d7          ; 0 == pressed -> 1 == pressed
    ; TODO (maybe): refer to manual to store current and old data in one word
    ; FORNOW: store current data in JOY1/2, lower byte
    MOVE.W  d7, (a5)+
    RTS     ; return to READJOY_BOTH, then READJOY
