INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/menu_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/structs/attack.inc"
INCLUDE "src/structs/npc.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/utils/macros.inc"

DEF MAX_ATTACKS_IN_MENU EQU 4

SECTION "Attack Menu Rendering Scratch", WRAM0
wAttackNameStringBuffer:: ds BYTES_IN_ATTACK_STRING

SECTION "Encounter Menu Rendering", ROM0

rPlayerString:: db "you               "
rUsedString:: db "used "
rAppearedString:: db "appeared          "

RenderEncounterMenuPlayerAttacks::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz
.prep
	; this is hardcoding to the menu to start at 0
	xor a
	ld [wMenuItemTopVisible], a
	call PopulateMenuItemsFromPlayerAttacks
.renderTopRow
	call PaintBlankTopMenuRow
.renderAttackRows
	; have wCurrentMenuItem point to wMenuItems
	ld hl, wMenuItems ; source

	ld a, [wMenuItemTopVisible]
	ld b, a ; b is the menu item offset that being rendered.
	ld c, 0 ; row offset, 0-3.
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(Attacks)
		rst SwapBank
	.renderMenuItemRowsLoop
		push hl ; stash current wMenuItems position ptr
		push bc ; stash b and c iterators

		; dereference wMenuItems position ptr to get Attack addr in hl and wCurrentMenuItemObjectAddr
		ld a, [hli]
		ld b, a
		ld a, [hl]
		ld c, a ; bc now contains addr of Attack

		ld a, b
		ld l, a
		ld [wCurrentMenuItemObjectAddr], a

		ld a, c
		ld h, a
		ld [wCurrentMenuItemObjectAddr + 1], a

		;;; get mp cost and convert to decimal
		ld a, Attack_MpCost
		AddAToHl
		ld a, [hl] ; a now contains mp cost
		; this function is in items land. idk what land it should be in. attacks land of course

		call ConvertBinaryNumberToTwoDigitDecimalNumber_Attacks ; 10s in d, 1s in e

		pop hl ; restore wMenuItems position ptr
		push hl ; stash wMenuItems position ptr

		; copy decimal characters + item name into wAttackNameStringBuffer
		call ClearTextRowBuffer
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

		ld a, [wCurrentMenuItemObjectAddr]
		ld e, a
		ld a, [wCurrentMenuItemObjectAddr + 1]
		ld d, a
		; it's cool to pass wCurrentMenuItemObjectAddr in de because its zeroth element is the name string that needs to be passed
		ld a, BYTES_IN_ATTACK_STRING - 3
		ld b, a
		MemcopySmall

		ld hl, wAttackNameStringBuffer
		pop bc ; restore iterators for PaintModalTextRow
		push bc ; save iterators
		call PaintModalTextRow
	.updateIterators
		pop bc ; restore iterators

		pop hl ; restore item def ptr
		inc hl
		inc hl ; add 2 to point to next wMenuItems entry

		inc c ; inc current row offset
		ld a, c
		ld [wTextRowsRendered], a ; painting uses this variable
		cp MODAL_TEXT_AREA_HEIGHT ; check to see if there is still space for more menu items
		jp z, .renderBottomRow ; quit out if not

		ld a, [wMenuItemsCount]
		inc b ; inc menu item offset
		cp b ; check to see if we've rendered all possible menu items in wMenuItems
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
	jp BankReturn

; populates wMenuItems with pointers to Attacks
; populates wMenuItemsCount
PopulateMenuItemsFromPlayerAttacks:
	ld de, wPlayerAttacks ; source
	ld hl, wMenuItems ; dest
	ld b, 8 ; 4 pointers
	MemcopySmall

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

RenderEncounterMenuNpcAppeared::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz

	call PaintBlankTopMenuRow

.textRow0
	call LoadNpcNameString
	ld hl, wAttackNameStringBuffer
	ld c, 0
	call PaintModalTextRow

.textRow1
	ld c, 1
	call PaintModalEmptyRow

.textRow2
	ld hl, rAppearedString
	ld c, 2
	call PaintModalTextRow

.textRow3
	ld c, 3
	call PaintModalEmptyRow

	call PaintModalBottomRow

	ld a, FALSE
	ld [wBottomMenuDirty], a
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

.textRow1
	ld c, 1
	call PaintModalEmptyRow

.textRow2
	call LoadBufferWithUsedStringAndAttackName
	ld hl, wAttackNameStringBuffer
	ld c, 2
	call PaintModalTextRow

.textRow3
	ld c, 3
	call PaintModalEmptyRow

	call PaintModalBottomRow

	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

RenderEncounterMenuEnemySkillUsed::
.checkDirty
	ld a, [wBottomMenuDirty]
	cp TRUE
	ret nz

.topBorder
	call PaintBlankTopMenuRow

.textRow0
	call LoadNpcNameString
.writeNpcName
	ld hl, wAttackNameStringBuffer
	ld c, 0
	call PaintModalTextRow

.textRow1
	ld c, 1
	call PaintModalEmptyRow

.textRow2
	call LoadBufferWithUsedStringAndAttackName
	ld hl, wAttackNameStringBuffer
	ld c, 2
	call PaintModalTextRow

.textRow3
	; empty line
	ld c, 3
	call PaintModalEmptyRow

.bottomBorder
	call PaintModalBottomRow

	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

LoadBufferWithUsedStringAndAttackName:
.writeUsedString
	ld hl, rUsedString
	ld b, USED_STRING_LENGTH
	call CopyStringIntoBufferWithWhitespace
.getAttackName
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(Attacks)
		rst SwapBank

		ld hl, wCurrentAttack
		DereferenceHlIntoHl
		ld a, Attack_Name
		AddAToHl
	.copy
		ld d, h
		ld e, l
		ld hl, wAttackNameStringBuffer + USED_STRING_LENGTH
		ld b, BYTES_IN_ATTACK_STRING
		MemcopySmall
	jp BankReturn

; there is no way to know the length of the string
; @param b, length to copy
CopyStringIntoBufferWithWhitespace:
	ld d, h
	ld e, l
	call ClearTextRowBuffer
	ld hl, wAttackNameStringBuffer
	MemcopySmall
	ret

ClearTextRowBuffer:
	ld c, BYTES_IN_ATTACK_STRING
	ld a, " "
	ld hl, wAttackNameStringBuffer
.copy:
	ld [hli], a
	dec c
	jp nz, .copy
	ret

; loads name into wAttackNameStringBuffer
LoadNpcNameString:
	ld hl, wNpcAddr
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(NPCs)
		rst SwapBank
		; swap bank? idk
		DereferenceHlIntoHl ; what does this pt into
		ld a, NPC_Name
		AddAToHl
		ld b, CHARACTER_NAME_LENGTH
		call CopyStringIntoBufferWithWhitespace
	jp BankReturn

DisableHighlight::
	ld a, $FF ; goofy hack
	ld [wDialogTextRowHighlighted], a
	ret
