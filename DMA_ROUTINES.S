; *******************
;  * DMA ROUNTINES *
; -------------------
; Aidan Garvey,
;          2021-09-22
; -------------------
; Routines for adding
; DMA requests to a
; queue in RAM and
; passing requests
; from the queue to
; the VDP.
; *******************

; ---- NOTE: -----------------------------------
; For now, all of this code should be able to
; stay in ROM. The Genesis manual says that to
; avoid failure, the destination address must be
; 2 word writes and either (1) the DMA code
; itself is in RAM or (2) the final write to
; VDP_CTRL is from work RAM. Since the queued
; commands are stored in RAM, I think all the
; code can be in ROM. However, if DMA starts
; failing, the code for processing a queued
; request will be put in RAM.
; ----------------------------------------------

; ---- NOTE: --------------------------------------
; Having a0 be the next empty DMA queue space might
; not be very helpful. Could write a subroutine to
; scan for it, make a spot in memory for it, or
; store it in a6 or something that can always point
; to the DMA queue.
; -------------------------------------------------

; --------------------------------
; AddToDMAQueue
;   * d0.L = 68k source address
;   * d1.W = size of data in words
;   * d2.W = VDP dest address
;   * a0.L = next DMA queue dest
;
;   After execution:
;   * d0.L = 68k source address of
;       last submitted command
;   * d1.W = size of last command
;   * d2.W = VDP dest of last cmd
;   * a0.L = next empty DMA queue
;       index
; --------------------------------
AddToDMAQueue:
    PUSH    d3
    
    ; Check if room in queue
    MOVE.L  a0, d3
    CMPI.L  #DMA_QUEUE_END, d3
    ; if our address is >= end of queue, no room
    BGE     AddToDMAQueue_RETURN
    
    ; Check if we're crossing a 128KB boundary ($010000, $020000, etc)
    ; If so, we need to split the DMA request at that boundary
    MOVEQ   #0, d3  ; clear d3 so we can perform long math with it later
    MOVE.W  d0, d3
    ADD.W   d1, d3
    ADD.W   d1, d3  ; add d1 twice because it contains the size in words
    ; d3 = source + size = end of source data
    ; note d3 points to the first byte AFTER what we're transferring.
    ;   (ex: array of length 10 has indices 0..9)
    ; so, if d3 = 0, we aren't crossing a 128KB boundary
    ; if d3 > 0 but the carry bit isn't set, we aren't crossing a boundary
    ; if d3 > 0 and the carry bit is set, we are crossing a boundary 
    
    BEQ DMANoSplit  ; d3 = 0 (end of source could be $10000, $20000, etc)
    BCS DMASplit    ; d3 > 0 and carry set means we went from $0xxxx - $1xxxx, or $1xxxx - $2xxxx, etc)
    BRA DMANoSplit  ; d3 > 0 and carry isn't set means we stayed in $0xxxx, or $1xxxx, etc)
    
DMASplit:
    ; from previous calculations, d3 is already the
    ; space we have before hitting the boundary
    PUSH    d0-d3
    
    MOVE.W  d3, d1  ; use d3 for our size so we don't cross boundary
    BSR     SubmitDMAReq
    
    POP     d0-d3
    
    ; calculate new src, length, VDP dest
    ; a0 was incremented in SubmitDMAReq,
    ; so it already points to next spot in queue
        ; note queue has space for overflow of 1 DMA request
        ; so we don't have to check if there's room, and
        ; we can always submit the whole original request
;   ADD.L   d3, d0  ; increase source address

    ; get d0 to next multiple of $10000
    ADD.L   #$10000, d0
    CLR.W   d0          
    SUB.W   d3, d1  ; get size of remaining data
    ADD.W   d3, d2  ; VDP dest
    
    ; fall thru to NoSplit to submit 2nd part of data
    
DMANoSplit:
    BSR     SubmitDMAReq
    
AddToDMAQueue_RETURN:
    POP     d3
    RTS

