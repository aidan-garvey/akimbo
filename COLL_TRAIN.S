; Traincar collision data
; Data for each car is to be copied to COL_X in RAM
; where X is the scroll slot number, 0..3

; traincar exterior
COLL_TRAIN_EXT:
    ; HEADER - 2B for number of lines followed by 2B for list offset
    DC.W    2, 0    ; up-facing lines
    DC.W    0, 12   ; down-facing
    DC.W    1, 12   ; left-facing
    DC.W    2, 18   ; right-facing
    
    ; list of up-facing lines: y, xStart, xEnd
    ; top of traincar
    DC.W    $F0, $0, $77
    ; connector
    DC.W    $120, $78, $7F
    
    ; list of down-facing lines: none
    
    ; list of left-facing lines: x, yStart, yEnd
    ; left side of traincar
    DC.W    $0, $F0, $12F
    
    ; list of right-facing lines: x, yStart, yEnd
    DC.W    $77, $F0, $11F
    DC.W    $7F, $120, $12F
