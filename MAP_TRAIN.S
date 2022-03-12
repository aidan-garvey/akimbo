; ==================
;  ** TRAIN  MAP **
; ------------------
; By Aidan Garvey,
; created 2022-03-11
; updated 2022-03-11
; ------------------
; Collision data for
; the train level
; ==================

; ---- Collision Patterns -----------------------------------
; For the train level, plane A can hold exactly 4 train cars.
; Thus, the collision data for the contents of plane A can be
; divided into 4 sections, and each of the following patterns
; takes up one of those sections. The data starts at the top
; row and specifies the collision data for each row of cells
; with 0 for no collision and 1 for collision, 32 rows total.
; -----------------------------------------------------------

; Pattern for normal train car
COLL_TRAIN_CAR: ; Pattern 01
    DC.W    $0000   ; x24
    DC.W    $FFFE   ; x6
    DC.W    $FFFF   ; x2


; ---- Map Pattern ------------------------------
; This data represents the collision data for
; the whole map by using collision pattern
; indexes (1 byte each). Index 0 is always empty.
; -----------------------------------------------
COLLMAP_TRAIN:
    DC.L    $00000000,$01010101,$01010101,$01010101
