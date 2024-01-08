INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"

SECTION "Pause Screen Renderer", ROMX

; pause screen contains current map
LoadPauseScreen::
.loadShadowTilemap
	ld a, [wActiveMap]
	ld d, a
	ld a, [wActiveMap+1]
	ld e, a
	ld hl, wShadowTilemap
	ld bc, TILEMAP_SIZE
	call Memcopy
.loadShadowTilemapAttributes
	; todo this is broken. the shadow tilemaps should be SCREEN_SIZE rather than TILEMAP_SIZE?
	; this would only change the time it takes for the memcopy. it would save space though
	ld e, INDEX_OW_PALETTE_Z0
	ld hl, wShadowTilemapAttrs
	ld bc, TILEMAP_SIZE
	call PaintTilemapAttrs
	ld a, SCREEN_PAUSE
	ld [wActiveScreen], a
	ret
