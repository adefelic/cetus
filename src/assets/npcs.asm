INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/structs/npc.inc"

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

; NPC Resistance Tables
BrambleResistanceTable::
OldBonesResistanceTable::
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
  dstruct NPC, NpcGreenBriars, "green briars", NpcBrambleTiles, NPCGreenBriarsPalette, BrambleResistanceTable, GreenBriarsAttackList, 40, 20
  dstruct NPC, NpcOldBones, "old bones", NpcOldBonesTiles, NPCOldBonesPalette, OldBonesResistanceTable, OldBonesAttackList, 20, 30
