INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "First Person View Room Cache", WRAM0
; this is a cache of 1 byte room constants representing the rooms currently within the player's view
; (see room_constants.inc)
; the rooms walls are rotated so that they match the player's view
; this is useful when rendering
wRoomFarLeft:: db
wRoomFarCenter:: db
wRoomFarRight:: db
wRoomNearLeft:: db
wRoomNearCenter:: db
wRoomNearRight:: db

SECTION "First Person Environment Renderer", ROM0

; first person perspective can display up to 6 rooms in this order:
;
; [5][4][6]
; [2][1][3]
;

; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
; todo bounds check and skip rooms that are oob
; currently this does no bounds checking for rooms with negative coords.
;   the whole map starts at 1,1 rather than 0,0 to make it unnecessary

RenderExploreEnvironmentWalls::
	; todo this shouldn't be called here, it should be called whenever the player's location is invalidated
	;    so moves or rotations. and on init. maybe fake a rotation on init
	call UpdateRoomWallCache

	; bank swap to the bank that the maze paint funcitons are in
	ld a, [hCurrentRomBank]
	push af
	ld a, bank(WallAndSegmentPaintRoutines) ; hardcoded
	rst SwapBank
	jp PaintMaze

; todo rotate room walls here so we dont have to do it later
UpdateRoomWallCache:
.getRooms
	ld a, [hCurrentRomBank]
	push af
	ld a, bank(Map1) ; hardcoded
	rst SwapBank
	; far left
	call GetRoomCoordsLeftFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarLeft], a

	; far center
	call GetRoomCoordsCenterFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarCenter], a

	; far right
	call GetRoomCoordsRightFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarRight], a

	; near left
	call GetRoomCoordsLeftNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearLeft], a

	; near center
	call GetRoomCoordsCenterNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearCenter], a

	; near right
	call GetRoomCoordsRightNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearRight], a
.rotateBitsToMatchPlayerOrientation
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_WEST
	jp z, RotateRoomCacheRightTwice
	cp a, ORIENTATION_SOUTH
	jp z, RotateRoomCacheRightFourTimes
	cp a, ORIENTATION_EAST
	jp z, RotateRoomCacheLeftTwice
	jp BankReturn
	;ret

RotateRoomCacheRightTwice:
	ld hl, wRoomFarLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomFarCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomFarRight
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearRight
rept 2
	rrc [hl]
endr
	jp BankReturn
	;ret

RotateRoomCacheRightFourTimes:
	ld hl, wRoomFarLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomFarCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomFarRight
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearRight
rept 4
	rrc [hl]
endr
	jp BankReturn
	;ret

RotateRoomCacheLeftTwice:
	ld hl, wRoomFarLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomFarCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomFarRight
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearRight
rept 2
	rlc [hl]
endr
	jp BankReturn
	;ret
