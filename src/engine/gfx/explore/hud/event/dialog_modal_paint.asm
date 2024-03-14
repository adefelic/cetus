INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/utils/hardware.inc"

SECTION "Dialog Modal Paint Routines", ROMX

PaintDialogTopRow::
.tl_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + cols 1
	ld bc, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + cols 1
	ld bc, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrs
.tr_corner
	ld d, TILE_MODAL_TOP_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

; this is probably not very efficient
; @param hl, addr of 14 byte label to print
; @param c, row offset
PaintDialogTextRow::
	push hl ; save addr of 0th byte of text. this will be clobbered by tile destination addrs
.multiplyOffsetByRowSize ; multiply c by the number of bytes in a row
	xor a
	ld d, a ; temp accumulator for final offset
.checkIfCZero
	ld a, c
	add 0
	jp z, .left
	ld a, d
	add BG_ROW_SIZE
	ld d, a
	dec c
	jp .checkIfCZero
.left
	ld c, d
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, 1
	call PaintTilemapAttrsSmall
.text
	; put text addr into de
	pop hl
	ld e, l
	ld d, h
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, DIALOG_MODAL_TEXT_AREA_WIDTH
	call MemcopySmall

	ld a, [wDialogRootTextAreaRowsRendered]
	call PutTextPaletteInE
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrsSmall
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, 1
	call PaintTilemapAttrsSmall
	ret

; @param a, text line #
PutTextPaletteInE:
	ld b, a
	ld a, [wDialogTextRowHighlighted]
	cp b
	jp z, .useHighlightedPalette
.useRegularPalette
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ret
.useHighlightedPalette
	ld e, BG_PALETTE_UI2 + OAMF_BANK1
	ret

PaintEmptyRow::
.multiplyOffsetByRowSize ; multiply c by the number of bytes in a row
	xor a
	ld d, a ; temp accumulator for final offset
.checkIfCZero
	ld a, c
	add 0
	jp z, .left
	ld a, d
	add BG_ROW_SIZE
	ld d, a
	dec c
	jp .checkIfCZero
.left
	ld c, d
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, 1
	call PaintTilemapAttrsSmall
.emptySpace
	ld d, TILE_MODAL_EMPTY
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, DIALOG_MODAL_TEXT_AREA_WIDTH
	call MemcopySmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrsSmall
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 1 + cols (DIALOG_MODAL_WIDTH - 1)
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, 1
	call PaintTilemapAttrsSmall
	ret

; todo make the bottom row have something like "b: leave"
PaintDialogBottomRow::
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemapAttrs
.bottom
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, DIALOG_MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrs
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowTilemap + DIALOG_MODAL_TOP_LEFT + rows 5 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowTilemapAttrs + DIALOG_MODAL_TOP_LEFT + rows 5 + cols (DIALOG_MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

