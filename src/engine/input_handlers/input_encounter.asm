INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "debug motion", WRAM0
wTileBeneathL: db
wTileBeneathR: db
wTileBeneathR_X: db
wTileBeneathR_Y: db
wTileBeneathL_X: db
wTileBeneathL_Y: db
wTileAboveL: db
wTileAboveR: db

SECTION "Battle Screen Input Handling", ROMX

; TODO
; - add acceleration to jumps and gravity
; - add per-pixel collision for ramps, both for top collisions and side collisions
;	- would it make sense to look for pixel colors rather than tiles
;	- or to have "collision tiles" that describe non-collidable pixels on a tile
; - allow player direction change without moving X position

HandleInputEncounterScreen::
HandlePressed:
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
.checkPressedSelect:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_SELECT
	jp z, .checkPressedA
	call HandlePressedSelect
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp z, .checkPressedLeft
	call HandlePressedA
;.checkPressedB:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_B
;	jp nz, HandlePressedB
;.checkPressedUp:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_UP
;	jp nz, HandlePressedUp
;.checkPressedDown:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_DOWN
;	jp nz, HandlePressedDown
.checkPressedLeft:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_LEFT
	jp z, .checkPressedRight
	call HandlePressedLeft
.checkPressedRight:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_RIGHT
	jp z, HandleHeld
	call HandlePressedRight

HandleHeld:
.checkHeldLeft:
	ld a, [wJoypadDown]
	and a, PADF_LEFT
	jp z, .checkHeldRight
	call HandleHeldLeft
.checkHeldRight:
	ld a, [wJoypadDown]
	and a, PADF_RIGHT
	ret z
	call HandleHeldRight
	ret

; begins a jump
HandlePressedA:
	ld a, [wJumpsRemaining]
	or 0
	ret z
	dec a
	ld [wJumpsRemaining], a
	ld a, TRUE
	ld [wIsJumping], a
	ld a, JUMP_MAX_FRAMES
	ld [wJumpFramesRemaining], a
	ret

HandlePressedSelect:
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	jp DirtyTilemap ; this is broken, whatever

HandlePressedLeft:
HandleHeldLeft:
	; you always turn
	ld a, DIRECTION_LEFT
	ld [wPlayerDirection], a
	; check for collision
	; c is the loop counter
	ld c, PLAYER_VELOCITY_X ; for each velocity, check one pixel out, move if no collision
.tryLeftOnePixel
	; do the thing
	ld a, [wPlayerEncounterX]
	sub PLAYER_SPRITE_PIXEL_OFFSET_SIDE_LEFT_X ; treat this const as negative
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_SIDE_Y
	sub OAM_PADDING_Y
	;   a and b currently contain the coords of the target pixel. this should be stored as a single byte index into the tile's pixels, tl to br
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	; todo
	;   use tile type to the tile's collision map.
	;   check the stored target pixel value against the tile's collision map
	cp TILE_ENCOUNTER_FLAT
	jp z, SideCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, SideCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, SideCollideHighRamp
	; move left
	ld a, [wPlayerEncounterX]
	dec a
	ld [wPlayerEncounterX], a
	dec c ; dec counter
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	jp nz, .tryLeftOnePixel
	ret

HandlePressedRight:
HandleHeldRight:
	; you always turn
	ld a, DIRECTION_RIGHT
	ld [wPlayerDirection], a
	; check for collision
	; c is the loop counter
	ld c, PLAYER_VELOCITY_X ; for each velocity, check one pixel out, move if no collision
.tryRightOnePixel
	ld a, [wPlayerEncounterX]
	add PLAYER_SPRITE_PIXEL_OFFSET_SIDE_RIGHT_X
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_SIDE_Y
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	cp TILE_ENCOUNTER_FLAT
	jp z, SideCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, SideCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, SideCollideHighRamp
	; move left
	ld a, [wPlayerEncounterX]
	inc a
	ld [wPlayerEncounterX], a
	dec c ; dec counter
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	jp nz, .tryRightOnePixel
	ret

DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

; apply gravity / continue jump
; if there's a jump going on, apply jump, otherwise apply gravity
ApplyVerticalMotion::
	ld a, [wIsJumping] ;; isAscending
	cp TRUE
	jp nz, ApplyDownwardMotion
