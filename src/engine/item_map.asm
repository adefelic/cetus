INCLUDE "src/constants/explore_constants.inc"

SECTION "Item Map Parsing", ROMX

; todo replace with LoadItemMap which would dump some sram into wItemMap
ClearItemMap::
	ld bc, wItemMapEnd - wItemMap
	ld hl, wItemMap
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop
	ret

; item map addr + wPlayerExploreX + wPlayerExploreY*32
; @param d: room X coord
; @param e: room Y coord
; @return hl: item map room address of tile
GetActiveItemMapRoomAddrFromCoords::
	ld hl, wItemMap
	jp GetRoomAddrFromCoords
