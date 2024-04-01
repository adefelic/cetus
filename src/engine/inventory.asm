
DEF INITIAL_ROCKS_COUNT EQU 5
DEF INITIAL_LAMPS_COUNT EQU 3
DEF INITIAL_TENTS_COUNT EQU 1

SECTION "Inventory State", WRAM0
wInventory::
wInventoryNothing: db ; placeholder dumb hack
wInventoryRock: db
wInventoryLamp: db
wInventoryTent: db
wInventoryEnd::

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

PickUpItem::
	; item # is still in a fwiw
	ret

;; unused
;IncrementRocks:
;	ld a, [wInventoryRock]
;	add 1
;	ret c ; don't go over 255
;	ld [wInventoryRock], a
;	ret

;; unused
;DecrementRocks:
;	ld a, [wInventoryRock]
;	sub 1
;	cp 255
;	ret z ; don't go below 0
;	ld [wInventoryRock], a
;	ret
