; ******************
; INTERRUPT HANDLING
; ------------------
; Code that gets
; executed upon an
; interrupt occuring
; (see ROM header)
; ******************

; ------------------------
; VERTICAL BLANK INTERRUPT
; ------------------------
VBLANK:
    MOVE.L  VBVECTOR, -(SP) ; push address stored in VBVECTOR to SP
    RTS                     ; jump to VBVECTOR

; -----------------------------
; MAIN VBI ROUTINE
; If VBVECTOR contains #VBMAIN,
; this is what will be executed
; after a VBI. VBDUMMY is also
; executed after, since all it
; does is set VBLANKON and
; return from the VB exception.
; -----------------------------
VBMAIN:
    PUSH    a0-a2/d0-d3

    ; Dump sprite buffer to VRAM
    MOVE.L  #BUFF_SPRITES, d0           ; source address
    MOVE.W  #VRAM_SPRITETBL_SIZE/2, d1  ; size of data (in words)
    MOVE.W  #VRAM_SPRITETBL, d2         ; VDP dest address
    
    JSR     DMADump

    ; Update playfield scroll values
    LEA.L   VDP_DATA, a0
    
    ; write vertical scroll to VSRAM for both fields
    VDP_ACCESS VDP_W_VSRAM, 0
    MOVE.L  SCROLL_Y, (a0)

    ; write horizontal scroll data for Plane A and B
    VDP_REG 15, $20 ; cell-by-cell scrolling has 32B between rows
    
    MOVE.L  #BUFF_HSCROLL, d0
    MOVEQ   #28, d1
    MOVE.W  #VRAM_HSCROLL, d2
    
    JSR     DMADump
    
    MOVE.L  #BUFF_HSCROLL+56,d0
    MOVEQ   #28, d1
    MOVE.W  #VRAM_HSCROLL+2,d2
    
    JSR     DMADump
    
    VDP_REG 15, 2   ; restore standard increment value for VDP

    ; perform other DMAs in queue
    JSR     FlushDMAQueue

    POP     a0-a2/d0-d3

; INTENTIONAL FALL-THRU TO VBDUMMY

; -------------------------------
; DUMMY VBI ROUTINE
; If VBVECTOR contains #VBDUMMY,
; or after executing VBMAIN,
; this will be executed. Sets
; indicator that VBI routine is
; done and returns to what was
; executing before the interrupt.
; -------------------------------
VBDUMMY:
    MOVE.W  #1, VBLANKON
    RTE

; --------------------------
; HORIZONTAL BLANK INTERRUPT
; --------------------------
HBLANK:
    RTE

; ------------------
; EXTERNAL INTERRUPT
; ------------------
EXTINT:
    RTE

; ----------------
; MISC. EXCEPTIONS
; ----------------
Exception:
    MOVE.W  #$2700, SR  ; disable interrupts
INF_LOOP:
    BRA.S INF_LOOP      ; infinite loop  
