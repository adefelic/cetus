INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Dialog Branch Modal Paint Routines", ROMX

PaintModalBottomRowDialogBranch::
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemapAttrs
.bottom_line
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, 8
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, 8
	call PaintTilemapAttrs
.text

	; "_"
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 9
	ld bc, 3
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 9
	ld bc, 3
	call PaintTilemapAttrs

	ld d, "a"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 12
	ld b, 1
	call PaintTilemapSmall
	ld d, "->"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 13
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 12
	ld b, 2
	call PaintTilemapAttrsSmall

	; "_"
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 14
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 14
	ld bc, 1
	call PaintTilemapAttrs
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret
