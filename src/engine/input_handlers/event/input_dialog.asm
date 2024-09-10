INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Dialog Event Input Handling", ROMX

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
	ld a, [wDialogTextRowHighlighted] ; this is an index into wMenuItems
	sla a ; multiply by 2 to transform from index -> address offset
	ld hl, wMenuItems
	AddAToHl
	ld c, [hl] ; stash the first byte of the zeroth element
	inc hl
	ld b, [hl] ; stash the second byte
	ld l, c
	ld h, b
.storeHighlightedDialogBranch
	; sets wDialogBranchAddr, wDialogBranchFramesAddr (unused), wCurrentDialogBranchFrameAddr, wDialogBranchFramesCount
	ld a, l
	ld [wDialogBranchAddr], a
	ld a, h
	ld [wDialogBranchAddr + 1], a
	ld a, DialogBranch_FramesCount ; FramesCount offset
	AddAToHl
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
	jp DirtyTilemap

PressedBFromDialogRoot:
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
	jp z, SetEventStateDialogRoot
	ld a, b
	ld [wDialogBranchFramesIndex], a

	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp DirtyTilemap

;; DIALOG_STATE_LABEL handlers

; called from explore_input handler. go to DIALOG_STATE_ROOT state
PressedAFromDialogLabel::
	call SetEventStateDialogRoot
	jp DirtyFpSegmentsAndTilemap ; this is done to remove the label
