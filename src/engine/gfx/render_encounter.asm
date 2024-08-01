INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/constants/location_constants.inc"
INCLUDE "src/structs/npc.inc"
INCLUDE "src/structs/attack.inc"

SECTION "Encounter Screen Renderer", ROMX

; todo these aren't paced correctly
DEF PLAYER_ANIMATION_FRAMES EQU 60 * 4
DEF ENEMY_ANIMATION_FRAMES EQU 60 * 4

; rename root function to EvalEncounterState? UpdateEncounter probably
; todo add ENCOUNTER_STATE_INITIAL_ANIMATION
UpdateShadowTilemapEncounterScreen::
	; state flow:
	; ENCOUNTER_STATE_INITIAL ->
	; ENCOUNTER_STATE_PLAYER_TURN -> ENCOUNTER_STATE_PLAYER_ANIMATION -> ENCOUNTER_STATE_PLAYER_END
	; ENCOUNTER_STATE_ENEMY_TURN -> ENCOUNTER_STATE_ENEMY_ANIMATION -> ENCOUNTER_STATE_ENEMY_END -> loop
	; once either are at 0 hp in an _END state -> ENCOUNTER_STATE_REWARD_SCREEN
	;
	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_INITIAL
	jp z, HandleInitialState
	cp ENCOUNTER_STATE_PLAYER_TURN
	jp z, HandlePlayerTurnState
	cp ENCOUNTER_STATE_PLAYER_ANIM
	jp z, HandlePlayerAnimState
	cp ENCOUNTER_STATE_PLAYER_END
	jp z, HandlePlayerEndState
	cp ENCOUNTER_STATE_ENEMY_TURN
	jp z, HandleEnemyTurnState
	cp ENCOUNTER_STATE_ENEMY_ANIM
	jp z, HandleEnemyAnimState
	cp ENCOUNTER_STATE_ENEMY_END
	jp z, HandleEnemyEndState
	cp ENCOUNTER_STATE_REWARD_SCREEN
	jp z, HandleRewardScreenState
	; control should not reach here
	ret

InitEnemyNpc:
.rollEnemy
	ld a, [wPlayerLocation]
	cp LOCATION_FIELD
	jr z, RollFieldEnemy
	cp LOCATION_SWAMP
	jr z, RollSwampEnemy
	; control should not reach here
	ret

; put a FIELD npc addr in hl
RollFieldEnemy:
	call Rand
	; mask out bits that arent used by FIELD_NPCS_COUNT. currently only 1 bit so AND 1
	AND 1
	sla a ; * 2 so that it's the random number * sizeof address
	ld hl, FieldNpcs
	call AddAToHl
	call DereferenceHlIntoHl
	jr CacheEnemyState

; put a SWAMP npc addr in hl
RollSwampEnemy:
	call Rand
	; mask out bits that arent used by SWAMP_NPCS_COUNT. currently only 1 bit so AND 1
	AND 1
	sla a ; * 2 so that it's the random number * sizeof address
	ld hl, SwampNpcs
	call AddAToHl
	call DereferenceHlIntoHl
	jr CacheEnemyState

CacheEnemyState:
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
	ret

HandleInitialState:
	call InitEnemyNpc
.setPlayerTurnState
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	jr LoadInitialEncounterGraphics

HandlePlayerTurnState:
	call RenderSkillsMenus
	jp UpdateStateIndependentEncounterGraphics

HandlePlayerAnimState:
	ld a, [wEncounterCurrentAnimationFrame]
	inc a
	cp PLAYER_ANIMATION_FRAMES
	jp z, .setPlayerEndState
.advanceAnimation
	ld [wEncounterCurrentAnimationFrame], a
	jp UpdateStateIndependentEncounterGraphics ; todo, UpdatePlayerAnimationGraphics instead
.setPlayerEndState
	ld a, ENCOUNTER_STATE_PLAYER_END
	ld [wEncounterState], a
	ret

HandlePlayerEndState:
	; check for enemy 0 hp
	ld a, [wNpcCurrentHp]
	sub 0
	jp nz, .setNextTurnState
.setRewardScreenState
	ld a, ENCOUNTER_STATE_REWARD_SCREEN
	ld [wEncounterState], a
	ret
.setNextTurnState
	ld a, ENCOUNTER_STATE_ENEMY_TURN
	ld [wEncounterState], a
	ret

HandleEnemyTurnState:
	call DoEnemySkill
.setEnemyAnimateState
	xor a
	ld [wEncounterCurrentAnimationFrame], a
	ld a, ENCOUNTER_STATE_ENEMY_ANIM
	ld [wEncounterState], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	call RenderEncounterMenuEnemySkillUsed
	jp UpdateStateIndependentEncounterGraphics

HandleEnemyAnimState:
	ld a, [wEncounterCurrentAnimationFrame]
	inc a
	cp ENEMY_ANIMATION_FRAMES
	jp z, .setEnemyEndState
.advanceAnimation
	ld [wEncounterCurrentAnimationFrame], a
	jp UpdateStateIndependentEncounterGraphics
.setEnemyEndState
	ld a, ENCOUNTER_STATE_ENEMY_END
	ld [wEncounterState], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp UpdateStateIndependentEncounterGraphics

HandleEnemyEndState:
	; todo check for player 0 hp
	; set either player turn or failure screen
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	call ResetSkillMenuState
	jp UpdateStateIndependentEncounterGraphics

HandleRewardScreenState:
	jp LoadRewardScreen

HandleFailureScreenState:
	; todo design a fail screen and put it here instead
	jp LoadRewardScreen

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
;.paintSkillMenu
; todo maybe the skills menu should have "____ APPEARED"
;	call RenderEnemyAppeared

UpdateStateIndependentEncounterGraphics:
.loadEncounterHUDIntoShadowTilemap
	call PaintNPCStatus
	call PaintPlayerStatus
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_ENCOUNTER
	ret z
.unloadUnusedSprites
	cp SCREEN_EXPLORE
	ret nz
	call PaintExploreSpritesOffScreen
	ret

LoadRewardScreen:
	call PaintRewardScreen
	ret

DoEnemySkill:
	ld hl, wNpcAddr
	call DereferenceHlIntoHl
	; hl now holds addr of npc
	ld a, NPC_AttacksAddr
	call AddAToHl
	call DereferenceHlIntoHl
	push hl
	; hl now holds addr of attack list
	call Rand
	AND %00000011 ; random # 0-3 for a random attack
	sla a ; go from bytes to words. each attack in the list is an address
	pop hl
	call AddAToHl
	call DereferenceHlIntoHl
	; hl now holds addr of attack definition

	; cache def reference
	ld a, l
	ld [wCurrentAttack], a
	ld a, h
	ld [wCurrentAttack+1], a

.subDamageFromHp
	ld a, Attack_DamageValue
	call AddAToHl
	ld a, [hl]
	ld b, a

	; subtract from player hp
	ld a, [wHpCurrent]
	sub b
	jp nc, .updateHp
.setZeroHp
	xor a
.updateHp
	ld [wHpCurrent], a
	ret
