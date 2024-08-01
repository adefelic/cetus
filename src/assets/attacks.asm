INCLUDE "src/constants/character_constants.inc"
INCLUDE "src/structs/attack.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "Attack Definitions", ROMX

; todo add "you text" and "them text"
; todo add attack types
Attacks::
	dstruct Attack, AttackSway, "sway", 5, 0, "gently sway.", "gently sways." ; "sways. there is no wind." "sways in the still air"
	dstruct Attack, AttackDeceive, "deceive", 25, 2, "are uncanny", "are uncanny"
	dstruct Attack, AttackCrowPeck, "crow peck", 30, 3, "whisper to a crow", "a crow launches" ; "a crow rakes __"
	dstruct Attack, AttackSpear, "spear", 30, 4, "lunge with a spear", "lunge with a spear"
	dstruct Attack, AttackTrip, "trip", 15, 1, "trip them up", "trips you over";
	dstruct Attack, AttackUnnerve, "watch", 10, 1, "watch in silence", "watch in silence"
	dstruct Attack, AttackGrasp, "grasp", 12, 1, "lunge with hands", "lunges with hands"
	dstruct Attack, AttackHold, "hold", 18, 1, "grab onto them", "grab onto you"
	dstruct Attack, AttackTangle, "tangle", 15, 1, "tangle them", "tangle you"
	dstruct Attack, AttackTrap, "trap", 20, 1, "block their exit", "block your exit"
	dstruct Attack, AttackRake, "rake", 20, 1, "rake with nails", "rake with nails"
