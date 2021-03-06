; ====================
;  **  TRAIN  GFX  **
; --------------------
; Palette and patterns
; for the train level
; ====================

; -------
; PALETTE
; -------
TRAIN_PAL:
    DC.W $0ECA  ; 0: TRANSPARENT / SKY BLUE
    DC.W $0AAA  ; 1: V. LIGHT GRAY for exterior highlights
    DC.W $0000  ; 2: BLACK for various details
    DC.W $0888  ; 3: LIGHT GRAY for exterior colour
    DC.W $0666  ; 4: GRAY for exterior shadows
    DC.W $0444  ; 5: DARK GRAY for details and interior background
    DC.W $0222  ; 6: V. DARK GRAY for details and interior background
    DC.W $00AE  ; 7: YELLOW-ORANGE for exterior details
    DC.W $006A  ; 8: LIGHT BROWN for objects like crates - consider 008A if looks bad
    DC.W $0048  ; 9: DARK BROWN for level objects like crates
    DC.W $0000  ; A:  
    DC.W $0000  ; B: 
    DC.W $0000  ; C: 
    DC.W $0000  ; D: 
    DC.W $0000  ; E: 
    DC.W $0000  ; F: 
    
; ----------
; CHARACTERS
; ----------
; Copy to VRAM starting at address $2020 (leave $2000 blank)

; NOTE: if this file needs to be smaller, you could overlap the engine slope characters
; by having 7 rows of sky, then the slope, then 7 rows of filler. Then for each slope
; character, start at a different row of this chunk of data to get a different number
; of empty and filler rows above and below the slope of light gray characters 

