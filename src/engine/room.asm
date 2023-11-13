INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/map_constants.inc"

SECTION "Room Parsing", ROMX

; @param hl: addr of map tile
; @ret a
RoomHasTopWallWRTPlayer::
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
	jp nz, .returnTrue
	jp .returnFalse
.facingNorth
	ld a, [hl]
	and a, MASK_TOP_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingEast
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingSouth
	ld a, [hl]
	and a, MASK_BOTTOM_WALL
	jp nz, .returnTrue
	jp .returnFalse
.returnTrue
	; this doesn't feel very idiomatic
	ld a, TRUE
	ret
.returnFalse
	ld a, FALSE
	ret

; @param hl: addr of map tile
; @ret a
RoomHasRightWallWRTPlayer::
	call GetRoomWallAttributesAddrFromBGMapAddr
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [hl]
	and a, MASK_TOP_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingNorth
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingEast
	ld a, [hl]
	and a, MASK_BOTTOM_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingSouth
	ld a, [hl]
	and a, MASK_LEFT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.returnTrue
	ld a, TRUE
	ret
.returnFalse
	ld a, FALSE
	ret

; @param hl: addr of map tile
; @ret a
RoomHasBottomWallWRTPlayer::
	call GetRoomWallAttributesAddrFromBGMapAddr
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingNorth
	ld a, [hl]
	and a, MASK_BOTTOM_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingEast
	ld a, [hl]
	and a, MASK_LEFT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingSouth
	ld a, [hl]
	and a, MASK_TOP_WALL
	jp nz, .returnTrue
	jp .returnFalse
.returnTrue
	ld a, TRUE
	ret
.returnFalse
	ld a, FALSE
	ret

; @param hl: addr of map tile
; @ret a
RoomHasLeftWallWRTPlayer::
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
	and a, MASK_BOTTOM_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingNorth
	ld a, [hl]
	and a, MASK_LEFT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingEast
	ld a, [hl]
	and a, MASK_TOP_WALL
	jp nz, .returnTrue
	jp .returnFalse
.facingSouth
	ld a, [hl]
	and a, MASK_RIGHT_WALL
	jp nz, .returnTrue
	jp .returnFalse
.returnTrue
	; this doesn't feel very idiomatic
	ld a, TRUE
	ret
.returnFalse
	ld a, FALSE
	ret

; @param hl, address of bg tile map entry representing current tile
; @return hl, address of entry tile's RoomWallAttributes
GetRoomWallAttributesAddrFromBGMapAddr::
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

; @return d: bg map x coord
; @return e: bg map y coord
GetRoomCoordsCenterNearWRTPlayer::
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
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
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	inc a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	ret
.facingEast
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
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
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	ret
.facingEast
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	inc a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
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
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerX]
	ld d, a
	ld a, [wPlayerY]
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
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	inc a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
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
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingNorth
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
	dec a
	ld e, a
	ret
.facingEast
	ld a, [wPlayerX]
	inc a
	ld d, a
	ld a, [wPlayerY]
	inc a
	ld e, a
	ret
.facingSouth
	ld a, [wPlayerX]
	dec a
	ld d, a
	ld a, [wPlayerY]
	inc a
	ld e, a
	ret