; Put a DMA command in the queue
; d0.L = source address
; d1.W = data size, words
; d2.W = VDP dest address
; a0 = queue address
; after execution, a0 = next queue address
SubmitDMAReq:
    ; fill upper byte of source address with 1's
    ; ORI.L   #$FF000000, d0
    ; copy source address
    MOVE.L  d0, (a0)+
    ; copy data size
    MOVE.W  d1, (a0)+
    ; copy VDP dest
    MOVE.W  d2, (a0)+
    ; copy all zeroes to next long
    ; to indicate end of queue
    MOVE.L  #0, (a0)
    
    RTS
  
; -----------------------------------------
; FlushDMAQueue
; Flush contents of DMA queue by retrieving
; values from queue and calling DMADump
; until the end of the queue is reached.
; Thrashed: a0-a2, d0-d3
; -----------------------------------------
FlushDMAQueue:
    ; put queue address in a2
    LEA.L   DMA_QUEUE, a2
    ; put size of queue in d3 (minus 1)
    MOVE.W  #$49, d3
@FLUSH_LOOP:
    ; get source address
    MOVE.L  (a2), d0
    ; if it's zero, return
    BEQ     @END_OF_QUEUE
    ; set to zero because we're consuming the item
    MOVE.L  #0, (a2)+
    ; get size
    MOVE.W  (a2)+,d1
    ; get VDP dest
    MOVE.W  (a2)+,d2
    ; perform DMA
    BSR     DMADump
    ; go back to start of loop if we aren't at end of queue
    DBRA    d3, @FLUSH_LOOP
@END_OF_QUEUE:
    RTS

; --------------------------------
; DMADump
;   * d0.L = 68k source address
;   * d1.W = size of data in words
;   * d2.W = VDP dest address
; Precondition: Not crossing a
;   128KB ROM boundary
; Thrashed: a0-a1, d0-d2
; --------------------------------
DMADump:
    LEA.L   VDP_CTRL, a1
    AND.L   #$00FFFFFF, d0  ; don't allow invalid address
    LEA.L   CURR_DMA_SRC+10, a0
    
    ; take Z80 off bus
    REMOVE_Z80
    ; enable DMA
    VDP_REG 1, %01110100

    ; source address lowest bit is bit 1, not 0
    LSR.L   #1, d0
    ; need to rearrage dest address
    LSL.L   #2, d2
    LSR.W   #2, d2
    SWAP    d2
    ; make sure only valid bits set
    AND.W   #$3, d2
    ; add info to VDP_CTRL write: RAM selection, DMA mode
    OR.L    #$40000080, d2
    
    ; move high byte of size to (a0 - 3), low byte to (a0 - 1)
    MOVEP.W d1, -3(a0)
    ; d0 distributed to (a0 - 11), (a0 - 9), (a0 - 7), (a0 - 5)
    MOVEP.L d0, -11(a0)
    ; note the highest byte of d0 is not needed, as the source address is 24 bits.
    ; this is why there's a word-length buffer before CURR_DMA_SRC
    
    ; (a0 - 10), (a0 - 8), ..., (a0 - 2) contain the register
    ; codes for writing to VDP registers
    
    ; CURR_DMA_SRC contents, byte by byte:
    ; reg code 23
    ; source address [23..17]
    ; reg code 22
    ; source address [16..9]
    ; reg code 21
    ; source address [8..1]
    ; CURR_DMA_LEN:
    ; reg code 20
    ; size [15..8]
    ; reg code 19
    ; size [7..0]
    
    ; transfer SRC and LEN contents
    MOVE.W -(a0), (a1)
    MOVE.W -(a0), (a1)
    MOVE.W -(a0), (a1)
    MOVE.W -(a0), (a1)
    MOVE.W -(a0), (a1)
    
    ; write first part of dest address
    SWAP    d2
    MOVE.W  d2, (a1)
    ; second part of dest address
    SWAP    d2
    MOVE.W  d2, (a1)
    ; DMA begins
    
    ; wait until DMA finished
    WAIT_DMA
    
    ; disable DMA
    VDP_REG 1, %01100100
    ; put Z80 back on bus
    REPLACE_Z80
    
    RTS