.continueJump:
	ld a, [wJumpFramesRemaining]
	or 0
	jp z, EndJump
	dec a
	ld [wJumpFramesRemaining], a
.applyUpwardMotion:
	; c is the loop counter
	ld c, JUMP_SPEED ; for each velocity, check one pixel out, move if no collision
	; todo i haven't tested any top collision because ... there are no top tiles to collide with yet
.tryOnePixelAboveLeft
	; get left pixel
	ld a, [wPlayerEncounterX]
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	sub PLAYER_SPRITE_PIXEL_OFFSET_T_Y ; it's negative
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileAboveL], a ; for debugging
	; compare
	cp TILE_ENCOUNTER_FLAT
	jp z, BottomCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, BottomCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, BottomCollideHighRamp
.tryOnePixelAboveRight
	; get right pixel
	ld a, [wPlayerEncounterX]
	add PLAYER_SPRITE_PIXEL_OFFSET_RT_X
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	sub PLAYER_SPRITE_PIXEL_OFFSET_T_Y ; it's negative
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileBeneathR], a ; for debugging
	; compare
	cp TILE_ENCOUNTER_FLAT
	jp z, BottomCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, BottomCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, BottomCollideHighRamp
.adjustY
	ld a, [wPlayerEncounterY]
	dec a
	ld [wPlayerEncounterY], a
	dec c ; dec counter
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	jp nz, .tryOnePixelAboveLeft
	ret

EndJump:
	ld a, FALSE
	ld [wIsJumping], a
ApplyDownwardMotion:
	; c is the loop counter
	ld c, PLAYER_GRAVITY_Y ; for each velocity, check one pixel out, move if no collision
.tryOnePixelBeneathLeft
	; get bottom left collision pixel
	ld a, [wPlayerEncounterX]
	ld [wTileBeneathL_X], a ; for debugging
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_B_Y
	ld [wTileBeneathL_Y], a ; for debugging
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileBeneathL], a ; for debugging
	; compare
	; nb: when the player collides on the left, this skips calculating collision on the right
	cp TILE_ENCOUNTER_FLAT
	jp z, TopCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, TopCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, TopCollideHighRamp
.tryOnePixelBeneathRight
	; get bottom right collision pixel
	ld a, [wPlayerEncounterX]
	add PLAYER_SPRITE_PIXEL_OFFSET_RB_X
	;ld [wTileBeneathR_X], a ; for debugging
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_B_Y
	;ld [wTileBeneathR_Y], a ; for debugging
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileBeneathR], a ; for debugging
	; compare
	cp TILE_ENCOUNTER_FLAT
	jp z, TopCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, TopCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, TopCollideHighRamp
.adjustY
	ld a, [wPlayerEncounterY]
	inc a
	ld [wPlayerEncounterY], a
	dec c ; dec counter
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	jp nz, .tryOnePixelBeneathLeft
	ret

; do per-tile-pixel collision checks here
TopCollideFlat:
TopCollideLowRamp:
TopCollideHighRamp:
	; colliding with the ground resets jumps
	ld a, MAX_JUMPS
	ld [wJumpsRemaining], a
BottomCollideFlat:
BottomCollideLowRamp:
BottomCollideHighRamp:
SideCollideFlat:
SideCollideLowRamp:
SideCollideHighRamp:
	ret


; @param a: y
; @param b: x
; @return hl
; mangles a,c,d,e,h,l
GetTileMapTileAddrFromPixelCoords:
	; this assumes tilemaps are the size of the tilemap and not the size of the screen
	; addr = wShadowTilemap + y/8 * 32 + x/8
	; y
	ld h, 0
	; gotta mask out the bottom bits to simulate dividing by 8 and dropping the remainder,
	; otherwise we'll end up adding the pixel value associated with the extra y pixels to the final value
	and a, %11111000
	ld l, a
	; multiply by 4
	add hl, hl
	add hl, hl
	; x
	ld a, b
	; divide by 8
	srl a
	srl a
	srl a ; largest decimal value is 20 (160/8)
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld de, wShadowTilemap
	add hl, de
	ret
