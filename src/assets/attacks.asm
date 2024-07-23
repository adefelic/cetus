INCLUDE "src/constants/character_constants.inc"
INCLUDE "src/structs/attack.inc"

SECTION "Attack Definitions", ROMX

; todo add "you text" and "them text"
Attacks::
	dstruct Attack, AttackSway, "sway", 5, 0 ; "__ sways gently"
	dstruct Attack, AttackDeceive, "deceive", 25, 2 ; "__ tricks __"
	dstruct Attack, AttackCrowPeck, "crow peck", 30, 3 ; "a crow rakes __"
	dstruct Attack, AttackSpear, "spear", 50, 4
	dstruct Attack, AttackTrip, "trip", 15, 1 ; " __ trips you"
	dstruct Attack, AttackUnnerve, "watch", 10, 1 ; "__ watches you"
	dstruct Attack, AttackSnare, "snare", 10, 1
	dstruct Attack, AttackGrasp, "grasp", 12, 1
	dstruct Attack, AttackHold, "hold", 18, 1
	dstruct Attack, AttackTangle, "tangle", 15, 1
	dstruct Attack, AttackTrap, "trap", 20, 1
	dstruct Attack, AttackRake, "rake", 20, 1
