INCLUDE "src/constants/character_constants.inc"
INCLUDE "src/macros/attack.inc"

SECTION "Attack Definitions", ROMX

Attacks::
	dstruct Attack, AttackSway, "Sway", RT_STRESS, 20, RT_NONE, 0 ; this should heal mp too
	dstruct Attack, AttackDeceive, "Deceive", RT_CONFUSE, 40, RT_NONE, 0
	dstruct Attack, AttackTrip, "Trip", RT_CONFUSE, 20, RT_CRUSH, 20
