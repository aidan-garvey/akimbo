; *******************
; ***** RAM MAP *****
; -------------------
;  Allocation of RAM
; ($FF0000 - $FFFFFF)
; *******************

; as defined in HW_CONST:
; RAM_BASE = $FF0000
; RAM_SIZE = $10000

STACK_END = $FF0400     ; 1024B stack
VBLANKON = $FF0400      ; WORD: Has VBlank routine finished? (TO-TRY: BYTE)
VBVECTOR = $FF0402      ; LONG: Location of VBlank routine

;JOY1 = $FF0406         ; LONG: Data from player 1
;JOY1_OLD = $FF040A     ; LONG: JOY1 from previous frame
;JOY2 = $FF040E         ; LONG: Data from player 2
;JOY2_OLD = $FF0412     ; LONG: JOY2 from previous frame
JOY1 = $FF0406          ; WORD: Joypad data for player 1
JOY2 = $FF0408          ; WORD: Joypad data for player 2
JOY1_OLD = $FF040A      ; WORD: JOY1 from previous frame
JOY2_OLD = $FF040C      ; WORD: JOY2 from previous frame

; $FF040E - $FF0416: RESERVED
    ; may be needed for reworks of controller input handling

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
; BUFF_COLLISION = $FF1BA0; $100B: collision data for Scroll A
; $FF1CA0:
; FREE SPACE
; $FF1D00: Space for cinematics variables (tentative)
; $FF2000:
MAIN_VECTOR = $FF2000   ; 4B: Address of current main loop subroutine
GAME_TICK = $FF2004     ; 4B: Game tick (frame counter)
SCROLL_Y = $FF2008      ; 4B: Y scroll values for each playfield
SCROLLA_Y = $FF2008
SCROLLB_Y = $FF200A
; $FF200C

; Note about position tracking: the sprite's top-left corner is stored
MAP_X = $FF3000         ; 4B: Players' X position in the level (x coord of left side of screen)
MAP_Y = $FF3004         ; 4B: Players' Y position in the level (y coord of top of screen)
MAP_X_OLD = $FF3008     ; 4B: MAP_X from previous frame
MAP_Y_OLD = $FF300C     ; 4B: MAP_Y from previous frame
PLAYER1_X = $FF3100     ; 2B: Player 1's X position on-screen
PLAYER1_Y = $FF3102     ; 2B: Player 1's Y position on-screen
PLAYER1_VX = $FF3104    ; 2B: Player 1's X velocity
PLAYER1_VY = $FF3106    ; 2B: Player 1's Y velocity
PLAYER1_FLAGS = $FF3108 ; 2B: Flags for P1
    ; {onGround, xx, v flip, direction (h flip), xxx xxxx xxxx}

COLL_0 = $FF4000
COLL_0_HEADER = $FF4000 ; 16B: Header describing contents of list
COLL_0_LIST = $FF4010   ; 192B: List of collision lines
; $FF40D0: 48B of padding
COLL_1 = $FF4100
COLL_1_HEADER = $FF4100 ; 16B: Header
COLL_1_LIST = $FF4110   ; 192B: List of collision lines
; $FF41D0: 48B of padding
COLL_2 = $FF4200
COLL_2_HEADER = $FF4200 ; 16B: Header
COLL_2_LIST = $FF4210   ; 192B: List of collision lines
; $FF42D0: 48B of padding
COLL_3 = $FF4300
COLL_3_HEADER = $FF4300 ; 16B: Header
COLL_3_LIST = $FF4310   ; 192B: List of collision lines
; $FF43D0
