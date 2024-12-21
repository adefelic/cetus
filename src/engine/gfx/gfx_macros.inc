
; these macros include calls to functions in ROM0

MACRO paint_row_single_tile
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInEToRange
ENDM

MACRO paint_row_incrementing
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyIncrementing
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInEToRange
ENDM
