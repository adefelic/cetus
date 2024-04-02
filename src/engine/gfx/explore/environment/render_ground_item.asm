INCLUDE "src/constants/constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/palette_constants.inc"

DEF ITEM_TOP_LEFT_X EQU TILE_WIDTH * $09
DEF ITEM_TOP_LEFT_Y EQU TILE_HEIGHT * $0E

SECTION "Ground Item State", ROMX
wGroundItemDirty:: db

SECTION "Ground Item Paint Routines", ROMX

InitGroundItem::
	ld a, TRUE
	ld [wGroundItemDirty], a
	ret

RenderGroundItem::
	ld a, [wHasPlayerRotatedThisFrame]
	ld b, a
	ld a, [wHasPlayerTranslatedThisFrame]
	and b ; true is 0. we want to check if either of these happened
	cp TRUE
	jp z, .checkForWall

	ld a, [wGroundItemDirty]
	cp FALSE
	ret z
	; get room in front of player, see if there's a wall in the way
.checkForWall
	; check closest player facing wall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords ; put related RoomWallAttributes addr in hl
	call GetTopWallWrtPlayer
	cp WALL_TYPE_NONE
	jp nz, PaintNoItems
.drawOrClearItem
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	cp ITEM_NONE
	jp z, PaintNoItems
	cp ITEM_QUARTZ
	jp z, PaintQuartz
	cp ITEM_LAMP
	jp z, PaintLamp
	cp ITEM_TENT
	jp z, PaintTent
	ret

PaintQuartz:
.paintQuartzA
	; y
	ld a, ITEM_TOP_LEFT_Y + 16
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_Y], a
	; x
	ld a, ITEM_TOP_LEFT_X + 8
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_X], a
	; tile id
	ld a, TILE_QUARTZ_A
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_QUARTZ
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_FLAGS], a
.paintQuartzB
	; y
	ld a, ITEM_TOP_LEFT_Y + 16
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_Y], a
	; x
	ld a, ITEM_TOP_LEFT_X + 8 + 8
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_X], a
	; tile id
	ld a, TILE_QUARTZ_B
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_QUARTZ
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_FLAGS], a
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret

PaintLamp:
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret

PaintTent:
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret

PaintNoItems::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_Y], a
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_X], a
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM + OAMA_X], a
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret
