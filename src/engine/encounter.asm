INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter state", WRAM0
wEncounterState:: db
wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram:: db

wNpcAddr:: dw
wNpcCurrentHp:: db
wNpcMaxHp:: db
wNpcSpriteTilesRomAddr:: dw

SECTION "Encounter init logic", ROMX
BeginEncounter::
.setEncounterState
	ld a, ENCOUNTER_STATE_INITIAL
	ld [wEncounterState], a

	; this is for rendering the skill menu
	; these two variables reset the highlight state
.initSkillMenuState
	xor a
	ld [wDialogTextRowHighlighted], a
	ld [wTextRowsRendered], a
	ld a, TRUE
	ld [wBottomMenuDirty], a

	jp DirtyFpSegmentsAndTilemap ; this is to remove the event label if there is one. maybe unnecessary, copied from item menu
