INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/engine/gfx/gfx_macros.inc"
INCLUDE "src/structs/equipment.inc"

SECTION "Paper Doll Screen Renderer", ROMX

RenderPaperDollScreen::
	call PaintEquipmentIcons
	call PaintBody
	call PaintHead ; this has to be called after body so that the head will overlap a little
	call PaintLegs
	call PaintWeapon
	ret

MACRO paint_empty_equipment_square
	; tl
	ld hl, wShadowBackgroundTilemap + rows TOP + cols LEFT
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI
	ld hl, wShadowBackgroundTilemapAttrs + rows TOP + cols LEFT
	ld b, 1
	call CopyByteInEToRange

	; tr
	ld hl, wShadowBackgroundTilemap + rows TOP + cols LEFT + 1
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP
	ld hl, wShadowBackgroundTilemapAttrs + rows TOP + cols LEFT + 1
	ld b, 1
	call CopyByteInEToRange

	; bl
	ld hl, wShadowBackgroundTilemap + rows (TOP + 1) + cols LEFT
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_YFLIP
	ld hl, wShadowBackgroundTilemapAttrs + rows (TOP + 1) + cols LEFT
	ld b, 1
	call CopyByteInEToRange

	; br
	ld hl, wShadowBackgroundTilemap + rows (TOP + 1) + cols LEFT + 1
	ld b, 1
	call CopyByteInDToRange
	ld e, BG_PALETTE_UI + OAMF_XFLIP + OAMF_YFLIP
	ld hl, wShadowBackgroundTilemapAttrs + rows (TOP + 1) + cols LEFT + 1
	ld b, 1
	call CopyByteInEToRange
ENDM

; todo, make a NO_ITEM equipment for each slot that has its icon loaded into vram instead of how it works now
PaintEquipmentIcons:
	ld d, TILE_EQUIPMENT_BORDER_TL
.leftSide
	DEF LEFT = 1
	DEF TOP = 1
	paint_empty_equipment_square
	DEF TOP = 4
	paint_empty_equipment_square
	DEF TOP = 7
	paint_empty_equipment_square
	DEF TOP = 10
	paint_empty_equipment_square
.rightSide
	DEF LEFT = 12
	DEF TOP = 1
	paint_empty_equipment_square
	DEF TOP = 4
	paint_empty_equipment_square
	DEF TOP = 7
	paint_empty_equipment_square

.checkWeapon
	DEF TOP = 10
	ld hl, wEquippedWeapon
	call DereferenceHlIntoHl
	ld a, h
	or l
	jp z, .weaponEmpty
.paintWeaponIcon
	ld d, TILE_WEAPON_ICON
	ld e, BG_PALETTE_UI
	DEF LEFTMOST_COLUMN = LEFT
	DEF ROW_WIDTH = EQUIPMENT_ICON_WIDTH
	FOR ROW, TOP, TOP + EQUIPMENT_ICON_HEIGHT
		paint_row_incrementing
	ENDR
	ret
.weaponEmpty
	paint_empty_equipment_square
	ret

PaintHead:
	DEF TOP = PAPER_DOLL_HEAD_TOP
	DEF LEFTMOST_COLUMN = PAPER_DOLL_HEAD_LEFT
	DEF ROW_WIDTH = PAPER_DOLL_HEAD_WIDTH
	ld d, TILE_PAPER_DOLL_HEAD
	ld e, BG_PALETTE_UI + OAMF_BANK1
	FOR ROW, TOP, TOP + PAPER_DOLL_HEAD_HEIGHT - 1
		paint_row_incrementing
	ENDR
	; draw neck
	inc d
	DEF ROW = PAPER_DOLL_HEAD_HEIGHT - 1
	DEF ROW_WIDTH = 2
	DEF LEFTMOST_COLUMN = PAPER_DOLL_HEAD_LEFT + 1
	paint_row_incrementing
	ret

PaintBody:
	DEF TOP = PAPER_DOLL_BODY_TOP
	DEF LEFTMOST_COLUMN = PAPER_DOLL_BODY_LEFT
	DEF ROW_WIDTH = PAPER_DOLL_BODY_WIDTH
	ld d, TILE_PAPER_DOLL_BODY
	ld e, BG_PALETTE_UI + OAMF_BANK1
	FOR ROW, TOP, TOP + PAPER_DOLL_BODY_HEIGHT
		paint_row_incrementing
	ENDR
	ret

PaintLegs:
	DEF TOP = PAPER_DOLL_LEGS_TOP
	DEF LEFTMOST_COLUMN = PAPER_DOLL_LEGS_LEFT
	DEF ROW_WIDTH = PAPER_DOLL_LEGS_WIDTH
	ld d, TILE_PAPER_DOLL_LEGS
	ld e, BG_PALETTE_UI + OAMF_BANK1
	FOR ROW, TOP, TOP + PAPER_DOLL_LEGS_HEIGHT
		paint_row_incrementing
	ENDR
	ret

PaintWeapon:
	DEF TOP = PAPER_DOLL_WEAPON_TOP
	DEF LEFTMOST_COLUMN = PAPER_DOLL_WEAPON_LEFT
	DEF ROW_WIDTH = PAPER_DOLL_WEAPON_WIDTH
	ld d, TILE_PAPER_DOLL_WEAPON
	ld e, BG_PALETTE_UI + OAMF_BANK1
	FOR ROW, TOP, TOP + PAPER_DOLL_WEAPON_HEIGHT
		paint_row_incrementing
	ENDR
	ret
