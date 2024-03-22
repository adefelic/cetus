
SECTION "Item Map Parsing", ROMX

; this assumes that a room can only have a 1 of an item.
; @return a, the id of the item in the player's current room. 0 if no item
GetItemFromCurrentRoom::
	call GetActiveMapRoomItemAddrFromCoords
	ld a, [hl]
	ret
