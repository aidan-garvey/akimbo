; ************************
;     A  K  I  M  B  O    
; ************************
; By Aidan Garvey
; Modified 2021-09-18
; ------------------------
; Acknowledgements:
; TODO
; ------------------------
; 
; ************************

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

; *********************
; MAIN LOOP SUBROUTINES
; *********************
    INCLUDE SUB_MAIN.S
    
; *******************
; GAME INITIALIZATION
; *******************
; Occurs at end of INIT_PROGRAM, before VBLANK
; routines are activated
GAME_INIT:
    ; copy train palette to spot 2
    LEA.L   TRAIN_PAL, a0
    MOVEQ   #2, d0
    JSR     LOAD_PALETTE
    
    ; copy landscape palette to spot 3
    LEA.L   LAND_NIGHT_PAL, a0
    MOVEQ   #3, d0
    JSR     LOAD_PALETTE
    
    ; copy system palette to other 2 spots
    LEA.L   SYSTEM_PALETTE, a0
    MOVEQ   #0, d0
    JSR     LOAD_PALETTE
    
    LEA.L   SYSTEM_PALETTE, a0
    MOVEQ   #1, d0
    JSR     LOAD_PALETTE
    
    JSR     DUMP_PALETTES
    
    ; background will use palette 3, colour 0
    VDP_REG 7, %00110000
    
    ; load landscape graphics into vram
    ; starting at cell $201 (address $4020)
    MOVE.L  #LAND_NIGHT_CHARS, d0
    MOVE.W  #16*8, d1
    MOVE.W  #$4020, d2
    
    JSR     DMADump
    
    ; load SCROLLB contents into screen
    ; buffer, DMA transfer it.
    
    LEA.L   BUFF_PLANE, a0
    
    ; pattern repeats 15 times vertically
    MOVE.W  #14, d0
@NIGHT_SKY_ROW:
    ; pattern repeats 16 times horizontally
    MOVE.W  #15, d1
@SKY_ROW_1:
    LEA.L   STARS_PATTERN_ROW1, a1

    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    
    DBRA    d1, @SKY_ROW_1
    
    MOVE.W  #15, d1
@SKY_ROW_2:
    LEA.L   STARS_PATTERN_ROW2, a1
    
    MOVE.L  (a1)+, (a0)+
    MOVE.L  (a1)+, (a0)+
    
    DBRA    d1, @SKY_ROW_2
    
    ; start new row of pattern
    DBRA    d0, @NIGHT_SKY_ROW
    
    ; ** do a row of train tracks **
    ; a1 will have first 2 tiles
    LEA.L   TRACKS_PATTERN_TOP, a1
    ; a2 will have second 2 tiles
    MOVE.L  a1, a2
    ADD.L   #4, a2

    ; 64-wide plane, 4-wide pattern
    ; 16 repetitions
    MOVE.W  #15, d0
@TRACKS_LOOP:
    MOVE.L  (a1), (a0)+
    MOVE.L  (a2), (a0)+
    DBRA    d0, @TRACKS_LOOP
    
    ; ** do a row of track supports **
    ; a1 will have 2 tiles without supports
    LEA.L   TRACKS_PATTERN_BOTTOM, a1
    ; a2 will have a tile without supports, and one with a support
    MOVE.L  a1, a2
    ADD.L   #2, a2
    ; repeats 8 times
    MOVE.W  #7, d0
@GROUND_LOOP:
    ; load in 7 tiles without supports, and 1 with a support
    MOVE.L  (a1), (a0)+
    MOVE.L  (a1), (a0)+
    MOVE.L  (a1), (a0)+
    MOVE.L  (a2), (a0)+
    DBRA    d0, @GROUND_LOOP
    
    ; DMA transfer pattern to VRAM
    MOVE.L  #BUFF_PLANE, d0
    MOVE.L  #$800, d1
    MOVE.L  #VRAM_SCROLLB, d2
    
    JSR     DMADump
    
    ; load train graphics into VRAM starting
    ; at cell $100 (address $2000)
    MOVE.L  #TRAIN_CHARS, d0
    MOVE.W  #16*$1D, d1
    MOVE.W  #$2020, d2
    
    JSR     DMADump
    
    ; Set up first subroutine to run in main loop
    ; (this subroutine also changes which code will execute every frame,
    ; i.e. the code for this cinematic)
    JSR     CIN_TRAIN_INIT
    
    RTS
    
; ************
; MAIN PROGRAM
; ************
MAIN:
    ; main loop should only happen once per frame
    WAIT_VB
    
    ; perform subroutine for current game state
    MOVE.L  MAIN_VECTOR, a0
    JSR     (a0)

    JMP     MAIN
    
; a1 should contain address of VDP_DATA
; a0 should contain starting address of first char
CopyChar:
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    MOVE.L  (a0)+, (a1)
    RTS
    
; ******
; ASSETS
; ******
    ; Colour palette
    INCLUDE PALETTES.S
    ; Train patterns & palette
    INCLUDE TRAINGFX.S
    ; Night landscape patterns & palette
    INCLUDE LAND_NIGHT.S
