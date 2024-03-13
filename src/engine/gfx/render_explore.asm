INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"

SECTION "Explore Screen Renderer", ROMX

InitExploreState::
	call InitEventState
	ret

; todo change map stuff to compass directions. trbl is player relative, nesw is absolute
; todo rename this to ... draw FP Tilemap?
; trbl are all relative to the player's orientation
LoadExploreScreen::
.updateShadowBgTilemap
	; render walls
	; todo:
	;   maybe make it so when rendering an event, all other background are painted with a single palette?
	;   it might look weird flattening depth like that.
	call RenderFirstPersonView

	; maybe render event on top of first person view
	ld a, [wIsPlayerFacingWallInteractable]
	cp FALSE
	jp z, .updateShadowOam
	call RenderDialog
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_EXPLORE
	jp z, .updateExploreSprites
.unloadUnusedSprites
	cp SCREEN_ENCOUNTER
	jp nz, .updateExploreSprites
	call PaintEncounterSpritesOffScreen
;.initExploreSprites
	; init maybe not right word.
	; they should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateExploreSprites
	; todo this is writing to the oam every frame.
	; it should write once and update when necessary
	call PaintDangerIndicator
	call PaintCompass
	ret

PaintExploreSpritesOffScreen::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_X], a
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_X], a
	ret

