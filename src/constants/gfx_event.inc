INCLUDE "src/constants/gfx_constants.inc"

IF !DEF(DEF_GFX_EVENT_CONSTANTS)
DEF DEF_GFX_EVENT_CONSTANTS EQU 1
; event constants

; todo probably combine these with event constants into menu constants
DEF MODAL_TOP_LEFT EQU rows 12
DEF MODAL_WIDTH EQU 20
DEF MODAL_TEXT_AREA_WIDTH EQU MODAL_WIDTH - 2 ; borders are 1 tile wide
DEF MODAL_HEIGHT EQU 6
DEF MODAL_TEXT_AREA_HEIGHT EQU MODAL_HEIGHT - 2 ; borders are 1 tile high

ENDC
