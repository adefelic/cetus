INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/character_constants.inc"

	; this is for enemies i should just call it enemies

	; these should all just be constants?
	struct Character
		bytes CHARACTER_NAME_LENGTH, Name
		; offsets into ResistancesAddr are resistance type constants (RT_). values are resistance values (RV_)
		words 1, ResistancesAddr
		bytes 1, AttacksCount ; size of attack array
		words 1, AttacksAddr  ; addr of array of offsets into attack chart
		bytes 1, MaxHp
		bytes 1, MaxMp
	end_struct
