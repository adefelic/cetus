INCLUDE "src/macros/npc.inc"

SECTION "NPC Data", ROMX

; NPC Attack Lists
VinesAttackList::
	dw AttackTrip

; NPC Reisstance Palettes
VinesResistancePalette::
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
  dstruct NPC, Vines, "Vines", VinesResistancePalette, 1, VinesAttackList, 40, 20
