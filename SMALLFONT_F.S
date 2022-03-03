; =============================
;      ** SMALLFONT.X68 **
; -----------------------------
; Created by Aidan Garvey,
;                    2022-02-25
; -----------------------------
; Basic, single colour font for
; Genesis / Mega Drive games.
; Each character is 1... erm...
; character in size. Features
; digits and capital letters.
;
; Characters are in order of
; their ASCII codes.
; =============================

SMALLFONT_0:
    DC.L    $000FF000
    DC.L    $00F00F00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00F00F00
    DC.L    $000FF000

SMALLFONT_1:
    DC.L    $0000F000
    DC.L    $000FF000
    DC.L    $00F0F000
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $00FFFF00

SMALLFONT_2:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $0000FF00
    DC.L    $00FF0000
    DC.L    $0F000000
    DC.L    $0FFFFFF0

SMALLFONT_3:
    DC.L    $0FFFFF00
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $00FFFF00
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $00000F00
    DC.L    $0FFFF000

SMALLFONT_4:
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $00F00F00
    DC.L    $0F000F00
    DC.L    $0FFFFFF0
    DC.L    $00000F00
    DC.L    $00000F00
    DC.L    $00000F00

SMALLFONT_5:
    DC.L    $0FFFFFF0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0FFFFF00
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_6:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F000000
    DC.L    $0FFFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_7:
    DC.L    $0FFFFFF0
    DC.L    $000000F0
    DC.L    $00000F00
    DC.L    $0000F000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $00F00000
    DC.L    $00F00000

SMALLFONT_8:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_9:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFFF0
    DC.L    $000000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_A:
    DC.L    $000FF000
    DC.L    $00F00F00
    DC.L    $00F00F00
    DC.L    $0F0000F0
    DC.L    $0FFFFFF0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0

SMALLFONT_B:
    DC.L    $0FFFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0FFFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0FFFFF00

SMALLFONT_C:
    DC.L    $000FFF00
    DC.L    $00F000F0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $00F000F0
    DC.L    $000FFF00

SMALLFONT_D:
    DC.L    $0FFFF000
    DC.L    $0F000F00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F000F00
    DC.L    $0FFFF000

SMALLFONT_E:
    DC.L    $0FFFFFF0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0FFFFF00
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0FFFFFF0

SMALLFONT_F:
    DC.L    $0FFFFFF0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0FFFFF00
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000

SMALLFONT_G:
    DC.L    $000FFF00
    DC.L    $00F000F0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F00FFF0
    DC.L    $0F0000F0
    DC.L    $00F000F0
    DC.L    $000FFF00

SMALLFONT_H:
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0FFFFFF0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0

SMALLFONT_I:
    DC.L    $0FFFFF00
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $0FFFFF00

SMALLFONT_J:
    DC.L    $0FFFFFF0
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $0000F000
    DC.L    $0F00F000
    DC.L    $0F00F000
    DC.L    $00FF0000

SMALLFONT_K:
    DC.L    $0F0000F0
    DC.L    $0F000F00
    DC.L    $0F00F000
    DC.L    $0FFF0000
    DC.L    $0F00F000
    DC.L    $0F000F00
    DC.L    $0F0000F0
    DC.L    $0F0000F0

SMALLFONT_L:
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0FFFFFF0

SMALLFONT_M:
    DC.L    $F00000F0
    DC.L    $FF000FF0
    DC.L    $FF000FF0
    DC.L    $F0F0F0F0
    DC.L    $F0F0F0F0
    DC.L    $F00F00F0
    DC.L    $F00F00F0
    DC.L    $F00000F0

SMALLFONT_N:
    DC.L    $0FF000F0
    DC.L    $0FF000F0
    DC.L    $0F0F00F0
    DC.L    $0F0F00F0
    DC.L    $0F00F0F0
    DC.L    $0F00F0F0
    DC.L    $0F000FF0
    DC.L    $0F000FF0

SMALLFONT_O:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_P:
    DC.L    $0FFFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0FFFFF00
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $0F000000

SMALLFONT_Q:
    DC.L    $00FFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00
    DC.L    $00000FFF

SMALLFONT_R:
    DC.L    $0FFFFF00
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F000F00
    DC.L    $0FFFF000
    DC.L    $0F000F00
    DC.L    $0F0000F0
    DC.L    $0F0000F0

SMALLFONT_S:
    DC.L    $00FFFFF0
    DC.L    $0F000000
    DC.L    $0F000000
    DC.L    $00FFFF00
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $000000F0
    DC.L    $0FFFFF00

SMALLFONT_T:
    DC.L    $0FFFFF00
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000
    DC.L    $000F0000

SMALLFONT_U:
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00FFFF00

SMALLFONT_V:
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00F00F00
    DC.L    $00F00F00
    DC.L    $000FF000
    DC.L    $000FF000

SMALLFONT_W:
    DC.L    $F00000F0
    DC.L    $F00000F0
    DC.L    $F00000F0
    DC.L    $F00000F0
    DC.L    $F00000F0
    DC.L    $F00F00F0
    DC.L    $F0F0F0F0
    DC.L    $0F000F00

SMALLFONT_X:
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00F00F00
    DC.L    $000FF000
    DC.L    $00F00F00
    DC.L    $00F00F00
    DC.L    $0F0000F0
    DC.L    $0F0000F0

SMALLFONT_Y:
    DC.L    $0F0000F0
    DC.L    $0F0000F0
    DC.L    $00F00F00
    DC.L    $00F00F00
    DC.L    $000FF000
    DC.L    $0000F000
    DC.L    $000F0000
    DC.L    $0FF00000

SMALLFONT_Z:
    DC.L    $0FFFFFF0
    DC.L    $000000F0
    DC.L    $00000F00
    DC.L    $0000F000
    DC.L    $000F0000
    DC.L    $00F00000
    DC.L    $0F000000
    DC.L    $0FFFFFF0
