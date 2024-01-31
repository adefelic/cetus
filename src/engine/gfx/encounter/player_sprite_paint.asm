INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"

SECTION "Player Sprite Variables", WRAM0
wPlayerSpriteTL:: db
wPlayerSpriteTR:: db
wPlayerSpriteBL:: db
wPlayerSpriteBR:: db
wPlayerSpriteFlags:: db

SECTION "Player Sprite Paint Routines", ROMX

PaintPlayerSprite::
	ld a, [wPlayerDirection]
	cp DIRECTION_LEFT
	jp z, .setPlayerSpritesLeft
.setPlayerSpritesRight:
	ld a, TILE_CHINCHILLA_A_TR
	ld [wPlayerSpriteTL], a
	ld a, TILE_CHINCHILLA_A_TL
	ld [wPlayerSpriteTR], a
	ld a, TILE_CHINCHILLA_A_BR
	ld [wPlayerSpriteBL], a
	ld a, TILE_CHINCHILLA_A_BL
	ld [wPlayerSpriteBR], a
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_PLAYER
	ld [wPlayerSpriteFlags], a
	jp .paintTopLeft
.setPlayerSpritesLeft:
	ld a, TILE_CHINCHILLA_A_TL
	ld [wPlayerSpriteTL], a
	ld a, TILE_CHINCHILLA_A_TR
	ld [wPlayerSpriteTR], a
	ld a, TILE_CHINCHILLA_A_BL
	ld [wPlayerSpriteBL], a
	ld a, TILE_CHINCHILLA_A_BR
	ld [wPlayerSpriteBR], a
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_PLAYER
	ld [wPlayerSpriteFlags], a
.paintTopLeft
	; y
	ld a, [wPlayerEncounterY]
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_Y], a
	; x
	ld a, [wPlayerEncounterX]
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_X], a
	; tile id
	ld a, [wPlayerSpriteTL]
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_TILEID], a
	; attrs/flags
	ld a, [wPlayerSpriteFlags]
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_FLAGS], a
.paintTopRight
	; y
	ld a, [wPlayerEncounterY]
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_Y], a
	; x
	ld a, [wPlayerEncounterX]
	add TILE_WIDTH * 1
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_X], a
	; tile id
	ld a, [wPlayerSpriteTR]
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_TILEID], a
	; attrs/flags
	ld a, [wPlayerSpriteFlags]
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_FLAGS], a
.paintBottomLeft
	; y
	ld a, [wPlayerEncounterY]
	add TILE_HEIGHT * 1
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_Y], a
	; x
	ld a, [wPlayerEncounterX]
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_X], a
	; tile id
	ld a, [wPlayerSpriteBL]
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_TILEID], a
	; attrs/flags
	ld a, [wPlayerSpriteFlags]
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_FLAGS], a
.paintBottomRight
	; y
	ld a, [wPlayerEncounterY]
	add TILE_HEIGHT * 1
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_Y], a
	; x
	ld a, [wPlayerEncounterX]
	add TILE_WIDTH * 1
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_X], a
	; tile id
	ld a, [wPlayerSpriteBR]
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_TILEID], a
	; attrs/flags
	ld a, [wPlayerSpriteFlags]
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_FLAGS], a
	ret

PaintEncounterSpritesOffScreen::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_Y], a
	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_X], a
	ret
