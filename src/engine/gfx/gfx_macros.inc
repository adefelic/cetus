
MACRO paint_row_single_tile
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInEToRange
ENDM

MACRO paint_row_incrementing
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyIncrementing
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInEToRange
ENDM
