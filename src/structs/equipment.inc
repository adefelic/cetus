INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/item_constants.inc"

	struct Equipment
		bytes EQUIPMENT_NAME_LENGTH, Name
		words 1, PaperDollTilesAddr
		words 1, IconTilesAddr
	end_struct
