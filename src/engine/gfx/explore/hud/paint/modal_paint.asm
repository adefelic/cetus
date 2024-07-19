INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Modal Paint Routines", ROMX

PaintModalTopRow::
.tl_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT
	ld bc, 1
	call PaintTilemapAttrs
.top
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols 1
	ld bc, MODAL_TEXT_AREA_WIDTH
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols 1
	ld bc, MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrs
.tr_corner
	ld d, TILE_MODAL_TL_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemapAttrs
	ret

; todo rename to PaintHighlightableTextRow ?
; todo does replacing the highlight (color) with a cursor save a palette? i dont think so
; this is probably not very efficient
; @param hl, addr of 14 byte label to print
; @param c, row offset
PaintModalTextRow::
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
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1
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
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1
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
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, MODAL_TEXT_AREA_WIDTH
	call MemcopySmall

	ld a, [wTextRowsRendered]
	call PutTextPaletteInE
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a

	ld b, MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrsSmall
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
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
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
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

PaintModalEmptyRow::
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
	ld c, d ; put offset back into c
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	; paint
	ld b, 1
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1
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
	ld d, $40 ; this is the space character
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	; paint tiles
	ld b, MODAL_TEXT_AREA_WIDTH
	call PaintTilemapSmall

	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols 1
	; add row offset to hl
	ld a, l
	add a, c
	ld l, a
	ld a, h
	adc 0
	ld h, a
	; paint tile attrs
	ld b, MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrsSmall
.right
	ld d, TILE_MODAL_VERTICAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
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
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 1 + cols (MODAL_WIDTH - 1)
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

PaintModalBottomRow::
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5
	ld b, 1
	call PaintTilemapAttrsSmall
.bottom
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, MODAL_TEXT_AREA_WIDTH
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 1
	ld b, MODAL_TEXT_AREA_WIDTH
	call PaintTilemapAttrsSmall
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapAttrsSmall
	ret

PaintModalBottomRowCheckX::
.bl_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5
	ld b, 1
	call PaintTilemapAttrsSmall
.bottom_line
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols 1
	ld bc, MODAL_WIDTH - 6
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols 1
	ld b, MODAL_WIDTH - 6
	call PaintTilemapAttrsSmall
.text
	ld d, "b"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 7)
	ld b, 1
	call PaintTilemapSmall
	ld d, "X"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 6)
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 7)
	ld b, 2
	call PaintTilemapAttrsSmall

	; "_"
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 5)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 5)
	ld b, 1
	call PaintTilemapAttrsSmall

	ld d, "a"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 4)
	ld b, 1
	call PaintTilemapSmall
	ld d, "check"
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 3)
	ld b, 1
	call PaintTilemapSmall
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 4)
	ld b, 2
	call PaintTilemapAttrsSmall

	; "_"
	ld d, TILE_MODAL_HORIZONTAL
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 2)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 2)
	ld b, 1
	call PaintTilemapAttrsSmall
.br_corner
	ld d, TILE_MODAL_BOTTOM_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld bc, 1
	call PaintTilemap
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + MODAL_TOP_LEFT + rows 5 + cols (MODAL_WIDTH - 1)
	ld b, 1
	call PaintTilemapAttrsSmall
	ret
