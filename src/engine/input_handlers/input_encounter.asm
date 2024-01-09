INCLUDE "src/utils/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"

SECTION "Battle Screen Input Handling", ROMX

HandleInputEncounterScreen::
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandleStart
;.checkPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandleSelect
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandleA
;.checkPressedB:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_B
;	jp nz, HandleB
;.checkPressedUp:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_UP
;	jp nz, HandleUp
;.checkPressedDown:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_DOWN
;	jp nz, HandleDown
;.checkPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp nz, HandleLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp nz, HandleRight
	ret



HandleA:
	ld a, SCREEN_EXPLORE
	ld [wActiveScreen], a
	jp DirtyTilemap
DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