TRAIN_CHARS:
    ; ***********************
    ; ** EXTERIOR TRAINCAR **
    ; ***********************

    ; 01: EXTERIOR TOP CORNER (LEFT)
    DC.B    $01,$11,$11,$11
    DC.B    $43,$33,$33,$33
    DC.B    $43,$44,$44,$44
    DC.B    $43,$43,$33,$33
    DC.B    $43,$41,$11,$11
    DC.B    $43,$44,$44,$44
    DC.B    $43,$43,$33,$33
    DC.B    $43,$43,$33,$33
    ; 02: EXTERIOR ROOF
    DC.B    $11,$11,$11,$11
    DC.B    $33,$33,$33,$33
    DC.B    $44,$44,$44,$44
    DC.B    $33,$33,$33,$33
    DC.B    $11,$11,$11,$11
    DC.B    $44,$44,$44,$44
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 03: EXTERIOR EDGE (LEFT)
    DC.B    $43,$41,$11,$11
    DC.B    $43,$44,$44,$44
    DC.B    $43,$43,$33,$33
    DC.B    $43,$43,$33,$33
    DC.B    $43,$41,$11,$11
    DC.B    $43,$44,$44,$44
    DC.B    $43,$43,$33,$33
    DC.B    $43,$43,$33,$33
    ; 04: EXTERIOR WALL
    DC.B    $11,$11,$11,$11
    DC.B    $44,$44,$44,$44
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $11,$11,$11,$11
    DC.B    $44,$44,$44,$44
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 05: CAUTION STRIPES
    DC.B    $77,$77,$77,$22
    DC.B    $77,$77,$72,$27
    DC.B    $77,$77,$22,$77
    DC.B    $77,$72,$27,$77
    DC.B    $77,$22,$77,$77
    DC.B    $72,$27,$77,$77
    DC.B    $22,$77,$77,$77
    DC.B    $22,$22,$22,$22
    ; 06: OUTTER UNDERCARRIAGE (LEFT)
    DC.B    $00,$05,$56,$50
    DC.B    $00,$00,$55,$60
    DC.B    $00,$00,$05,$50
    DC.B    $00,$00,$05,$50
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    ; 07: INNER UNDERCARRIAGE (LEFT)
    DC.B    $05,$55,$66,$55
    DC.B    $05,$66,$55,$50
    DC.B    $06,$55,$50,$00
    DC.B    $05,$50,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    ; 08: HALF WHEEL (LEFT)
    DC.B    $22,$55,$65,$55
    DC.B    $22,$55,$65,$55
    DC.B    $22,$25,$56,$55
    DC.B    $02,$25,$55,$66
    DC.B    $02,$22,$55,$55
    DC.B    $00,$22,$22,$55
    DC.B    $00,$02,$22,$22
    DC.B    $00,$00,$02,$22
    ; 09: CONNECTOR
    DC.B    $77,$27,$27,$27
    DC.B    $72,$72,$72,$77
    DC.B    $00,$00,$00,$00
    DC.B    $55,$55,$55,$55
    DC.B    $66,$66,$66,$66
    DC.B    $62,$22,$22,$26
    DC.B    $20,$00,$00,$02
    DC.B    $00,$00,$00,$00

    ; ******************
    ; ** TRAIN ENGINE **
    ; ******************

    ; 0A: ENGINE TOP LEFT
    DC.B    $01,$11,$11,$11
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    ; 0B: ENGINE TOP
    DC.B    $11,$11,$11,$11
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 0C: ENGINE SIDE
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    DC.B    $43,$33,$33,$33
    ; 0D: ENGINE MIDDLE
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 0E: ENGINE SLOPE 1
    DC.B    $11,$00,$00,$00
    DC.B    $33,$11,$11,$10
    DC.B    $33,$33,$33,$31
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 0F: ENGINE SLOPE 2
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $11,$10,$00,$00
    DC.B    $33,$31,$11,$00
    DC.B    $33,$33,$33,$11
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 10: ENGINE SLOPE 3
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $11,$10,$00,$00
    DC.B    $33,$31,$11,$00
    DC.B    $33,$33,$33,$11
    ; 11: ENGINE WINDOW TOP 1
    DC.B    $22,$20,$00,$00
    DC.B    $22,$22,$22,$00
    DC.B    $32,$22,$22,$22
    DC.B    $32,$22,$22,$22
    DC.B    $33,$22,$22,$22
    DC.B    $33,$32,$22,$22
    DC.B    $33,$33,$22,$22
    DC.B    $33,$33,$33,$22
    ; 12: ENGINE WINDOW TOP 2
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $22,$20,$00,$00
    DC.B    $22,$22,$22,$00
    DC.B    $22,$22,$22,$22
    DC.B    $22,$22,$22,$22
    DC.B    $22,$22,$22,$22
    ; 13: ENGINE WINDOW TOP 3
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $22,$20,$00,$00
    DC.B    $22,$22,$22,$00
    ; 14: ENGINE WINDOW BOTTOM 1
    DC.B    $33,$22,$22,$22
    DC.B    $33,$33,$32,$22
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 15: ENGINE WINDOW BOTTOM 2
    DC.B    $22,$22,$22,$22
    DC.B    $22,$22,$22,$22
    DC.B    $32,$22,$22,$22
    DC.B    $33,$33,$33,$32
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 16: ENGINE WINDOW BOTTOM 3
    DC.B    $00,$00,$00,$00
    DC.B    $22,$20,$00,$00
    DC.B    $22,$22,$22,$00
    DC.B    $22,$22,$22,$22
    DC.B    $33,$33,$32,$22
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 17: ENGINE SLOPE 4
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $11,$10,$00,$00
    DC.B    $33,$31,$11,$00
    DC.B    $33,$33,$33,$11
    DC.B    $33,$33,$33,$33
    ; 18: ENGINE SLOPE 5
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $11,$10,$00,$00
    ; 19: ENGINE SLOPE 6
    DC.B    $33,$31,$11,$00
    DC.B    $33,$33,$33,$11
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 1A: ENGINE SLOPE 7
    DC.B    $11,$10,$00,$00
    DC.B    $33,$31,$11,$00
    DC.B    $33,$33,$33,$11
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    DC.B    $33,$33,$33,$33
    ; 1B: ENGINE TOP RIGHT
    DC.B    $00,$00,$00,$00
    DC.B    $00,$00,$00,$00
    DC.B    $10,$00,$00,$00
    DC.B    $31,$10,$00,$00
    DC.B    $33,$31,$00,$00
    DC.B    $33,$33,$10,$00
    DC.B    $33,$33,$10,$00
    DC.B    $33,$33,$31,$00
    ; 1C: ENGINE MID RIGHT
    DC.B    $33,$33,$31,$00
    DC.B    $33,$33,$33,$10
    DC.B    $33,$33,$33,$10
    DC.B    $33,$33,$33,$10
    DC.B    $33,$33,$33,$31
    DC.B    $33,$33,$33,$31
    DC.B    $33,$33,$33,$31
    DC.B    $33,$33,$33,$31
    ; 1D: ENGINE BOTTOM RIGHT
    DC.B    $77,$77,$77,$22
    DC.B    $77,$77,$72,$27
    DC.B    $77,$77,$22,$77
    DC.B    $77,$72,$27,$77
    DC.B    $77,$22,$77,$70
    DC.B    $72,$27,$77,$00
    DC.B    $22,$77,$00,$00
    DC.B    $00,$00,$00,$00
    
    ; ***********************
    ; ** INTERIOR TRAINCAR **
    ; ***********************

    ; 1E: INTERIOR TOP CORNER (LEFT)
    DC.L    $01111111
    DC.L    $43333333
    DC.L    $43444444
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    ; 1F: INTERIOR SIDE DARK (LEFT)
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    DC.L    $43466666
    ; 20: INTERIOR SIDE DITHERED (LEFT)
    DC.L    $43456665
    DC.L    $43466566
    DC.L    $43465656
    DC.L    $43456565
    DC.L    $43465656
    DC.L    $43456565
    DC.L    $43465556
    DC.L    $43455655
    ; 21: INTERIOR SIDE LIGHT (LEFT)
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    DC.L    $43455555
    ; 22: INTERIOR ROOF
    DC.L    $11111111
    DC.L    $33333333
    DC.L    $44444444
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    ; 23: INTERIOR BACK WALL DARK
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    DC.L    $66666666
    ; 24: INTERIOR BACK WALL DITHERED
    DC.L    $56665666
    DC.L    $66566656
    DC.L    $65656565
    DC.L    $56565656
    DC.L    $65656565
    DC.L    $56565656
    DC.L    $65556555
    DC.L    $55655565
    ; 25: INTERIOR BACK WALL LIGHT
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    DC.L    $55555555
    ; 26: FULL CRATE
    DC.L    $99999999
    DC.L    $98888889
    DC.L    $98888889
    DC.L    $98888889
    DC.L    $98888889
    DC.L    $98888889
    DC.L    $98888889
    DC.L    $99999999
    ; 27: HALF-CRATE (LEFT SIDE)
    DC.L    $55559999
    DC.L    $55559888
    DC.L    $55559888
    DC.L    $55559888
    DC.L    $55559888
    DC.L    $55559888
    DC.L    $55559888
    DC.L    $55559999
    ; 28: SIDE DOOR (LEFT)
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555
    DC.L    $54555555

    
; --------
; PATTERNS
; --------
; Uses palette 2 (from 0..3)
; Uses characters starting with cell $100

; ************************
; ** EXTERIOR TRAIN CAR **
; ************************

; top row:
TRAIN_TOP_LEFT:
    DC.W    $4101
TRAIN_TOP_ROOF:
    DC.W    $4102
    ; repeat 13 times total
TRAIN_TOP_RIGHT:
    DC.W    $4901
    ; followed by blank char
    
; middle rows (x5):
TRAIN_MID_LEFT:
    DC.W    $4103
TRAIN_MID_MID:
    DC.W    $4104
    ; repeat 13 times total
TRAIN_MID_RIGHT:
    DC.W    $4903
    ; followed by blank char

; caution stripes:
TRAIN_STRIPES:
    DC.W    $4105
    ; repeat 15 times total
TRAIN_CONNECTOR:
    DC.W    $4109
    
; undercarriage
TRAIN_WHEEL_LEFT:
    DC.W    $4106,$4108,$4908,$4107
    ; followed by 7 blank chars
TRAIN_WHEEL_RIGHT:
    DC.W    $4907,$4108,$4908,$4906
    ; followed by blank char
    
; ******************
; ** TRAIN ENGINE **
; ******************

; pattern for left side of train
ENGINE_SIDE_LEFT:
    DC.W    $410C
; pattern for filler on train
ENGINE_FILL:
    DC.W    $410D

ENGINE_ROW_1:
    DC.W    $410A,$410B,$410B,$410E,$410F,$4110
    ; followed by 10 blank chars
ENGINE_ROW_2:
    ; SIDE_LEFT
    ; FILL x 5
    DC.W    $4111,$4112,$4113
    ; 7 blank chars
ENGINE_ROW_3:
    ; SIDE_LEFT
    ; FILL x 6
    DC.W    $4114,$4115,$4116,$4117,$4118
    ; 4 blank chars
ENGINE_ROW_4:
    ; SIDE_LEFT
    ; FILL x 10
    DC.W    $4119,$410F,$4110
    ; 2 blank chars
ENGINE_ROW_5:
    ; SIDE_LEFT
    ; FILL x 13
    DC.W    $411A,$411B
ENGINE_ROW_6:
    ; SIDE_LEFT
    ; FILL x 14
    DC.W    $411C
ENGINE_ROW_7:
    ; TRAIN_STRIPES x 15
    DC.W    $411D
ENGINE_ROW_8:
    ; TRAIN_WHEEL_LEFT
    ; 7 blank chars
    ; TRAIN_WHEEL_RIGHT
    ; 1 blank char

; ************************
; ** INTERIOR TRAIN CAR **
; ************************

TRAIN_INSIDE_TOP_LEFT:
    DC.W    $411E
TRAIN_INSIDE_ROOF:
    DC.W    $4122   ; x 13
TRAIN_INSIDE_TOP_RIGHT:
    DC.W    $491E
; 1 blank char

    ; repeat this row twice:
TRAIN_INSIDE_LEFT_DARK:
    DC.W    $411F
TRAIN_INSIDE_DARK:
    DC.W    $4123   ; x 13
TRAIN_INSIDE_RIGHT_DARK:
    DC.W    $491F
; 1 blank char

TRAIN_INSIDE_LEFT_DITHER:
    DC.W    $4120
TRAIN_INSIDE_DITHER:
    DC.W    $4124   ; x 13
TRAIN_INSIDE_RIGHT_DITHER:
    DC.W    $4920
; 1 blank char

TRAIN_INSIDE_LEFT_LIGHT:
    DC.W    $4121
TRAIN_INSIDE_LIGHT:
    DC.W    $4125   ; x 2
TRAIN_HALF_CRATE_LEFT:
    DC.W    $4127
TRAIN_HALF_CRATE_RIGHT:
    DC.W    $4927
; TRAIN_INSIDE_LIGHT x 9
TRAIN_INSIDE_RIGHT_LIGHT:
    DC.W    $4921
; 1 BLANK

; TRAIN_INSIDE_LEFT_LIGHT
; TRAIN_INSIDE_LIGHT x 2
TRAIN_FULL_CRATE:
    DC.W    $4126   ; x 2
; TRAIN_INSIDE_LIGHT x 6
; TRAIN_HALF_CRATE_LEFT
; TRAIN_HALF_CRATE_RIGHT
; TRAIN_FULL_CRATE
; TRAIN_INSIDE_RIGHT_LIGHT
; 1 BLANK

; LAST TWO ROWS SAME AS EXTERIOR CAR
