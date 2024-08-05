INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/structs/attack.inc"

SECTION "Battle Screen Input Handling", ROMX

HandleInputEncounterScreen::
	; todo: if not player turn, disable input
	ld a, [wEncounterState]
	cp ENCOUNTER_STATE_PLAYER_TURN
	jp z, HandleInputPlayerTurn
	cp ENCOUNTER_STATE_REWARD_SCREEN
	jp z, HandleInputRewardScreen
	ret

HandleInputPlayerTurn:
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
.checkPressedSelect:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_SELECT
	jp nz, HandlePressedSelect
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandlePressedA
;.checkPressedB:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_B
;	jp nz, HandlePressedB
.checkPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, HandlePressedUp
.checkPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, HandlePressedDown
;.checkPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp z, .checkPressedRight
;	call HandlePressedLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp z, HandleHeld
;	call HandlePressedRight
	; bad
	ret

HandleInputRewardScreen:
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandlePressedARewardScreen
	ret

HandlePressedARewardScreen:
	; reload explore screen
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a ; i can't remember what this is used for. also setting this here is bad anyways?
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a

	call HandleVisibleEvents

	; todo reload bg palette 6 to map default(special/enemy)
	; requires storing map palette addr, or map struct

	jp DirtyFpSegmentsAndTilemap

HandlePressedSelect:
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	call HandleVisibleEvents
	jp DirtyFpSegmentsAndTilemap

HandlePressedUp:
	jp DecrementLineHighlight

HandlePressedDown:
	jp IncrementLineHighlight

HandlePressedA:
DoAttack:
; todo, reorder the attack struct elements to match the order that they're used here so we can hli
; there's going to be changes to the struct w things like resistances and hp costs so this is for down the line
	call GetHighlightedMenuItemAddr
	push hl ; stash Attack addr

.checkMpCost
	ld a, Attack_MpCost
	call AddAToHl
	ld a, [hl]
	ld b, a ; put mp cost in b

	ld a, [wMpCurrent]
	cp b
	ret c ; quit out if Attack_MpCost > wMpCurrent

.subFromMp
	sub b
	ld [wMpCurrent], a

.subDamageFromHp
	pop hl ; restore Attack addr

	; cache def reference (this can go anywhere)
	ld a, l
	ld [wCurrentAttack], a
	ld a, h
	ld [wCurrentAttack+1], a

	ld a, Attack_DamageValue
	call AddAToHl
	ld a, [hl]
	ld b, a

	; subtract from enemy hp
	ld a, [wNpcCurrentHp]
	sub b
	jp nc, .updateHp
.setZeroHp
	xor a
.updateHp
	ld [wNpcCurrentHp], a
.setPlayerAnimateState
	ld a, PLAYER_ANIMATION_FRAMES
	ld [wEncounterCurrentAnimationFrame], a
	ld a, ENCOUNTER_STATE_PLAYER_ANIM
	ld [wEncounterState], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	call RenderEncounterMenuSkillUsed
	ret
	;jp UpdateStateIndependentEncounterGraphics
