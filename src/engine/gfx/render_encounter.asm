INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/macros/character.inc"

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

	; set wEnemyCurrentHp to their max hp
	ld a, Character_MaxHp
	call AddAToHl
	ld a, [hl]
	ld hl, wEnemyCurrentHp
	ld [hl], a
.cachePlayerState

	; we have player info
	; we need to draw those things to the screen now
	; enemy:
	; 	use enemy id to pull up their max hp, name, and resistance palette
	;   use cached value (wEnemyCurrentHp) to pull up their current hp
	; player:
	;   get wCurrentPlayerHp
	;   get wCurrentPlayerMp
	;   get CurrentPlayerMaxHp ; calculated from end?
	;	get CurrentPlayerMaxMp ; calculated from wil?
	; 	get moves
		; each move will have a name, an effect, and a cost. part of a scrolling menu
	call UpdateScreen
	ret

HandlePlayerTurnState:
	call UpdateScreen
	ret

HandleEnemyTurnState:
	call UpdateScreen
	ret

UpdateScreen:
; load hardcoded screen into shadow tilemap
.loadShadowTilemapForBlackBackground
	; okay next up is to set up the stuff that doesn't change on the battle screen: window borders
	; fixme it is absolutely brutal to be doing this mem copy every frame
	ld de, Map1EncounterScreen
	ld hl, wShadowBackgroundTilemap
	ld bc, Map1EncounterScreenEnd - Map1EncounterScreen
	call Memcopy
.loadShadowTilemapForMenus
	call PaintEncounterMenus
.loadShadowTilemapAttributes
	ld e, BG_PALETTE_Z0
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call PaintTilemapAttrs
.updateShadowOam:
	;ld a, [wPreviousFrameScreen]
	;cp SCREEN_ENCOUNTER
	;jp z, .updateEncounterSprites
.unloadUnusedSprites
	cp SCREEN_EXPLORE
	jp nz, .updateEncounterSprites
	call PaintExploreSpritesOffScreen
;.initEncounterSprites
	; sprites should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateEncounterSprites
	;call PaintPlayerSprite
	ret
