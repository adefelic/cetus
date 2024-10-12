INCLUDE "src/assets/player_classes.inc"

DEF PLAYER_ATTACKS_COUNT EQU 3

SECTION "Player Character Attributes", WRAM0
;wAttributeEndurance:: db
;wAttributeWillpower:: db
;wLevel:: db

; these should be loaded when the game starts and updated when necessary.
wHpMax:: db
wHpCurrent:: db
wMpMax:: db
wMpCurrent:: db
wPlayerAttacksCount:: db

; collection of addresses of active attacks
wPlayerAttacks:: ; collection of 4 pointers into the Attacks:: array
wPlayerAttack1: dw
wPlayerAttack2: dw
wPlayerAttack3: dw
wPlayerAttack4: dw

SECTION "Player Character Functions", ROM0

InitPlayerCharacter::
	ld a, MAX_HP
	ld [wHpMax], a
	ld [wHpCurrent], a

	ld a, MAX_MP
	ld [wMpMax], a
	ld [wMpCurrent], a

	ld a, PLAYER_ATTACKS_COUNT ; hard code number of available attacks
	ld [wPlayerAttacksCount], a

.loadAttack1
	ld a, LOW(AttackWatch)
	ld [wPlayerAttack1], a
	ld a, HIGH(AttackWatch)
	ld [wPlayerAttack1+1], a
.loadAttack2
	ld a, LOW(AttackSwipe)
	ld [wPlayerAttack2], a
	ld a, HIGH(AttackSwipe)
	ld [wPlayerAttack2+1], a
.loadAttack3
	ld a, LOW(AttackMenace)
	ld [wPlayerAttack3], a
	ld a, HIGH(AttackMenace)
	ld [wPlayerAttack3+1], a
.loadAttack4
	; later
	ret
