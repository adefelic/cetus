INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/tiles/indices/overworld_sprites.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"

; top left corners
DEF COMPASS_ARROW_Y EQU TILE_HEIGHT * 1
DEF COMPASS_ARROW_X EQU TILE_WIDTH * 10
DEF COMPASS_CHAR_Y EQU TILE_HEIGHT * 1
DEF COMPASS_CHAR_X EQU TILE_WIDTH * 9
DEF DANGER_Y EQU 0
DEF DANGER_X EQU TILE_WIDTH * 6

SECTION "HUD Paint Routines", ROMX

; todo have a "load oam" routine that loads all explore-screen sprites into the oam
; update this so that it just modifies what's already in there
PaintDangerIndicator::
	ld a, [wCurrentDangerLevel]
	cp DANGER_YELLOW
	jp z, PaintDangerYellow
	cp DANGER_RED
	jp z, PaintDangerRed
PaintDangerGrey:
.OAM_HUD_DANGER_0
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_Y], a
	; x
	ld a, DANGER_X + 8
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_FLAGS], a
.OAM_HUD_DANGER_1
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 1) + 8
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_FLAGS], a
.OAM_HUD_DANGER_2
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 2) + 8
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_FLAGS], a
.OAM_HUD_DANGER_3
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 3) + 8
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_GREY
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_FLAGS], a
.OAM_HUD_DANGER_4
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 4) + 8
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_GREY
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_FLAGS], a
.OAM_HUD_DANGER_5
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 5) + 8
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_FLAGS], a
.OAM_HUD_DANGER_6
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 2) + 8
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_FLAGS], a
.OAM_HUD_DANGER_7
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 7) + 8
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_FLAGS], a
	ret

PaintDangerYellow:
.OAM_HUD_DANGER_0
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_Y], a
	; x
	ld a, DANGER_X + 8
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_FLAGS], a
.OAM_HUD_DANGER_1
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 1) + 8
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_SHORT_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_FLAGS], a
.OAM_HUD_DANGER_2
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 2) + 8
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_FLAGS], a
.OAM_HUD_DANGER_3
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 3) + 8
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_FLAGS], a
.OAM_HUD_DANGER_4
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 4) + 8
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_FLAGS], a
.OAM_HUD_DANGER_5
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 5) + 8
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_FLAGS], a
.OAM_HUD_DANGER_6
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 6) + 8
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_SHORT_YELLOW
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_FLAGS], a
.OAM_HUD_DANGER_7
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 7) + 8
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_NONE
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_FLAGS], a
	ret

PaintDangerRed:
.OAM_HUD_DANGER_0
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_Y], a
	; x
	ld a, DANGER_X + 8
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_SHORT_RED
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_FLAGS], a
.OAM_HUD_DANGER_1
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 1) + 8
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_RED
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_FLAGS], a
.OAM_HUD_DANGER_2
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 2) + 8
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_RED
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_FLAGS], a
.OAM_HUD_DANGER_3
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 3) + 8
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_RED
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_FLAGS], a
.OAM_HUD_DANGER_4
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 4) + 8
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_RED
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_FLAGS], a
.OAM_HUD_DANGER_5
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 5) + 8
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_TALL_RED
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_FLAGS], a
.OAM_HUD_DANGER_6
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 6) + 8
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_MED_RED
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_FLAGS], a
.OAM_HUD_DANGER_7
	; y
	ld a, DANGER_Y + 16
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_Y], a
	; x
	ld a, DANGER_X + (TILE_WIDTH * 7) + 8
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_X], a
	; tile id
	ld a, TILE_DANGER_SHORT_RED
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + INDEX_OW_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_FLAGS], a
	ret

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
