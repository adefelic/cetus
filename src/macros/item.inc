INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/menu_constants.inc"

; Item struct definition

	struct Item
		bytes BYTES_IN_DIALOG_STRING, Label; string. this text is displayed in the dialog option menu

		bytes 1, InventoryOffset ; index into wInventory to find the item's current quantity.
		; this might be unnessecary as you can just subtract the item's addr from Items:: ??

		; todo address of sprite?
	end_struct
