INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/location_constants.inc"
INCLUDE "src/constants/room_constants.inc"

SECTION "Map / Room Parsing", ROMX

; todo make this more than the one hardcoded map
SetMap::
	ld hl, Map1Walls
	ld a, h
	ld [wActiveMap], a
	ld a, l
	ld [wActiveMap+1], a

	ld hl, Map1EventLocations
	ld a, h
	ld [wActiveMapEventLocations], a
	ld a, l
	ld [wActiveMapEventLocations+1], a

	ld a, LOCATION_FIELD
	ld [wPlayerLocation], a

; todo replace with LoadItemMap which would dump some sram into wItemMap
.clearItemMap:
	ld bc, wItemMapEnd - wItemMap
	ld hl, wItemMap
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop
	ret

; @param hl, Room addr
; @return a, wall type
GetTopWallWrtPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, GetNorthWallTypeFromRoomAddr
	cp a, ORIENTATION_EAST
	jp z, GetEastWallTypeFromRoomAddr
	cp a, ORIENTATION_SOUTH
	jp z, GetSouthWallTypeFromRoomAddr
	jp GetWestWallTypeFromRoomAddr

; @param hl, room addr
; @return a, wall type
GetTopWallTypeFromRoomAddr::
GetNorthWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_NORTH_WALL
rept 6
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetRightWallTypeFromRoomAddr::
GetEastWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_EAST_WALL
rept 4
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetBottomWallTypeFromRoomAddr::
GetSouthWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_SOUTH_WALL
rept 2
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetLeftWallTypeFromRoomAddr::
GetWestWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_WEST_WALL
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsCenterNearWRTPlayer::
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsLeftNearWRTPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret
.facingEast
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsRightNearWRTPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret
.facingEast
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsCenterFarWRTPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsLeftFarWRTPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsRightFarWRTPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerExploreX]
	inc a
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerExploreX]
	dec a
	ld d, a
	ld a, [wPlayerExploreY]
	inc a
	ld e, a
	ret

; map addr + wPlayerExploreX + wPlayerExploreY*32
; @return hl: tile address of room of event map
GetEventRoomAddrFromPlayerCoords::
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ld a, [wActiveMapEventLocations]
	ld b, a
	ld a, [wActiveMapEventLocations+1]
	ld c, a
	jp GetRoomAddrFromCoords

; item map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: item map room address of tile
GetActiveItemMapRoomAddrFromCoords::
	ld bc, wItemMap
	jp GetRoomAddrFromCoords

; map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: player X coord
; @param e: player Y coord
; @param bc: map addr
; @return hl: tile address of player occupied tile of Map1 (this need to change)
GetRoomAddrFromCoords:
	ld l, e
	ld h, 0
	; shift left 5 times to multiply by 32
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, d
	add a, l
	ld l, a
	add hl, bc
	ret


; this is the only plce where the code reads from the active map, Map1
; it translates between a room's map room constant (TILE_MAP_RL) and its room wall attribute constant (%00010001). each is one byte
; Map1 + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: address of room tile's RoomWallAttributes
GetRoomAddrFromRoomCoords::
.getActiveMapRoomAddr
	ld a, [wActiveMap]
	ld b, a
	ld a, [wActiveMap+1]
	ld c, a
	call GetRoomAddrFromCoords
	ret
