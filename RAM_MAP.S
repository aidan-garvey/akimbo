; ************
;   RAM  MAP
; ------------
; Allocation
; of RAM
; ($FF0000 - 
; $FFFFFF).
; ************

; as defined in HW_CONST:
; RAM_BASE = $FF0000
; RAM_SIZE = $10000

STACK_END = $FF0400     ; 1024B stack
VBLANKON = $FF0400      ; WORD: Has VBlank routine finished? (TO-TRY: BYTE)
VBVECTOR = $FF0402      ; LONG: Location of VBlank routine

; TODO: rewrite joypad code so result fits in WORD, and it is still easy to check 3/6 button
    ; currently, the MSB of the LONG is 1 for 6b, 0 for 3b. Rearranging could fit data in WORD and still have 1/0 as MSB
JOY1 = $FF0406          ; LONG: Data from player 1
JOY1_OLD = $FF040A      ; LONG: JOY1 from previous frame
JOY2 = $FF040E          ; LONG: Data from player 2
JOY2_OLD = $FF0412      ; LONG: JOY2 from previous frame

; $FF0416: WORD OF MARGIN, DMA routine writes junk here
CURR_DMA_SRC = $FF0418  ; 3B: Source Address register writes for current DMA command
CURR_DMA_LEN = $FF041E  ; WORD: Size register writes for current DMA command
DMA_QUEUE = $FF0422     ; 8B*$50 = $280 Bytes
DMA_QUEUE_END = $FF06A2 ; 12B: Space for queue overflow (1 extra cmd + LONG of zeroes)

; $FF06AE - 2B of extra space (might need it in the future)

BUFF_PALETTES = $FF06B0 ; 128B: Palettes on screen
BUFF_SPRITES = $FF0730  ; $400B: Sprite Table Buffer
BUFF_PLANE = $FF0B30    ; $1000B: Playfield buffer for writing to VRAM
BUFF_HSCROLL = $FF1B30  ; Horizontal Scroll buffer (cell-by-cell)
                        ; 28 rows * 2 planes * 2 bytes = 112B
BUFF_HSCROLLA = $FF1B30
BUFF_HSCROLLB = $FF1B68
; $FF1BA0
; FREE SPACE
; $FF1C00: Space for cinematics variables (tentative)
; $FF2000:
MAIN_VECTOR = $FF2000   ; 4B: Address of current main loop subroutine
SCROLL_Y = $FF2004      ; 4B: Y scroll values for each playfield
SCROLLA_Y = $FF2004
SCROLLB_Y = $FF2006
