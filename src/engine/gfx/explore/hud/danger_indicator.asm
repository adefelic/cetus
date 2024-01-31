INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"

; top left corners
DEF DANGER_Y EQU 0
DEF DANGER_X EQU TILE_WIDTH * 6

SECTION "HUD Danger Indicator Paint Routines", ROMX

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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
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
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_DANGER
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_FLAGS], a
	ret
