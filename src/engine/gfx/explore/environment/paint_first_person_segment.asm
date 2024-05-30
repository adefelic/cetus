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
; todo use macros to make this way smaller

CheckSegmentA::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
	call PaintSegmentA
	ret

CheckSegmentB::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentB
	ret

CheckSegmentADistanceFog::
	ld a, [wADirty]
	cp a, TRUE
	ret nz
	call PaintSegmentADistanceFog
	ret

CheckSegmentBDistanceFog::
	ld a, [wBDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentBDistanceFog

	; B will draw right border if far-center has top wall
	ld hl, wRoomAttributesFarCenter
	call GetTopWallTypeFromRoomAttrAddr
	call nz, PaintSegmentBFogBorderRight
	ret

CheckSegmentC::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentC
	ret

CheckSegmentCDistanceFog::
	ld a, [wCDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentCDistanceFog

	; C will draw left border if far-center has a left wall or far-left has a top wall
	ld hl, wRoomAttributesFarCenter
	call GetLeftWallTypeFromRoomAttrAddr
	ld b, a
	ld hl, wRoomAttributesFarLeft
	call GetTopWallTypeFromRoomAttrAddr
	or b
	call nz, PaintSegmentCFogBorderLeft

	; C will draw left border if far-center has a right wall or far-right has a top wall
	ld hl, wRoomAttributesFarCenter
	call GetRightWallTypeFromRoomAttrAddr
	ld b, a
	ld hl, wRoomAttributesFarRight
	call GetTopWallTypeFromRoomAttrAddr
	or b
	call nz, PaintSegmentCFogBorderRight
	ret

CheckSegmentD::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentD
	ret

CheckSegmentE::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentE
	ret

CheckSegmentDDistanceFog::
	ld a, [wDDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentDDistanceFog

	; D will draw left border if far-center has top wall
	ld hl, wRoomAttributesFarCenter
	call GetTopWallTypeFromRoomAttrAddr
	call nz, PaintSegmentDFogBorderLeft
	ret

CheckSegmentEDistanceFog::
	ld a, [wEDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentEDistanceFog
	ret

CheckSegmentK::
	ld a, [wKDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentK
	ret

CheckSegmentL::
	ld a, [wLDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentL
	ret

CheckSegmentLDiag::
	ld a, [wLDiagDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentLDiag
	ret

CheckSegmentM::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentM
	ret

CheckSegmentMGround::
	ld a, [wMDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentMGround
	ret

CheckSegmentN::
	ld a, [wNDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentN
	ret

CheckSegmentNDiag::
	ld a, [wNDiagDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentNDiag
	ret

CheckSegmentO::
	ld a, [wODirty]
	cp a, TRUE
	ret nz
	call PaintSegmentO
	ret

CheckSegmentP::
	ld a, [wPDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentP
	ret

CheckSegmentPDiag::
	ld a, [wPDiagDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentPDiag
	ret

; todo, dirty this every time probably
CheckSegmentQGround::
	ld a, [wQDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentQ
	ret

CheckSegmentR::
	ld a, [wRDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentR
	ret

CheckSegmentRDiag::
	ld a, [wRDiagDirty]
	cp a, TRUE
	ret nz
	call PaintSegmentRDiag
	ret

; @param d: the tile index to paint with
PaintSegmentA::
.row0
	ld hl, wShadowTilemap + rows 0 ; dest in VRAM
	ld b, 3      ; # of bytes (tile indices) remaining.
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 0
	ld b, 3
	call PaintTilemapAttrsSmall
.row1
	ld hl, wShadowTilemap + rows 1
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 1
	ld b, 3
	call PaintTilemapAttrsSmall
.row2
	ld hl, wShadowTilemap + rows 2
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 2
	ld b, 3
	call PaintTilemapAttrsSmall
.row3
	ld hl, wShadowTilemap + rows 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row4
	ld hl, wShadowTilemap + rows 4
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 4
	ld b, 3
	call PaintTilemapAttrsSmall
.row5
	ld hl, wShadowTilemap + rows 5
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 5
	ld b, 3
	call PaintTilemapAttrsSmall
.row6
	ld hl, wShadowTilemap + rows 6
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 6
	ld b, 3
	call PaintTilemapAttrsSmall
.row7
	ld hl, wShadowTilemap + rows 7
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 7
	ld b, 3
	call PaintTilemapAttrsSmall
.row8
	ld hl, wShadowTilemap + rows 8
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 8
	ld b, 3
	call PaintTilemapAttrsSmall
.row9
	ld hl, wShadowTilemap + rows 9
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 9
	ld b, 3
	call PaintTilemapAttrsSmall
.row10
	ld hl, wShadowTilemap + rows 10
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 10
	ld b, 3
	call PaintTilemapAttrsSmall
.row11
	ld hl, wShadowTilemap + rows 11
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 11
	ld b, 3
	call PaintTilemapAttrsSmall
.row12
	ld hl, wShadowTilemap + rows 12
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 12
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wADirty], a
	ret

PaintSegmentADistanceFog::
	.row0
		ld hl, wShadowTilemap + rows 0 ; dest in VRAM
		ld d, 3      ; # of bytes (tile indices) remaining.
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 0
		ld b, 3
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 1
		ld b, 3
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 2
		ld b, 3
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 4
		ld b, 3
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 5
		ld b, 3
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 6
		ld b, 3
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 7
		ld b, 3
		call PaintTilemapAttrsSmall
	.row8
		ld hl, wShadowTilemap + rows 8
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 8
		ld b, 3
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 9
		ld b, 3
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 10
		ld b, 3
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 11
		ld b, 3
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12
		ld d, TILE_DISTANCE_FOG_GROUND
		ld b, 3
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12
		ld b, 3
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wADirty], a
		ret

PaintSegmentB::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 0 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row1
	ld hl, wShadowTilemap + rows 1 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 1 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row2
	ld hl, wShadowTilemap + rows 2 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 2 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row3
	ld hl, wShadowTilemap + rows 3 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 3 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row4
	ld hl, wShadowTilemap + rows 4 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 4 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row5
	ld hl, wShadowTilemap + rows 5 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 5 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row6
	ld hl, wShadowTilemap + rows 6 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 6 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row7
	ld hl, wShadowTilemap + rows 7 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 7 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row8
	ld hl, wShadowTilemap + rows 8 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 8 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row9
	ld hl, wShadowTilemap + rows 9 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 9 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row10
	ld hl, wShadowTilemap + rows 10 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 10 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row11
	ld hl, wShadowTilemap + rows 11 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 11 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.row12
	ld hl, wShadowTilemap + rows 12 + cols 3
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 12 + cols 3
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wBDirty], a
	ret

PaintSegmentBDistanceFog::
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 0 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 1 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 2 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 3 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 4 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 5 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 6 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 7 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 8 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 9 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 10 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 3
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 11 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 3
		ld d, TILE_DISTANCE_FOG_GROUND
		ld b, 3
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 3
		ld b, 3
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wBDirty], a
		ret

PaintSegmentBFogBorderRight::
		call Rand ; we'll use the byte in c
		ld d, TILE_DISTANCE_FOG_LEFT_WALL
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 0 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 1 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 2 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 3 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 4 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 5 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 6 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 7 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.getAnotherRandomByte
		call Rand ; we'll use the byte in c
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 8 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 9 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 10 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 5
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 11 + cols 5
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 5
		ld d, TILE_DISTANCE_FOG_LEFT_CORNER
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 5
		ld b, 1
		ld e, BG_PALETTE_FOG + OAMF_XFLIP
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wBDirty], a
		ret

PaintSegmentC::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 0 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row1
	ld hl, wShadowTilemap + rows 1 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 1 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row2
	ld hl, wShadowTilemap + rows 2 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 2 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row3
	ld hl, wShadowTilemap + rows 3 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 3 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row4
	ld hl, wShadowTilemap + rows 4 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 4 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row5
	ld hl, wShadowTilemap + rows 5 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 5 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row6
	ld hl, wShadowTilemap + rows 6 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 6 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row7
	ld hl, wShadowTilemap + rows 7 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 7 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row8
	ld hl, wShadowTilemap + rows 8 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 8 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row9
	ld hl, wShadowTilemap + rows 9 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 9 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row10
	ld hl, wShadowTilemap + rows 10 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 10 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row11
	ld hl, wShadowTilemap + rows 11 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 11 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row12
	ld hl, wShadowTilemap + rows 12 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 12 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wCDirty], a
	ret

PaintSegmentCDistanceFog::
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 0 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 1 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 2 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 3 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 4 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 5 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 6 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 7 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 8 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 9 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 10 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 6
		ld d, 8
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 11 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 6
		ld d, TILE_DISTANCE_FOG_GROUND
		ld b, 8
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 6
		ld b, 8
		call PaintTilemapAttrsSmall

		; the area we need to paint is 8 * 12
		; we can add one of those bits to TILE_DISTANCE_FOG_A to get pick a random tile
		; it would be nice to also randomize the x flip and y flip attributes, that's 3 bits per tile
	.clean
		ld a, FALSE
		ld [wCDirty], a
		ret

PaintSegmentCFogBorderLeft::
		call Rand ; we'll use the byte in c
		ld d, TILE_DISTANCE_FOG_LEFT_WALL
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 0 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 1 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 2 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 3 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 4 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 5 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 6 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 7 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.getAnotherRandomByte
		call Rand ; we'll use the byte in c
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 8 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 9 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 10 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 11 + cols 6
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row12
		ld d, TILE_DISTANCE_FOG_LEFT_CORNER
		ld hl, wShadowTilemap + rows 12 + cols 6
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 6
		ld e, BG_PALETTE_FOG
		ld b, 1
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wCDirty], a
		ret


PaintSegmentCFogBorderRight::
		call Rand ; we'll use the byte in c
		ld d, TILE_DISTANCE_FOG_LEFT_WALL
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 0 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 1 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 2 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 3 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 4 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 5 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 6 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 7 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.getAnotherRandomByte
		call Rand ; we'll use the byte in c
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 8 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 9 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 10 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 11 + cols 13
		call GetRandomYFlipFogAttrsXFlip
		ld b, 1
		call PaintTilemapAttrsSmall
	.row12
		ld d, TILE_DISTANCE_FOG_LEFT_CORNER
		ld hl, wShadowTilemap + rows 12 + cols 13
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 13
		ld e, BG_PALETTE_FOG + OAMF_XFLIP
		ld b, 1
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wCDirty], a
		ret

PaintSegmentD::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 0 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row1
	ld hl, wShadowTilemap + rows 1 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 1 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row2
	ld hl, wShadowTilemap + rows 2 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 2 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row3
	ld hl, wShadowTilemap + rows 3 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 3 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row4
	ld hl, wShadowTilemap + rows 4 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 4 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row5
	ld hl, wShadowTilemap + rows 5 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 5 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row6
	ld hl, wShadowTilemap + rows 6 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 6 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row7
	ld hl, wShadowTilemap + rows 7 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 7 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row8
	ld hl, wShadowTilemap + rows 8 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 8 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row9
	ld hl, wShadowTilemap + rows 9 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 9 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row10
	ld hl, wShadowTilemap + rows 10 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 10 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row11
	ld hl, wShadowTilemap + rows 11 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 11 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row12
	ld hl, wShadowTilemap + rows 12 + cols 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 12 + cols 14
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wDDirty], a
	ret

PaintSegmentDDistanceFog::
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 0 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 1 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 2 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 3 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 4 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 5 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 6 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 7 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 8 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 9 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 10 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 14
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 11 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 14
		ld d, TILE_DISTANCE_FOG_GROUND
		ld b, 3
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 14
		ld b, 3
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wDDirty], a
		ret

PaintSegmentDFogBorderLeft::
		call Rand ; we'll use the byte in c
		ld d, TILE_DISTANCE_FOG_LEFT_WALL
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 0 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 1 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 2 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 3 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 4 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 5 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 6 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 7 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.getAnotherRandomByte
		call Rand ; we'll use the byte in c
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 8 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 9 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 10 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 14
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 11 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 14
		ld d, TILE_DISTANCE_FOG_LEFT_CORNER
		ld b, 1
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 14
		call GetRandomYFlipFogAttrs
		ld b, 1
		ld e, BG_PALETTE_FOG
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wDDirty], a
		ret

PaintSegmentE::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 0 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row1
	ld hl, wShadowTilemap + rows 1 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 1 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row2
	ld hl, wShadowTilemap + rows 2 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 2 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row3
	ld hl, wShadowTilemap + rows 3 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 3 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row4
	ld hl, wShadowTilemap + rows 4 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 4 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row5
	ld hl, wShadowTilemap + rows 5 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 5 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row6
	ld hl, wShadowTilemap + rows 6 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 6 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row7
	ld hl, wShadowTilemap + rows 7 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 7 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row8
	ld hl, wShadowTilemap + rows 8 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 8 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row9
	ld hl, wShadowTilemap + rows 9 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 9 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row10
	ld hl, wShadowTilemap + rows 10 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 10 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row11
	ld hl, wShadowTilemap + rows 11 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 11 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row12
	ld hl, wShadowTilemap + rows 12 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 12 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wEDirty], a
	ret

PaintSegmentEDistanceFog::
	.row0
		ld hl, wShadowTilemap + rows 0 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 0 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row1
		ld hl, wShadowTilemap + rows 1 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 1 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row2
		ld hl, wShadowTilemap + rows 2 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 2 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row3
		ld hl, wShadowTilemap + rows 3 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 3 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row4
		ld hl, wShadowTilemap + rows 4 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 4 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row5
		ld hl, wShadowTilemap + rows 5 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 5 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row6
		ld hl, wShadowTilemap + rows 6 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 6 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row7
		ld hl, wShadowTilemap + rows 7 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 7 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row8
		ld hl, wShadowTilemap + rows 8 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 8 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row9
		ld hl, wShadowTilemap + rows 9 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 9 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row10
		ld hl, wShadowTilemap + rows 10 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 10 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row11
		ld hl, wShadowTilemap + rows 11 + cols 17
		ld d, 3
		call PaintFogTilemapWithRandomFogTile
		ld hl, wShadowTilemapAttrs + rows 11 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.row12
		ld hl, wShadowTilemap + rows 12 + cols 17
		ld d, TILE_DISTANCE_FOG_GROUND
		ld b, 3
		call PaintTilemapSmall
		ld hl, wShadowTilemapAttrs + rows 12 + cols 17
		ld b, 3
		call PaintTilemapAttrsSmall
	.clean
		ld a, FALSE
		ld [wEDirty], a
		ret


PaintSegmentK::
.row13
	ld hl, wShadowTilemap + rows 13
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13
	ld b, 3
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14
	ld b, 3
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wKDirty], a
	ret

PaintSegmentL::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 3
	ld b, 2
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 3
	ld b, 2
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 3
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 3
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wLDirty], a
	ret

