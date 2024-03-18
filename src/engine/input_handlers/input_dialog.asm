INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/utils/hardware.inc"
INCLUDE "src/macros/event.inc"

SECTION "Explore Screen Dialog Input Handling", ROMX

;;; DIALOG_STATE_ROOT handlers
HandleInputFromDialogRoot::
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, PressedAFromDialogRoot
.checkPressedB:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_B
	jp nz, PressedBFromDialogRoot
.checkPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, PressedUpFromDialogRoot
.checkPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, PressedDownFromDialogRoot
	ret

PressedAFromDialogRoot:
.getHighlightedDialogBranchAddr
	ld a, [wDialogTextRowHighlighted]
	sla a ; multiply by 2 to transform from index -> address offset
	ld hl, wDialogBranchRendered0
	call AddAToHl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld l, c
	ld h, b
.storeHighlightedDialogBranch
	; sets wDialogBranchAddr, wDialogBranchFramesAddr, wCurrentDialogBranchFrameAddr, wDialogBranchFramesCount
	ld a, l
	ld [wDialogBranchAddr], a
	ld a, h
	ld [wDialogBranchAddr + 1], a
	ld a, DialogBranch_FramesCount ; FramesCount offset
	call AddAToHl
	ld a, [hli] ; hl now pointing to frames array
	ld [wDialogBranchFramesCount], a
	call DereferenceHlIntoHl
	ld a, l
	ld [wDialogBranchFramesAddr], a
	ld [wCurrentDialogBranchFrameAddr], a
	ld a, h
	ld [wDialogBranchFramesAddr + 1], a
	ld [wCurrentDialogBranchFrameAddr + 1], a
	call SetEventStateDialogBranch
	;jp DirtyFpSegmentsAndTilemap
	ret

PressedBFromDialogRoot:
	; this might need to be zeroing out more things than it is
	call SetEventStateDialogLabel
	jp DirtyFpSegmentsAndTilemap

PressedUpFromDialogRoot:
	jp DecrementLineHighlight

PressedDownFromDialogRoot:
	jp IncrementLineHighlight

;;; DIALOG_STATE_BRANCH handlers

HandleInputFromDialogBranch::
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, PressedAFromDialogBranch
	ret

PressedAFromDialogBranch:
	; either advance frame index or go to DIALOG_STATE_ROOT state if at the last frame in the branch
	ld a, [wDialogBranchFramesIndex]
	inc a
	ld b, a
	ld a, [wDialogBranchFramesCount]
	cp b
	jp z, .goToRootState
	ld a, b
	ld [wDialogBranchFramesIndex], a

	ld a, TRUE
	ld [wDialogModalDirty], a
	ret
.goToRootState
	call SetEventStateDialogRoot
	ret

;; DIALOG_STATE_LABEL handlers

; called from explore_input handler. go to DIALOG_STATE_ROOT state
PressedAFromDialogLabel::
	call SetEventStateDialogRoot
	jp DirtyFpSegmentsAndTilemap ; this is done to remove the label
	ret

; old: would jump here if index == max frames
; saving for later
;CompleteWarpEvent:
;	ld a, [wEventDefinition]
;	ld l, a
;	ld a, [wEventDefinition + 1]
;	ld h, a
;	ld a, ED_MAP_OFFSET
;	call AddAToHl
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
