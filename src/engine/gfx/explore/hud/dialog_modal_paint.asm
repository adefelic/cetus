INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/utils/hardware.inc"

DEF DIALOG_MODAL_TOP_LEFT EQU rows 2 + cols 12
DEF DIALOG_MODAL_WIDTH EQU 16
DEF DIALOG_MODAL_HEIGHT EQU 6
DEF DIALOG_MODAL_TEXT_AREA_HEIGHT EQU DIALOG_MODAL_HEIGHT - 2

SECTION "Dialog Modal Paint Routines", ROMX

PaintDialogTopRow::
.tl_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.tr_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

; TODO handle the offset ...
; @param hl, addr of 14 byte label to print
; @param c, row offset
PaintDialogTextRow::
	push hl
.left
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemapAttrs
.text
	pop hl
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 14
	call Memcopy
	ld e, BG_PALETTE_MODAL + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, 14
	call PaintTilemapAttrs
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

PaintEmptyRow::
.left
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1
	ld bc, 1
	call PaintTilemapAttrs
.emptySpace
	ld d, TILE_MODAL_EMPTY
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, DIALOG_MODAL_WIDTH - 2
	call Memcopy
	ld e, BG_PALETTE_MODAL + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	ld bc, DIALOG_MODAL_WIDTH - 2
	call PaintTilemapAttrs
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

PaintDialogBottomRow::
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemapAttrs
.bottom
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, 10
	call PaintTilemap
	ld e, BG_PALETTE_MODAL
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, 10
	call PaintTilemapAttrs
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_MODAL + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

