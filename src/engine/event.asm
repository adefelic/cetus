INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/event_constants.inc"
INCLUDE "src/structs/event.inc"

SECTION "Event Struct Storage", WRAM0
; current RoomEvent struct state
wRoomEventAddr:: dw
wRoomEventType:: db
wWarpDestinationAddr:: ; wWarpDestinationAddr and wDialogBranchesAddr are mutually exclusive
wDialogBranchesAddr:: dw
wDialogBranchesCount:: db

; current DialogBranch struct state
wDialogBranchAddr:: dw
wDialogBranchFramesAddr:: dw
wDialogBranchFramesIndex:: db
wDialogBranchFramesCount:: db
wCurrentDialogBranchFrameAddr:: dw

SECTION "Event Game State", WRAM0
wIsPlayerFacingWallInteractable:: db
wDialogState:: db ; should the game render the dialog root or a dialog option
wCurrentDialogFrame:: dw ; addr of the dialog option frame is currently rendered if in the DIALOG_STATE_BRANCH state
wCurrentLabelAddr:: dw ; addr of the label to paint if the dialog state is DIALOG_STATE_LABEL

; specifically _new_ event parsing. event loading? event initilization? event map parsing?
SECTION "Event Parsing", ROMX

ResetAllEventState::
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a

	xor a
	; current RoomEvent struct state
	ld [wRoomEventAddr], a
	ld [wDialogBranchesAddr], a
	ld [wDialogBranchesCount], a

	; current DialogBranch struct state
	ld [wDialogBranchAddr], a
	ld [wDialogBranchFramesAddr], a
	ld [wDialogBranchFramesCount], a

	; current modal state
	ld [wMenuItemsCount], a
	ld [wDialogTextRowHighlighted], a
	ld [wTextRowsRendered], a
	ld [wDialogBranchesIteratedOver], a
	ld [wDialogBranchFramesIndex], a
	ld [wCurrentDialogBranchFrameAddr], a

	jp SetEventStateDialogLabel

SetEventStateDialogLabel::
	ld a, DIALOG_STATE_LABEL
	ld [wDialogState], a

	ld a, TRUE
	ld [wBottomMenuDirty], a
	ret

SetEventStateDialogRoot::
	ld a, DIALOG_STATE_ROOT
	ld [wDialogState], a
.setHighlightedMenuRowZero
	xor a
	ld [wDialogTextRowHighlighted], a
ResetModalStateAfterHighlightChange::
	xor a
	ld [wTextRowsRendered], a
	ld [wMenuItemsCount], a
	ld [wDialogBranchesIteratedOver], a

	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp DirtyTilemap

SetEventStateDialogBranch::
	xor a
	ld [wDialogBranchFramesIndex], a
	ld [wTextRowsRendered], a

	ld a, DIALOG_STATE_BRANCH
	ld [wDialogState], a

	ld a, TRUE
	ld [wBottomMenuDirty], a
	ret

; populate current event state with new events
HandleVisibleEvents::
.checkLocationTableForEvent
	call GetEventRoomAddrFromPlayerCoords ; into hl
	ld a, [hl] ; contains offset of the room's RoomEvent from Map1Events
	; check for presence of RoomEvent
	cp EVENT_NONE ; offset is 0 == no event
	jp z, UnsetIsPlayerFacingWallInteractable
.checkIfPlayerFacingWallInteractable
	ld hl, Map1Events ; get event definitions
	call AddAToHl
	; hl now contains that room's RoomEvent address
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

	; store RoomEvent type and handle by type
	ld a, RoomEvent_Type
	call AddAToHl
	ld a, [hl]
	ld [wRoomEventType], a
	cp ROOMEVENT_DIALOG
	jp z, HandleNewDialogRoomEvent
	cp ROOMEVENT_WARP
	jp z, HandleNewDialogWarpEvent
	pop hl
	ret

HandleNewDialogRoomEvent:
.storeDialogBranchData
	pop hl
	push hl
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
	ret

; this function is the same as the first half of HandleNewDialogRoomEvent
HandleNewDialogWarpEvent:
	pop hl
	; store DialogBranchesAddr
	ld a, RoomEvent_DialogBranchesAddr
	call AddAToHl
	call DereferenceHlIntoHl ; put addr of event def in hl
	ld a, l
	ld [wWarpDestinationAddr], a
	ld a, h
	ld [wWarpDestinationAddr + 1], a
	ret

UnsetIsPlayerFacingWallInteractable:
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	ret
