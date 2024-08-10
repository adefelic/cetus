INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/palette_constants.inc"

SECTION "Pause Screen Renderer", ROMX

; pause screen contains current map
; actually it is broken now, but that is okay
; this should be replaced with a paper doll screen
UpdatePauseScreen::
.loadShadowTilemap
	ld a, [wCurrentMapWalls]
	ld d, a
	ld a, [wCurrentMapWalls+1]
	ld e, a
	ld hl, wShadowBackgroundTilemap
	ld bc, VISIBLE_TILEMAP_SIZE
	call Memcopy
.loadShadowTilemapAttributes
	ld e, BG_PALETTE_Z0
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call CopyByteInEToRangeLarge
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	;cp SCREEN_ENCOUNTER
	;jp z, PaintEncounterSpritesOffScreen
	cp SCREEN_EXPLORE
	jp z, PaintExploreSpritesOffScreen
	ret
