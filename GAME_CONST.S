; **************
; GAME CONSTANTS
; --------------
; Aidan Garvey,
;     2021-09-21
; --------------
; Game-specific
; constants,
; stored here so
; they can be
; changed easily
; **************

; ------------------------------------
; VDP MEMORY MAP
;
; Scroll A gets max 8KB
; Scroll B gets max 8KB
; Window gets max 4KB (H40)
; HSCROLL gets 1KB (960B used)
; Sprite table gets 1KB (640B used)
;
; Free space between start of VRAM and
; any of the above is used for storing
; actual graphics (pattern generator).
;
; Note: 1KB = 1024B = $400B
; ------------------------------------
VRAM_SPRITETBL = $B800
VRAM_HSCROLL = $BC00
VRAM_SCROLLA = $C000
VRAM_SCROLLB = $E000
VRAM_WINDOW EQU VRAM_SCROLLA ; (UNUSED)

VRAM_SPRITETBL_SIZE = $400
VRAM_HSCROLL_SIZE = $400
VRAM_SCROLLA_SIZE = $2000
VRAM_SCROLLB_SIZE = $2000
