INCLUDE "src/assets/items.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Item Placement Scratch", WRAM0
wWallTypeInFrontOfPlayer:: db
wItemTypeInFrontOfPlayer:: db
wItemTypeBeingPlaced:: db

SECTION "Explore Screen Item Menu Input Handling", ROMX

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
	; get room in front of player, see if there's a wall in the way
.checkForWall
	; check closest player facing wall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomAddrFromRoomCoords
	call GetTopWallWrtPlayer
	cp WALL_TYPE_NONE
	jp z, .checkForItem
	; todo play negative sound
	ret
.checkForItem
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	ld [wItemTypeInFrontOfPlayer], a ; debug
	cp ITEM_NONE
	jp z, .placeItem
	; todo play negative sound
	ret
.placeItem
	ld d, h ; stash item map room in de
	ld e, l
	; get the item id of highlighted item in menu
	call GetHighlightedMenuItemAddr ; in hl
	ld a, Item_InventoryOffset
	call AddAToHl
	ld a, [hl] ; item index is in a
	ld [wItemTypeBeingPlaced], a ; debug
	ld [de], a ; store item id in item map room
	call DecrementInventoryItemQuantity
	; todo play item placement sound
	jp CloseExploreMenu

CloseExploreMenu:
	ld a, FALSE
	ld [wInExploreMenu], a
	ld a, TRUE
	ld [wBottomMenuDirty], a
	jp DirtyFpSegmentsAndTilemap
