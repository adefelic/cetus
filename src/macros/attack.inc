INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/attack_constants.inc"

	struct Attack
		bytes ATTACK_NAME_LENGTH, Name
		;bytes ATTACK_ACTION_STRING_LENGTH, ActionString ; ____ harvested ___. is this necessary? visual feedback probably would be better
		bytes 1, ResistanceTypeA
		bytes 1, DamageValueA
		bytes 1, ResistanceTypeB
		bytes 1, DamageValueB
		; todo cost
		; todo hp heal effect strength
		; todo mp heal effect strength
	end_struct
