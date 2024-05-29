INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/palette_constants.inc"

SECTION "Pause Screen Renderer", ROMX

; pause screen contains current map
UpdateShadowTilemapPauseScreen::
.loadShadowTilemap
	ld a, [wActiveMap]
	ld d, a
	ld a, [wActiveMap+1]
	ld e, a
	ld hl, wShadowTilemap
	ld bc, VISIBLE_TILEMAP_SIZE
	call Memcopy
.loadShadowTilemapAttributes
	ld e, BG_PALETTE_Z0
	ld hl, wShadowTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call PaintTilemapAttrs ; more like, copySingleByteToRange
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_ENCOUNTER
	jp z, PaintEncounterSpritesOffScreen
	cp SCREEN_EXPLORE
	jp z, PaintExploreSpritesOffScreen
	ret
