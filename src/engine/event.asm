INCLUDE "src/assets/map_data.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Event Variables", WRAM0
wIsEventActive:: db
wEventType:: db
wEventDefinition:: dw ; address of active event definition
wEventFrameAddr:: dw  ; address of active event frame. 0 if no active event
wEventFrameIndex:: db ; index of current event frame of active event
wEventFramesSize:: db ; index of final event frame of active event

; specifically _new_ event parsing. event loading? event initiation?

; todo rename these to "explore events"
SECTION "Event Parsing", ROMX

InitEventState::
	ld a, FALSE
	ld [wIsEventActive], a
	xor a
	ld [wEventFrameIndex], a
	ld [wEventFramesSize], a
	ret

; all this will do is populate player event state with new events
CheckForNewEvents::
	ld a, [wHasPlayerRotatedThisFrame]
	ld b, a
	ld a, [wHasPlayerTranslatedThisFrame]
	and b ; false is 1. we want to check is either of these happened
	cp FALSE
	ret z
.checkLocationTableForEvent
	; get event trigger entry
	ld bc, Map1EventLocations
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	call GetRoomAddrFromCoords ; into hl
	ld a, [hl] ; contains offset
	; check for presence of event trigger
	cp EVENT_NONE
	jp z, UnsetIsActiveEvent
	ld hl, Map1EventTriggers ; contains event def table address
	call AddOffsetToAddress
	; hl now contains that room's event trigger address
.checkIfEventTriggered
	ld a, [hli] ; get event walls, now pointing at type
	ld b, a
	ld a, [wPlayerOrientation]
	and b
	jp z, UnsetIsActiveEvent
.setNewActiveEvent:
	ld a, TRUE
	ld [wIsEventActive], a
	ld a, [hli] ; get type, now pointing at event def
	ld [wEventType], a
	cp EVENT_TYPE_WARP
	jp z, InitWarpEvent
	; todo check for other event types
	; fixme we'll maybe get in a bad state if a non-warp event exists
	ret

InitWarpEvent:
	; todo it's possible that instead of this i could just remove the pointer
	; to the event def altogether and inc hl, so long as the def was always contiguous with the trigger
	call DereferenceHl ; put addr of event def in hl
	ld a, l
	ld [wEventDefinition], a
	ld a, h
	ld [wEventDefinition + 1], a

	ld a, [hli]
	ld [wEventFramesSize], a ; 0th byte of event def
	xor a
	ld [wEventFrameIndex], a

	call DereferenceHl
	ld a, l
	ld [wEventFrameAddr], a
	ld a, h
	ld [wEventFrameAddr + 1], a
	ret

UnsetIsActiveEvent:
	ld a, FALSE
	ld [wIsEventActive], a
	ret
