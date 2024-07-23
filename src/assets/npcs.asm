INCLUDE "src/structs/npc.inc"

SECTION "NPC Data", ROMX

; NPC Attack Lists
DEF GREEN_BRIARS_ATTACK_COUNT EQU 3
GreenBriarsAttackList::
	dw AttackTrip
	dw AttackSnare
	dw AttackTangle

DEF OLD_BONES_ATTACK_COUNT EQU 3
OldBonesAttackList::
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
  dstruct NPC, NpcGreenBriars, "green briars", NpcBrambleTiles, BrambleResistancePalette, 1, GreenBriarsAttackList, 40, 20
  dstruct NPC, NpcOldBones, "old bones", NpcOldBonesTiles, OldBonesResistancePalette, 1, OldBonesAttackList, 20, 30
