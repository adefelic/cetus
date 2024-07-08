INCLUDE "src/assets/player_classes.inc"

SECTION "Player Character Attributes", WRAM0
;wAttributeEndurance:: db
;wAttributeWillpower:: db
;wLevel:: db

; these should be loaded when the game starts and updated when necessary.
wHpMax:: db
wHpCurrent:: db
wMpMax:: db
wMpCurrent:: db

; array of extra attacks?

SECTION "Player Character Functions", ROMX

InitPlayerCharacter::
	ld a, MAX_HP
	ld [wHpMax], a
	ld [wHpCurrent], a

	ld a, MAX_MP
	ld [wMpMax], a
	ld [wMpCurrent], a
	ret
