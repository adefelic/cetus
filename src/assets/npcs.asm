INCLUDE "src/macros/npc.inc"

SECTION "NPC Data", ROMX

; NPC Attack Lists
BrambleAttackList::
	dw AttackTrip

; NPC Reisstance Palettes
BrambleResistancePalette::
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL
	db RV_NEUTRAL

; field encounters
FieldEncounters::
  dstruct NPC, NpcBramble, "bramble", NpcBrambleTiles, BrambleResistancePalette, 1, BrambleAttackList, 40, 20
