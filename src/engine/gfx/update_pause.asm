INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/palette_constants.inc"


SECTION "Pause Screen State", WRAM0
wDoesWeaponIconTileDataNeedToBeCopiedIntoVram:: db

SECTION "Pause Screen Renderer", ROMX

UpdatePauseScreen::
	ld a, [wIsShadowTilemapDirty]
	cp FALSE
	ret z
.loadEquipmentTilesIntoVram
	ld a, TRUE
	ld [wDoesWeaponIconTileDataNeedToBeCopiedIntoVram], a
.loadPaperDollArmorTilesIntoVram
.loadPaperDollWeaponTilesIntoVram
.loadBackgroundIntoTilemap
	ld de, BlackBackground
	ld hl, wShadowBackgroundTilemap
	ld bc, BlackBackgroundEnd - BlackBackground
	call Memcopy
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call CopyByteInEToRangeLarge
.loadPaperDollScreen
	call RenderPaperDollScreen
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	;cp SCREEN_ENCOUNTER
	;jp z, PaintEncounterSpritesOffScreen
	cp SCREEN_EXPLORE
	call z, PaintExploreSpritesOffScreen
.clean
	ld a, FALSE
	ld [wIsShadowTilemapDirty], a
	ret
