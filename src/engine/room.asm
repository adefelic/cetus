INCLUDE "src/constants/constants.inc"

SECTION "Room Parsing", ROMX

; @param hl: addr of map tile
; @ret a
RoomHasTopWallWRTPlayer::
	call GetRoomWallAttributes ; put related RoomWallAttributes addr in hl
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
	call GetRoomWallAttributes
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
	call GetRoomWallAttributes
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
	call GetRoomWallAttributes ; put related RoomWallAttributes addr in hl
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

; @param hl, address of tilemap entry representing current tile
; @return hl, address of entry tile's RoomWallAttributes
GetRoomWallAttributes:
	ld a, [hl] ; get tile index from tilemap. each is one byte in size so no need to multiply by entry size
	ld hl, RoomWallAttributes
	; add to lsb
	add a, l; get addr of correct tile attrs
	ld l, a
	; add to msb
	ld a, h
	adc a, 0 ; in case of overflow
	ld h, a
	ret
