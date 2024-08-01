INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/attack_constants.inc"

	struct Attack
		bytes ATTACK_NAME_LENGTH, Name
		bytes 1, DamageValue
		bytes 1, MpCost
		bytes ATTACK_ACTION_STRING_LENGTH, YouText  ; "you __________________"
		bytes ATTACK_ACTION_STRING_LENGTH, ThemText ; "they __________________"
	end_struct
