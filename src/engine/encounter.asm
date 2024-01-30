INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter logic", ROMX

GenerateEncounter::
	; roll an encounter from map's encounter table
	; generate map
	; set non-player character x/y
	; set player character x/y
	ld a, MAX_JUMPS
	ld [wJumpsRemaining], a
	ld a, FALSE
	ld [wIsJumping], a
	ret

