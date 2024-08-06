INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/structs/palette_animation.inc"

SECTION "Animation Definitions", ROMX

; PaletteAnimations
	dstruct PaletteAnimation, EncounterDamagePaletteAnimation, 60, 4, EncounterDamagePaletteAnimationFrames


; todo, different damage animation when enemy is at critical health. flash BG_PALETTE_ENEMY_DAMAGE_CRITICAL palette
EncounterDamagePaletteAnimationFrames::
	dstruct PaletteAnimationKeyFrame, EncounterDamageKeyFrame0, 59, BG_PALETTE_ENEMY_DAMAGE
	dstruct PaletteAnimationKeyFrame, EncounterDamageKeyFrame1, 39, BG_PALETTE_ENEMY
	dstruct PaletteAnimationKeyFrame, EncounterDamageKeyFrame2, 19, BG_PALETTE_ENEMY_DAMAGE
	dstruct PaletteAnimationKeyFrame, EncounterDamageKeyFrame3,  0, BG_PALETTE_ENEMY

