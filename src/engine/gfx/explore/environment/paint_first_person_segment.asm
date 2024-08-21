INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/ram/wram.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

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

SECTION "Segment Paint Routines", ROMX

MACRO paint_row_single_tile
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInEToRange
ENDM

MACRO paint_row_random_fog_tiles
	ld hl, wShadowBackgroundTilemap + rows ROW + cols LEFTMOST_COLUMN
	ld d, ROW_WIDTH
	call CopyRandomFogTilesToTilemapRow
	ld hl, wShadowBackgroundTilemapAttrs + rows ROW + cols LEFTMOST_COLUMN
	ld b, ROW_WIDTH
	call CopyByteInEToRange
ENDM

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
		paint_row_single_tile
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
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
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
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 5
	FOR ROW, 8
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile
	ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
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
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 6
	FOR ROW, 8
		call GetRandomYFlipFogAttrs
		paint_row_single_tile
	ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrs
		paint_row_single_tile
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG
	paint_row_single_tile
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCFogBorderRight:
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 13
	FOR ROW, 8
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile
	ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrsXFlip
		paint_row_single_tile
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
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
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
.paintRepeatingRows
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = 14
	FOR ROW, 8
		call GetRandomYFlipFogAttrs
		paint_row_single_tile
	ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
.paintMoreRepeatingRows
	FOR ROW, 8, MIDDLE_SEGMENTS_TOP - 1
		call GetRandomYFlipFogAttrs
		paint_row_single_tile
	ENDR
.row12
	DEF ROW = MIDDLE_SEGMENTS_TOP - 1
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld e, BG_PALETTE_FOG
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF ROW_WIDTH = 1
	paint_row_single_tile
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 4
	paint_row_single_tile
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 3
	paint_row_single_tile
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 5
	DEF ROW_WIDTH = 10
	paint_row_single_tile
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 4
	DEF ROW_WIDTH = 12
	paint_row_single_tile
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 5
	DEF ROW_WIDTH = 10
	paint_row_single_tile
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 4
	DEF ROW_WIDTH = 12
	paint_row_single_tile
.randomGrassRow13
	; randomly generate a tile locations that will be grass
	ld d, 8
	call Rand ; between 0 and 255
	and `00000111 ; mask to be between 0 and 7 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 6
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call CopyByteInDToRange

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 6
	call AddAToHl
	ld b, 1
	call CopyByteInEToRange
.randomGrassRow14
	; randomly generate a tile locations that will be grass
	ld d, 10
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 5
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call CopyByteInDToRange

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 5
	call AddAToHl
	ld b, 1
	call CopyByteInEToRange
.randomGrassRow15
	; randomly generate a tile locations that will be grass
	ld d, 12
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 4
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call CopyByteInDToRange

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 4
	call AddAToHl
	ld b, 1
	call CopyByteInEToRange
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 16
	DEF ROW_WIDTH = 1
	paint_row_single_tile
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
	paint_row_single_tile
.row14
	DEF ROW = MIDDLE_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 15
	paint_row_single_tile
.row15
	DEF ROW = MIDDLE_SEGMENTS_TOP + 2
	DEF LEFTMOST_COLUMN = 16
	paint_row_single_tile
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
		paint_row_single_tile
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
	paint_row_single_tile
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF ROW_WIDTH = 1
	paint_row_single_tile
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
	paint_row_single_tile
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 1
	paint_row_single_tile
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
	paint_row_single_tile
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 2
	DEF ROW_WIDTH = 16
	paint_row_single_tile
.randomGrassRow16
	; randomly generate a tile locations that will be grass
	ld d, 14
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a, between

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 3
	call AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call CopyByteInDToRange

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 3
	call AddAToHl
	ld b, 1
	call CopyByteInEToRange
.randomGrassRow17
	; randomly generate a tile locations that will be grass
	ld d, 16
	call Rand ; between 0 and 255
	and `00011111 ; mask to be between 0 and 31 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 2
	call AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call CopyByteInDToRange

	; randomize x flip
	call Rand
	and `00100000
	or e
	ld e, a

	pop af ; restore random column #
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 2
	call AddAToHl
	ld b, 1
	call CopyByteInEToRange

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
	paint_row_single_tile
.column19
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 19
	DEF ROW_WIDTH = 1
	paint_row_single_tile
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
	paint_row_single_tile
.row17
	DEF ROW = BOTTOM_SEGMENTS_TOP + 1
	DEF LEFTMOST_COLUMN = 18
	paint_row_single_tile
.clean
	ld a, FALSE
	ld [wRDiagDirty], a
	ret

PaintWallLeftSideNearTypeB::
	; hmm how will this work, if specials walls are different per-locale
	; get locale -> call CurrentLocaleSpecialWallBSideNear ??? would each locale come with ... a table of 6 custom function pointers per custom wall type? :(
	; maybe the paint functions should all be the same, at least initially?
	;   this will be impossible without very simplified paint functions
	; for the time being, i'll just add the one wall type and all locales can use it

	ld e, BG_PALETTE_SIDE_NEAR + OAMF_BANK1

	; top part of wall
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_A_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT
	FOR ROW, 6
		paint_row_single_tile
	ENDR

	; door
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT
	FOR ROW, 6, SCREEN_BOTTOM
		paint_row_single_tile
	ENDR

	; wall right of door
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = 2
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT + 1
	FOR ROW, 6, SCREEN_BOTTOM - 2
		paint_row_single_tile
	ENDR
	DEF ROW_WIDTH = 1
	DEF LEFTMOST_COLUMN = SEGMENT_A_LEFT + 1
	DEF ROW = SCREEN_BOTTOM - 2
	paint_row_single_tile

	; diagonal. overwrites some of "wall right of door"
	ld d, TILE_FIELD_WALL_B_SIDE_FAR_DIAG
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
	ld e, BG_PALETTE_FRONT_NEAR + OAMF_BANK1
.segmentB
	call PaintSegmentB
.segmentD
	call PaintSegmentD
.segmentC
	ld a, [wCDirty]
	cp a, TRUE
	ret nz

	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_C_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, TOP_SEGMENTS_TOP, TOP_SEGMENTS_TOP + 6
		paint_row_single_tile
	ENDR

	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = 8
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, TOP_SEGMENTS_TOP + 6, MIDDLE_SEGMENTS_TOP
		paint_row_single_tile
	ENDR
	ld a, FALSE
	ld [wCDirty], a

.segmentL_LDiag_MLeft
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_B_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_B_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile
	ENDR
.segmentMMiddle
	ld d, TILE_FIELD_WALL_B_DOOR
	DEF ROW_WIDTH = SEGMENT_C_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_C_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile
	ENDR
.segmentMMiddle_NDiag_N
	ld d, TILE_FIELD_WALL_B_WALL
	DEF ROW_WIDTH = SEGMENT_D_WIDTH
	DEF LEFTMOST_COLUMN = SEGMENT_D_LEFT
	FOR ROW, MIDDLE_SEGMENTS_TOP, BOTTOM_SEGMENTS_TOP
		paint_row_single_tile
	ENDR
.cleanFlags
	ld a, FALSE
	ld [wLDirty], a
	ld [wLDiagDirty], a
	ld [wMDirty], a
	ld [wNDirty], a
	ld [wNDiagDirty], a
	ret

; @param d: counter, must be <= 8
; @param hl: destination
; trashes abchl
CopyRandomFogTilesToTilemapRow:
	push hl
	call Rand ; rand in c
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

; todo there is probably a more efficient way to do this
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
