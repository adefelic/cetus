INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Item Modal Paint Routines", ROMX
PaintModalTopRowItemMenu::
.tl_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT
	ld b, 1
	call PaintTilemapAttrsSmall
.text
	ld d, "p"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 1
	ld b, 1
	call PaintTilemapSmall
	ld d, "l"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 2
	ld b, 1
	call PaintTilemapSmall
	ld d, "a"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 3
	ld b, 1
	call PaintTilemapSmall
	ld d, "c"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 4
	ld b, 1
	call PaintTilemapSmall
	ld d, "e"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 5
	ld b, 1
	call PaintTilemapSmall
	ld d, " "
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 6
	ld b, 1
	call PaintTilemapSmall
	ld d, "i"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 7
	ld b, 1
	call PaintTilemapSmall
	ld d, "t"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 8
	ld b, 1
	call PaintTilemapSmall
	ld d, "e"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 9
	ld b, 1
	call PaintTilemapSmall
	ld d, "m"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 10
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld b, 10
	call PaintTilemapAttrsSmall
.top_line
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 11
	ld b, 4
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 11
	ld b, 4
	call PaintTilemapAttrsSmall
.tr_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapAttrsSmall
	ret
