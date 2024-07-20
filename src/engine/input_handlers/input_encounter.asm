INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/encounter_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/structs/attack.inc"

SECTION "Battle Screen Input Handling", ROMX

HandleInputEncounterScreen::
	; todo: if not player turn, disable input
HandlePressed:
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

HandlePressedSelect:
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
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
.advanceEncounterState
	; go to ENCOUNTER_STATE_PLAYER_END
	; eventually what would happen here is we would kick off an animation.
	; when the animation resolved, there would be a check to see if anyone is at zero hp and if the encounter end screen should be entered

	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp DirtyFpSegmentsAndTilemap
