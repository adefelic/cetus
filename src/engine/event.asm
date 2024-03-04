INCLUDE "src/assets/map_data.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Event Variables", WRAM0
wIsPlayerFacingWallInteractable:: db
wEventType:: db
wEventDefinition:: dw ; address of active event definition
wEventFrameAddr:: dw  ; address of active event frame. 0 if no active event
wEventFrameIndex:: db ; index of current event frame of active event
wEventFramesSize:: db ; index of final event frame of active event
; ~
wRoomEventAddr:: dw
wDialogOptionsAddr:: dw
wDialogOptionsIndex:: db
wDialogOptionsSize:: db
wDialogOptionFramesAddr:: dw
wDialogOptionFramesIndex:: db
wDialogOptionFramesSize:: db

; specifically _new_ event parsing. event loading? event initiation?
; todo rename these to "explore events"
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
	ld [wDialogOptionsSize], a
	ld [wDialogOptionFramesAddr], a
	ld [wDialogOptionFramesIndex], a
	ld [wDialogOptionFramesSize], a
	ret

; populate current event state with new events
UpdateEventState::
	ld a, [wHasPlayerRotatedThisFrame]
	ld b, a
	ld a, [wHasPlayerTranslatedThisFrame]
	and b ; false is 1. we want to check is either of these happened
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
	call SetInitialEventRenderingState
.loadRoomEventIntoRam:
	; store RoomEvent addr
	ld a, l
	ld [wRoomEventAddr], a
	ld a, h
	ld [wRoomEventAddr + 1], a

	; store DialogOptionsAddr
	ld a, RoomEvent_DialogOptionsAddr
	call AddOffsetToAddress
	call DereferenceHlIntoHl ; put addr of event def in hl
	ld a, l
	ld [wDialogOptionsAddr], a
	ld a, h
	ld [wDialogOptionsAddr + 1], a

	; store DialogOptionsCount
	ld a, RoomEvent_DialogOptionsSize
	call AddOffsetToAddress
	ld [wDialogOptionsSize], a ; 0th byte of event def

	; store DialogOptionsIndex
	xor a
	ld [wDialogOptionsIndex], a
	ret

UnsetIsPlayerFacingWallInteractable:
	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	ret
