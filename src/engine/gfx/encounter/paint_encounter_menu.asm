INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Encounter Menu Painting", ROMX

PaintBlankTopMenuRow::
.tl_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT
	ld b, 1
	call CopyByteInEToRange
.top
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 1
	ld b, MODAL_TEXT_AREA_WIDTH
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld b, MODAL_TEXT_AREA_WIDTH
	call CopyByteInEToRange
.tr_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInEToRange
	ret
