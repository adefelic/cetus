INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Explore Screen Item Menu Input Handling", ROMX

HandleInputFromItemMenu::
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
;.checkPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandlePressedSelect
;.checkPressedA:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_A
;	jp nz, HandlePressedA
.checkPressedB:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_B
	jp nz, HandlePressedB
.checkPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, HandlePressedUp
.checkPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, HandlePressedDown
;.checkPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp nz, HandlePressedLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp nz, HandlePressedRight
	ret

HandlePressedB:
.setNormalState
	ld a, EXPLORE_STATE_NORMAL
	ld [wExploreState], a
	ld a, TRUE
	ld [wDialogModalDirty], a
	jp DirtyFpSegmentsAndTilemap

HandlePressedUp:
	jp DecrementLineHighlight

HandlePressedDown:
	jp IncrementLineHighlight
