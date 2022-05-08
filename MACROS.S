; ******************
;   **  MACROS  **  
; ------------------
; General-purpose
; macros for common
; tasks including
; taking the Z80 off
; the bus or waiting
; for DMA or VBLANK.
; ******************

; Wait for VDP to finish queued DMA tasks
WAIT_DMA: MACRO
@WAIT_DMA_LOOP\@:
    BTST    #1, VDP_CTRL+1   ; check if status register says "DMA BUSY"
    BNE.S   @WAIT_DMA_LOOP\@ ; keep checking until done
    ENDM
    
; Reset VBLANKON, wait until it is set by our VB routine after the next VB
WAIT_VB: MACRO
    MOVE.W  #0, VBLANKON
@LOOP\@:
    CMP.W   #0, VBLANKON
    BEQ.S   @LOOP\@
    ENDM

; Remove the Z80 from the bus and ensure it is off before continuing
REMOVE_Z80: MACRO
    MOVE.W  #$0100, Z80_BUSREQ  ; request bus from z80
@LOOP\@:
    BTST    #0, Z80_BUSREQ      ; wait until it is off bus
    BNE.S   @LOOP\@
    ENDM
    
; Replace the Z80 on the bus (for code readability)
REPLACE_Z80: MACRO
    MOVE.W  #0, Z80_BUSREQ
    ENDM
    
; Write byte of data (\2) to a VDP register (\1)
VDP_REG: MACRO
    MOVE.W  #$8000!((\1)<<8)!((\2)&$FF),VDP_CTRL
    ENDM
    
; Set up VDP to write/read to VRAM, CRAM or VSRAM
; (code given by \1) at given 16-bit offset (\2)
VDP_ACCESS: MACRO
    ;MOVE.L  #\1+(((\2)&$C000)>>14)+(((\2)&$3FFFF)<<16),VDP_CTRL
    MOVE.L  #\1+((\2)&$3FFF)<<16+((\2)&$C000)>>14, VDP_CTRL
    ENDM
    
; Simillar to above macro, except using a register
; for the offset instead of an immediate value
    ; \1: R/W ID code (imm)
    ; \2: Data register with 16-bit offset
VDP_ACCESS_REG: MACRO
    ; We need %0000 0000 0000 0000 AABB BBBB BBBB BBBB
    ; in form %00BB BBBB BBBB BBBB 0000 0000 0000 00AA
    ROL.L   #2, \2  ; 0000 0000 0000 00AA BBBB BBBB BBBB BB00
    ROR.W   #2, \2  ; 0000 0000 0000 00AA 00BB BBBB BBBB BBBB
    SWAP    \2      ; 00BB BBBB BBBB BBBB 0000 0000 0000 00AA
    AND.L   #$3FFF0003, \2  ; Clear any bits that should not be set
    OR.L    #\1, \2         ; Add the R/W ID Code into the data register
    MOVE.L  \2, VDP_CTRL    ; Pass our control instruction to the VDP
    ENDM

; Push registers onto stack
; \1: register list (ex: d0/d1/d2/a3/a4 or d0-d2/a3-a4)
PUSH: MACRO
    MOVEM.L \1, -(SP)
    ENDM

; Pop registers from stack
; \1: register list
POP: MACRO
    MOVEM.L (SP)+, \1
    ENDM

; Move source to dest if source is smaller
; \1: source register or immediate value
; \2: dest register
MIN: MACRO
    CMP.\0  \1, \2
    BLE     @END\@
    MOVE.\0 \1, \2
@END\@:
    ENDM

; Move source to dest if source is larger
; \1: source register or immediate value
; \2: dest register
MAX: MACRO
    CMP.\0  \1, \2
    BGE     @END\@
    MOVE.\0 \1, \2
@END\@:
    ENDM

