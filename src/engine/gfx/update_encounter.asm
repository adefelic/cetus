INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/structs/npc.inc"
INCLUDE "src/structs/attack.inc"
INCLUDE "src/structs/palette_animation.inc"

DEF NPC_COUNT_2_EXPONENT EQU 3

SECTION "Encounter Screen Renderer", ROMX

; todo get rid of end states, just do things at the end of animation
UpdateEncounterScreen::
	; state flow:
	; ENCOUNTER_STATE_INITIAL -> ENCOUNTER_STATE_INITIAL_ANIM -> ENCOUNTER_STATE_INITIAL_END ->
	;   ENCOUNTER_STATE_PLAYER_TURN -> ENCOUNTER_STATE_PLAYER_ANIMATION -> ENCOUNTER_STATE_PLAYER_END ->
	; 	ENCOUNTER_STATE_ENEMY_TURN  -> ENCOUNTER_STATE_ENEMY_ANIMATION  -> ENCOUNTER_STATE_ENEMY_END  -> back to ENCOUNTER_STATE_PLAYER_TURN
	;  enemy at 0 hp in ENCOUNTER_STATE_PLAYER_END state -> ENCOUNTER_STATE_REWARD_SCREEN
	;  player at 0 hp in ENCOUNTER_STATE_ENEMY_END state -> ENCOUNTER_STATE_FAIL_SCREEN

	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_INITIAL
	jp z, HandleInitialState
	cp ENCOUNTER_STATE_INITIAL_ANIM
	jp z, HandleInitialAnimState
	cp ENCOUNTER_STATE_INITIAL_END
	jp z, HandleInitialEndState
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
	cp ENCOUNTER_STATE_FAIL_SCREEN
	jp z, HandleFailScreenState
	; control should not reach here
	ret

RollEnemyNpc:
	call Rand
	; mask out bits that arent used by FIELD_NPCS_COUNT. currently  2 bit so AND 3
	AND NPC_COUNT_2_EXPONENT
	sla a ; * 2 so that it's the random number * sizeof address
	ld d, a
	ld hl, wCurrentEncounterTable
	call DereferenceHlIntoHl
	ld a, d
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
	push hl

	; cache ROM sprite addr
	ld a, NPC_SpriteAddr
	call AddAToHl
	ld a, [hli]
	ld [wNpcSpriteTilesRomAddr], a
	ld a, [hl]
	ld [wNpcSpriteTilesRomAddr + 1], a

	pop hl

	ld a, NPC_PaletteAddr
	call AddAToHl
	call DereferenceHlIntoHl
	call EnqueueEnemyBgPaletteUpdate

	ld a, TRUE
	ld [wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram], a
	ret

HandleInitialState:
	call RollEnemyNpc
	ld a, 1
	ld [wAnimationFramesRemaining], a
	ld a, BG_PALETTE_ENEMY
	ld [wCurrentNpcPalette], a
.loadEncounterBackground
	ld de, BlackBackground
	ld hl, wShadowBackgroundTilemap
	ld bc, BlackBackgroundEnd - BlackBackground
	call Memcopy
	ld e, BG_PALETTE_Z0
	ld hl, wShadowBackgroundTilemapAttrs
	ld bc, VISIBLE_TILEMAP_SIZE
	call CopyByteInEToRangeLarge
.paintEnvTiles
	call PaintEnvironment
.paintNpc
	call PaintNpcPortrait
.paintMenu
	call ResetEncounterMenuStateNoHighlight
	call RenderEncounterMenuNpcAppeared
.setAnimState
	ld a, INITIAL_ANIMATION_FRAMES
	ld [wAnimationFramesRemaining], a
	ld a, ENCOUNTER_STATE_INITIAL_ANIM
	ld [wEncounterState], a
	jp UpdateStateIndependentEncounterGraphics

HandleInitialAnimState:
	ld a, [wAnimationFramesRemaining]
	dec a
	ret nz
.setEndState
	ld a, ENCOUNTER_STATE_INITIAL_END
	ld [wEncounterState], a

HandleInitialEndState:
	; this state doesn't do anything special yet
	call ResetEncounterMenuStateHighlight
	ld [wDialogTextRowHighlighted], a
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	jp UpdateStateIndependentEncounterGraphics

HandlePlayerTurnState:
	call RenderEncounterMenuPlayerAttacks
	jp UpdateStateIndependentEncounterGraphics

HandlePlayerAnimState:
	ld a, [wAnimationFramesRemaining] ; this is decremented in the lcd interrupt handler
	dec a
	jp z, .setEndState
.checkNextKeyFrame
	ld a, [wAnimationKeyFramesRemaining]
	sub 0
	jp z, .continue

	; look at the next key frame to see if it matches the current frame #
	ld a, [wNextAnimationKeyFrameFrameNumber]
	ld b, a
	ld a, [wAnimationFramesRemaining]
	cp b
	jp nz, .continue
.applyNewKeyFrame
	ld a, [wNextAnimationKeyFramePalette]
	ld [wCurrentNpcPalette], a
.parseNextKeyFrame
	; inc wNextAnimationKeyFrame pointer
	ld a, [wNextAnimationKeyFrame]
	ld l, a
	ld a, [wNextAnimationKeyFrame+1]
	ld h, a
	ld a, sizeof_PaletteAnimationKeyFrame
	call AddAToHl
	ld a, l
	ld [wNextAnimationKeyFrame], a
	ld a, h
	ld [wNextAnimationKeyFrame+1], a
	; cache contents of next keyframe object
	ld a, [hli]
	ld [wNextAnimationKeyFrameFrameNumber], a
	ld a, [hl]
	ld [wNextAnimationKeyFramePalette], a

	ld a, [wAnimationKeyFramesRemaining]
	dec a
	ld [wAnimationKeyFramesRemaining], a
.continue
	call PaintNpcPortrait
	ld a, [wAnimationFramesRemaining]
	sub 0
	ret nz
.setEndState
	; reset palette
	ld a, BG_PALETTE_ENEMY
	ld [wCurrentNpcPalette], a
	call PaintNpcPortrait
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
	jp UpdateStateIndependentEncounterGraphics
.setNextTurnState
	ld a, ENCOUNTER_STATE_ENEMY_TURN
	ld [wEncounterState], a
	jp UpdateStateIndependentEncounterGraphics

HandleEnemyTurnState:
	call DoEnemySkill
.setEnemyAnimateState
	ld a, ENEMY_ANIMATION_FRAMES
	ld [wAnimationFramesRemaining], a
	ld a, ENCOUNTER_STATE_ENEMY_ANIM
	ld [wEncounterState], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	call RenderEncounterMenuEnemySkillUsed
	jp UpdateStateIndependentEncounterGraphics

HandleEnemyAnimState:
	ld a, [wAnimationFramesRemaining]
	dec a
	ret nz
.setEndState
	ld a, ENCOUNTER_STATE_ENEMY_END
	ld [wEncounterState], a
	ret

HandleEnemyEndState:
	call ResetEncounterMenuStateHighlight
	; todo check for player 0 hp
	; set either player turn or failure screen
	ld a, ENCOUNTER_STATE_PLAYER_TURN
	ld [wEncounterState], a
	jp UpdateStateIndependentEncounterGraphics

HandleFailScreenState: ; todo, add a fail state
HandleRewardScreenState:
	jp LoadRewardScreen

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
	jp PaintRewardScreen

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
