INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/structs/npc.inc"

SECTION "Encounter Screen Renderer", ROMX

; rename root function to EvalEncounterState?
UpdateShadowTilemapEncounterScreen::
	; state flow:
	; ENCOUNTER_STATE_INITIAL ->
	; ENCOUNTER_STATE_PLAYER_TURN -> ENCOUNTER_STATE_PLAYER_ANIMATION -> ENCOUNTER_STATE_PLAYER_END
	; ENCOUNTER_STATE_ENEMY_TURN -> ENCOUNTER_STATE_ENEMY_ANIMATION -> ENCOUNTER_STATE_ENEMY_END -> loop
	;
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
	ld hl, NpcBramble
.cacheEnemyState
	; store enemy definition table addr
	ld a, l
	ld [wNpcAddr], a
	ld a, h
	ld [wNpcAddr+1], a

	push hl

	; set wNpcCurrentHp to their max hp. cache values
	ld a, NPC_MaxHp
	call AddAToHl
	ld a, [hl]
	ld hl, wNpcCurrentHp
	ld [hl], a
	ld hl, wNpcMaxHp
	ld [hl], a

	pop hl

	; cache ROM sprite addr
	ld a, NPC_SpriteAddr
	call AddAToHl
	ld a, [hli]
	ld [wNpcSpriteTilesRomAddr], a
	ld a, [hl]
	ld [wNpcSpriteTilesRomAddr + 1], a

	ld a, TRUE
	ld [wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram], a

	jp LoadInitialEncounterGraphics

HandlePlayerTurnState:
	jp UpdateEncounterGraphics

HandleEnemyTurnState:
	jp UpdateEncounterGraphics

LoadInitialEncounterGraphics:
.loadBackground
	ld de, Map1EncounterScreen
	ld hl, wShadowBackgroundTilemap
	ld bc, Map1EncounterScreenEnd - Map1EncounterScreen
	call Memcopy
	ld e, BG_PALETTE_Z0
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call PaintTilemapAttrs
.paintEnv
	call PaintEnvironment
.paintNpc
	call PaintNpcSprite

UpdateEncounterGraphics:
.loadEncounterHUDIntoShadowTilemap
	call PaintNPCStatus
	call PaintPlayerStatus
	call RenderSkillsMenus

.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_ENCOUNTER
	jp z, .advanceEncounterState
.unloadUnusedSprites
	cp SCREEN_EXPLORE
	jp nz, .advanceEncounterState
	call PaintExploreSpritesOffScreen
.advanceEncounterState
	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_INITIAL
	ret nz
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	ret
