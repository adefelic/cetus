INCLUDE "src/constants/explore_constants.inc"

SECTION "Item Map Parsing", ROMX

;; @param d: room X coord
;; @param e: room Y coord
;; @return a, the id of the item in the player's current room. 0 if no item
;GetItemFromRoomInFrontOfPlayer::
;	call GetActiveItemMapRoomAddrFromCoords
;	ld a, [hl]
;	ret
