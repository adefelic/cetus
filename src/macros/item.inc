INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/menu_constants.inc"

; Item struct definition

	struct Item
		bytes BYTES_IN_DIALOG_STRING, Label; string. this text is displayed in the dialog option menu
		; todo address of sprite?
	end_struct
