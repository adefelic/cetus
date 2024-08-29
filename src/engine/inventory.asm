INCLUDE "src/structs/equipment.inc"

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

wEquippedHead:: dw
wEquippedHeadIconTiles:: dw
wEquippedHeadPaperDollTiles:: dw

wEquippedBody:: dw
wEquippedBodyIconTiles:: dw
wEquippedBodyPaperDollTiles:: dw

wEquippedLegs:: dw
wEquippedLegsIconTiles:: dw
wEquippedLegsPaperDollTiles:: dw

wEquippedWeapon:: dw
wEquippedWeaponIconTiles:: dw
wEquippedWeaponPaperDollTiles:: dw

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

InitEquipment::

	ld de, EquipmentHelmFrogMouth
	ld hl, wEquippedHead
	call EquipSlot

	ld de, EquipmentSurcoatRoot
	ld hl, wEquippedBody
	call EquipSlot

	ld de, EquipmentLegWrappings
	ld hl, wEquippedLegs
	call EquipSlot

	ld de, EquipmentFlail
	ld hl, wEquippedWeapon
	call EquipSlot
	ret

; @param de, src equipment def
; @param hl, dest slot
EquipSlot:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a

	push de
	ld a, Equipment_IconTilesAddr
	call AddAToDe
	call DereferenceDeIntoDe
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a

	pop de
	ld a, Equipment_PaperDollTilesAddr
	call AddAToDe
	call DereferenceDeIntoDe
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
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
