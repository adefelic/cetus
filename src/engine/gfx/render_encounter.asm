INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/macros/npc.inc"

SECTION "Encounter Screen Renderer", ROMX

; rename root function to EvalEncounterState?
UpdateShadowTilemapEncounterScreen::
	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_INITIAL
	jp z, HandleInitialState
	cp ENCOUNTER_STATE_PLAYER_TURN
	jp z, HandlePlayerTurnState
	cp ENCOUNTER_STATE_ENEMY_TURN
	jp z, HandleEnemyTurnState
	; control should not reach here
	ret

HandleInitialState:
.rollEnemy
	; todo: get current biome, get current biome enemy table, roll from table
	ld hl, Vines
.cacheEnemyState
	; store enemy definition table addr
	ld a, l
	ld [wEnemyAddr], a
	ld a, h
	ld [wEnemyAddr+1], a

	; set wEnemyCurrentHp to their max hp. cache values for easier display
	ld a, NPC_MaxHp
	call AddAToHl
	ld a, [hl]
	ld hl, wEnemyCurrentHp
	ld [hl], a
	ld hl, wEnemyMaxHp
	ld [hl], a
	jp LoadInitialEncounterTiles

HandlePlayerTurnState:
	jp UpdateEncounterTiles

HandleEnemyTurnState:
	jp UpdateEncounterTiles

LoadInitialEncounterTiles:
.loadShadowTilemapForBlackBackground
	ld de, Map1EncounterScreen
	ld hl, wShadowBackgroundTilemap
	ld bc, Map1EncounterScreenEnd - Map1EncounterScreen
	call Memcopy
.loadShadowTilemapAttributes
	ld e, BG_PALETTE_Z0
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call PaintTilemapAttrs
.loadEnvironment
	call PaintEnvironment

UpdateEncounterTiles:
.loadEncounterHUDIntoShadowTilemap
	;call RenderSkillsMenus
	call PaintPlayerStatus
	call RenderEnemy
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_ENCOUNTER
	jp z, .updateEncounterSprites
.unloadUnusedSprites
	cp SCREEN_EXPLORE
	jp nz, .updateEncounterSprites
	call PaintExploreSpritesOffScreen
;.initEncounterSprites
	; sprites should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateEncounterSprites
	;call PaintPlayerSprite
.updateFromInitialState
	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_INITIAL
	ret nz
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	ret