PaintSegmentLDiag::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 5
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 5
	ld b, 1
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 4
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 4
	ld b, 1
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15 + cols 3
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15 + cols 3
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wLDiagDirty], a
	ret

PaintSegmentM::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 5
	ld b, 10
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 5
	ld b, 10
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15 + cols 4
	ld b, 12
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15 + cols 4
	ld b, 12
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wMDirty], a
	ret

PaintSegmentMGround::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 6
	ld b, 8
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 6
	ld b, 8
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 5
	ld b, 10
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 5
	ld b, 10
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15 + cols 4
	ld b, 12
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15 + cols 4
	ld b, 12
	call PaintTilemapAttrsSmall

.randomGrassRow13
	; randomly generate a tile locations that will be grass
	ld d, 8
	call Rand ; between 0 and 255
	and `00000111 ; mask to be between 0 and 7 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowTilemap + rows 13 + cols 6
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call PaintTilemapSmall

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowTilemapAttrs + rows 13 + cols 6
	call AddAToHl
	ld b, 1
	call PaintTilemapAttrsSmall
.randomGrassRow14
	; randomly generate a tile locations that will be grass
	ld d, 10
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowTilemap + rows 14 + cols 5
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call PaintTilemapSmall

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowTilemapAttrs + rows 14 + cols 5
	call AddAToHl
	ld b, 1
	call PaintTilemapAttrsSmall
.randomGrassRow15
	; randomly generate a tile locations that will be grass
	ld d, 12
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowTilemap + rows 15 + cols 4
	call AddAToHl
	ld d, TILE_GRASS_FAR
	ld b, 1
	call PaintTilemapSmall

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowTilemapAttrs + rows 15 + cols 4
	call AddAToHl
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wMDirty], a
	ret

PaintSegmentN::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 15
	ld b, 2
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 15
	ld b, 2
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 16
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 16
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wNDirty], a
	ret

PaintSegmentNDiag::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 14
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 14
	ld b, 1
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 15
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 15
	ld b, 1
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15 + cols 16
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15 + cols 16
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wNDiagDirty], a
	ret

PaintSegmentO::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 13 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row14
	ld hl, wShadowTilemap + rows 14 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 14 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.row15
	ld hl, wShadowTilemap + rows 15 + cols 17
	ld b, 3
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 15 + cols 17
	ld b, 3
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wODirty], a
	ret

PaintSegmentP::
.row16
	ld hl, wShadowTilemap + rows 16
	ld b, 2
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 16
	ld b, 2
	call PaintTilemapAttrsSmall
.row17
	ld hl, wShadowTilemap + rows 17
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 17
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wPDirty], a
	ret

PaintSegmentPDiag:
.row16
	ld hl, wShadowTilemap + rows 16 + cols 2
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 16 + cols 2
	ld b, 1
	call PaintTilemapAttrsSmall
.row17
	ld hl, wShadowTilemap + rows 17 + cols 1
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 17 + cols 1
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wPDiagDirty], a
	ret

PaintSegmentQ::
.row16
	ld hl, wShadowTilemap + rows 16 + cols 3
	ld b, 14
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 16 + cols 3
	ld b, 14
	call PaintTilemapAttrsSmall
.row17
	ld hl, wShadowTilemap + rows 17 + cols 2
	ld b, 16
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 17 + cols 2
	ld b, 16
	call PaintTilemapAttrsSmall
.randomGrassRow16
	; randomly generate a tile locations that will be grass
	ld d, 14
	call Rand ; between 0 and 255
	and `00001111 ; mask to be between 0 and 15 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a, between

	push af ; stash random column #
	ld hl, wShadowTilemap + rows 16 + cols 3
	call AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call PaintTilemapSmall

	; randomize x flip
	call Rand
	and `00100000 ; byte 5 of bg attributes is x flip. mask out other bits
	or e
	ld e, a

	pop af
	ld hl, wShadowTilemapAttrs + rows 16 + cols 3
	call AddAToHl
	ld b, 1
	call PaintTilemapAttrsSmall
.randomGrassRow17
	; randomly generate a tile locations that will be grass
	ld d, 16
	call Rand ; between 0 and 255
	and `00011111 ; mask to be between 0 and 31 to remove some subtractions from the mod operation
	call SingleByteModulo ; result in a

	push af ; stash random column #
	ld hl, wShadowTilemap + rows 17 + cols 2
	call AddAToHl
	ld d, TILE_GRASS_NEAR
	ld b, 1
	call PaintTilemapSmall

	; randomize x flip
	call Rand
	and `00100000
	or e
	ld e, a

	pop af ; restore random column #
	ld hl, wShadowTilemapAttrs + rows 17 + cols 2
	call AddAToHl
	ld b, 1
	call PaintTilemapAttrsSmall

.clean
	ld a, FALSE
	ld [wQDirty], a
	ret

PaintSegmentR::
.column18
	ld hl, wShadowTilemap + rows 16 + cols 18
	ld b, 2
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 16 + cols 18
	ld b, 2
	call PaintTilemapAttrsSmall
.column19
	ld hl, wShadowTilemap + rows 17 + cols 19
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 17 + cols 19
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wRDirty], a
	ret

PaintSegmentRDiag::
.row16
	ld hl, wShadowTilemap + rows 16 + cols 17
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 16 + cols 17
	ld b, 1
	call PaintTilemapAttrsSmall
.row17
	ld hl, wShadowTilemap + rows 17 + cols 18
	ld b, 1
	call PaintTilemapSmall
	ld hl, wShadowTilemapAttrs + rows 17 + cols 18
	ld b, 1
	call PaintTilemapAttrsSmall
.clean
	ld a, FALSE
	ld [wRDiagDirty], a
	ret

; @param d: source tile id
; @param hl: destination
; @param bc: length
PaintTilemap::
	ld a, d
	ld [hli], a ; write tile id
	dec bc
	ld a, b
	or c
	jp nz, PaintTilemap
	ret

; @param d: source tile id
; @param hl: destination
; @param b: length
PaintTilemapSmall::
	ld a, d
.loop
	ld [hli], a ; write tile id
	dec b
	jp nz, .loop
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

; @param d: source tile id
; @param hl: destination
; @param bc: length
PaintTilemapIncrementingTileId::
	ld a, d
	ld [hli], a ; write tile id
	inc a
	ld d, a
	dec bc
	ld a, b
	or c
	jp nz, PaintTilemapIncrementingTileId
	ret


; todo rename to CopySingleByteToRange
; @param e: BG Map Attribute byte
; @param hl: destination
; @param bc: length
PaintTilemapAttrs::
	ld a, e
	ld [hli], a ; write palette id
	dec bc
	ld a, b
	or c
	jp nz, PaintTilemapAttrs
	ret

; @param e: BG Map Attribute byte
; @param hl: destination
; @param b: length
PaintTilemapAttrsSmall::
	ld a, e
.loop
	ld [hli], a ; write palette id
	dec b
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
