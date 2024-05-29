INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"

SECTION "Room Attribute Definitions", ROMX
; maps tiles data to wall presence data. supports 3 wall types
; these require the same ordering as the map room tiles in explore-simple for the pausemap to work (is that true?)
; 00 00 00 00 = wall definition, in n e s w order.
; 00 = open, 01 = wallA, 10 = wallB, 11 = wallC
; todo rename to room definition? wall sets?
; todo make a macro to define rooms with wall types

RoomWallAttributes::
	db %00000000 ; 0,  ROOM_NONE
	db %00000001 ; 1,  ROOM_L
	db %00000100 ; 2,  ROOM_B
	db %00000101 ; 3,  ROOM_BL
	db %00010000 ; 4,  ROOM_R
	db %00010001 ; 5,  ROOM_RL
	db %00010100 ; 6,  ROOM_RB
	db %00010101 ; 7,  ROOM_RBL
	db %01000000 ; 8,  ROOM_T
	db %01000001 ; 9,  ROOM_TL
	db %01000100 ; 10, ROOM_TB
	db %01000101 ; 11, ROOM_TBL
	db %01010000 ; 12, ROOM_TR
	db %01010001 ; 13, ROOM_TRL
	db %01010100 ; 14, ROOM_TRB
	db %01010100 ; 15, ROOM_TRBL
RoomWallAttributesEnd:

SECTION "Map / Room Parsing", ROMX

; todo make this more than the one hardcoded map
SetMap::
	ld hl, Map1Tiles
	ld a, h
	ld [wActiveMap], a
	ld a, l
	ld [wActiveMap+1], a

	ld hl, Map1EventLocations
	ld a, h
	ld [wActiveMapEventLocations], a
	ld a, l
	ld [wActiveMapEventLocations+1], a
	ret

; necessary? probably
ClearItemMap:
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

; deprecated?

;; @param hl, address of map room representing current tile
;; @return a, wall type
;GetRightWallWrtPlayer::
;	ld a, [wPlayerOrientation]
;	cp a, ORIENTATION_NORTH
;	jp z, GetEastWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_EAST
;	jp z, GetSouthWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_SOUTH
;	jp z, GetWestWallTypeFromRoomAttrAddr
;	jp GetNorthWallTypeFromRoomAttrAddr

;; @param hl, address of map room representing current tile
;; @return a, wall type
;GetBottomWallWrtPlayer::
;	ld a, [wPlayerOrientation]
;	cp a, ORIENTATION_NORTH
;	jp z, GetSouthWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_EAST
;	jp z, GetWestWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_SOUTH
;	jp z, GetNorthWallTypeFromRoomAttrAddr
;	jp GetEastWallTypeFromRoomAttrAddr

;; @param hl, address of map room representing current tile
;; @return a, wall type
;GetLeftWallWrtPlayer::
;	ld a, [wPlayerOrientation]
;	cp a, ORIENTATION_NORTH
;	jp z, GetWestWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_EAST
;	jp z, GetNorthWallTypeFromRoomAttrAddr
;	cp a, ORIENTATION_SOUTH
;	jp z, GetEastWallTypeFromRoomAttrAddr
;	jp GetSouthWallTypeFromRoomAttrAddr

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetTopWallTypeFromRoomAttrAddr::
GetNorthWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_NORTH_WALL
rept 6
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetRightWallTypeFromRoomAttrAddr::
GetEastWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_EAST_WALL
rept 4
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetBottomWallTypeFromRoomAttrAddr::
GetSouthWallTypeFromRoomAttrAddr::
	ld a, [hl]
	and a, ROOM_MASK_SOUTH_WALL
rept 2
	srl a
endr
	ret

; @param hl, address of room attrs representing current tile
; @return a, wall type
GetLeftWallTypeFromRoomAttrAddr::
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

; Map1 + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: address of room tile's RoomWallAttributes
GetRoomWallAttributesFromRoomCoords::
.getActiveMapRoomAddr
	ld a, [wActiveMap]
	ld b, a
	ld a, [wActiveMap+1]
	ld c, a
	call GetRoomAddrFromCoords
.getRoomWallAttributesAddrFromMapRoomAddr:
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
