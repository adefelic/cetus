INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/gfx_constants.inc"

; top left corners
; this probably shouldn't be a const
DEF PLAYER_SPRITE_INITIAL_Y EQU TILE_HEIGHT * 12
DEF PLAYER_SPRITE_INITIAL_X EQU TILE_WIDTH  * 4

SECTION "Player Sprite Paint Routines", ROMX

PaintPlayerSprite::
.paintTopLeft
	; y
	ld a, PLAYER_SPRITE_INITIAL_Y + 16
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_Y], a
	; x
	ld a, PLAYER_SPRITE_INITIAL_X + 8
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_X], a
	; tile id
	ld a, TILE_CHINCHILLA_A_TL
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_PLAYER
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_FLAGS], a
.paintTopRight
	; y
	ld a, PLAYER_SPRITE_INITIAL_Y + 16
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_Y], a
	; x
	ld a, PLAYER_SPRITE_INITIAL_X + TILE_WIDTH * 1 + 8
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_X], a
	; tile id
	ld a, TILE_CHINCHILLA_A_TR
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_PLAYER
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_FLAGS], a
.paintBottomLeft
	; y
	ld a, PLAYER_SPRITE_INITIAL_Y + TILE_HEIGHT * 1 + 16
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_Y], a
	; x
	ld a, PLAYER_SPRITE_INITIAL_X + 8
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_X], a
	; tile id
	ld a, TILE_CHINCHILLA_A_BL
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_PLAYER
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_FLAGS], a
.paintBottomRight
	; y
	ld a, PLAYER_SPRITE_INITIAL_Y + TILE_HEIGHT * 1 + 16
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_Y], a
	; x
	ld a, PLAYER_SPRITE_INITIAL_X + TILE_WIDTH * 1 + 8
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_X], a
	; tile id
	ld a, TILE_CHINCHILLA_A_BR
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_PLAYER
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_FLAGS], a
	ret
