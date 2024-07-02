INCLUDE "src/macros/character.inc"

SECTION "Character Data", ROMX

; Character Attack Lists
VinesAttackList::
	dw AttackTrip

; Character Reisstance Palettes
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
  dstruct Character, Vines, "Vines", VinesResistancePalette, 1, VinesAttackList, 40, 20
