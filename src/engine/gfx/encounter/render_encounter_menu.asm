INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/menu_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/structs/attack.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"

DEF MAX_ATTACKS_IN_MENU EQU 4

SECTION "Attack Menu Rendering Scratch", WRAM0
wAttackNameStringBuffer:: ds BYTES_IN_ATTACK_STRING

SECTION "Encounter Menu Rendering", ROMX

rEnemyString::  db "enemy             "
rPlayerString:: db "player            "
rAttackString:: db "attacking         "

RenderSkillsMenus::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz
.prep
	call PopulateMenuItemsFromPlayerAttacks
.renderTopRow
	call PaintBlankTopMenuRow
.renderAttackRows
	; have wCurrentMenuItem point to wMenuItems
	ld hl, wMenuItems ; source

	ld a, [wMenuItemTopVisible]
	ld b, a ; b is the menu item offset that being rendered.
	ld c, 0 ; row offset, 0-3.
.renderMenuItemRowsLoop

	; todo. the highlight seems to be resetting after pressing A on the 0th row?

	push hl ; stash current wMenuItems position ptr
	push bc ; stash b and c iterators

	; dereference wMenuItems position ptr to get Attack addr in hl and wCurrentItemAddr ; rename to wCurrentMenuItemObject ?
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a ; bc now contains addr of Attack

	ld a, b
	ld l, a
	ld [wCurrentItemAddr], a

	ld a, c
	ld h, a
	ld [wCurrentItemAddr + 1], a

	;;; get mp cost and convert to decimal
	ld a, Attack_MpCost
	call AddAToHl
	ld a, [hl] ; a now contains mp cost
	call ConvertBinaryNumberToTwoDigitDecimalNumber ; 10s in d, 1s in e
	pop hl ; restore wMenuItems position ptr
	push hl ; stash wMenuItems position ptr

	; copy decimal characters + item name into wAttackNameStringBuffer
	ld hl, wAttackNameStringBuffer
	; 10s place
	ld a, d
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	; 1s place
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, "m"
	ld [hli], a
	ld a, "p"
	ld [hli], a
	ld a, " "
	ld [hli], a

	ld a, [wCurrentItemAddr]
	ld e, a
	ld a, [wCurrentItemAddr + 1]
	ld d, a
	; it's cool to pass wCurrentItemAddr in de because its zeroth element is the name string that needs to be passed
	ld a, BYTES_IN_ATTACK_STRING - 3
	ld b, a
	call MemcopySmall

	ld hl, wAttackNameStringBuffer
	pop bc ; restore iterators for PaintModalTextRow
	push bc ; save iterators
	call PaintModalTextRow
.updateIterators
	pop bc ; restore iterators

	pop hl ; restore item def ptr and inc hl by sizeof_Item
	inc hl
	inc hl ; add 2 to point to next wMenuItems entry

	; inc and check
	inc c ; inc current row offset
	ld a, c
	ld [wTextRowsRendered], a ; painting uses this
	cp MODAL_TEXT_AREA_HEIGHT ; check to see if the visible menu is filled
	jp z, .renderBottomRow

	ld a, [wMenuItemsCount]
	inc b ; inc menu offset
	cp b ; check to see if the
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

; populates wMenuItems with pointers to Attacks
; populates wMenuItemsCount
PopulateMenuItemsFromPlayerAttacks::
	ld de, wPlayerAttacks ; source
	ld hl, wMenuItems ; dest
	ld b, 8 ; 4 pointers
	call MemcopySmall

	ld a, [wPlayerAttacksCount]
	ld [wMenuItemsCount], a
	ld d, a ; this will be the loop counter

	xor a
	ld hl, wMenuItems ; dest
.countLoop
	ld a, [hli] ; low byte of attack addr
	ld b, a ;
	ld a, [hli] ; high byte of attack addr
	or b ; addr of 0000 == no attack
	dec d
	jp nz, .countLoop
	ret

RenderEncounterMenuSkillUsed::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz

	call PaintBlankTopMenuRow

	ld c, 0
	ld hl, rPlayerString
	call PaintModalTextRow

	ld c, 1
	call PaintModalEmptyRow

	ld c, 2
	ld hl, rAttackString
	call PaintModalTextRow

	ld c, 3
	call PaintModalEmptyRow

	call PaintModalBottomRowCheckX

	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

RenderEncounterMenuEnemySkillUsed::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz

	call PaintBlankTopMenuRow

	ld c, 0
	ld hl, rEnemyString
	call PaintModalTextRow

	ld c, 1
	call PaintModalEmptyRow

	ld c, 2
	ld hl, rAttackString
	call PaintModalTextRow

	ld c, 3
	call PaintModalEmptyRow

	call PaintModalBottomRowCheckX

	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret
