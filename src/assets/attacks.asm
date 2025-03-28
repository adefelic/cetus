INCLUDE "src/constants/character_constants.inc"
INCLUDE "src/structs/attack.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Attack Definitions", ROMX

; todo add alternate text if there's a critical hit?
Attacks::
	dstruct Attack, AttackSway, "sway", 5, 0, "gently sway" ; "sways. there is no wind." "sways in the still air"
	dstruct Attack, AttackDeceive, "deceive", 25, 2, "are uncanny"
	dstruct Attack, AttackCrowPeck, "crow peck", 30, 3, "whisper to a crow" ; "a crow rakes __"
	dstruct Attack, AttackSpear, "spear", 30, 4, "lunge with a spear"
	dstruct Attack, AttackTrip, "trip", 15, 1, "trips you over"
	dstruct Attack, AttackUnnerve, "watch", 10, 1, "watch in silence"
	dstruct Attack, AttackGrasp, "grasp", 12, 1, "lunges with hands"
	dstruct Attack, AttackHold, "hold", 18, 1, "grab onto you"
	dstruct Attack, AttackTangle, "tangle", 15, 1, "tangle you"
	dstruct Attack, AttackTrap, "trap", 20, 1, "block your exit"
	dstruct Attack, AttackRake, "rake", 20, 1, "rake with nails"
	dstruct Attack, AttackSunRay, "sun ray", 20, 1, "glow like the sun"
	dstruct Attack, AttackMoonRay, "moon ray", 20, 1, "glow like the moon"
	dstruct Attack, AttackGlow, "glow", 20, 1, "silently glows"
	dstruct Attack, AttackLull, "lull", 20, 1, "lulls you"
	dstruct Attack, AttackFlutter, "lull", 20, 1, "flies erratically"
	dstruct Attack, AttackSwipe, "swipe", 20, 1, "take a broad swipe"
	dstruct Attack, AttackMenace, "menace", 20, 1, "reposition"
	dstruct Attack, AttackWatch, "watch", 20, 1, "observe the field"


; moved from utils.asm, in ROM0
; @param a, # to convert. must be >= 0 and <= 99
; @return d, # in 10s place
; @return e, # in 1s place
ConvertBinaryNumberToTwoDigitDecimalNumber_Attacks::
	ld b, a
	xor a
	ld d, a
	ld e, a
	ld a, b
.subTens
	sub 10
	jp c, .carryFromTens
	jp z, .finishFromTens
	inc d
	jp .subTens
.carryFromTens
	add 10
	jp .subOnes
.finishFromTens
	inc d
	ret
.subOnes
	sub 1
	ret c
	jp z, .finishFromOnes
	inc e
	jp .subOnes
.finishFromOnes
	inc e
	ret
