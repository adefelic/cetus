INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/character_constants.inc"

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
	end_struct
