INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"

SECTION "Map / Room Parsing", ROMX

; @param hl, address of bg tile map entry representing current tile
; @return hl, address of entry tile's RoomWallAttributes
GetRoomWallAttributesAddrFromMapAddr::
	ld a, [hl] ; get tile data index from tilemap. each is one byte in size so no need to multiply by entry size
	ld hl, RoomWallAttributes
	; add to lsb
	add a, l; get addr of correct tile attrs
	ld l, a
	; add to msb
	ld a, h
	adc a, 0 ; in case of overflow
	ld h, a
	ret

; @param hl, address of map room representing current tile
; @return a, wall type
GetTopWallWrtPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, GetNorthWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_EAST
	jp z, GetEastWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_SOUTH
	jp z, GetSouthWallTypeFromRoomAttrAddr
	jp GetWestWallTypeFromRoomAttrAddr

; @param hl, address of map room representing current tile
; @return a, wall type
GetRightWallWrtPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, GetEastWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_EAST
	jp z, GetSouthWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_SOUTH
	jp z, GetWestWallTypeFromRoomAttrAddr
	jp GetNorthWallTypeFromRoomAttrAddr

; @param hl, address of map room representing current tile
; @return a, wall type
GetBottomWallWrtPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, GetSouthWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_EAST
	jp z, GetWestWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_SOUTH
	jp z, GetNorthWallTypeFromRoomAttrAddr
	jp GetEastWallTypeFromRoomAttrAddr

; @param hl, address of map room representing current tile
; @return a, wall type
GetLeftWallWrtPlayer::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, GetWestWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_EAST
	jp z, GetNorthWallTypeFromRoomAttrAddr
	cp a, ORIENTATION_SOUTH
	jp z, GetEastWallTypeFromRoomAttrAddr
	jp GetSouthWallTypeFromRoomAttrAddr

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetNorthWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_NORTH_WALL
rept 6
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetEastWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_EAST_WALL
rept 4
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetSouthWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_SOUTH_WALL
rept 2
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetWestWallTypeFromRoomAttrAddr::
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

; Map1 + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: tile address of room of Map1
GetActiveMapRoomAddrFromCoords::
	ld a, [wActiveMap]
	ld b, a
	ld a, [wActiveMap+1]
	ld c, a
	jp GetRoomAddrFromCoords

; map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: tile address of room of Map1
GetActiveEventMapRoomAddrFromCoords::
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
