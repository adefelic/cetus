INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Encounter Screen Renderer", ROMX

; load hardcoded screen into shadow tilemap
LoadEncounterScreen::
	ld de, Map1EncounterScreen
	ld hl, wShadowTilemap
	ld bc, Map1EncounterScreenEnd - Map1EncounterScreen
	call Memcopy
.loadShadowTilemapAttributes
	ld e, INDEX_OW_PALETTE_Z0
	ld hl, wShadowTilemapAttrs
	ld bc, TILEMAP_SIZE
	call PaintTilemapAttrs
	ret
