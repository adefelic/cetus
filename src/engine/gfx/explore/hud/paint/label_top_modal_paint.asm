INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/utils/macros.inc"

DEF LABEL_MODAL_TOP_LEFT EQU rows 2 + cols 4
DEF LABEL_MODAL_WIDTH EQU 12
DEF LABEL_MODAL_HEIGHT EQU 3

SECTION "Label Modal Paint Routines", ROM0

; this is for painting 1 line, 10 character LABELS at the top of the screen
; todo make macro for painting both tilemap + attrs
; @param d: the tile index to paint with
PaintLabelTopModal::
.tl_corner
	ld d, TILE_UI_BORDER_TL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT
	ld b, 1
	call CopyByteInEToRange
.top
	ld d, TILE_UI_BORDER_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + cols 1
	ld b, 10
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + cols 1
	ld b, 10
	call CopyByteInEToRange
.tr_corner
	ld d, TILE_UI_BORDER_TL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInEToRange
.left
	ld d, TILE_UI_BORDER_VERTICAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1
	ld b, 1
	call CopyByteInEToRange
.text
	ld hl, wCurrentLabelAddr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1 + cols 1
	ld b, 10
	MemcopySmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1 + cols 1
	ld b, 10
	call CopyByteInEToRange
.right
	ld d, TILE_UI_BORDER_VERTICAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1 + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1 + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInEToRange
.bl_corner
	ld d, TILE_UI_BORDER_BL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2
	ld b, 1
	call CopyByteInEToRange
.bottom
	ld d, TILE_UI_BORDER_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2 + cols 1
	ld b, 10
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2 + cols 1
	ld b, 10
	call CopyByteInEToRange
.br_corner
	ld d, TILE_UI_BORDER_BL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2 + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2 + cols (LABEL_MODAL_WIDTH - 1)
	ld b, 1
	call CopyByteInEToRange
	ret
