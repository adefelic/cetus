INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "Battle Screen Input Handling", ROMX

HandleInputEncounterScreen::
HandlePressed:
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
.checkPressedSelect:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_SELECT
	ret z
	;jp z, .checkPressedA
	call HandlePressedSelect
;.checkPressedA:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_A
;	jp z, .checkPressedLeft
;	call HandlePressedA
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
;	jp z, .checkPressedRight
;	call HandlePressedLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp z, HandleHeld
;	call HandlePressedRight


HandlePressedSelect:
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	jp DirtyTilemap ; this is broken, whatever

DirtyTilemap:
	ld a, TRUE
	ld [wIsShadowTilemapDirty], a
	ret
