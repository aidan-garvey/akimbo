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
    DC.W    $0000 ; 0: Black (background/transparent)
    DC.W    $0EEE ; 1: White (stars)
    DC.W    $0CCC ; 2: V. Light Gray (stars)
    DC.W    $0AAA ; 3: Light Gray (stars)
    
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
    ; 1: LARGE STAR
    DC.L    $00030000
    DC.L    $00030000
    DC.L    $00323000
    DC.L    $33212330
    DC.L    $00323000
    DC.L    $00030000
    DC.L    $00030000
    DC.L    $00000000

    ; 2: SMALL STAR
    DC.L    $00000000
    DC.L    $00300000
    DC.L    $03230000
    DC.L    $00300000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    
    ; 3: TRACKS 1
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $77766655
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    DC.L    $88888888
    
    ; 4: TRACKS 2 - NO SUPPORT
    DC.L    $55555555
    DC.L    $77777777
    DC.L    $55555555
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    DC.L    $00000000
    
    ; 5: TRACKS 2 - SUPPORT
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

LARGE_STAR_PATTERN:
    DC.W    $6201
SMALL_STAR_PATTERN:
    DC.W    $6202
    
TRACKS_PATTERN_TOP:
    DC.W    $6203,$6A03,$7203,$7A03
; A tile with a support, and one without a support.
; Can write the lower word repeatedly to space out supports
TRACKS_PATTERN_BOTTOM:
    DC.W    $6204,$6204,$6205
