INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/character_constants.inc"

DEF END_COMBAT_STR EQU 10 ; this is arbitrary atm

	struct NPC
		bytes CHARACTER_NAME_LENGTH, Name
		words 1, SpriteAddr
		words 1, PaletteAddr
		; todo
		; words 1, PaletteAddr
		; offsets into ResistancesAddr are resistance type constants (RT_). values are resistance values (RV_)
		words 1, ResistancesAddr
		words 1, AttacksAddr
		bytes 1, MaxHp
		bytes 1, MaxMp
		;bytes END_COMBAT_STR, EndCombatVerb ; todo this would go after their name. "turns and flees", "crumbles away", "vanishes"
		;words 1, ItemDropTable: table of 8 items that represents drop chances after combat
	end_struct
