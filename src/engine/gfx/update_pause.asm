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

SECTION "Pause Screen Renderer", ROM0
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
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(Map1) ; BlackBackground lives here for now
		rst SwapBank
		ld de, BlackBackground
		ld hl, wShadowBackgroundTilemap
		ld bc, BlackBackgroundEnd - BlackBackground
		Memcopy
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a

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
