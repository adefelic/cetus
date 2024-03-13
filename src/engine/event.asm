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
wDialogOptionsAddr:: dw
wDialogOptionsIndex:: db
wDialogOptionsCount:: db
wDialogOptionFramesAddr:: dw
wDialogOptionFramesIndex:: db
wDialogOptionFramesCount:: db

SECTION "Event Game State", WRAM0
wIsPlayerFacingWallInteractable:: db
wDialogState:: db ; should the game render the dialog root or a dialog option
wDialogHighlightedOption:: dw  ; addr of the dialog option that is currently highlighted if in the DIALOG_STATE_ROOT state
wCurrentDialogFrame:: dw ; addr of the dialog option frame is currently rendered if in the DIALOG_STATE_BRANCH state
wCurrentLabelAddr:: dw ; addr of the label to paint if the dialog state is DIALOG_STATE_LABEL

; specifically _new_ event parsing. event loading? event initiation?
SECTION "Event Parsing", ROMX

InitEventState::
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	xor a
	ld [wEventFrameIndex], a
	ld [wEventFramesSize], a
	ld [wRoomEventAddr], a
	ld [wDialogOptionsAddr], a
	ld [wDialogOptionsIndex], a
	ld [wDialogOptionsCount], a
	ld [wDialogOptionFramesAddr], a
	ld [wDialogOptionFramesIndex], a
	ld [wDialogOptionFramesCount], a
	jp SetEventStateDialogLabel

SetEventStateDialogLabel::
	ld a, DIALOG_STATE_LABEL
	ld [wDialogState], a

	xor a
	ld [wDialogOptionLinesRendered], a

	ld a, TRUE
	ld [wDialogModalDirty], a
	ret

SetEventStateDialogRoot::
	ld a, DIALOG_STATE_ROOT
	ld [wDialogState], a

	xor a
	ld [wDialogOptionLinesRendered], a

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
	call AddOffsetToAddress
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

	; store DialogOptionsAddr
	ld a, RoomEvent_DialogOptionsAddr
	call AddOffsetToAddress
	call DereferenceHlIntoHl ; put addr of event def in hl
	ld a, l
	ld [wDialogOptionsAddr], a
	ld a, h
	ld [wDialogOptionsAddr + 1], a

	pop hl
	; store DialogOptionsCount
	ld a, RoomEvent_DialogOptionsCount
	call AddOffsetToAddress
	ld a, [hl]
	ld [wDialogOptionsCount], a

	; store DialogOptionsIndex
	xor a
	ld [wDialogOptionsIndex], a
	ret

UnsetIsPlayerFacingWallInteractable:
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	ret
