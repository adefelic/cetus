INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

DEF REWARD_SCREEN_TOP_LEFT EQU rows 5 + cols 2
DEF REWARD_SCREEN_WIDTH EQU 20 - 4

SECTION "Reward Screen Painting", ROMX

PaintRewardScreen::
.blank_row0
	ld d, TILE_UI_BORDER_EMPTY
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + REWARD_SCREEN_TOP_LEFT
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInEToRange
.blank_row1
	ld d, TILE_UI_BORDER_EMPTY
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 1
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + REWARD_SCREEN_TOP_LEFT + rows 1
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInEToRange
.text
	ld d, " "
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2
	ld b, 2
	call CopyByteInDToRange
	ld d, "y"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 2
	ld b, 1
	call CopyByteInDToRange
	ld d, "o"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 3
	ld b, 1
	call CopyByteInDToRange
	ld d, "u"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 4
	ld b, 1
	call CopyByteInDToRange
	ld d, " "
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 5
	ld b, 1
	call CopyByteInDToRange
	ld d, "d"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 6
	ld b, 1
	call CopyByteInDToRange
	ld d, "i"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 7
	ld b, 1
	call CopyByteInDToRange
	ld d, "d"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 8
	ld b, 1
	call CopyByteInDToRange
	ld d, " "
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 9
	ld b, 1
	call CopyByteInDToRange
	ld d, "i"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 10
	ld b, 1
	call CopyByteInDToRange
	ld d, "t"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 11
	ld b, 1
	call CopyByteInDToRange
	ld d, "!"
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 12
	ld b, 1
	call CopyByteInDToRange
	ld d, " "
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 2 + cols 13
	ld b, 5
	call CopyByteInDToRange

	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + REWARD_SCREEN_TOP_LEFT + rows 2
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInEToRange
.blank_row2
	ld d, TILE_UI_BORDER_EMPTY
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 3
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + REWARD_SCREEN_TOP_LEFT + rows 3
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInEToRange
.blank_row3
	ld d, TILE_UI_BORDER_EMPTY
	ld hl, wShadowBackgroundTilemap + REWARD_SCREEN_TOP_LEFT + rows 4
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + REWARD_SCREEN_TOP_LEFT + rows 4
	ld b, REWARD_SCREEN_WIDTH
	call CopyByteInEToRange
	ret
