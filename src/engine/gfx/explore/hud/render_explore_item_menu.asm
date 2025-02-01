INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/structs/item.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Item Rendering Scratch", WRAM0
wItemQuantityNameStringBuffer:: ds BYTES_IN_DIALOG_STRING
wCurrentMenuItemObjectAddr:: dw ; in this case, the Item that is being referred to. points into xItems

SECTION "Explore Item Menu Renderer", ROM0

; todo rendering breaks when the inventory is totally empty
RenderExploreItemMenu::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz
.renderTopRow
	call PaintModalTopRowItemMenu
.checkNeedsToRepopulateMenuItemsList
	; todo, compare current menu state w previous menu state - i don't know what i meant by this
	call PopulateMenuItemsFromInventory
.setStartingMenuItemIndex
	; todo, compare current menu state w previous menu state
	; this should maybe be done a level above this.
	xor a
	ld [wMenuItemTopVisible], a
.setup
	; have wCurrentMenuItem point to wMenuItems
	ld hl, wMenuItems ; source

	ld a, [wMenuItemTopVisible]
	ld b, a ; b is the wMenuItems offset that being rendered.
	ld c, 0 ; row offset, 0-3.
.renderMenuItemRowsLoop
	push hl ; stash current wMenuItems position ptr
	push bc ; stash b and c iterators

	; dereference wMenuItems position ptr to get Item addr in hl and wCurrentMenuItemObjectAddr
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a ; bc now contains addr of Item def in xItems

	ld a, b
	ld l, a
	ld [wCurrentMenuItemObjectAddr], a

	ld a, c
	ld h, a
	ld [wCurrentMenuItemObjectAddr + 1], a

.getItemQuantity ; this dereference is failing somehow
	; push bank
	ld a, [hCurrentRomBank]
	push af
	ld a, bank(xItems)
	rst SwapBank
		ld a, Item_InventoryOffset
		AddAToHl
		ld a, [hl] ; a now contains wInventory offset
		ld hl, wInventory
		AddAToHl
		ld a, [hl] ; a now contains wInventory quantity
		call ConvertBinaryNumberToTwoDigitDecimalNumber ; 10s in d, 1s in e
	; pop bank
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a

	pop hl ; restore wMenuItems position ptr
	push hl ; stash wMenuItems position ptr
.copyItemQuantityIntoMenuItemStringBuffer
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

	; copy from item.name into string buffer
	; push bank
	ld a, [hCurrentRomBank]
	push af
	ld a, bank(xItems)
	rst SwapBank
		ld a, [wCurrentMenuItemObjectAddr]
		ld e, a
		ld a, [wCurrentMenuItemObjectAddr + 1]
		ld d, a

		; skip "99x" characters
		; todo this is dumb just remove
		inc de
		inc de
		ld a, BYTES_IN_DIALOG_STRING - 3
		ld b, a
		MemcopySmall
	; pop bank
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a

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

	; inc c (row being rendered) and check to see if we've written all available rows
	inc c
	ld a, c
	ld [wTextRowsRendered], a ; painting uses this
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow

	; check the number of menu items we have available to draw (wMenuItemsCount) against the wMenuItems offset being rendered (b).
	; if we've drawn the last available item, fill with blank rows
	ld a, [wMenuItemsCount]
	inc b
	cp b
	jp nz, .renderMenuItemRowsLoop
.renderBlankRows
	ld a, [wTextRowsRendered]
.renderBlankRowsLoop
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow
	ld c, a
	call PaintModalEmptyRow ; c is an arg to this
	ld a, [wTextRowsRendered]
	inc a
	ld [wTextRowsRendered], a
	jp .renderBlankRowsLoop
.renderBottomRow
	call PaintModalBottomRowCheckX
	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

; populates wMenuItems:: from the listof item definitions, checking against the inventory to filter out items that are not held
; mangles a,b,d,e,h,l
PopulateMenuItemsFromInventory:
.setup
	xor a
	ld [wMenuItemsCount], a
	; b is the loop counter / current item's offset in Items / current item's offset in wInventory ( -1 )
	ld b, a
	ld de, xItems ; source, item definitions. in a mysterious bank but not dereferenced here
	ld hl, wMenuItems ; destination, area for Item definition addrs
.filterInventoryItemsWithNonZeroQuantityLoop
.checkQuantityOfItemInInventory
	push hl ; stash addr of wMenuItems[b]
	ld hl, wInventory + 1 ; to deal with 0 meaning empty space
	ld a, b
	AddAToHl
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

	; inc wMenuItemsCount
	ld a, [wMenuItemsCount]
	inc a
	ld [wMenuItemsCount], a

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
