INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Pause Screen State", WRAM0
wWeaponIconTilesReadyForVramWrite:: db
wWeaponPaperDollTilesReadyForVramWrite:: db
wHeadPaperDollTilesReadyForVramWrite:: db
wBodyPaperDollTilesReadyForVramWrite:: db
wLegsPaperDollTilesReadyForVramWrite:: db

SECTION "Pause Screen Renderer", ROMX
UpdatePauseScreen::
	ld a, [wIsShadowTilemapDirty]
	cp FALSE
	ret z
.loadEquipmentTilesIntoVram
	ld a, TRUE
	ld [wWeaponIconTilesReadyForVramWrite], a
.loadPaperDollArmorTilesIntoVram
	ld a, TRUE
	ld [wHeadPaperDollTilesReadyForVramWrite], a
	ld [wBodyPaperDollTilesReadyForVramWrite], a
	ld [wLegsPaperDollTilesReadyForVramWrite], a
	; todo have a loadall function here
.loadPaperDollWeaponTilesIntoVram
	ld a, TRUE
	ld [wWeaponPaperDollTilesReadyForVramWrite], a
.loadBackgroundIntoTilemap
	ld de, BlackBackground
	ld hl, wShadowBackgroundTilemap
	ld bc, BlackBackgroundEnd - BlackBackground
	Memcopy
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
