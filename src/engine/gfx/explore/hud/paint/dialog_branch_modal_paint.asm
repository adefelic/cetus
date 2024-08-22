INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Dialog Branch Modal Paint Routines", ROMX

PaintModalBottomRowDialogBranch::
.bl_corner
	ld d, TILE_UI_BORDER_BL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5
	ld b, 1
	call CopyByteInEToRange
.bottom_line
	ld d, TILE_UI_BORDER_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols 1
	ld b, 15
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 1
	ld b, 15
	call CopyByteInEToRange
.text
	ld d, "a"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 4)
	ld b, 1
	call CopyByteInDToRange
	ld d, "->"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 3)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 4)
	ld b, 2
	call CopyByteInEToRange
.br_corner
	ld d, TILE_UI_BORDER_BL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInEToRange
	ret
