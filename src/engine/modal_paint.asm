INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"
INCLUDE "src/assets/tile.inc"
INCLUDE "src/utils/hardware.inc"

SECTION "Modal Paint Routines", ROMX

; todo make macro for painting both tilemap + attrs
; @param d: the tile index to paint with
PaintModal::
.tl_corner
	ld d, MODAL_TILE_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_4
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + BG_ROW_1 + BG_COL_4
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, MODAL_TILE_HORIZONTAL
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_5
	ld bc, 10
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + BG_ROW_1 + BG_COL_5
	ld bc, 10
	call PaintTilemapAttrs
.tr_corner
	ld d, MODAL_TILE_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_15
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + BG_ROW_1 + BG_COL_15
	ld bc, 1
	call PaintTilemapAttrs
.left
	ld d, MODAL_TILE_VERTICAL
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_4
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + BG_ROW_2 + BG_COL_4
	ld bc, 1
	call PaintTilemapAttrs
.text ; single row
	;todo should move this deref?
	ld hl, wEventFrameAddr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_5
	ld bc, 10
	call Memcopy
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + BG_ROW_2 + BG_COL_5
	ld bc, 10
	call PaintTilemapAttrs
.right
	ld d, MODAL_TILE_VERTICAL
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_15
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + BG_ROW_2 + BG_COL_15
	ld bc, 1
	call PaintTilemapAttrs
.bl_corner
	ld d, MODAL_TILE_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_4
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + BG_ROW_3 + BG_COL_4
	ld bc, 1
	call PaintTilemapAttrs
.bottom
	ld d, MODAL_TILE_HORIZONTAL
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_5
	ld bc, 10
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + BG_ROW_3 + BG_COL_5
	ld bc, 10
	call PaintTilemapAttrs
.br_corner
	ld d, MODAL_TILE_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_15
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + BG_ROW_3 + BG_COL_15
	ld bc, 1
	call PaintTilemapAttrs
	ret
