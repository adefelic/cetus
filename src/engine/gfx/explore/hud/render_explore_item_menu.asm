INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/macros/item.inc"

SECTION "Item Rendering Scratch", WRAM0
wItemQuantityNameStringBuffer:: ds BYTES_IN_DIALOG_STRING
wCurrentItemAddr:: dw

SECTION "Explore Item Menu Renderer", ROMX

; todo rendering breaks when the inventory is totally empty
RenderExploreItemMenu::
.checkDirty
	ld a, [wDialogModalDirty]
	cp TRUE
	ret nz
.renderTopRow
	call PaintModalTopRowItemMenu
.checkNeedsToRepopulateMenuItemsList
	; todo, compare current menu state w previous menu state
	call PopulateListToRenderInMenu
.setStartingMenuItemIndex
	; todo, compare current menu state w previous menu state
	; this should maybe be done a level above this.
	xor a
	ld [wMenuItemTopVisible], a
.setup
	; have wCurrentMenuItem point to wMenuItems
	ld hl, wMenuItems ; source
	ld a, [wMenuItemCount] ; maybe populating the list should set this

	ld a, [wMenuItemTopVisible]
	ld b, a ; b is the menu item offset that being rendered.
	ld c, 0 ; row offset, 0-3.
.renderMenuItemRowsLoop
	push hl ; stash current wMenuItems position ptr
	push bc ; stash b and c iterators

	; dereference wMenuItems position ptr to get Item addr in hl and wCurrentItemAddr
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a ; bc now contains addr of Item

	ld a, b
	ld l, a
	ld [wCurrentItemAddr], a

	ld a, c
	ld h, a
	ld [wCurrentItemAddr + 1], a

	;;; get item quantity and convert to decimal
	ld a, Item_InventoryOffset
	call AddAToHl
	ld a, [hl] ; a now contains wInventory offset
	ld hl, wInventory
	call AddAToHl
	ld a, [hl] ; a now contains wInventory quantity
	call ConvertBinaryNumberToDecimalNumber ; 10s in d, 1s in e
	pop hl ; restore wMenuItems position ptr
	push hl ; stash wMenuItems position ptr

	; copy decimal characters + item name into wItemQuantityNameStringBuffer
	ld hl, wItemQuantityNameStringBuffer
	; 10s place
	ld a, d
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	; 1s place
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a

	; skip "99x" characters
	ld a, [wCurrentItemAddr]
	ld e, a
	ld a, [wCurrentItemAddr + 1]
	ld d, a
	inc de
	inc de
	ld a, BYTES_IN_DIALOG_STRING - 3
	ld b, a
	call MemcopySmall

	ld hl, wItemQuantityNameStringBuffer

	; hl should be ptr to first char of wItemQuantityNameStringBuffer
	pop bc ; restore iterators for PaintModalTextRow
	push bc ; save iterators
	call PaintModalTextRow
.updateIterators
	pop bc ; restore iterators

	pop hl ; restore item def ptr and inc hl by sizeof_Item
	inc hl
	inc hl ; add 2 to point to next wMenuItems entry

	; inc and check
	inc c
	ld a, c
	ld [wDialogRootTextAreaRowsRendered], a ; painting uses this
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow

	ld a, [wMenuItemCount]
	inc b
	cp b
	jp nz, .renderMenuItemRowsLoop
.renderBlankRows
	ld a, [wDialogRootTextAreaRowsRendered]
.renderBlankRowsLoop
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow
	ld c, a
	call PaintModalEmptyRow ; c is an arg to this
	ld a, [wDialogRootTextAreaRowsRendered]
	inc a
	ld [wDialogRootTextAreaRowsRendered], a
	jp .renderBlankRowsLoop
.renderBottomRow
	call PaintModalBottomRowCheckX
	ld a, FALSE
	ld [wDialogModalDirty], a
	ret

; populates wMenuItems::
; mangles a,b,d,e,h,l
PopulateListToRenderInMenu:
.setup
	xor a
	ld [wMenuItemCount], a
	; b is the loop counter / current item's offset in Items / current item's offset in wInventory ( -1 )
	ld b, a
	ld de, Items ; source, item definitions
	ld hl, wMenuItems ; destination, area for Item definition addrs
.filterInventoryItemsWithNonZeroQuantityLoop
.checkQuantityOfItemInInventory
	push hl ; stash addr of wMenuItems[b]
	ld hl, wInventory + 1 ; to deal with 0 meaning empty space
	ld a, b
	call AddAToHl
	ld a, [hl]
	pop hl ; restore wMenuItems[b]
	cp 0
	jp z, .updateIterator ; skip if none
.saveItemToMenuItems
	; update hl: move addr of current item def (in de) into wMenuItems[b] (in hl)
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a ; inc once more to point to next space in wMenuItems

	; inc wMenuItemCount
	ld a, [wMenuItemCount]
	inc a
	ld [wMenuItemCount], a

.updateIterator
	; inc de by sizeof_Item
	ld a, sizeof_Item
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a

	inc b
	ld a, b
	cp ITEMS_COUNT
	jp nz, .filterInventoryItemsWithNonZeroQuantityLoop
	ret
