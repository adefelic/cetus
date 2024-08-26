INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/attack_constants.inc"

	struct Attack
		bytes ATTACK_NAME_LENGTH, Name
		bytes 1, DamageValue
		bytes 1, MpCost
		bytes ATTACK_ACTION_STRING_LENGTH, VerbString  ; "you/they __________________"
		;bytes 1, Speed ; # between 0 and 99. 0 is fastest
		;bytes 1, Type ;
	end_struct
