INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/utils/hardware.inc"

SECTION "Pause Screen Input Handling", ROMX

HandleInputPauseScreen::
CheckPressedStart:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_START
	jp nz, HandleStart
;CheckPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandleSelect
;CheckPressedA:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_A
;	jp nz, HandleA
;CheckPressedB:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_B
;	jp nz, HandleB
;CheckPressedUp:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_UP
;	jp nz, HandleUp
;CheckPressedDown:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_DOWN
;	jp nz, HandleDown
;CheckPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp nz, HandleLeft
;CheckPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp nz, HandleRight
	ret

HandleStart:
UnpauseGame:
	ld a, SCREEN_EXPLORE
	ld [wActiveScreen], a
DirtyFpSegmentsAndTilemap:
	call DirtyFpSegments
DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret
