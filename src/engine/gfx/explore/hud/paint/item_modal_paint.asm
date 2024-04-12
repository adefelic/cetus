INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Item Modal Paint Routines", ROMX
PaintModalTopRowItemMenu::
.tl_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT
	ld b, 1
	call PaintTilemapAttrsSmall
.text
	ld d, "p"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 1
	ld b, 1
	call PaintTilemapSmall
	ld d, "l"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 2
	ld b, 1
	call PaintTilemapSmall
	ld d, "a"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 3
	ld b, 1
	call PaintTilemapSmall
	ld d, "c"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 4
	ld b, 1
	call PaintTilemapSmall
	ld d, "e"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 5
	ld b, 1
	call PaintTilemapSmall
	ld d, " "
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 6
	ld b, 1
	call PaintTilemapSmall
	ld d, "i"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 7
	ld b, 1
	call PaintTilemapSmall
	ld d, "t"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 8
	ld b, 1
	call PaintTilemapSmall
	ld d, "e"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 9
	ld b, 1
	call PaintTilemapSmall
	ld d, "m"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 10
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld b, 10
	call PaintTilemapAttrsSmall
.top_line
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols 11
	ld b, 4
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + cols 11
	ld b, 4
	call PaintTilemapAttrsSmall
.tr_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapAttrsSmall
	ret

PaintModalBottomRowItemMenu::
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
	ld d, "b"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 9
	ld b, 1
	call PaintTilemapSmall
	ld d, "X"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 10
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 9
	ld b, 2
	call PaintTilemapAttrsSmall

	; "_"
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 11
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 11
	ld bc, 1
	call PaintTilemapAttrs

	ld d, "a"
	ld hl, wShadowTilemap + MODAL_TOP_LEFT + rows 5 + cols 12
	ld b, 1
	call PaintTilemapSmall
	ld d, "check"
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
