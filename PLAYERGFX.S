; *************************
; PLAYER CHARACTER GRAPHICS
; -------------------------
; Currently placeholders
; *************************

; -------
; PALETTE
; -------
PLAYER_PALETTE:
        ; BGR
        DC.W    $0000
        DC.W    $0E00 ; BLUE
        DC.W    $000E ; RED
        DC.W    $0EE0 ; CYAN

        DC.W    $0080 ; DARK GREEN
        DC.W    $0000
        DC.W    $0000
        DC.W    $0000

        DC.W    $0000
        DC.W    $0000
        DC.W    $0000
        DC.W    $0000

        DC.W    $0000
        DC.W    $0000
        DC.W    $0000
        DC.W    $0000

; ----------
; CHARACTERS
; ----------
; Copy into VRAM starting at $20 (leave $0 blank)

PLAYER_CHARS:
PLAYER_RED:
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
        DC.L    $22222222
PLAYER_CYAN:
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
        DC.L    $33333333
PLAYER_BLUE:
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
PLAYER_DARKGREEN:
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444
        DC.L    $44444444


; --------
; PATTERNS
; --------
; Uses palette 0
; Uses characters starting with cell $0

PLAYER_BACK:    ; (copy 4 times)
        DC.W    $0001
PLAYER_FRONT:   ; (copy 4 times)
        DC.W    $0002