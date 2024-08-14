INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/locale_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/structs/map.inc"

SECTION "Map / Room Parsing", ROMX

; @param hl, addr of map struct def
LoadMapInHl::
	ld a, l
	ld [wCurrentMap], a
	ld a, h
	ld [wCurrentMap+1], a

	; long term todo, optimize map struct to let this use hli instead of stack verbs
	push hl ; stash map struct location
	ld a, Map_WallMapAddr
	call AddAToHl
	call DereferenceHlIntoHl
	ld a, l
	ld [wCurrentMapWalls], a
	ld a, h
	ld [wCurrentMapWalls+1], a

	pop hl
	push hl
	ld a, Map_EventMapAddr
	call AddAToHl
	call DereferenceHlIntoHl
	ld a, l
	ld [wCurrentMapEvents], a
	ld a, h
	ld [wCurrentMapEvents+1], a
	pop hl
	ret

LoadPlayerIntoMap::
	ld hl, wCurrentMap
	call DereferenceHlIntoHl
	ld a, Map_StartingOrientation
	call AddAToHl

	; the struct contains orientation, x, y, and location bytes in order so we can inc through with hli

	ld a, [hli]
	ld [wPlayerOrientation], a
	ld a, [hli]
	ld [wPlayerExploreX], a
	ld a, [hli]
	ld [wPlayerExploreY], a
	ld a, [hli]
	ld [wCurrentLocale], a ; todo make this parse a new locale instead. update map struct to use locale
	ret

; todo replace with LoadItemMap which would dump some sram into wItemMap
ClearItemMap::
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
	ld a, [wCurrentMapEvents]
	ld l, a
	ld a, [wCurrentMapEvents+1]
	ld h, a
	jr GetRoomAddrFromCoords

; item map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: item map room address of tile
GetActiveItemMapRoomAddrFromCoords::
	ld hl, wItemMap
	jr GetRoomAddrFromCoords

; map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: player X coord
; @param e: player Y coord
; @param hl: map addr
; @return hl: tile address of player occupied tile of Map1 (this need to change)
GetRoomAddrFromCoords:
	ld b, h
	ld c, l
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
GetCurrentMapWallsRoomAddrFromRoomCoords::
	ld a, [wCurrentMapWalls]
	ld l, a
	ld a, [wCurrentMapWalls+1]
	ld h, a
	jr GetRoomAddrFromCoords
