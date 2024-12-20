INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter state", WRAM0
wEncounterState:: db

; this flag could be put in the same place as palette enqueuing, for consistancy
; not sure if i should standardize to an address that becomes 0, or a flag + an address
wNpcSpriteTilesReadyForVramWrite:: db
wBgWallTilesReadyForVramWrite:: db

wNpcAddr:: dw
wNpcCurrentHp:: db
wNpcMaxHp:: db
wNpcSpriteTilesRomAddr:: dw

wCurrentAttack:: dw

wCurrentNpcPalette:: db
wNextAnimationKeyFrame:: dw
; for caching contents of key frame
wNextAnimationKeyFrameFrameNumber:: dw
wNextAnimationKeyFramePalette:: dw
; for caching contents of animation
wAnimationKeyFramesRemaining:: db
wAnimationFramesRemaining:: db

SECTION "Encounter init logic", ROM0
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
