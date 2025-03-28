INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/lib/hardware.inc"

DEF ROCK_TOP_LEFT_X EQU TILE_WIDTH * $09 + OAM_PADDING_X
DEF ROCK_TOP_LEFT_Y EQU TILE_HEIGHT * $0E + OAM_PADDING_Y
DEF LAMP_TOP_LEFT_X EQU TILE_WIDTH * $09 + OAM_PADDING_X
DEF LAMP_TOP_LEFT_Y EQU TILE_HEIGHT * $0D + OAM_PADDING_Y

SECTION "Ground Item Paint Routines", ROM0

; fixme make this use the room cache instead of checking the map
RenderGroundItemCenterFar::
.checkForWall
	ld hl, wRoomNearCenter
	call GetNorthWallTypeFromRoomAddr ; top wall ...
	cp WALL_TYPE_NONE
	jp nz, PaintNone
.drawOrClearItem
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	cp ITEM_NONE
	jp z, PaintNone
	cp ITEM_ROCK
	jp z, PaintRock
	cp ITEM_LAMP
	jp z, PaintLamp
	cp ITEM_TENT
	jp z, PaintTent
	ret

PaintRock:
.paintRockA
	; y
	ld a, ROCK_TOP_LEFT_Y
	ld [wShadowOam + OAM_ROCK_A + OAMA_Y], a
	; x
	ld a, ROCK_TOP_LEFT_X
	ld [wShadowOam + OAM_ROCK_A + OAMA_X], a
	; tile id
	ld a, TILE_ROCK_A
	ld [wShadowOam + OAM_ROCK_A + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_ROCK
	ld [wShadowOam + OAM_ROCK_A + OAMA_FLAGS], a
.paintRockB
	; y
	ld a, ROCK_TOP_LEFT_Y
	ld [wShadowOam + OAM_ROCK_B + OAMA_Y], a
	; x
	ld a, ROCK_TOP_LEFT_X + TILE_WIDTH
	ld [wShadowOam + OAM_ROCK_B + OAMA_X], a
	; tile id
	ld a, TILE_ROCK_B
	ld [wShadowOam + OAM_ROCK_B + OAMA_TILEID], a
	; attrs/flags
	ld a, (OAMF_PRI * 0) + (OAMF_YFLIP * 0) + (OAMF_XFLIP * 0) + (OAMF_BANK1 * 0) + OBJ_PALETTE_ROCK
	ld [wShadowOam + OAM_ROCK_B + OAMA_FLAGS], a
.clearOthers
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_X], a
	ret

; todo this could be made less redundant
PaintLamp:
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
.clearOthers
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_ROCK_A + OAMA_Y], a
	ld [wShadowOam + OAM_ROCK_B + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_ROCK_A + OAMA_X], a
	ld [wShadowOam + OAM_ROCK_B + OAMA_X], a
	ret

PaintTent:
	ret

PaintNone:
ClearGroundItemsFromOam::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_ROCK_A + OAMA_Y], a
	ld [wShadowOam + OAM_ROCK_B + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_Y], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_ROCK_A + OAMA_X], a
	ld [wShadowOam + OAM_ROCK_B + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_TOP_R + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_L + OAMA_X], a
	ld [wShadowOam + OAM_LAMP_BOTTOM_R + OAMA_X], a
	ret
