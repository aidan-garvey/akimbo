; *******************************
; SEGA GENESIS HARDWARE CONSTANTS
; -------------------------------
; Locations of various registers
; and memory locations in the
; Genesis, as well as important
; numerical values.
; *******************************

; --------------
; 68K SYSTEM I/O
; --------------

Z80_RAM = $A00000

HW_VERSION = $A10001

JOY1_DATA = $A10003
JOY2_DATA = $A10005
JOYX_DATA = $A10007

JOY1_CTRL = $A10009
JOY2_CTRL = $A1000B
JOYX_CTRL = $A1000D

JOY1_SCTRL = $A10013
JOY2_SCTRL = $A10019
JOYX_SCTRL = $A1001F

Z80_BUSREQ = $A11100
Z80_RESET = $A11200

; -------------
; 68K VDP SPACE
; -------------

VDP_DATA = $C00000
VDP_CTRL = $C00004
VDP_STATUS EQU VDP_CTRL

; ------------------------
; 68K MEMORY MAP CONSTANTS
; ------------------------

RAM_BASE = $FF0000
RAM_SIZE = $10000

; -----------------
; VDP R/W ADDRESSES
; -----------------

VDP_W_VRAM = $40000000
VDP_W_CRAM = $C0000000
VDP_W_VSRAM = $40000010
VDP_R_VRAM = $00000000
VDP_R_CRAM = $00000020
VDP_R_VSRAM = $00000010
