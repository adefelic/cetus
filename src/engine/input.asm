INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"

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
DirtyTilemap:
	ld a, DIRTY
	ld [wShadowTilemapDirty], a
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
	call GetBGTileMapAddrFromMapCoords ; puts player bg map entry addr in hl
	call GetRoomWallAttributesAddrFromBGMapAddr ; put related RoomWallAttributes addr in hl
AdvanceIfNoCollisions:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [hl]
	and a, MASK_LEFT_WALL
	jp nz, .doNotAdvance
	ld a, [wPlayerX]
	dec a
	ld [wPlayerX], a
	jp .finishAdvance
.facingNorth
	ld a, [hl]
	and a, MASK_TOP_WALL
	jp nz, .doNotAdvance
	ld a, [wPlayerY]
	dec a
	ld [wPlayerY], a
	jp .finishAdvance
.facingEast
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	jp nz, .doNotAdvance
	ld a, [wPlayerX]
	inc a
	ld [wPlayerX], a
	jp .finishAdvance
.facingSouth
	ld a, [hl]
	and a, MASK_BOTTOM_WALL
	jp nz, .doNotAdvance
	ld a, [wPlayerY]
	inc a
	ld [wPlayerY], a
	jp .finishAdvance
.doNotAdvance
	; play bonk sound
	ret
.finishAdvance
	call PlayFootstep
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
