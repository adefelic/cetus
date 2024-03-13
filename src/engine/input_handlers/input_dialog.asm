INCLUDE "src/constants/explore_constants.inc"

SECTION "Explore Screen Dialog Input Handling", ROMX

; go to DIALOG_STATE_ROOT state
PressedAFromDialogLabel::
	call SetEventStateDialogRoot
	jp DirtyFpSegmentsAndTilemap

; go to DIALOG_STATE_BRANCH state
PressedAFromDialogRoot::
	ret

; either advance frame or go to to PressedAFromDialogRoot state if frames = max
PressedAFromDialogOption::
	ret


; old: would jump here if index == max frames
; saving for later
;CompleteWarpEvent:
;	ld a, [wEventDefinition]
;	ld l, a
;	ld a, [wEventDefinition + 1]
;	ld h, a
;	ld a, ED_MAP_OFFSET
;	call AddOffsetToAddress
;	ld a, [hli]
;	; todo do something with the map id that's currently in a
;	ld a, [hli]
;	ld [wPlayerExploreX], a
;	ld a, [hli]
;	ld [wPlayerExploreY], a
;	ld a, [hl]
;	ld [wPlayerOrientation], a
;	; clear data todo?
;	ld a, FALSE
;	ld [wIsPlayerFacingWallInteractable], a
;	ld a, TRUE
;	ld [wHasPlayerTranslatedThisFrame], a
;	jp DirtyFpSegmentsAndTilemap
