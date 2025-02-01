INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/structs/item.inc"
INCLUDE "src/constants/item_constants.inc"

; this is an idea, not sure if it would work
;SECTION "Item Definitions Bank", ROM0
;	rItemsBank:: db bank(xItems)

SECTION "Item Definitions", ROMX

; an item's offset in the definitions collection here is also the offset of its # in wInventory
xItems::
	; items must begin with 3 spaces that will be replaced with quantities when rendered
	dstruct Item, ROCK, "99x rock", ITEM_ROCK
	dstruct Item, Lamp, "99x lamp", ITEM_LAMP
	dstruct Item, Tent, "99x tent", ITEM_TENT

; this might be silly to put here, as this will end up being used for rendering the encounter menu too
; moved from utils.asm, in ROM0
; @param a, # to convert. must be >= 0 and <= 99
; @return d, # in 10s place
; @return e, # in 1s place
ConvertBinaryNumberToTwoDigitDecimalNumber::
	ld b, a
	xor a
	ld d, a
	ld e, a
	ld a, b
.subTens
	sub 10
	jp c, .carryFromTens
	jp z, .finishFromTens
	inc d
	jp .subTens
.carryFromTens
	add 10
	jp .subOnes
.finishFromTens
	inc d
	ret
.subOnes
	sub 1
	ret c
	jp z, .finishFromOnes
	inc e
	jp .subOnes
.finishFromOnes
	inc e
	ret
