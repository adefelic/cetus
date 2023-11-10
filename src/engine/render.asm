INCLUDE "src/utils/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/fp_render_constants.inc"

Section "Segment Render State", WRAM0
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

SECTION "Renderer", ROMX

; first person perspective can render up to 6 tiles:
;
; [1][2][3]
; [4][5][6]
;
; player is in tile 5 facing tile 2.
;
; ceilings will not be rendered

; for attempt #1 this will write directly to vram
LoadFPTilemapByMapTile::
	; todo bounds check and skip rooms that are oob
	call DisableLcd
ProcessTileCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; put coords in ram?
	call GetBGMapAddressByCoords ; puts player tilemap entry addr in hl. should probably put this in ram?
	call RoomHasLeftWallWRTPlayer
	cp a, TRUE
	jp nz, .checkTopWall
	ld d, INDEX_FP_TILE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, INDEX_FP_TILE_DIAG_L
	call CheckSegmentPDiag
.checkTopWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .checkRightWall
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentB
	call CheckSegmentC
	call CheckSegmentD
	call CheckSegmentL
	call CheckSegmentLDiag
	call CheckSegmentM
	call CheckSegmentN
	call CheckSegmentNDiag
.checkRightWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasRightWallWRTPlayer
	cp a, TRUE
	jp nz, .paintGround
	ld d, INDEX_FP_TILE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
	call CheckSegmentR
	ld d, INDEX_FP_TILE_DIAG_R
	call CheckSegmentRDiag
.paintGround
	ld d, INDEX_FP_TILE_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call CheckSegmentQ
ProcessTileLeftNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsLeftNearWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .paintGround
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentA
	call CheckSegmentK
.paintGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentP
	call CheckSegmentPDiag
ProcessTileRightNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsRightNearWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .paintGround
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentE
	call CheckSegmentO
.paintGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentR
	call CheckSegmentRDiag
ProcessTileCenterFar:
.checkLeftWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasLeftWallWRTPlayer
	cp a, TRUE
	jp nz, .paintLeftGround
	ld d, INDEX_FP_TILE_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentL
	ld d, INDEX_FP_TILE_DIAG_L
	call CheckSegmentLDiag
	jp .checkTopWall
.paintLeftGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentL
	call CheckSegmentLDiag
.checkTopWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .fillDistance
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentC
	jp .checkRightWall
.fillDistance
	ld d, INDEX_FP_TILE_DARK
	call CheckSegmentC
.checkRightWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasRightWallWRTPlayer
	cp a, TRUE
	jp nz, .paintRightGround
	ld d, INDEX_FP_TILE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentN
	ld d, INDEX_FP_TILE_DIAG_R
	call CheckSegmentNDiag
	jp .paintCenterGround
.paintRightGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentN
	call CheckSegmentNDiag
.paintCenterGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentM
ProcessTileLeftFar:
	call GetRoomCoordsLeftFarWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .fillDistance
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.fillDistance
	ld d, INDEX_FP_TILE_DARK
	call CheckSegmentA
	call CheckSegmentB
.paintGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag
ProcessTileRightFar:
	call GetRoomCoordsRightFarWRTPlayer
	call GetBGMapAddressByCoords
	call RoomHasTopWallWRTPlayer
	cp a, TRUE
	jp nz, .fillDistance
	ld d, INDEX_FP_TILE_WALL_FRONT
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.fillDistance
	ld d, INDEX_FP_TILE_DARK
	call CheckSegmentD
	call CheckSegmentE
.paintGround
	ld d, INDEX_FP_TILE_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	call EnableLcd
	ret

; MapTilemap + wPlayerX + wPlayerY*32
; @param d: player X coord
; @param e: player Y coord
; @return hl: tile address of player occupied tile of MapTilemap (this need to change)
GetBGMapAddressByCoords:
	ld l, e
	ld h, 0
	; shift left 5 times to multiply by 32
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, d
	add a, l
	ld l, a
	ld bc, MapTilemap
	add hl, bc
	ret

