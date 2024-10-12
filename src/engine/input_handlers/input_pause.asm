INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Pause Screen Input Handling", ROM0

HandleInputPauseScreen::
.checkPressedStart:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_START
	jp nz, HandlePressedStart
;.checkPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandlePressedSelect
;.checkPressedA:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_A
;	jp nz, HandlePressedA
;.checkPressedB:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_B
;	jp nz, HandlePressedB
;.checkPressedUp:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_UP
;	jp nz, HandlePressedUp
;.checkPressedDown:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_DOWN
;	jp nz, HandlePressedDown
;.checkPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp nz, HandlePressedLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp nz, HandlePressedRight
	ret

HandlePressedStart:
UnpauseGame:
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	call HandleVisibleEvents
	jp DirtyFpSegmentsAndTilemap
