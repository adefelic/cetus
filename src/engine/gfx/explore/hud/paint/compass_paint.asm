INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/palette_constants.inc"

; top left corners
DEF COMPASS_ARROW_Y EQU TILE_HEIGHT * 1 + OAM_PADDING_Y
DEF COMPASS_ARROW_X EQU TILE_WIDTH * 10 + OAM_PADDING_X
DEF COMPASS_CHAR_Y EQU TILE_HEIGHT * 1 + OAM_PADDING_Y
DEF COMPASS_CHAR_X EQU TILE_WIDTH * 9 + OAM_PADDING_X

SECTION "HUD Compass Paint Routines", ROMX

; todo, fix, this is copying sprites into the OAM every frame, whether they change or not
PaintCompass::
	ld a, [wPlayerOrientation]
	cp ORIENTATION_NORTH
	jp z, .facingNorth
	cp ORIENTATION_EAST
	jp z, .facingEast
	cp ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld b, TILE_COMPASS_CHAR_W
	ld c, TILE_COMPASS_ARROW_RIGHT
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + BG_PALETTE_UI
	jp .paintCharacter
.facingNorth
	ld b, TILE_COMPASS_CHAR_N
	ld c, TILE_COMPASS_ARROW_UP
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + BG_PALETTE_UI
	jp .paintCharacter
.facingEast
	ld b, TILE_COMPASS_CHAR_E
	ld c, TILE_COMPASS_ARROW_RIGHT
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + BG_PALETTE_UI
	jp .paintCharacter
.facingSouth
	ld b, TILE_COMPASS_CHAR_S
	ld c, TILE_COMPASS_ARROW_UP
	ld d, (OAMF_PRI * 0) + (OAMF_YFLIP * 1) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + BG_PALETTE_UI
.paintCharacter
	; y
	ld a, COMPASS_CHAR_Y
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_Y], a
	; x
	ld a, COMPASS_CHAR_X
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_X], a
	; tile id
	ld a, b
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + BG_PALETTE_UI
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_FLAGS], a
.paintArrow
	; y
	ld a, COMPASS_ARROW_Y
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_Y], a
	; x
	ld a, COMPASS_ARROW_X
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_X], a
	; tile id
	ld a, c
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_TILEID], a
	; attrs/flags
	ld a, d
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_FLAGS], a
	ret
