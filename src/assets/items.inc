INCLUDE "src/assets/tiles/indices/computer_dark.inc"
INCLUDE "src/macros/item.inc"
INCLUDE "src/constants/item_constants.inc"

SECTION "Item Definitions", ROMX

; an item's offset in the definitions collection here is also the offset of its # in wInventory
ItemsMinusOne::
	nop ; so index 0 can equal "no item"
Items::
	; items must begin with 3 spaces that will be replaced with quantities when rendered
	dstruct Item, Quartz, "99x quartz", ITEM_QUARTZ
	dstruct Item, Lamp, "99x lamp", ITEM_LAMP
	dstruct Item, Tent, "99x tent", ITEM_TENT ; todo why isnt this being rendered in the menu
	;dstruct Item, Tent, "99x tent"
	;dstruct Item, Tent, "99x tent"

