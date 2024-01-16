INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/encounter_constants.inc"

DEF INITIAL_PLAYER_ENCOUNTER_Y EQU TILE_HEIGHT * 12 + OAM_PADDING_Y
DEF INITIAL_PLAYER_ENCOUNTER_X EQU TILE_WIDTH  * 4 + OAM_PADDING_X

SECTION "Encounter Screen Renderer", ROMX

; load hardcoded screen into shadow tilemap
LoadEncounterScreen::
.loadShadowTilemap
	ld de, Map1EncounterScreen
	ld hl, wShadowTilemap
	ld bc, Map1EncounterScreenEnd - Map1EncounterScreen
	call Memcopy
.loadShadowTilemapAttributes
	ld e, INDEX_OW_PALETTE_Z0
	ld hl, wShadowTilemapAttrs
	ld bc, TILEMAP_SIZE
	call PaintTilemapAttrs
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_ENCOUNTER
	jp z, .updateEncounterSprites
.unloadUnusedSprites
	cp SCREEN_EXPLORE
	jp nz, .updateEncounterSprites
	call PaintExploreSpritesOffScreen
.initEncounterValues
	; this should maybe not be in rendering code
	ld a, INITIAL_PLAYER_ENCOUNTER_Y
	ld [wPlayerEncounterY], a
	ld a, INITIAL_PLAYER_ENCOUNTER_X
	ld [wPlayerEncounterX], a
	ld a, DIRECTION_RIGHT
	ld [wPlayerDirection], a
;.initEncounterSprites
	; sprites should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateEncounterSprites
	call PaintPlayerSprite
	ret
