INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/structs/npc.inc"

SECTION "NPC Data", ROMX

; NPC Attack Lists. out of 4
GreenBriarsAttackList:
	dw AttackTrip
	dw AttackHold
	dw AttackTangle
	dw AttackTangle

OldBonesAttackList:
	dw AttackUnnerve
	dw AttackUnnerve
	dw AttackRake
	dw AttackHold

SunflowerAttackList:
	dw AttackTangle
	dw AttackGlow
	dw AttackGlow
	dw AttackSunRay

MoonflowerAttackList:
	dw AttackTangle
	dw AttackGlow
	dw AttackGlow
	dw AttackMoonRay

ButterflyAttackList:
	dw AttackLull
	dw AttackGlow
	dw AttackFlutter
	dw AttackMoonRay

ScarecrowAttackList:
	dw AttackSpear
	dw AttackSway
	dw AttackDeceive
	dw AttackCrowPeck

; NPC Resistance Tables
BrambleResistanceTable:
OldBonesResistanceTable:
SunflowerResistanceTable:
MoonflowerResistanceTable:
ButterflyResistanceTable:
ScarecrowResistanceTable:
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
  dstruct NPC, NpcSunflower, "sunflower", NpcSunflowerTiles, NPCSunflowerPalette, SunflowerResistanceTable, SunflowerAttackList, 40, 20
  dstruct NPC, NpcMoonflower, "moonflower", NpcSunflowerTiles, NPCMoonflowerPalette, MoonflowerResistanceTable, MoonflowerAttackList, 20, 40
  dstruct NPC, NpcButterfly, "tarn moth", NpcButterflyTiles, NPCButterflyPalette, ButterflyResistanceTable, ButterflyAttackList, 20, 60
  dstruct NPC, NpcScarecrow, "straw effigy", NpcScarecrowTiles, NPCScarecrowPalette, ScarecrowResistanceTable, ScarecrowAttackList, 40, 5


