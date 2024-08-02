INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter state", WRAM0
wEncounterState:: db
wEncounterCurrentAnimationFrame:: db
wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram:: db

wNpcAddr:: dw
wNpcCurrentHp:: db
wNpcMaxHp:: db
wNpcSpriteTilesRomAddr:: dw

wCurrentAttack:: dw

SECTION "Encounter init logic", ROMX
BeginEncounter::
.setEncounterState
	ld a, ENCOUNTER_STATE_INITIAL
	ld [wEncounterState], a

	; this is for rendering the skill menu
	; these two variables reset the highlight state
ResetEncounterMenuStateHighlight::
	ld a, 0 ; have it highlight the first row being rendered
	ld [wDialogTextRowHighlighted], a
	xor a
	ld [wTextRowsRendered], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	ret

ResetEncounterMenuStateNoHighlight::
	ld a, $FF ; disable highlight
	ld [wDialogTextRowHighlighted], a
	xor a
	ld [wTextRowsRendered], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	ret
