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
	ld e, INDEX_OW_PALETTE_Z0
	ld hl, wShadowTilemapAttrs
	ld bc, TILEMAP_SIZE
	call PaintTilemapAttrs
	ret
