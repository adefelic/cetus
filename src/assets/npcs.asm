INCLUDE "src/structs/npc.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

SECTION "NPC Data", ROMX

; NPC Attack Lists. out of 4
GreenBriarsAttackList::
	dw AttackTrip
	dw AttackHold
	dw AttackTangle
	dw AttackTangle

OldBonesAttackList::
	dw AttackUnnerve
	dw AttackUnnerve
	dw AttackRake
	dw AttackHold

; NPC Resistance Palettes
BrambleResistancePalette::
OldBonesResistancePalette::
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

NPCs:
  dstruct NPC, NpcGreenBriars, "green briars", NpcBrambleTiles, BrambleResistancePalette, GreenBriarsAttackList, 40, 20
  dstruct NPC, NpcOldBones, "old bones", NpcOldBonesTiles, OldBonesResistancePalette, OldBonesAttackList, 20, 30
