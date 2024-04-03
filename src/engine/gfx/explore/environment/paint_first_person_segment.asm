INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/ram/wram.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

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
	cp a, DIRTY
	ret nz
	call PaintSegmentA
	ret

CheckSegmentB::
	ld a, [wBDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentB
	ret

CheckSegmentC::
	ld a, [wCDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentC
	ret

CheckSegmentCFog::
	ld a, [wCDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentCFog
	ret

CheckSegmentD::
	ld a, [wDDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentD
	ret

CheckSegmentE::
	ld a, [wEDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentE
	ret

CheckSegmentK::
	ld a, [wKDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentK
	ret

CheckSegmentL::
	ld a, [wLDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentL
	ret

CheckSegmentLDiag::
	ld a, [wLDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentLDiag
	ret

CheckSegmentM::
	ld a, [wMDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentM
	ret

CheckSegmentN::
	ld a, [wNDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentN
	ret

CheckSegmentNDiag::
	ld a, [wNDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentNDiag
	ret

CheckSegmentO::
	ld a, [wODirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentO
	ret

CheckSegmentP::
	ld a, [wPDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentP
	ret

CheckSegmentPDiag::
	ld a, [wPDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentPDiag
	ret

CheckSegmentQ::
	ld a, [wQDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentQ
	ret

CheckSegmentR::
	ld a, [wRDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentR
	ret

CheckSegmentRDiag::
	ld a, [wRDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentRDiag
	ret

; todo make macro for painting both tilemap + attrs
; @param d: the tile index to paint with
PaintSegmentA::
.row0
	ld hl, wShadowTilemap + rows 0 ; dest in VRAM
	ld bc, 3      ; # of bytes (tile indices) remaining.
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0
	ld bc, 3
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1
	ld bc, 3
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2
	ld bc, 3
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3
	ld bc, 3
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4
	ld bc, 3
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5
	ld bc, 3
	call PaintTilemapAttrs
.row6
	ld hl, wShadowTilemap + rows 6
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6
	ld bc, 3
	call PaintTilemapAttrs
.row7
	ld hl, wShadowTilemap + rows 7
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 7
	ld bc, 3
	call PaintTilemapAttrs
.row8
	ld hl, wShadowTilemap + rows 8
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 8
	ld bc, 3
	call PaintTilemapAttrs
.row9
	ld hl, wShadowTilemap + rows 9
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 9
	ld bc, 3
	call PaintTilemapAttrs
.row10
	ld hl, wShadowTilemap + rows 10
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 10
	ld bc, 3
	call PaintTilemapAttrs
.row11
	ld hl, wShadowTilemap + rows 11
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 11
	ld bc, 3
	call PaintTilemapAttrs
.row12
	ld hl, wShadowTilemap + rows 12
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 12
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wADirty], a
	ret

PaintSegmentB::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row6
	ld hl, wShadowTilemap + rows 6 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row7
	ld hl, wShadowTilemap + rows 7 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 7 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row8
	ld hl, wShadowTilemap + rows 8 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 8 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row9
	ld hl, wShadowTilemap + rows 9 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 9 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row10
	ld hl, wShadowTilemap + rows 10 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 10 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row11
	ld hl, wShadowTilemap + rows 11 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 11 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.row12
	ld hl, wShadowTilemap + rows 12 + cols 3
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 12 + cols 3
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wBDirty], a
	ret

PaintSegmentC::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row6
	ld hl, wShadowTilemap + rows 6 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row7
	ld hl, wShadowTilemap + rows 7 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 7 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row8
	ld hl, wShadowTilemap + rows 8 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 8 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row9
	ld hl, wShadowTilemap + rows 9 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 9 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row10
	ld hl, wShadowTilemap + rows 10 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 10 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row11
	ld hl, wShadowTilemap + rows 11 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 11 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row12
	ld hl, wShadowTilemap + rows 12 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 12 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wCDirty], a
	ret

; this is rough lol
PaintSegmentCFog::
	ld d, TILE_FOG_BLANK
.row0
	ld hl, wShadowTilemap + rows 0 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5 + cols 6
	ld bc, 8
	call PaintTilemapAttrs

	; things get complicated
	; sigh, this makes a case for a 20*18 tilemap buffer. there could a tilecpy function that pastes tile ids to the buffer
	; wait they're just incing by 1 there can just be a loop

.row6_col0
	ld d, TILE_FOG_R6_C0
	ld hl, wShadowTilemap + rows 6 + cols 6
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 6
	ld bc, 1
	call PaintTilemapAttrs
.row6_middle
	ld d, TILE_FOG_BLANK
	ld hl, wShadowTilemap + rows 6 + cols 7
	ld bc, 6
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 7
	ld bc, 6
	call PaintTilemapAttrs
.row6_col7
	ld hl, wShadowTilemap + rows 6 + cols 13
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 13
	ld bc, 1
	call PaintTilemapAttrs

.row7
	ld d, TILE_FOG_R7_C0
	ld hl, wShadowTilemap + rows 7 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 7 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row8
	ld d, TILE_FOG_R8_C0
	ld hl, wShadowTilemap + rows 8 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 8 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row9
	ld d, TILE_FOG_R9_C0
	ld hl, wShadowTilemap + rows 9 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 9 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row10
	ld d, TILE_FOG_R10_C0
	ld hl, wShadowTilemap + rows 10 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 10 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row11
	ld d, TILE_FOG_R11_C0
	ld hl, wShadowTilemap + rows 11 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 11 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row12
	ld d, TILE_FOG_R12_C0
	ld hl, wShadowTilemap + rows 12 + cols 6
	ld bc, 8
	call PaintTilemapIncrementingTileId
	ld hl, wShadowTilemapAttrs + rows 12 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wCDirty], a
	ret

PaintSegmentD::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row6
	ld hl, wShadowTilemap + rows 6 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row7
	ld hl, wShadowTilemap + rows 7 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 7 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row8
	ld hl, wShadowTilemap + rows 8 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 8 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row9
	ld hl, wShadowTilemap + rows 9 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 9 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row10
	ld hl, wShadowTilemap + rows 10 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 10 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row11
	ld hl, wShadowTilemap + rows 11 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 11 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.row12
	ld hl, wShadowTilemap + rows 12 + cols 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 12 + cols 14
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wDDirty], a
	ret

PaintSegmentE::
.row0
	ld hl, wShadowTilemap + rows 0 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 0 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row1
	ld hl, wShadowTilemap + rows 1 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 1 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row2
	ld hl, wShadowTilemap + rows 2 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 2 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row3
	ld hl, wShadowTilemap + rows 3 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 3 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row4
	ld hl, wShadowTilemap + rows 4 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 4 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row5
	ld hl, wShadowTilemap + rows 5 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 5 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row6
	ld hl, wShadowTilemap + rows 6 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 6 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row7
	ld hl, wShadowTilemap + rows 7 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 7 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row8
	ld hl, wShadowTilemap + rows 8 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 8 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row9
	ld hl, wShadowTilemap + rows 9 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 9 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row10
	ld hl, wShadowTilemap + rows 10 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 10 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row11
	ld hl, wShadowTilemap + rows 11 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 11 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row12
	ld hl, wShadowTilemap + rows 12 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 12 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wEDirty], a
	ret

PaintSegmentK::
.row13
	ld hl, wShadowTilemap + rows 13
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13
	ld bc, 3
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14
	ld bc, 3
	call PaintTilemapAttrs
.row15
	ld hl, wShadowTilemap + rows 15
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 15
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wKDirty], a
	ret

PaintSegmentL::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 3
	ld bc, 2
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 3
	ld bc, 2
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 3
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 3
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wLDirty], a
	ret

PaintSegmentLDiag::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 5
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 5
	ld bc, 1
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 4
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 4
	ld bc, 1
	call PaintTilemapAttrs
.row15
	ld hl, wShadowTilemap + rows 15 + cols 3
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 15 + cols 3
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wLDiagDirty], a
	ret

PaintSegmentM::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 6
	ld bc, 8
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 6
	ld bc, 8
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 5
	ld bc, 10
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 5
	ld bc, 10
	call PaintTilemapAttrs
.row15
	ld hl, wShadowTilemap + rows 15 + cols 4
	ld bc, 12
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 15 + cols 4
	ld bc, 12
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wMDirty], a
	ret

PaintSegmentN::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 15
	ld bc, 2
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 15
	ld bc, 2
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 16
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 16
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wNDirty], a
	ret

PaintSegmentNDiag::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 14
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 14
	ld bc, 1
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 15
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 15
	ld bc, 1
	call PaintTilemapAttrs
.row15
	ld hl, wShadowTilemap + rows 15 + cols 16
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 15 + cols 16
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wNDiagDirty], a
	ret

PaintSegmentO::
.row13
	ld hl, wShadowTilemap + rows 13 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 13 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row14
	ld hl, wShadowTilemap + rows 14 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 14 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.row15
	ld hl, wShadowTilemap + rows 15 + cols 17
	ld bc, 3
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 15 + cols 17
	ld bc, 3
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wODirty], a
	ret

PaintSegmentP::
.row16
	ld hl, wShadowTilemap + rows 16
	ld bc, 2
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 16
	ld bc, 2
	call PaintTilemapAttrs
.row17
	ld hl, wShadowTilemap + rows 17
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 17
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wPDirty], a
	ret

PaintSegmentPDiag:
.row16
	ld hl, wShadowTilemap + rows 16 + cols 2
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 16 + cols 2
	ld bc, 1
	call PaintTilemapAttrs
.row17
	ld hl, wShadowTilemap + rows 17 + cols 1
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 17 + cols 1
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wPDiagDirty], a
	ret

PaintSegmentQ::
.row16
	ld hl, wShadowTilemap + rows 16 + cols 3
	ld bc, 14
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 16 + cols 3
	ld bc, 14
	call PaintTilemapAttrs
.row17
	ld hl, wShadowTilemap + rows 17 + cols 2
	ld bc, 16
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 17 + cols 2
	ld bc, 16
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wQDirty], a
	ret

PaintSegmentR::
.column18
	ld hl, wShadowTilemap + rows 16 + cols 18
	ld bc, 2
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 16 + cols 18
	ld bc, 2
	call PaintTilemapAttrs
.column19
	ld hl, wShadowTilemap + rows 17 + cols 19
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 17 + cols 19
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
	ld [wRDirty], a
	ret

PaintSegmentRDiag::
.row16
	ld hl, wShadowTilemap + rows 16 + cols 17
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 16 + cols 17
	ld bc, 1
	call PaintTilemapAttrs
.row17
	ld hl, wShadowTilemap + rows 17 + cols 18
	ld bc, 1
	call PaintTilemap
	ld hl, wShadowTilemapAttrs + rows 17 + cols 18
	ld bc, 1
	call PaintTilemapAttrs
.clean
	ld a, CLEAN
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

; todo there is probably a more efficient way to do this
DirtyFpSegments::
	ld a, DIRTY
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
