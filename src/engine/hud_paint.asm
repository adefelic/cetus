INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/tiles/indices/overworld_sprites.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"

DEF COMPASS_ARROW_Y EQU TILE_HEIGHT * 1
DEF COMPASS_ARROW_X EQU TILE_WIDTH * 10
DEF COMPASS_CHAR_Y EQU TILE_HEIGHT * 1
DEF COMPASS_CHAR_X EQU TILE_WIDTH * 9

SECTION "HUD Paint Routines", ROMX

PaintCompass::
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld b, TILE_COMPASS_CHAR_W
	ld c, TILE_COMPASS_ARROW_RIGHT
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_MODAL
	jp .paintCharacter
.facingNorth
	ld b, TILE_COMPASS_CHAR_N
	ld c, TILE_COMPASS_ARROW_UP
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_MODAL
	jp .paintCharacter
.facingEast
	ld b, TILE_COMPASS_CHAR_E
	ld c, TILE_COMPASS_ARROW_RIGHT
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_MODAL
	jp .paintCharacter
.facingSouth
	ld b, TILE_COMPASS_CHAR_S
	ld c, TILE_COMPASS_ARROW_UP
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 1) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_MODAL
.paintCharacter
	; y
	ld a, COMPASS_CHAR_Y + 16
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_Y], a
	; x
	ld a, COMPASS_CHAR_X + 8
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_X], a
	; tile id
	ld a, b
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_MODAL
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_FLAGS], a
.paintArrow
	; y
	ld a, COMPASS_ARROW_Y + 16
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_Y], a
	; x
	ld a, COMPASS_ARROW_X + 8
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_X], a
	; tile id
	ld a, c
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_TILEID], a
	; attrs/flags
	ld a, d
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_FLAGS], a
	ret
