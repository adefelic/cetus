INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Dialog Root Modal Paint Routines", ROMX
PaintModalTopRowDialogRoot::
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
	ld d, "a"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 1
	ld b, 1
	call PaintTilemapSmall
	ld d, "s"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 2
	ld b, 1
	call PaintTilemapSmall
	ld d, "k"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 3
	ld b, 1
	call PaintTilemapSmall
	ld d, " "
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 4
	ld b, 1
	call PaintTilemapSmall
	ld d, "a"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 5
	ld b, 1
	call PaintTilemapSmall
	ld d, "b"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 6
	ld b, 1
	call PaintTilemapSmall
	ld d, "o"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 7
	ld b, 1
	call PaintTilemapSmall
	ld d, "u"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 8
	ld b, 1
	call PaintTilemapSmall
	ld d, "t"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 9
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld b, 9
	call PaintTilemapAttrsSmall
.top_line
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 10
	ld b, 5
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 10
	ld b, 5
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
