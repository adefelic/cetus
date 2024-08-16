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

; todo combine/dedup routines that paint similar shapes

CheckSegmentA::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentA

CheckSegmentB::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentB

CheckSegmentADistanceFog::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentADistanceFog

CheckSegmentBDistanceFog::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentBDistanceFog

	; B will draw right border if far-center has top wall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	call nz, PaintSegmentBFogBorderRight
	ret

CheckSegmentC::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentC

CheckSegmentCDistanceFog::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentCDistanceFog

	; C will draw left border if far-center has a left wall or far-left has a top wall
	ld hl, wRoomFarCenter
	call GetLeftWallTypeFromRoomAddr
	ld b, a
	ld hl, wRoomFarLeft
	call GetTopWallTypeFromRoomAddr
	or b
	call nz, PaintSegmentCFogBorderLeft

	; C will draw left border if far-center has a right wall or far-right has a top wall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
	ld b, a
	ld hl, wRoomFarRight
	call GetTopWallTypeFromRoomAddr
	or b
	call nz, PaintSegmentCFogBorderRight
	ret

CheckSegmentD::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentD

CheckSegmentE::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentE

CheckSegmentDDistanceFog::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentDDistanceFog

	; D will draw left border if far-center has top wall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	call nz, PaintSegmentDFogBorderLeft
	ret

CheckSegmentEDistanceFog::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentEDistanceFog

CheckSegmentK::
	ld a, [wKDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentK

CheckSegmentL::
	ld a, [wLDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentL

CheckSegmentLDiag::
	ld a, [wLDiagDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentLDiag

CheckSegmentM::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentM

CheckSegmentMGround::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentMGround

CheckSegmentN::
	ld a, [wNDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentN

CheckSegmentNDiag::
	ld a, [wNDiagDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentNDiag

CheckSegmentO::
	ld a, [wODirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentO

CheckSegmentP::
	ld a, [wPDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentP

CheckSegmentPDiag::
	ld a, [wPDiagDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentPDiag

; todo, dirty this every time probably
CheckSegmentQGround::
	ld a, [wQDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentQ

CheckSegmentR::
	ld a, [wRDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentR

CheckSegmentRDiag::
	ld a, [wRDiagDirty]
	cp a, TRUE
	ret nz
	jp PaintSegmentRDiag

MACRO paint_rectangular_segment
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDM

MACRO paint_rectangular_segment_fog
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld d, SEGMENT_WIDTH
	call PaintFogTilemapWithRandomFogTile
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDM

; @param d: the tile index to paint with
; @param e: the attribute byte to paint with
PaintSegmentA:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 0
FOR ROWS, 13
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wADirty], a
	ret

PaintSegmentADistanceFog:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 0
FOR ROWS, 12
	paint_rectangular_segment_fog
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12
	ld d, TILE_DISTANCE_FOG_GROUND
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wADirty], a
	ret

PaintSegmentB:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 3
FOR ROWS, 13
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentBDistanceFog:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 3
FOR ROWS, 12
	paint_rectangular_segment_fog
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld d, TILE_DISTANCE_FOG_GROUND
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentBFogBorderRight:
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
	DEF SEGMENT_WIDTH = 1
	DEF LEFTMOST_COLUMN = 5
FOR ROWS, 8
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrsXFlip
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
FOR ROWS, 8, 12
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrsXFlip
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols 5
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols 5
	ld b, 1
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentC:
DEF SEGMENT_WIDTH = 8
DEF LEFTMOST_COLUMN = 6
FOR ROWS, 13
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCDistanceFog:
DEF SEGMENT_WIDTH = 8
DEF LEFTMOST_COLUMN = 6
FOR ROWS, 12
	paint_rectangular_segment_fog
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld d, TILE_DISTANCE_FOG_GROUND
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCFogBorderLeft:
DEF SEGMENT_WIDTH = 1
DEF LEFTMOST_COLUMN = 6
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
FOR ROWS, 8
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrs
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
FOR ROWS, 8, 12
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrs
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.row12
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld e, BG_PALETTE_FOG
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCFogBorderRight:
DEF SEGMENT_WIDTH = 1
DEF LEFTMOST_COLUMN = 13
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
FOR ROWS, 8
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrsXFlip
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
FOR ROWS, 8, 12
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrsXFlip
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.row12
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld e, BG_PALETTE_FOG + OAMF_XFLIP
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentD:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 14
FOR ROWS, 13
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentDDistanceFog:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 14
FOR ROWS, 12
	paint_rectangular_segment_fog
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld d, TILE_DISTANCE_FOG_GROUND
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentDFogBorderLeft:
DEF SEGMENT_WIDTH = 1
DEF LEFTMOST_COLUMN = 14
	call Rand ; we'll use the byte in c
	ld d, TILE_DISTANCE_FOG_LEFT_WALL
FOR ROWS, 8
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrs
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.getAnotherRandomByte
	call Rand ; we'll use the byte in c
FOR ROWS, 8, 12
	ld hl, wShadowBackgroundTilemap + rows ROWS + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows ROWS + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrs
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld d, TILE_DISTANCE_FOG_LEFT_CORNER
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	call GetRandomYFlipFogAttrs
	ld b, SEGMENT_WIDTH
	ld e, BG_PALETTE_FOG
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentE:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 17
FOR ROWS, 13
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wEDirty], a
	ret

PaintSegmentEDistanceFog:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 17
FOR ROWS, 12
	paint_rectangular_segment_fog
ENDR
.row12
	ld hl, wShadowBackgroundTilemap + rows 12 + cols LEFTMOST_COLUMN
	ld d, TILE_DISTANCE_FOG_GROUND
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 12 + cols LEFTMOST_COLUMN
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wEDirty], a
	ret

PaintSegmentK:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 0
FOR ROWS, 13, 16
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wKDirty], a
	ret

PaintSegmentL:
DEF LEFTMOST_COLUMN = 3
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols LEFTMOST_COLUMN
	ld b, 2
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols LEFTMOST_COLUMN
	ld b, 2
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols LEFTMOST_COLUMN
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols LEFTMOST_COLUMN
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wLDirty], a
	ret

PaintSegmentLDiag:
DEF SEGMENT_WIDTH = 1
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 5
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 5
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 4
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 4
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.row15
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 3
	ld b, SEGMENT_WIDTH
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 3
	ld b, SEGMENT_WIDTH
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wLDiagDirty], a
	ret

PaintSegmentM:
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 6
	ld b, 8
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 6
	ld b, 8
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 5
	ld b, 10
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 5
	ld b, 10
	call CopyByteInEToRange
.row15
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 4
	ld b, 12
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 4
	ld b, 12
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wMDirty], a
	ret

PaintSegmentMGround:
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 6
	ld b, 8
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 6
	ld b, 8
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 5
	ld b, 10
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 5
	ld b, 10
	call CopyByteInEToRange
.row15
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 4
	ld b, 12
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 4
	ld b, 12
	call CopyByteInEToRange

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

PaintSegmentN:
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 15
	ld b, 2
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 15
	ld b, 2
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 16
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 16
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wNDirty], a
	ret

PaintSegmentNDiag:
.row13
	ld hl, wShadowBackgroundTilemap + rows 13 + cols 14
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 13 + cols 14
	ld b, 1
	call CopyByteInEToRange
.row14
	ld hl, wShadowBackgroundTilemap + rows 14 + cols 15
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 14 + cols 15
	ld b, 1
	call CopyByteInEToRange
.row15
	ld hl, wShadowBackgroundTilemap + rows 15 + cols 16
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 15 + cols 16
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wNDiagDirty], a
	ret