CheckSegmentA:
	ld a, [wADirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentA
	ret

CheckSegmentB:
	ld a, [wBDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentB
	ret

CheckSegmentC:
	ld a, [wCDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentC
	ret

CheckSegmentD:
	ld a, [wDDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentD
	ret

CheckSegmentE:
	ld a, [wEDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentE
	ret

CheckSegmentK:
	ld a, [wKDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentK
	ret

CheckSegmentL:
	ld a, [wLDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentL
	ret

CheckSegmentLDiag:
	ld a, [wLDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentLDiag
	ret

CheckSegmentM:
	ld a, [wMDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentM
	ret

CheckSegmentN:
	ld a, [wNDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentN
	ret

CheckSegmentNDiag:
	ld a, [wNDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentNDiag
	ret

CheckSegmentO:
	ld a, [wODirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentO
	ret

CheckSegmentP:
	ld a, [wPDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentP
	ret

CheckSegmentPDiag:
	ld a, [wPDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentPDiag
	ret

CheckSegmentQ:
	ld a, [wQDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentQ
	ret

CheckSegmentR:
	ld a, [wRDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentR
	ret

CheckSegmentRDiag:
	ld a, [wRDiagDirty]
	cp a, DIRTY
	ret nz
	call PaintSegmentRDiag
	ret

; @param d: the tile index to paint with
PaintSegmentA:
	ld hl, _SCRN0 + BG_ROW_0 ; dest in VRAM
	ld bc, 3      ; # of bytes (tile indices) remaining.
	call Paint
	ld hl, _SCRN0 + BG_ROW_1
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_2
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_4
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_5
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_6
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_7
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_8
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_9
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_10
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_11
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_12
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wADirty], a
	ret

PaintSegmentB:
	ld hl, _SCRN0 + BG_ROW_0 + BG_COL_3; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_1 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_2 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_3 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_4 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_5 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_6 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_7 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_8 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_9 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_10 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_11 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_12 + BG_COL_3
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wBDirty], a
	ret

PaintSegmentC:
	ld hl, _SCRN0 + BG_ROW_0 + BG_COL_6; dest in VRAM
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_1 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_2 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_3 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_4 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_5 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_6 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_7 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_8 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_9 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_10 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_11 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_12 + BG_COL_6
	ld bc, 8
	call Paint
	ld a, CLEAN
	ld [wCDirty], a
	ret

PaintSegmentD:
	ld hl, _SCRN0 + BG_ROW_0 + BG_COL_14; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_1 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_2 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_3 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_4 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_5 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_6 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_7 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_8 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_9 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_10 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_11 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_12 + BG_COL_14
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wDDirty], a
	ret

PaintSegmentE:
	ld hl, _SCRN0 + BG_ROW_0 + BG_COL_17; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_1 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_2 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_3 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_4 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_5 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_6 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_7 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_8 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_9 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_10 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_11 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_12 + BG_COL_17
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wEDirty], a
	ret

; @param d: the tile index to paint with
PaintSegmentK:
	ld hl, _SCRN0 + BG_ROW_13
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_14
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_15
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wKDirty], a
	ret

PaintSegmentL:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_3
	ld bc, 2
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_3
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wLDirty], a
	ret

PaintSegmentLDiag:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_5
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_4
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_15 + BG_COL_3
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wLDiagDirty], a
	ret

PaintSegmentM:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_5
	ld bc, 10
	call Paint
	ld hl, _SCRN0 + BG_ROW_15 + BG_COL_4
	ld bc, 12
	call Paint
	ld a, CLEAN
	ld [wMDirty], a
	ret

PaintSegmentN:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_15
	ld bc, 2
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_16
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wNDirty], a
	ret

PaintSegmentNDiag:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_14
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_15
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_15 + BG_COL_16
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wNDiagDirty], a
	ret

PaintSegmentO:
	ld hl, _SCRN0 + BG_ROW_13 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_14 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, _SCRN0 + BG_ROW_15 + BG_COL_17
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wODirty], a
	ret

PaintSegmentP:
	ld hl, _SCRN0 + BG_ROW_16
	ld bc, 2
	call Paint
	ld hl, _SCRN0 + BG_ROW_17
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wPDirty], a
	ret

PaintSegmentPDiag:
	ld hl, _SCRN0 + BG_ROW_16 + BG_COL_2
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_17 + BG_COL_1
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wPDiagDirty], a
	ret

PaintSegmentQ:
	ld hl, _SCRN0 + BG_ROW_16 + BG_COL_3
	ld bc, 14
	call Paint
	ld hl, _SCRN0 + BG_ROW_17 + BG_COL_2
	ld bc, 16
	call Paint
	ld a, CLEAN
	ld [wQDirty], a
	ret

PaintSegmentR:
	ld hl, _SCRN0 + BG_ROW_16 + BG_COL_18
	ld bc, 2
	call Paint
	ld hl, _SCRN0 + BG_ROW_17 + BG_COL_19
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wRDirty], a
	ret

PaintSegmentRDiag:
	ld hl, _SCRN0 + BG_ROW_16 + BG_COL_17
	ld bc, 1
	call Paint
	ld hl, _SCRN0 + BG_ROW_17 + BG_COL_18
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wRDiagDirty], a
	ret

; copy bytes from one area to another
; @param de: source
; @param hl: destination
; @param bc: length
Paint:
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, Paint
	ret

DirtyFPScreen::
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
