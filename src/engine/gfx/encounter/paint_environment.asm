INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "Encounter Environment Rendering", ROMX

DEF ENV_LEFT_BLOCK_TL EQU rows 4
DEF ENV_RIGHT_BLOCK_TL EQU ENV_LEFT_BLOCK_TL + cols 15

PaintEnvironment::
.leftBlock
	ld d, TILES_ENV_BLOCK_LEFT
	ld hl, wShadowBackgroundTilemap + ENV_LEFT_BLOCK_TL
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_LEFT + TILES_ENV_LINE_WIDTH
	ld hl, wShadowBackgroundTilemap + ENV_LEFT_BLOCK_TL + rows 1
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_LEFT + TILES_ENV_LINE_WIDTH * 2
	ld hl, wShadowBackgroundTilemap + ENV_LEFT_BLOCK_TL + rows 2
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_LEFT + TILES_ENV_LINE_WIDTH * 3
	ld hl, wShadowBackgroundTilemap + ENV_LEFT_BLOCK_TL + rows 3
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_LEFT + TILES_ENV_LINE_WIDTH * 4
	ld hl, wShadowBackgroundTilemap + ENV_LEFT_BLOCK_TL + rows 4
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

.rightBlock
	ld d, TILES_ENV_BLOCK_RIGHT
	ld hl, wShadowBackgroundTilemap + ENV_RIGHT_BLOCK_TL
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_RIGHT + TILES_ENV_LINE_WIDTH
	ld hl, wShadowBackgroundTilemap + ENV_RIGHT_BLOCK_TL + rows 1
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_RIGHT + TILES_ENV_LINE_WIDTH * 2
	ld hl, wShadowBackgroundTilemap + ENV_RIGHT_BLOCK_TL + rows 2
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_RIGHT + TILES_ENV_LINE_WIDTH * 3
	ld hl, wShadowBackgroundTilemap + ENV_RIGHT_BLOCK_TL + rows 3
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing

	ld d, TILES_ENV_BLOCK_RIGHT + TILES_ENV_LINE_WIDTH * 4
	ld hl, wShadowBackgroundTilemap + ENV_RIGHT_BLOCK_TL + rows 4
	ld b, TILES_ENV_LINE_WIDTH
	call CopyIncrementing
	ret