PaintSegmentO:
DEF SEGMENT_WIDTH = 3
DEF LEFTMOST_COLUMN = 17
FOR ROWS, 13, 16
	paint_rectangular_segment
ENDR
.clean
	ld a, FALSE
	ld [wODirty], a
	ret

PaintSegmentP:
.row16
	ld hl, wShadowBackgroundTilemap + rows 16
	ld b, 2
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 16
	ld b, 2
	call CopyByteInEToRange
.row17
	ld hl, wShadowBackgroundTilemap + rows 17
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 17
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wPDirty], a
	ret

PaintSegmentPDiag:
.row16
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 2
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 2
	ld b, 1
	call CopyByteInEToRange
.row17
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 1
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 1
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wPDiagDirty], a
	ret

PaintSegmentQ:
.row16
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 3
	ld b, 14
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 3
	ld b, 14
	call CopyByteInEToRange
.row17
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 2
	ld b, 16
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 2
	ld b, 16
	call CopyByteInEToRange
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

PaintSegmentR:
.column18
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 18
	ld b, 2
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 18
	ld b, 2
	call CopyByteInEToRange
.column19
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 19
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 19
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wRDirty], a
	ret

PaintSegmentRDiag:
.row16
	ld hl, wShadowBackgroundTilemap + rows 16 + cols 17
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 16 + cols 17
	ld b, 1
	call CopyByteInEToRange
.row17
	ld hl, wShadowBackgroundTilemap + rows 17 + cols 18
	ld b, 1
	call CopyByteInDToRange
	ld hl, wShadowBackgroundTilemapAttrs + rows 17 + cols 18
	ld b, 1
	call CopyByteInEToRange
.clean
	ld a, FALSE
	ld [wRDiagDirty], a
	ret

; @param d: counter, must be <= 8
; @param hl: destination
; trashes abchl
PaintFogTilemapWithRandomFogTile:
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
