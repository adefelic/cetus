INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/engine/gfx/gfx_macros.inc"
INCLUDE "src/structs/equipment.inc"

SECTION "Paper Doll Screen Renderer", ROMX

RenderPaperDollScreen::
	call PaintEquipmentIcons
	; PaintHead
	; PaintBody
	; PaintLegs
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

PaintWeapon:
	DEF TOP = 1
	DEF LEFTMOST_COLUMN = 9
	DEF ROW_WIDTH = WEAPON_PAPER_DOLL_WIDTH
	ld d, TILE_WEAPON_PAPER_DOLL
	ld e, BG_PALETTE_UI
	FOR ROW, TOP, TOP + WEAPON_PAPER_DOLL_HEIGHT
		paint_row_incrementing
	ENDR
	ret
