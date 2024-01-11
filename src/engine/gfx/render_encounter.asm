INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"

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
	call UnloadExploreSprites
;.initEncounterSprites
	; init maybe not right word.
	; they should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateEncounterSprites
	call PaintPlayerSprite
	ret

UnloadEncounterSprites::
	; todo only load OFFSCREEN values once, do all the ys, all the xs
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_Y], a
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_Y], a
	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_CHINCHILLA_TL + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_TR + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_BL + OAMA_X], a
	ld [wShadowOam + OAM_CHINCHILLA_BR + OAMA_X], a
	ret
