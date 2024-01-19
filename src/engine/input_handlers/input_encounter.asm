INCLUDE "src/utils/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "debug motion", WRAM0
wTileBeneathL: db
wTileBeneathR: db

SECTION "Player Velocity", WRAM0
; these values are added to the player's position every frame?
;
wPlayerVelocityX: db
wPlayerVelocityY: db

SECTION "Battle Screen Input Handling", ROMX

; TODO
; - add jumping w/ acceleration
; - give gravity acceleration
; - add per-pixel collision for ramps, both for top collisions and side collisions
;	- would it make sense to look for pixel colors rather than tiles
;	- or to have "collision tiles" that describe non-collidable pixels on a tile

HandleInputEncounterScreen::
HandlePressed:
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
;.checkPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandlePressedSelect
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

HandlePressedA:
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	jp DirtyTilemap

HandlePressedLeft:
HandleHeldLeft:
	; you always turn
	ld a, DIRECTION_LEFT
	ld [wPlayerDirection], a
	; check for collision
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
	jp nz, .tryLeftOnePixel
	jp DirtyTilemap

HandlePressedRight:
HandleHeldRight:
	; you always turn
	ld a, DIRECTION_RIGHT
	ld [wPlayerDirection], a
	; check for collision
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
	jp nz, .tryRightOnePixel
	jp DirtyTilemap

DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

ApplyGravity::
	ld c, PLAYER_GRAVITY_Y ; for each velocity, check one pixel out, move if no collision
.tryOnePixelBeneathLeft
	; get left pixel
	ld a, [wPlayerEncounterX]
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_Y
	sub OAM_PADDING_Y
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileBeneathL], a ; for debugging
	; compare
	cp TILE_ENCOUNTER_FLAT
	jp z, TopCollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, TopCollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, TopCollideHighRamp
.tryOnePixelBeneathRight
	; get right pixel
	ld a, [wPlayerEncounterX]
	add PLAYER_SPRITE_PIXEL_OFFSET_RB_X
	sub OAM_PADDING_X
	ld b, a
	ld a, [wPlayerEncounterY]
	add PLAYER_SPRITE_PIXEL_OFFSET_Y
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
	jp nz, .tryOnePixelBeneathLeft
	jp DirtyTilemap

; do per-tile-pixel collision checks here
TopCollideFlat:
TopCollideLowRamp:
TopCollideHighRamp:
SideCollideFlat:
SideCollideLowRamp:
SideCollideHighRamp:
	ret


; @param a: y
; @param c: x
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
