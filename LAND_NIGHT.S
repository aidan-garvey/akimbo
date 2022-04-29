; =====================
; ** NIGHT LANDSCAPE **
; ---------------------
; Palette and patterns
; for a hilly landscape
; at night
; =====================

; -------
; PALETTE
; -------
LAND_NIGHT_PAL:
            ; BGR
    DC.W    $0200 ; 0: Dark blue (background/transparent)
    DC.W    $0200 ; 1: Dark blue
    DC.W    $0EEE ; 2: White (stars)
    DC.W    $0422 ; 3: Dark blue-gray (hills)
    
    DC.W    $0000 ; 4: Black
    DC.W    $0444 ; 5: Dark gray (tracks)
    DC.W    $0666 ; 6: Medium-dark gray (tracks)
    DC.W    $0888 ; 7: Medium gray (tracks)
    
    DC.W    $0AAA ; 8: Light gray (tracks)
    DC.W    $0002 ; 9: Maroon (supports)
    DC.W    $0000 ; A: 
    DC.W    $0000 ; B: 
    
    DC.W    $0000 ; C: 
    DC.W    $0000 ; D: 
    DC.W    $0000 ; E: 
    DC.W    $0000 ; F: 
    
; ----------
; CHARACTERS
; ----------
; Copy to VRAM starting at address $4020 (leave $4000 blank)

LAND_NIGHT_CHARS:
    ; 1: STARS 1
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00200000
    DC.L    $02220000
    DC.L    $00200000
    ; 2: STARS 2
    DC.L    $00000000
    DC.L    $00000000
    ;DC.L    $00200000
    ;DC.L    $02220000
    ;DC.L    $00200000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    ; 3: STARS 3
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00020000
    DC.L    $00222000
    DC.L    $00020000
    DC.L    $00000000
    ;DC.L    $00000000
    ;DC.L    $00000000
    ;DC.L    $00000000
    DC.L    $00000000
    ; 4: STARS 4
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    ;DC.L    $00020000
    ;DC.L    $00222000
    ;DC.L    $00020000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    ; 5: STARS 5
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000020
    DC.L    $00000222
    DC.L    $00000020
    DC.L    $00000000
    DC.L    $00000000
    
    ; 6: TRACKS 1
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $77766655
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    
    ; 7: TRACKS 2 - NO SUPPORT
    DC.L    $55555555
    DC.L    $77777777
    DC.L    $55555555
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    
    ; 8: TRACKS 2 - SUPPORT
    DC.L    $55555555
    DC.L    $77777777
    DC.L    $55555555
    DC.L    $99999999
    DC.L    $99999999
    DC.L    $09999990
    DC.L    $00999900
    DC.L    $00999900
    

; --------
; PATTERNS
; --------
; Uses palette 3
; Uses characters starting with cell $200

; 4x2 cell pattern for starry sky
STARS_PATTERN_ROW1:
    DC.W    $0000
    DC.W    $6201
    DC.W    $6202
    DC.W    $6203
STARS_PATTERN_ROW2:
    DC.W    $6204
    DC.W    $0000
    DC.W    $6205
    DC.W    $0000
    
TRACKS_PATTERN_TOP:
    DC.W    $6206,$6A06,$7206,$7A06
; A tile with a support, and one without a support.
; Can write the lower word repeatedly to space out supports
TRACKS_PATTERN_BOTTOM:
    DC.W    $6207,$6207,$6208
