
DEF INITIAL_ROCKS_COUNT EQU 5
DEF INITIAL_LAMPS_COUNT EQU 3
DEF INITIAL_TENTS_COUNT EQU 1
DEF MAX_ITEM_STACK EQU 99

SECTION "Inventory State", WRAM0
wInventory::
wInventoryNothing: db ; placeholder dumb hack
wInventoryRock: db
wInventoryLamp: db
wInventoryTent: db
wInventoryEnd::

wEquipmentInventory::
wEquipmentInventoryWeapons::
wEquipmentInventoryIcons::


SECTION "Inventory Functions", ROMX

InitInventory::
	xor a
	ld [wInventoryNothing], a
	ld a, INITIAL_ROCKS_COUNT
	ld [wInventoryRock], a
	ld a, INITIAL_LAMPS_COUNT
	ld [wInventoryLamp], a
	ld a, INITIAL_TENTS_COUNT
	ld [wInventoryTent], a
	ret

; @param a, item offset
IncrementInventoryItemQuantity::
	ld hl, wInventory
	call AddAToHl
	ld a, [hl]
	inc a
	cp MAX_ITEM_STACK + 1
	ret z
	ld [hl], a
	ret


; @param a, item offset
DecrementInventoryItemQuantity::
	ld hl, wInventory
	call AddAToHl
	ld a, [hl]
	dec a
	cp 255
	ret z ; don't go below 0
	ld [hl], a
	ret
