INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/structs/item.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Item Placement Scratch", WRAM0
wWallTypeInFrontOfPlayer:: db
wItemTypeInFrontOfPlayer:: db

SECTION "Explore Screen Item Menu Input Handling", ROM0

HandleInputFromItemMenu::
;.checkPressedStart:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_START
;	jp nz, HandlePressedStart
;.checkPressedSelect:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_SELECT
;	jp nz, HandlePressedSelect
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandlePressedA
.checkPressedB:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_B
	jp nz, HandlePressedB
.checkPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, HandlePressedUp
.checkPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, HandlePressedDown
;.checkPressedLeft:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_LEFT
;	jp nz, HandlePressedLeft
;.checkPressedRight:
;	ld a, [wJoypadNewlyPressed]
;	and a, PADF_RIGHT
;	jp nz, HandlePressedRight
	ret

HandlePressedB:
	jp CloseExploreMenu

HandlePressedUp:
	jp DecrementLineHighlight

HandlePressedDown:
	jp IncrementLineHighlight

; place the highlighted item if there's space
HandlePressedA:
.checkForWallInFrontOfPlayer
	ld hl, wRoomNearCenter ; use room cache hell yeah wrote somethin good
	call GetNorthWallTypeFromRoomAddr ; meanwhile augh it's top not north, but the relatively-named functions are in ROMX with the first person paint routines ;_;
	cp WALL_TYPE_NONE
	jp z, .checkForItemInRoomInFrontOfPlayer
	; todo play negative sound
	ret
.checkForItemInRoomInFrontOfPlayer
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	cp ITEM_NONE
	jp z, .placeItem
	; todo play negative sound
	ret
.placeItem
	ld d, h ; stash item map room in de
	ld e, l
	; get the item id of highlighted item in menu
	call GetHighlightedMenuItemAddr ; in hl
	ld a, Item_InventoryOffset ; what if this wasn't necessary
	AddAToHl
	; push bank
	ld a, [hCurrentRomBank]
	push af
	ld a, bank(xItems)
	rst SwapBank
		ld a, [hl] ; retrieve item index from definition into a
		ld [de], a ; store item id in item map room in ram
		ld b, a ; stash item id for decrementing inv
	; pop bank
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a

	ld a, b
	call DecrementInventoryItemQuantity
	; todo play item placement sound
	jp CloseExploreMenu

CloseExploreMenu:
	ld a, FALSE
	ld [wInExploreMenu], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp DirtyFpSegmentsAndTilemap
