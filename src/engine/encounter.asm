INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter state", WRAM0
wEncounterState:: db
wEnemyAddr:: dw
wEnemyCurrentHp:: db

wEnemyMaxHp:: db ; this is just caching a value for easier printing

SECTION "Encounter init logic", ROMX
BeginEncounter::
.setEncounterState
	ld a, ENCOUNTER_STATE_INITIAL
	ld [wEncounterState], a
	ret
