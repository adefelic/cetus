INCLUDE "src/assets/map_data.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Event Struct Storage", WRAM0
; old below, deprecate
wEventType:: db
wEventDefinition:: dw ; address of active event definition
wEventFrameAddr:: dw  ; address of active event frame. 0 if no active event
wEventFrameIndex:: db ; index of current event frame of active event
wEventFramesSize:: db ; index of final event frame of active event
; new below
wRoomEventAddr:: dw
wDialogBranchesAddr:: dw
wDialogBranchesIndex:: db
wDialogBranchesCount:: db
wDialogBranchFramesAddr:: dw
wDialogBranchFramesIndex:: db
wDialogBranchFramesCount:: db

SECTION "Event Game State", WRAM0
wIsPlayerFacingWallInteractable:: db
wDialogState:: db ; should the game render the dialog root or a dialog option
wCurrentDialogFrame:: dw ; addr of the dialog option frame is currently rendered if in the DIALOG_STATE_BRANCH state
wCurrentLabelAddr:: dw ; addr of the label to paint if the dialog state is DIALOG_STATE_LABEL

; specifically _new_ event parsing. event loading? event initiation?
SECTION "Event Parsing", ROMX

ResetAllEventState::
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	xor a
	ld [wEventFrameIndex], a
	ld [wEventFramesSize], a
	ld [wRoomEventAddr], a
	ld [wDialogBranchesAddr], a
	ld [wDialogBranchesIndex], a
	ld [wDialogBranchesCount], a
	ld [wDialogBranchFramesAddr], a
	ld [wDialogBranchFramesIndex], a
	ld [wDialogBranchFramesCount], a
	ld [wDialogBranchLinesRendered], a
	ld [wDialogBranchesVisibleCount], a
	ld [wDialogTextRowHighlighted], a

	jp SetEventStateDialogLabel

SetEventStateDialogLabel::
	ld a, DIALOG_STATE_LABEL
	ld [wDialogState], a

	;xor a
	;ld [wDialogBranchLinesRendered], a

	ld a, TRUE
	ld [wDialogModalDirty], a
	ret

SetEventStateDialogRoot::
	ld a, DIALOG_STATE_ROOT
	ld [wDialogState], a

	; reset ROOT specific state
	xor a
	ld [wDialogBranchLinesRendered], a
	ld [wDialogBranchesVisibleCount], a
	ld [wDialogTextRowHighlighted], a

	ld a, TRUE
	ld [wDialogModalDirty], a
	ret

; populate current event state with new events
LoadVisibleEvents::
	ld a, [wHasPlayerRotatedThisFrame]
	ld b, a
	ld a, [wHasPlayerTranslatedThisFrame]
	and b ; false is 1. we want to check if either of these happened
	cp FALSE
	ret z
.checkLocationTableForEvent
	; get RoomEvent entry from location map
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	call GetActiveMapRoomEventsAddrFromCoords ; into hl
	ld a, [hl] ; contains offset of the room's RoomEvent from Map1Events
	; check for presence of RoomEvent
	cp EVENT_NONE ; offset is 0 == no event
	jp z, UnsetIsPlayerFacingWallInteractable
	ld hl, Map1Events ; contains event def table address
	call AddAToHl
	; hl now contains that room's RoomEvent address
.checkIfPlayerFacingWallInteractable
	ld a, [hl] ; get event walls, which are the 0th byte of the RoomEvent
	ld b, a
	ld a, [wPlayerOrientation]
	and b
	jp z, UnsetIsPlayerFacingWallInteractable ; it's ok to keep setting this when an event isn't found
.setIsPlayerFacingWallInteractable:
	ld a, TRUE
	ld [wIsPlayerFacingWallInteractable], a
	call SetEventStateDialogLabel
.loadRoomEventIntoRam:
	; store RoomEvent addr
	ld a, l
	ld [wRoomEventAddr], a
	ld a, h
	ld [wRoomEventAddr + 1], a
	push hl ; stash RoomEvent addr

	; store DialogBranchesAddr
	ld a, RoomEvent_DialogBranchesAddr
	call AddAToHl
	call DereferenceHlIntoHl ; put addr of event def in hl
	ld a, l
	ld [wDialogBranchesAddr], a
	ld a, h
	ld [wDialogBranchesAddr + 1], a

	pop hl
	; store DialogBranchesCount
	ld a, RoomEvent_DialogBranchesCount
	call AddAToHl
	ld a, [hl]
	ld [wDialogBranchesCount], a

	; store DialogBranchesIndex
	xor a
	ld [wDialogBranchesIndex], a
	ret

UnsetIsPlayerFacingWallInteractable:
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	ret
