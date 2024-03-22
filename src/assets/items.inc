INCLUDE "src/assets/tiles/indices/computer_dark.inc"
INCLUDE "src/macros/item.inc"
INCLUDE "src/constants/item_constants.inc"


DEF ITEMS_COUNT EQU 3

SECTION "Item Definitions", ROMX

; an item's offset in the definitions collection here is also the offset of its # in wInventory
ItemsMinusOne::
	nop ; so index 0 can equal "no item"
Items::
	; items must begin with 3 spaces that will be replaced with quantities when rendered
	dstruct Item, Rock, "99xpaintedrock"
	dstruct Item, Lamp, "99xlamp"
	dstruct Item, Tent, "99xtent" ; todo why isnt this being rendered in the menu
	;dstruct Item, Tent, "99xtent"
	;dstruct Item, Tent, "99xtent"

