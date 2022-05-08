; ***************************
;      A  K  I  M  B  O    
; ***************************
; Main file for including all
; other code, initializing
; the game, and executing the
; main game loop.
; ***************************

    ORG     $0000
    
; ***************************************
; Include files which don't take up space
; ***************************************
    INCLUDE GAME_CONST.S  ; Game-specific VRAM locations
    INCLUDE HW_CONST.S    ; Hardware constants
    INCLUDE RAM_MAP.S     ; Locations for 68k's RAM
    INCLUDE MACROS.S      ; Generally useful macros
    
; **********
; ROM HEADER
; **********
    INCLUDE AKIMBO_HEADER.S
    
; ******************
; INTERRUPT ROUTINES
; ******************
    INCLUDE INTERRUPT.S
    
; **********************
; INITIALIZATION PROGRAM
; **********************
    INCLUDE INIT_PROGRAM.S
    
; *****************
; MISC. SUBROUTINES
; *****************
    INCLUDE SUB_GENERAL.S
    
; ************
; DMA ROUTINES
; ************
    INCLUDE DMA_ROUTINES.S

; ***********************
; JOYPAD INPUT SUBROUTINE
; ***********************
    INCLUDE READJOY.S

; **************************
; PLAYER MOVEMENT SUBROUTINE
; **************************
    INCLUDE MOVE_PLAYER.S

; ******************************
; PLAYER-MAP COLLISION DETECTION
; ******************************
    INCLUDE PLAYER_COLLISION.S
    
; *******************
; GAME INITIALIZATION
; *******************
; Occurs at end of INIT_PROGRAM, before VBLANK
; routines are activated
GAME_INIT:
    ; copy player palette to spot 0
    LEA.L   PLAYER_PALETTE, a0
    MOVEQ   #0, d0
    JSR     LOAD_PALETTE

    ; copy system palette to spot 1
    LEA.L   SYSTEM_PALETTE, a0
    MOVEQ   #1, d0
    JSR     LOAD_PALETTE

    ; copy train palette to spot 2
    LEA.L   TRAIN_PAL, a0
    MOVEQ   #2, d0
    JSR     LOAD_PALETTE
    
    ; copy landscape palette to spot 3
    LEA.L   LAND_NIGHT_PAL, a0
    MOVEQ   #3, d0
    JSR     LOAD_PALETTE
    
    JSR     DUMP_PALETTES
    
    ; background will use palette 3, colour 0
    VDP_REG 7, %00110000
    
    ; Set up first subroutine to run in main loop
    ; (this subroutine also places a subroutine in MAIN_VECTOR)
    JSR     CIN_TRAIN_INIT
    
    RTS
    
; **************
; MAIN GAME LOOP
; **************
MAIN:
    ; main loop should only happen once per frame
    WAIT_VB

    ; get joypad input
    JSR     READJOY
    
    ; perform subroutine for current game state
    MOVE.L  MAIN_VECTOR, a0
    JSR     (a0)

    BRA     MAIN
    
; **********************
; GAME STATE SUBROUTINES
; **********************
    ; Constants for train level
    INCLUDE EQU_TRAIN.S
    ; Main subroutines for train level
    INCLUDE SUB_TRAIN.S
    ; Cinematic for train arriving
    INCLUDE CIN_TRAIN.S
    ; Gameplay loop for train level
    INCLUDE LVL_TRAIN.S

; ******
; ASSETS
; ******
    ; Player patterns & palette
    INCLUDE PLAYERGFX.S
    ; System palette
    INCLUDE PALETTES.S
    ; Train patterns & palette
    INCLUDE TRAINGFX.S
    ; Night landscape patterns & palette
    INCLUDE LAND_NIGHT.S
    ; Collision data for train
    INCLUDE COLL_TRAIN.S
