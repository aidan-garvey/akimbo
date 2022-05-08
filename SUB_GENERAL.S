; *******************
; GENERAL SUBROUTINES
; -------------------
; General purpose
; subroutines, not
; game-specific.
; *******************

; ---------------------------
; CLEAR_CRAM: clears all CRAM
; Thrashed: d0, d1, a0
; ---------------------------
CLEAR_CRAM:
    ; write to CRAM at base addr
    MOVE.L  #VDP_W_CRAM, VDP_CTRL
    MOVEQ   #0, d1
    MOVE.W  #31, d0     ; 31 = 128 bytes / (4 bytes / long word) - 1
    LEA.L   VDP_DATA, a0
CL_CRAM_LOOP:
    ; MOVE.W  d1, VDP_DATA
    MOVE.L  d1, (a0)
    DBRA    d0, CL_CRAM_LOOP
    
    RTS
    
; -----------------------------
; CLEAR_VSRAM: clears all VSRAM
; Thrashed: d0, d1, a0
; -----------------------------
CLEAR_VSRAM:
    MOVE.L  #VDP_W_VSRAM, VDP_CTRL
    MOVEQ   #0, d1
    ; MOVE.W  #39, d0     ; 39 = 80B / 2 - 1 = 40W - 1
    MOVE.W  #19, d0     ; 19 = 80 bytes / (4 bytes / long word) - 1
    LEA.L   VDP_DATA, a0
CL_VSRAM_LOOP:
    ; MOVE.W  d1, VDP_DATA
    MOVE.L  d1, (a0)
    DBRA    d0, CL_VSRAM_LOOP
    
    RTS
    
; ---------------------------
; CLEAR_VRAM: clears all VRAM
; Thrashed: d0, d1, a0
; ---------------------------
CLEAR_VRAM:
    MOVE.L  #VDP_W_VRAM, VDP_CTRL
    MOVEQ.L #0, d1
    MOVE.L  #$800-1, d0     ; $800 = VRAM size in bytes * (LW/B) / number of writes per loop
    LEA.L   VDP_DATA, a0    ;      = $1 0000 * 1/4 / 8 = $800
CL_VRAM_LOOP:
    MOVE.L  d1, (a0)    ; Doing 1 write per loop would mean
    MOVE.L  d1, (a0)    ; looping $4000 (16 284) times, which
    MOVE.L  d1, (a0)    ; would be much slower since it takes
    MOVE.L  d1, (a0)    ; time to execute a loop instruction.
    MOVE.L  d1, (a0)    ; Writing 8 times per loop means we
    MOVE.L  d1, (a0)    ; only have to execute the loop $800
    MOVE.L  d1, (a0)    ; (2 048) times while still not using
    MOVE.L  d1, (a0)    ; too much space in ROM with code.
    
    DBRA    d0, CL_VRAM_LOOP
    
    RTS

; ----------------------------------
; CL_VRAM_BLOCK
; Clear a chunk of VRAM of any size,
; starting at any point
;
; Parameters:
; d0.W: starting VRAM address
; d1.W: number of bytes to clear
; Thrashed: d0-d1, a0
; ----------------------------------
;CL_VRAM_BLOCK:
    ; set up VDP to write to VRAM at offset in d0
    ;VDP_ACCESS_REG VDP_W_VRAM, d0
    ; now we will use d0 as the empty data
    ;MOVEQ   #0, d0
    ; convert number of bytes to clear into number of longs
    ;LSR.L   #2, d1  ; divide by 4 (i.e. 2^2)
    ;SUB.L   #1, d1  ; since loop counts 0th iteration, subtract 1
    ;LEA.L   VDP_DATA, a0
    ; write zeroes to VRAM for given number of bytes
;@CL_VRAM_LOOP:
    ;MOVE.L  d0, (a0)
    ;DBRA    d0, @CL_VRAM_LOOP
    
    ;RTS
    
; -------------------------------------
; LOAD_PALETTE:
; Load a colour palette into colour
; palette buffer
;
; Parameters:
; d0: palette we are overwriting (0..3)
; a0: starting address of palette
;
; Thrased: a0-a1, d0
; -------------------------------------
LOAD_PALETTE:
    ; Convert palette number into CRAM address offset
    ANDI.L  #$3, d0     ; make sure d0 contains valid number
    LSL.W   #5, d0      ; multiply d0 by 32 (i.e. 2^5)
    LEA.L   BUFF_PALETTES, a1
    ADD.L   d0, a1
    
    ; Move palette
    MOVE.L  #$F, d0
LOAD_PALETTE_LOOP:
    MOVE.W  (a0)+, (a1)+
    DBRA    d0, LOAD_PALETTE_LOOP
    
    RTS

; --------------------------------------
; DUMP_PALETTES:
; Dump all colours in the palette buffer
; into CRAM. Doesn't use DMA, which
; could be improved in the future
;
; Thrashed: a0-a1, d0
; --------------------------------------
DUMP_PALETTES:
    VDP_ACCESS VDP_W_CRAM, 0
    LEA.L   VDP_DATA, a1
    LEA.L   BUFF_PALETTES, a0
    MOVE.W  #63, d0
DUMP_PALETTES_LOOP:
    MOVE.W  (a0)+, (a1)
    DBRA    d0, DUMP_PALETTES_LOOP
    
    RTS

; ----------------------------------
; CopyChar:
; Copy a single character into VRAM.
; For larger amount of chars, DMA
; should be used instead, especially
; during gameplay.
; 
; Parameters:
; a0: starting address of first char
; a1: address of VDP_DATA register
;
; Thrashed: a0
; ----------------------------------
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
