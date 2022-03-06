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
        DC.W    $0E00
        DC.W    $000E
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
PLAYER_BLUE:
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111
        DC.L    $11111111

; --------
; PATTERNS
; --------
; Uses palette 0
; Uses characters starting with cell $0

PLAYER_BACK:    ; (copy 4 times)
        DC.W    $0001
PLAYER_FRONT:   ; (copy 4 times)
        DC.W    $0002