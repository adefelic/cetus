INCLUDE "src/utils/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "debug motion", WRAM0
wTileBeneathL:: db
wTileBeneathR:: db

SECTION "Battle Screen Input Handling", ROMX

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
	ld a, DIRECTION_LEFT
	ld [wPlayerDirection], a
	ld a, [wPlayerEncounterX]
	sub PLAYER_VELOCITY_X
	; bounds check todo
	ld [wPlayerEncounterX], a
	jp DirtyTilemap

HandlePressedRight:
	ld a, DIRECTION_RIGHT
	ld [wPlayerDirection], a
	ld a, [wPlayerEncounterX]
	add PLAYER_VELOCITY_X
	; bounds check todo
	ld [wPlayerEncounterX], a
	jp DirtyTilemap

HandleHeldLeft:
	ld a, [wPlayerEncounterX]
	sub PLAYER_VELOCITY_X
	; bounds check todo
	ld [wPlayerEncounterX], a
	jp DirtyTilemap

HandleHeldRight:
	ld a, [wPlayerEncounterX]
	add PLAYER_VELOCITY_X
	; bounds check todo
	ld [wPlayerEncounterX], a
	jp DirtyTilemap

DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

ApplyGravity::
.checkBeneathBottomLeft
	ld a, [wPlayerEncounterY]
	add TILE_HEIGHT * 2 - OAM_PADDING_Y
	ld b, a
	ld a, [wPlayerEncounterX]
	sub OAM_PADDING_X
	call GetTileMapTileAddrFromPixelCoords
	ld c, a
	ld a, [hl]
	ld [wTileBeneathL], a
	cp TILE_ENCOUNTER_FLAT
	jp z, CollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, CollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, CollideHighRamp
.checkBeneathBottomRight
	ld a, [wPlayerEncounterY]
	add TILE_HEIGHT * 2 - OAM_PADDING_Y
	ld b, a
	ld a, [wPlayerEncounterX]
	add TILE_WIDTH * 2 - 1 - OAM_PADDING_X
	ld c, a
	call GetTileMapTileAddrFromPixelCoords
	ld a, [hl]
	ld [wTileBeneathR], a
	cp TILE_ENCOUNTER_FLAT
	jp z, CollideFlat
	cp TILE_ENCOUNTER_RAMP_LOW
	jp z, CollideLowRamp
	cp TILE_ENCOUNTER_RAMP_HIGH
	jp z, CollideHighRamp
.adjustY
	; todo: add gravity pixels until colliding with a collision pixel, so gravity can be more than 1 pixel
	ld a, [wPlayerEncounterY]
	add PLAYER_GRAVITY_Y
	ld [wPlayerEncounterY], a
	jp DirtyTilemap

; do per-tile-pixel collision checks here
CollideFlat:
CollideLowRamp:
CollideHighRamp:
	ret


; TODO this is definitely broken
; @param c: x
; @param b: y
; @return hl
GetTileMapTileAddrFromPixelCoords:
	; this assumes tilemaps are the size of the tilemap and not the size of the screen
	; addr = wShadowTilemap + y/8 * 32 + x/8

	xor a
	ld h, a
	ld l, b
rept 2
	sla h
	sla l
	ld a, h
	adc 0
	ld h, a
endr

	srl a
	srl a
	srl a
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld de, wShadowTilemap
	add hl, de
	ret






