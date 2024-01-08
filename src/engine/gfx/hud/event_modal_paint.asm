INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"
INCLUDE "src/assets/tiles/indices/overworld_tileset.inc"
INCLUDE "src/utils/hardware.inc"

DEF MODAL_TOP_LEFT EQU rows 2 + cols 4
DEF MODAL_WIDTH EQU 12
DEF MODAL_HEIGHT EQU 3

SECTION "Event Modal Paint Routines", ROMX

; todo make macro for painting both tilemap + attrs
; @param d: the tile index to paint with
PaintEventModal::
.tl_corner
	ld d, MODAL_TILE_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, MODAL_TILE_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.tr_corner
	ld d, MODAL_TILE_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
.left
	ld d, MODAL_TILE_VERTICAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemapAttrs
.text ; single row
	;todo should move this deref?
	ld hl, wEventFrameAddr
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 10
	call Memcopy
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.right
	ld d, MODAL_TILE_VERTICAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
.bl_corner
	ld d, MODAL_TILE_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 2
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 2
	ld bc, 1
	call PaintTilemapAttrs
.bottom
	ld d, MODAL_TILE_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 2 + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 2 + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.br_corner
	ld d, MODAL_TILE_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 2 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, INDEX_OW_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 2 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret
