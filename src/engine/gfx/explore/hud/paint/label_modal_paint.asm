INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"

DEF LABEL_MODAL_TOP_LEFT EQU rows 2 + cols 4
DEF LABEL_MODAL_WIDTH EQU 12
DEF LABEL_MODAL_HEIGHT EQU 3

SECTION "Label Modal Paint Routines", ROMX

; this is for painting 1 line, 10 character LABELS at the top of the screen
; todo make macro for painting both tilemap + attrs
; @param d: the tile index to paint with
PaintLabelModel::
.tl_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.tr_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
.left
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemapAttrs
.text
	ld hl, wCurrentLabelAddr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 10
	call Memcopy
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 1 + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 1 + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2
	ld bc, 1
	call PaintTilemapAttrs
.bottom
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2 + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2 + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + LABEL_MODAL_TOP_LEFT + rows 2 + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + LABEL_MODAL_TOP_LEFT + rows 2 + cols (LABEL_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret
