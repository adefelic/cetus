INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/utils/macros.inc"
INCLUDE "src/constants/room_constants.inc"

; the uncontested worst file in this project

SECTION "Segment Render State", WRAM0
; these could be a single bits
wADirty: db
wBDirty: db
wCDirty: db
wDDirty: db
wEDirty: db
wFDirty: db
wGDirty: db
wHDirty: db
wIDirty: db
wJDirty: db
wKDirty: db
wLDirty: db
wLDiagDirty: db
wMDirty: db
wNDirty: db
wNDiagDirty: db
wODirty: db
wPDirty: db
wPDiagDirty: db
wQDirty: db
wRDirty: db
wRDiagDirty: db

MACRO paint_row_random_fog_tiles
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld d, ROW_WIDTH
	call CopyRandomFogTilesToTilemapRow
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInEToRange
ENDM

MACRO paint_row_single_tile_romx
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call Paint_CopyByteInEToRange
ENDM

; wall and segment routines are together so that the bank doesn't need to be switched to go between them
SECTION "Wall and Segment Paint Routines", ROMX
WallAndSegmentPaintRoutines::

PaintMaze::
; process rooms closest to farthest w/ dirtying to only draw topmost z segments
ProcessRoomCenterNear:
.checkLeftWall:
	ld hl, wRoomNearCenter
	call GetLeftWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
	cp a, WALL_TYPE_A
	call z, PaintWallLeftSideNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftSideNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftSideNearTypeC
.checkTopWall
	ld hl, wRoomNearCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
	cp a, WALL_TYPE_A
	call z, PaintWallCenterFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallCenterFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallCenterFrontNearTypeC
.checkRightWall
	ld hl, wRoomNearCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundCenterNear
	cp a, WALL_TYPE_A
	call z, PaintWallRightSideNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightSideNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightSideNearTypeC
.paintGroundCenterNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentQGround

ProcessRoomLeftNear:
.checkTopWall
	ld hl, wRoomNearLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundLeftNear
	cp a, WALL_TYPE_A
	call z, PaintWallLeftFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftFrontNearTypeC
.paintGroundLeftNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentP
	call PaintSegmentPDiag

ProcessRoomRightNear:
.checkTopWall
	ld hl, wRoomNearRight
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundRightNear
	cp a, WALL_TYPE_A
	call z, PaintWallRightFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightFrontNearTypeC
.paintGroundRightNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentR
	call PaintSegmentRDiag

ProcessRoomCenterFar:
.checkLeftWall
	ld hl, wRoomFarCenter
	call GetLeftWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundLeftFar
	cp a, WALL_TYPE_A
	call z, PaintWallLeftSideFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftSideFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftSideFarTypeC
	jp .checkTopWall
.paintGroundLeftFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentL
	call PaintSegmentLDiag

.checkTopWall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
	cp a, WALL_TYPE_A
	call z, PaintWallCenterFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallCenterFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallCenterFrontFarTypeC
	jp .checkRightWall
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentCDistanceFog

.checkRightWall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundRightFar
	cp a, WALL_TYPE_A
	call z, PaintWallRightSideFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightSideFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightSideFarTypeC
	jp .paintGroundCenterFar
.paintGroundRightFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentN
	call PaintSegmentNDiag

.paintGroundCenterFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentMGround

ProcessRoomLeftFar:
.checkTopWall
	ld hl, wRoomFarLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
	cp a, WALL_TYPE_A
	call z, PaintWallLeftFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftFrontFarTypeC
	jp .paintGroundLeftFar
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentADistanceFog
	call PaintSegmentBDistanceFog
.paintGroundLeftFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentK
	call PaintSegmentL
	call PaintSegmentLDiag

ProcessRoomRightFar:
.checkTopWall
	ld hl, wRoomFarRight
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
	cp a, WALL_TYPE_A
	call z, PaintWallRightFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightFrontFarTypeC
	jp .paintGroundRightFar
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentDDistanceFog
	call PaintSegmentEDistanceFog
.paintGroundRightFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentO
	call PaintSegmentN
	call PaintSegmentNDiag
.finishProcessingRooms
	;ret
	jp BankReturn

; these wall cache accessor functions are copies of Get___WallTypeFromRoomAddr in map.asm.
; only these are in this bank to make my life easier
; @param hl, room addr
; @return a, wall type
GetTopWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_NORTH_WALL
rept 6
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetRightWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_EAST_WALL
rept 4
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetBottomWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_SOUTH_WALL
rept 2
	srl a
endr
	ret

; @param hl, room addr
; @return a, wall type
GetLeftWallTypeFromRoomAddr::
	ld a, [hl]
	and a, ROOM_MASK_WEST_WALL
	ret

; side near
PaintWallLeftSideNearTypeA::
PaintWallLeftSideNearTypeC::
	ld e, BG_PALETTE_SIDE_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentK
	call PaintSegmentP
	ld d, TILE_EXPLORE_DIAG_L
	call PaintSegmentPDiag
	ret

PaintWallRightSideNearTypeA::
PaintWallRightSideNearTypeC::
	ld e, BG_PALETTE_SIDE_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentE
	call PaintSegmentO
	call PaintSegmentR
	ld d, TILE_EXPLORE_DIAG_R
	call PaintSegmentRDiag
	ret

; front near
PaintWallLeftFrontNearTypeA::
; skip
PaintWallLeftFrontNearTypeB::
PaintWallLeftFrontNearTypeC::
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentK
	ret

PaintWallCenterFrontNearTypeA::
PaintWallCenterFrontNearTypeC::
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentB
	call PaintSegmentC
	call PaintSegmentD
	call PaintSegmentL
	call PaintSegmentLDiag
	call PaintSegmentM
	call PaintSegmentN
	call PaintSegmentNDiag
	ret

PaintWallRightFrontNearTypeA::
; skip
PaintWallRightFrontNearTypeB::
PaintWallRightFrontNearTypeC::
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentE
	call PaintSegmentO
	ret

; side far
PaintWallLeftSideFarTypeA::
PaintWallLeftSideFarTypeC::
	ld e, BG_PALETTE_SIDE_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentB
	call PaintSegmentL
	ld d, TILE_EXPLORE_DIAG_L
	call PaintSegmentLDiag
	ret

PaintWallRightSideFarTypeA::
PaintWallRightSideFarTypeC::
	ld e, BG_PALETTE_SIDE_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentD
	call PaintSegmentN
	ld d, TILE_EXPLORE_DIAG_R
	call PaintSegmentNDiag
	ret

; front far
PaintWallLeftFrontFarTypeA::
; skip
PaintWallLeftFrontFarTypeB::
PaintWallLeftFrontFarTypeC::
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentB
	ret

PaintWallCenterFrontFarTypeA::
PaintWallCenterFrontFarTypeC::
	ld d, TILE_EXPLORE_WALL
	ld e, BG_PALETTE_FRONT_FAR
	call PaintSegmentC
	ret

PaintWallRightFrontFarTypeA::
; skip
PaintWallRightFrontFarTypeB::
PaintWallRightFrontFarTypeC::
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentD
	call PaintSegmentE
	ret

PaintWallLeftSideNearTypeB::
	; hmm how will this work, if specials walls are different per-locale
	; get locale -> call CurrentLocaleSpecialWallBSideNear ??? would each locale come with ... a table of 6 custom function pointers per custom wall type? :(
	; maybe the paint functions should all be the same, at least initially?
	;   this will be impossible without very simplified paint functions
	; for the time being, i'll just add the one wall type and all locales can use it

	ld e, BG_PALETTE_SIDE_NEAR

	; top part of wall
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_A_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT
	FOR ROW, 6
		paint_row_single_tile_romx
	ENDR

	; door
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT
	FOR ROW, 6, SCREEN_BOTTOM
		paint_row_single_tile_romx
	ENDR

	; wall right of door
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = 2
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT + 1
	FOR ROW, 6, SCREEN_BOTTOM - 2
		paint_row_single_tile_romx
	ENDR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT + 1
	DEF ROW = SCREEN_BOTTOM - 2
	paint_row_single_tile_romx

	; diagonal. overwrites some of "wall right of door"
	ld d, TILE_EXPLORE_DIAG_L
	ld e, BG_PALETTE_SIDE_NEAR
	call PaintSegmentPDiag

.cleanFlags
	ld a, FALSE
	ld [wADirty], a
	ld a, FALSE
	ld [wKDirty], a
	ld a, FALSE
	ld [wPDirty], a
	ret

; this could be made more efficient by unpacking segments b and d
; but i think it'll cause flickering with labels
PaintWallCenterFrontNearTypeB::
	ld d, TILE_FIELD_WALL_B_WALL
	ld e, BG_PALETTE_FRONT_NEAR
.segmentB
	call PaintSegmentB
.segmentD
	call PaintSegmentD
.segmentC
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_C_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, TOP_SEGMENTS_TOP, TOP_SEGMENTS_TOP + 6
		paint_row_single_tile_romx
	ENDR

	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 8
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, TOP_SEGMENTS_TOP + 6, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.segmentL_LDiag_MLeft
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_B_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_B_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.segmentMMiddle
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = SEGMENT_C_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.segmentMMiddle_NDiag_N
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_D_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_D_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.cleanFlags
	ld a, FALSE
	ld [wCDirty], a
	ld [wLDirty], a
	ld [wLDiagDirty], a
	ld [wMDirty], a
	ld [wNDirty], a
	ld [wNDiagDirty], a
	ret

PaintWallRightSideNearTypeB::
	ld e, BG_PALETTE_SIDE_NEAR

	; top part of wall
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_E_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_E_LEFT
	FOR ROW, 6
		paint_row_single_tile_romx
	ENDR

	; door
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_E_LEFT + SEGMENT_E_WIDTH - 1
	FOR ROW, 6, SCREEN_BOTTOM
		paint_row_single_tile_romx
	ENDR

	; wall right of door
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = 2
	DEF LEFTMOST_COLUMN = SEGMENT_E_LEFT
	FOR ROW, 6, SCREEN_BOTTOM - 2
		paint_row_single_tile_romx
	ENDR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_E_LEFT + 1
	DEF ROW = SCREEN_BOTTOM - 2
	paint_row_single_tile_romx

	; diagonal. overwrites some of "wall right of door"
	ld d, TILE_EXPLORE_DIAG_R
	ld e, BG_PALETTE_SIDE_NEAR
	call PaintSegmentRDiag

.cleanFlags
	ld a, FALSE
	ld [wEDirty], a
	ld a, FALSE
	ld [wODirty], a
	ld a, FALSE
	ld [wRDirty], a
	ret

PaintWallLeftSideFarTypeB::
	ret

PaintWallRightSideFarTypeB::
	ret

PaintWallCenterFrontFarTypeB::
	; make it all wall colored
	ld d, TILE_FIELD_WALL_B_WALL
	ld e, BG_PALETTE_FRONT_FAR
	call PaintSegmentC

	; draw door on top
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 4
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT + 2
	FOR ROW, TOP_SEGMENTS_TOP + 8, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR

	; this is done in PaintSegmentC
	;ld a, FALSE
	;ld [wCDirty], a
	ret

; @param d: the tile index to paint with
; @param e: the attribute byte to paint with
; segment a: (0, 0) to (2, 12)
PaintSegmentA::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 0
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wADirty], a
	ret

PaintSegmentADistanceFog::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 0
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP - 1
		paint_row_random_fog_tiles
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_GROUND
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wADirty], a
	ret

PaintSegmentB::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 3
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentBDistanceFog::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 3
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP - 1
		paint_row_random_fog_tiles
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_GROUND
	paint_row_single_tile_romx
.maybeDrawRightFogBorder
	; B will draw right border if far-center has top wall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	call nz, PaintSegmentBFogBorderRight
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentBFogBorderRight:
	call Paint_Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 5
	FOR ROW, 8
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile_romx
	ENDR
.getAnotherRandomByte
	call Paint_Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile_romx
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentC::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 8
	DEF LEFTMOST_COLUMN = 6
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCDistanceFog::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 8
	DEF LEFTMOST_COLUMN = 6
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP - 1
		paint_row_random_fog_tiles
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_GROUND
	paint_row_single_tile_romx
.maybeDrawLeftFogBorder
	; C will draw left border if far-center has a left wall or far-left has a top wall
	ld hl, wRoomFarCenter
	call GetLeftWallTypeFromRoomAddr
	ld b, a
	ld hl, wRoomFarLeft
	call GetTopWallTypeFromRoomAddr
	or b
	call nz, PaintSegmentCFogBorderLeft
.maybeDrawRightFogBorder
	; C will draw left border if far-center has a right wall or far-right has a top wall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
	ld b, a
	ld hl, wRoomFarRight
	call GetTopWallTypeFromRoomAddr
	or b
	call nz, PaintSegmentCFogBorderRight
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCFogBorderLeft:
	call Paint_Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 6
	FOR ROW, 8
		call GetRandomYFlipFogAttrs
		paint_row_single_tile_romx
	ENDR
.getAnotherRandomByte
	call Paint_Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrs
		paint_row_single_tile_romx
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCFogBorderRight:
	call Paint_Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 13
	FOR ROW, 8
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile_romx
	ENDR
.getAnotherRandomByte
	call Paint_Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile_romx
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentD::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 14
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentDDistanceFog::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 14
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP - 1
		paint_row_random_fog_tiles
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_GROUND
	paint_row_single_tile_romx
.maybeDrawLeftFogBorder
	; D will draw left border if far-center has top wall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	call nz, PaintSegmentDFogBorderLeft
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentDFogBorderLeft:
	call Paint_Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 14
	FOR ROW, 8
		call GetRandomYFlipFogAttrs
		paint_row_single_tile_romx
	ENDR
.getAnotherRandomByte
	call Paint_Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrs
		paint_row_single_tile_romx
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentE::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 17
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wEDirty], a
	ret

PaintSegmentEDistanceFog::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 17
	FOR ROW, TOP_SEGMENTS_TOP, MIDDLE_SEGMENTS_TOP - 1
		paint_row_random_fog_tiles
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_GROUND
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wEDirty], a
	ret

PaintSegmentK::
	ld a, [wKDirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 0
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wKDirty], a
	ret

PaintSegmentL::
	ld a, [wLDirty]
	cp a, TRUE
	ret nz
	DEF LEFTMOST_COLUMN = 3
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF ROW_WIDTH = 2
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF ROW_WIDTH = 1
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wLDirty], a
	ret

PaintSegmentLDiag::
	ld a, [wLDiagDirty]
	cp a, TRUE
	ret nz
	DEF ROW_WIDTH = 1
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 5
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 4
	paint_row_single_tile_romx
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 3
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wLDiagDirty], a
	ret

PaintSegmentM::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 6
	DEF ROW_WIDTH = 8
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 5
	DEF ROW_WIDTH = 10
	paint_row_single_tile_romx
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 4
	DEF ROW_WIDTH = 12
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wMDirty], a
	ret

PaintSegmentMGround::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 6
	DEF ROW_WIDTH = 8
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 5
	DEF ROW_WIDTH = 10
	paint_row_single_tile_romx
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 4
	DEF ROW_WIDTH = 12
	paint_row_single_tile_romx
.randomGrassRow13
	; randomly generate a tile locations that will be grass
	ld d, 8
	call Paint_Rand ; between 0 and 255
	and `00000111 ; mask to be between 0 and 7 to remove some subtractions from the mod operation
	call Paint_SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 6
	AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call Paint_CopyByteInDToRange

	; randomize x flip
	call Paint_Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 6
	AddAToHl
	ld b, 1
	call Paint_CopyByteInEToRange
.randomGrassRow14
	; randomly generate a tile locations that will be grass
	ld d, 10
	call Paint_Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call Paint_SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 5
	AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call Paint_CopyByteInDToRange

	; randomize x flip
	call Paint_Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 5
	AddAToHl
	ld b, 1
	call Paint_CopyByteInEToRange
.randomGrassRow15
	; randomly generate a tile locations that will be grass
	ld d, 12
	call Paint_Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call Paint_SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 4
	AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call Paint_CopyByteInDToRange

	; randomize x flip
	call Paint_Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 4
	AddAToHl
	ld b, 1
	call Paint_CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wMDirty], a
	ret

PaintSegmentN::
	ld a, [wNDirty]
	cp a, TRUE
	ret nz
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 15
	DEF ROW_WIDTH = 2
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 16
	DEF ROW_WIDTH = 1
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wNDirty], a
	ret

PaintSegmentNDiag::
	ld a, [wNDiagDirty]
	cp a, TRUE
	ret nz

	DEF ROW_WIDTH = 1
.row13
	DEF ROW = MIDDLE_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 14
	paint_row_single_tile_romx
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 15
	paint_row_single_tile_romx
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 16
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wNDiagDirty], a
	ret

PaintSegmentO::
	ld a, [wODirty]
	cp a, TRUE
	ret nz
.paintRepeatingRows
	DEF ROW_WIDTH = 3
	DEF LEFTMOST_COLUMN = 17
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile_romx
	ENDR
.clean
	ld a, FALSE
	ld [wODirty], a
	ret

PaintSegmentP::
	ld a, [wPDirty]
	cp a, TRUE
	ret nz

	DEF LEFTMOST_COLUMN = 0
.row16
	DEF ROW = BOTTOM_SEGMENTS_TOP
	DEF ROW_WIDTH = 2
	paint_row_single_tile_romx
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF ROW_WIDTH = 1
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wPDirty], a
	ret

PaintSegmentPDiag::
	ld a, [wPDiagDirty]
	cp a, TRUE
	ret nz
	DEF ROW_WIDTH = 1
.row16
	DEF ROW = BOTTOM_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 2
	paint_row_single_tile_romx
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 1
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wPDiagDirty], a
	ret

PaintSegmentQGround::
	ld a, [wQDirty]
	cp a, TRUE
	ret nz
.row16
	DEF ROW = BOTTOM_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 3
	DEF ROW_WIDTH = 14
	paint_row_single_tile_romx
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 2
	DEF ROW_WIDTH = 16
	paint_row_single_tile_romx
.randomGrassRow16
	; randomly generate a tile locations that will be grass
	ld d, 14
	call Paint_Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call Paint_SingleByteModulo ; result in a, between

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 3
	AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call Paint_CopyByteInDToRange

	; randomize x flip
	call Paint_Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 3
	AddAToHl
	ld b, 1
	call Paint_CopyByteInEToRange
.randomGrassRow17
	; randomly generate a tile locations that will be grass
	ld d, 16
	call Paint_Rand ; between 0 and 255
	and `00011111 ; mask to be between 0 and 31 to remove some subtractions from the mod operation
	call Paint_SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 2
	AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call Paint_CopyByteInDToRange

	; randomize x flip
	call Paint_Rand
	and `00100000
	or e
	ld e, a

	pop af ; restore random column #
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 2
	AddAToHl
	ld b, 1
	call Paint_CopyByteInEToRange

.clean
	ld a, FALSE
	ld [wQDirty], a
	ret

PaintSegmentR::
	ld a, [wRDirty]
	cp a, TRUE
	ret nz
.column18
	DEF ROW = BOTTOM_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 18
	DEF ROW_WIDTH = 2
	paint_row_single_tile_romx
.column19
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 19
	DEF ROW_WIDTH = 1
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wRDirty], a
	ret

PaintSegmentRDiag::
	ld a, [wRDiagDirty]
	cp a, TRUE
	ret nz
	DEF ROW_WIDTH = 1
.row16
	DEF ROW = BOTTOM_SEGMENTS_TOP
	DEF LEFTMOST_COLUMN = 17
	paint_row_single_tile_romx
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 18
	paint_row_single_tile_romx
.clean
	ld a, FALSE
	ld [wRDiagDirty], a
	ret

;SECTION "Fog Painting Routines", ROM0
; Fog Painting Routines

; @param d: counter, must be <= 8
; @param hl: destination
; trashes abchl
CopyRandomFogTilesToTilemapRow:
	push hl
	call Paint_Rand ; rand in c
	pop hl
.loop
	ld a, c
	and 1 ; get bottom bit
	add TILE_DISTANCE_FOG_A
	ld [hli], a ; write tile id
	srl c ; right shift entropy byte
	dec d ; dec counter
	jp nz, .loop
	ret

; @param c, random byte
; @return e, fog attrs with random yflip
GetRandomYFlipFogAttrs:
	ld a, c
	and 1 ; grab the bottom bit
	rrc a
	rrc a ; move it to the 6th bit position (OAMF_YFLIP)
	add BG_PALETTE_FOG
	ld e, a
	sra c ; shift c
	ret

; @param c, random byte
; @return e, fog attrs with random yflip
GetRandomYFlipFogAttrsXFlip:
	ld a, c
	and 1 ; grab the bottom bit
	rrc a
	rrc a ; move it to the 6th bit position (OAMF_YFLIP)
	add BG_PALETTE_FOG + OAMF_XFLIP
	ld e, a
	sra c ; shift c
	ret

; these Paint_ routines are copied from memory_utils.asm

; @param d: source tile id
; @param hl: destination
; @param b: length
Paint_CopyByteInDToRange:
	ld a, d
.loop
	ld [hli], a ; write tile id
	dec b
	jp nz, .loop
	ret ; this is ret-ing to the wrong bank, bank 0 instead of non-zero

; @param e: BG Map Attribute byte
; @param hl: destination
; @param b: length
Paint_CopyByteInEToRange:
	ld a, e
.loop
	ld [hli], a ; write palette id
	dec b
	jp nz, .loop
	ret

; copy bytes from one area to another. max 256 bytes
; @param d: source value
; @param hl: destination
; @param b: length
Paint_CopyIncrementing:
	ld a, d
	ld [hli], a
	inc d
	dec b
	ld a, b
	jp nz, Paint_CopyIncrementing
	ret

;; copied from rand.asm
; Generates a pseudorandom 16-bit integer in BC
; using the LCG formula from cc65 rand():
; x[i + 1] = x[i] * 0x01010101 + 0xB3B3B3B3
; @return A=B=state bits 31-24 (which have the best entropy),
; C=state bits 23-16, HL trashed
Paint_Rand:
  ; Add 0xB3 then multiply by 0x01010101
  ld hl, randstate+0
  ld a, [hl]
  add a, $B3
  ld [hl+], a
  adc a, [hl]
  ld [hl+], a
  adc a, [hl]
  ld [hl+], a
  ld c, a
  adc a, [hl]
  ld [hl], a
  ld b, a
  ret

; @param d, modulo value
; @return a, remainder
Paint_SingleByteModulo:
.subtractionLoop
	sub d
	jp z, .returnZero
	jp c, .returnNonZero
	jp .subtractionLoop
.returnZero
	xor a
	ret
.returnNonZero
	add d
	ret

SECTION "Segment Dirtying Routine", ROM0

; todo there is probably a more efficient way to do this
; todo this can totally go somewhere else
DirtyFpSegments::
	ld a, TRUE
	ld [wADirty], a
	ld [wBDirty], a
	ld [wCDirty], a
	ld [wDDirty], a
	ld [wEDirty], a
	ld [wFDirty], a
	ld [wGDirty], a
	ld [wHDirty], a
	ld [wIDirty], a
	ld [wJDirty], a
	ld [wKDirty], a
	ld [wLDirty], a
	ld [wLDiagDirty], a
	ld [wMDirty], a
	ld [wNDirty], a
	ld [wNDiagDirty], a
	ld [wODirty], a
	ld [wPDirty], a
	ld [wPDiagDirty], a
	ld [wQDirty], a
	ld [wRDirty], a
	ld [wRDiagDirty], a
	ret
