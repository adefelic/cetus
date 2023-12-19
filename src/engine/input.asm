INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"
INCLUDE "src/macros/event.inc"

; todo this doesn't actually handle input and should be broken up into respective things being done
SECTION "Input Handling", ROMX

HandleStart::
	ld a, [wActiveScreen]
	cp PAUSE_SCREEN
	jp z, UnpauseGame
PauseGame:
	ld a, PAUSE_SCREEN
	ld [wActiveScreen], a
	jp DirtyTilemap
UnpauseGame:
	ld a, FP_SCREEN
	ld [wActiveScreen], a
DirtyFpSegmentsAndTilemap:
	call DirtyFpSegments
	ld a, TRUE
	ld [wHasPlayerMovedThisFrame], a
DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

; todo today
HandlePressedA::
	ld a, [wIsEventActive]
	cp FALSE
	ret z
UpdateActiveEvent:
	ld a, [wEventType]
	cp EVENT_TYPE_WARP
	jp z, UpdateWarpEvent
	ret
UpdateWarpEvent:
	ld a, [wEventFramesSize]
	ld b, a
	ld a, [wEventFrameIndex]
	inc a
	cp b
	jp z, CompleteWarpEvent
.incrementFrameAddress
	; inc frame address by frame size
	ld a, [wEventFrameAddr]
	ld l, a
	ld a, [wEventFrameAddr + 1]
	ld h, a
	ld a, EVENT_FRAME_SIZE
	call AddOffsetToAddress ; this might be silly and inefficient
	ld a, l
	ld [wEventFrameAddr], a
	ld a, h
	ld [wEventFrameAddr + 1], a
.incrementFrameIndex
	ld a, [wEventFrameIndex]
	inc a
	ld [wEventFrameIndex], a
	ret

CompleteWarpEvent:
	ld a, [wEventDefinition]
	ld l, a
	ld a, [wEventDefinition + 1]
	ld h, a
	ld a, ED_MAP_OFFSET
	call AddOffsetToAddress
	ld a, [hli]
	; todo do something with the map id that's currently in a
	ld a, [hli]
	ld [wPlayerX], a
	ld a, [hli]
	ld [wPlayerY], a
	ld a, [hl]
	ld [wPlayerOrientation], a
	; clear data?
	ld a, FALSE
	ld [wIsEventActive], a
	ret

HandleUp::
	ld a, [wActiveScreen]
	cp PAUSE_SCREEN
	ret z ; ignore input if paused
AttemptMoveUp:
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	call GetActiveMapRoomAddrFromCoords ; puts player bg map entry addr in hl
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
AdvanceIfNoCollisions:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	call GetWestWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerX]
	dec a
	ld [wPlayerX], a
	jp .finishAdvance
.facingNorth
	call GetNorthWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerY]
	dec a
	ld [wPlayerY], a
	jp .finishAdvance
.facingEast
	call GetEastWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerX]
	inc a
	ld [wPlayerX], a
	jp .finishAdvance
.facingSouth
	call GetSouthWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerY]
	inc a
	ld [wPlayerY], a
	jp .finishAdvance
.doNotAdvance
	; todo play bonk sound
	ret
.finishAdvance
	call PlayFootstepSfx
	jp DirtyFpSegmentsAndTilemap

HandleDown::
	ld a, [wActiveScreen]
	cp PAUSE_SCREEN
	ret z ; ignore input if paused
AttemptTurnAround:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationEast
.facingNorth
	jp SetOrientationSouth
.facingEast
	jp SetOrientationWest
.facingSouth
	jp SetOrientationNorth

HandleLeft::
	ld a, [wActiveScreen]
	cp PAUSE_SCREEN
	ret z ; ignore input if paused
AttemptTurnLeft:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationSouth
.facingNorth
	jp SetOrientationWest
.facingEast
	jp SetOrientationNorth
.facingSouth
	jp SetOrientationEast

HandleRight::
	ld a, [wActiveScreen]
	cp PAUSE_SCREEN
	ret z ; ignore input if paused
AttemptTurnRight:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationNorth
.facingNorth
	jp SetOrientationEast
.facingEast
	jp SetOrientationSouth
.facingSouth
	jp SetOrientationWest

SetOrientationNorth:
	ld a, ORIENTATION_NORTH
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationSouth:
	ld a, ORIENTATION_SOUTH
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationEast:
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationWest:
	ld a, ORIENTATION_WEST
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap
