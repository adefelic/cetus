INCLUDE "src/constants/constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/palette_constants.inc"

DEF QUARTZ_TOP_LEFT_X EQU TILE_WIDTH * $09 + OAM_PADDING_X
DEF QUARTZ_TOP_LEFT_Y EQU TILE_HEIGHT * $0E + OAM_PADDING_Y
DEF LAMP_TOP_LEFT_X EQU TILE_WIDTH * $09 + OAM_PADDING_X
DEF LAMP_TOP_LEFT_Y EQU TILE_HEIGHT * $0D + OAM_PADDING_Y

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
.renderCenterFarGround
.checkForWall
	; check closest player facing wall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords ; put related RoomWallAttributes addr in hl
	call GetTopWallWrtPlayer
	cp WALL_TYPE_NONE
	jp nz, ClearGroundItemsFromOam
.drawOrClearItem
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	cp ITEM_NONE
	jp z, ClearGroundItemsFromOam
	cp ITEM_QUARTZ
	jp z, PaintQuartz
	cp ITEM_LAMP
	jp z, PaintLamp
	cp ITEM_TENT
	jp z, PaintTent
	ret

PaintQuartz:
	call ClearGroundItemsFromOam
.paintQuartzA
	; y
	ld a, QUARTZ_TOP_LEFT_Y
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_Y], a
	; x
	ld a, QUARTZ_TOP_LEFT_X
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_X], a
	; tile id
	ld a, TILE_QUARTZ_A
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_QUARTZ
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_FLAGS], a
.paintQuartzB
	; y
	ld a, QUARTZ_TOP_LEFT_Y
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_Y], a
	; x
	ld a, QUARTZ_TOP_LEFT_X + TILE_WIDTH
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

; todo this could be made less redundant
PaintLamp:
	call ClearGroundItemsFromOam
.paintTopL
	; y
	ld a, LAMP_TOP_LEFT_Y
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_Y], a
	; x
	ld a, LAMP_TOP_LEFT_X
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_X], a
	; tile id
	ld a, TILE_LAMP_TOP
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_LAMP
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_FLAGS], a
.paintTopR
	; y
	ld a, LAMP_TOP_LEFT_Y
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_Y], a
	; x
	ld a, LAMP_TOP_LEFT_X + TILE_WIDTH
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_X], a
	; tile id
	ld a, TILE_LAMP_TOP
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_LAMP
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_FLAGS], a
.paintBottomL
	; y
	ld a, LAMP_TOP_LEFT_Y + TILE_HEIGHT
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_Y], a
	; x
	ld a, LAMP_TOP_LEFT_X
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_X], a
	; tile id
	ld a, TILE_LAMP_BOTTOM
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_LAMP
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_FLAGS], a
.paintBottomR
	; y
	ld a, LAMP_TOP_LEFT_Y + TILE_HEIGHT
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_Y], a
	; x
	ld a, LAMP_TOP_LEFT_X + TILE_WIDTH
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_X], a
	; tile id
	ld a, TILE_LAMP_BOTTOM
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 1) + (OAMF_BANK1 * 0) + OBJ_PALETTE_LAMP
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_FLAGS], a
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret

PaintTent:
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret

ClearGroundItemsFromOam::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_Y], a
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_QUARTZ_A + OAMA_X], a
	ld [wShadowOam + OAM_QUARTZ_B + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_X], a
	ld a, FALSE
	ld [wGroundItemDirty], a
	ret
