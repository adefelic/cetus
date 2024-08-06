INCLUDE "src/constants/npc_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "Enemy Rendering", ROMX

DEF NPC_TL EQU rows 4 + cols 9

PaintNpcPortrait::
.loadPalette
	ld a, [wCurrentNpcPalette]
	ld e, a
.row0
	ld d, TILES_ENCOUNTER_NPC
	ld hl, wShadowBackgroundTilemap + NPC_TL
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyIncrementing

	ld hl, wShadowBackgroundTilemapAttrs + NPC_TL
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyByteInEToRange

.row1
	ld d, TILES_ENCOUNTER_NPC + NPC_SPRITE_TILE_WIDTH
	ld hl, wShadowBackgroundTilemap + NPC_TL + rows 1
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyIncrementing

	ld hl, wShadowBackgroundTilemapAttrs + NPC_TL + rows 1
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyByteInEToRange

.row2
	ld d, TILES_ENCOUNTER_NPC + NPC_SPRITE_TILE_WIDTH * 2
	ld hl, wShadowBackgroundTilemap + NPC_TL + rows 2
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyIncrementing

	ld hl, wShadowBackgroundTilemapAttrs + NPC_TL + rows 2
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyByteInEToRange

.row3
	ld d, TILES_ENCOUNTER_NPC + NPC_SPRITE_TILE_WIDTH * 3
	ld hl, wShadowBackgroundTilemap + NPC_TL + rows 3
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyIncrementing

	ld hl, wShadowBackgroundTilemapAttrs + NPC_TL + rows 3
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyByteInEToRange

.row4
	ld d, TILES_ENCOUNTER_NPC + NPC_SPRITE_TILE_WIDTH * 4
	ld hl, wShadowBackgroundTilemap + NPC_TL + rows 4
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyIncrementing

	ld hl, wShadowBackgroundTilemapAttrs + NPC_TL + rows 4
	ld b, NPC_SPRITE_TILE_WIDTH
	call CopyByteInEToRange
	ret
