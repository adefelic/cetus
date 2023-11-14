INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"

SECTION "Input Handling", ROMX

HandleStart::
	ld a, [wGameState]
	cp GAME_PAUSED
	jp z, UnpauseGame ; if paused, unpause
PauseGame:
	ld a, GAME_PAUSED
	ld [wGameState], a
	jp DirtyScreen
UnpauseGame:
	ld a, GAME_UNPAUSED
	ld [wGameState], a
DirtyScreenAndFpSegments:
	call DirtyFPScreen
DirtyScreen:
	ld a, DIRTY
	ld [wScreenDirty], a
	ret

HandleUp::
	ld a, [wGameState]
	cp GAME_PAUSED
	ret z ; ignore input if paused
AttemptMoveUp:
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	call GetBGTileMapAddrFromMapCoords ; puts player bg map entry addr in hl
	call GetRoomWallAttributesAddrFromBGMapAddr ; put related RoomWallAttributes addr in hl

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
	ret nz
	ld a, [wPlayerX]
	dec a
	ld [wPlayerX], a
	call DirtyScreenAndFpSegments
	ret
.facingNorth
	ld a, [hl]
	and a, MASK_TOP_WALL
	ret nz
	ld a, [wPlayerY]
	dec a
	ld [wPlayerY], a
	call DirtyScreenAndFpSegments
	ret
.facingEast
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	ret nz
	ld a, [wPlayerX]
	inc a
	ld [wPlayerX], a
	call DirtyScreenAndFpSegments
	ret
.facingSouth
	ld a, [hl]
	and a, MASK_BOTTOM_WALL
	ret nz
	ld a, [wPlayerY]
	inc a
	ld [wPlayerY], a
	call DirtyScreenAndFpSegments
	ret

HandleDown::
	ld a, [wGameState]
	cp GAME_PAUSED
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
	ld a, [wGameState]
	cp GAME_PAUSED
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
	ld a, [wGameState]
	cp GAME_PAUSED
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
	jp DirtyScreenAndFpSegments
SetOrientationSouth:
	ld a, ORIENTATION_SOUTH
	ld [wPlayerOrientation], a
	jp DirtyScreenAndFpSegments
SetOrientationEast:
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	jp DirtyScreenAndFpSegments
SetOrientationWest:
	ld a, ORIENTATION_WEST
	ld [wPlayerOrientation], a
	jp DirtyScreenAndFpSegments
