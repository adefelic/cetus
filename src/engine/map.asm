INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/structs/map.inc"
INCLUDE "src/structs/locale.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Map / Room Parsing", ROM0

; todo split into map loading and map utils

; @param hl, addr of map struct def
; please switch bank right in advance of this
LoadMapInHl::
	ld a, l
	ld [wxCurrentMap], a
	ld a, h
	ld [wxCurrentMap+1], a

	; long term todo, optimize map struct to let this use hli instead of stack verbs
	push hl ; stash map struct location
		ld a, Map_WallMapAddr
		AddAToHl
		DereferenceHlIntoHl
		ld a, l
		ld [wxCurrentMapWalls], a
		ld a, h
		ld [wxCurrentMapWalls+1], a
	pop hl
	push hl
		ld a, Map_EventMapAddr
		AddAToHl
		DereferenceHlIntoHl
		ld a, l
		ld [wxCurrentMapEvents], a
		ld a, h
		ld [wxCurrentMapEvents+1], a
	pop hl
	push hl
		ld a, Map_StartingLocale
		AddAToHl
		DereferenceHlIntoHl
		call LoadLocale
	pop hl

	; the struct contains orientation, x, y bytes in order so we can inc through with hli
	ld a, Map_StartingOrientation
	AddAToHl
	ld a, [hli]
	ld [wPlayerOrientation], a
	ld a, [hli]
	ld [wPlayerExploreX], a
	ld a, [hli]
	ld [wPlayerExploreY], a
	ret

; todo i don't _think_ the banks needs to be adjusted here to point to the bank the locale is in
; @param hl, addr of Locale
LoadLocale::
.loadPaletteSet
	push hl ; contains addr of Locale
	ld a, Locale_BgPaletteSetAddr
	AddAToHl ; contains addr of Locale_BgPaletteSetAddr
	DereferenceHlIntoHl
	ld d, h
	ld e, l
	call EnqueueBgPaletteSetUpdate
	pop hl
.loadEncountersTable
	push hl
	ld a, Locale_EncountersTableAddr
	AddAToHl
	ld a, [hli]
	ld [wCurrentEncounterTable], a
	ld a, [hl]
	ld [wCurrentEncounterTable+1], a
	pop hl
.loadMusic
	push hl
	ld a, Locale_MusicAddr
	AddAToHl
	ld a, [hli]
	ld [wCurrentMusicTrack], a
	ld a, [hl]
	ld [wCurrentMusicTrack+1], a
	call LoadCurrentMusic
	pop hl

.loadSpecialWallTiles
	ld a, Locale_WallTilesAddr
	AddAToHl
	ld a, [hli]
	ld [wCurrentWallTilesAddr], a
	ld a, [hli]
	ld [wCurrentWallTilesAddr+1], a
	ld a, [hl] ; this is pointing to Locale_WallTilesBank now. this'll break if the locale struct changes womp
	ld [wCurrentWallTilesBank], a
	ld a, TRUE
	ld [wBgWallTilesReadyForVramWrite], a
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
GetNorthWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_NORTH_WALL
rept 6
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetEastWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_EAST_WALL
rept 4
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetSouthWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_SOUTH_WALL
rept 2
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
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

; @return hl: tile address of room of event map
CalcEventRoomAddrFromPlayerMapCoords::
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	ld a, [wxCurrentMapEvents]
	ld l, a
	ld a, [wxCurrentMapEvents+1]
	ld h, a
	jr CalcEventRoomAddrFromMapCoords

; map addr + ((wPlayerExploreX + wPlayerExploreY*32) * 2)
; @param d: player X coord
; @param e: player Y coord
; @param hl: map addr
; @return hl: tile address of player occupied tile of map in hl
CalcEventRoomAddrFromMapCoords:
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
	add hl, hl ; this is the only difference between this and CalcRoomAddrFromMapCoords
	add hl, bc
	ret

; map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: player X coord
; @param e: player Y coord
; @param hl: map addr
; @return hl: tile address of player occupied tile of map in hl
; calculates the offset from the addr of the current map that the coordinates represent
CalcRoomAddrFromMapCoords::
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
	ld a, [wxCurrentMapWalls]
	ld l, a
	ld a, [wxCurrentMapWalls+1]
	ld h, a
	jr CalcRoomAddrFromMapCoords
