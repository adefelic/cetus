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
	call GetOccupiedTilemapEntry ; puts player tilemap entry addr in hl
	; todo bounds check and skip rooms that are oob
	call DisableLcd
ProcessTileCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call RoomHasLeftWallWRTPlayer
	cp a, TRUE
	jp nz, .checkTopWall
	ld d, INDEX_FP_TILE_45 ; hopefully this doesn't unset
.checkSegmentA
	ld a, [wADirty]
	cp a, DIRTY
	jp nz, .checkSegmentK
	call PaintSegmentA
.checkSegmentK
	ld a, [wKDirty]
	cp a, DIRTY
	jp nz, .checkSegmentP
	call PaintSegmentK
.checkSegmentP
	ld a, [wPDirty]
	cp a, DIRTY
	jp nz, .checkTopWall
	call PaintSegmentP
	ld d, INDEX_FP_TILE_DIAG_L ; hopefully this doesn't unset
	call PaintSegmentPDiag

.setDiagTile
		; if dirty, paint k
		; if dirty, paint p + diags
.checkTopWall
	; if left wall

	; if top wall
		; if dirty, paint b
		; if dirty, paint c
		; if dirty, paint d
		; if dirty, paint l + diags
		; if dirty, paint m
		; if dirty, paint n + diags
	; if right wall
		; if dirty, paint e
		; if dirty, paint o
		; if dirty, paint r + diags
	; if dirty, paint q (floor) (flip from previous for now)
.processTileLeftNear
	; if top wall
		; if dirty, paint a
		; if dirty, paint k
		; if dirty, paint p + diags
	; if dirty, paint p + diags (floor)
.processTileRightNear
	; if top wall
		; if dirty, paint e
		; if dirty, paint o
		; if dirty, paint r + diags
	; if dirty, paint r + diags (floor)
.processTileCenterFar
	; if left wall
		; if dirty, paint b
		; if dirty, paint l + diags
	; if top wall
		; if dirty, paint c
	; else
		; if dirty, fill c
	; if right wall
		; if dirty, paint d
		; if dirty, paint n + diags
	; if dirty, paint m (floor)
.processTileLeftFar
	; if top wall
		; if dirty, paint a
		; if dirty, paint b
	; else
		; if dirty, fill a
		; if dirty, fill b
	; if dirty, paint k (floor)
	; if dirty, paint l + diags (floor)
.processTileRightFar
	; if top wall
		; if dirty, paint d
		; if dirty, paint e
	; else
		; if dirty, fill d
		; if dirty, fill e
	; if dirty, paint o (floor)
	; if dirty, paint n + diags (floor)
.finish
	call EnableLcd
	ret

; MapTilemap + wPlayerX + wPlayerY*32
; @return hl: tile address of player occupied tile of MapTilemap (this need to change)
GetOccupiedTilemapEntry:
	ld a, [wPlayerY]
	ld l, a
	ld h, 0
	; shift left 5 times
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [wPlayerX]
	add a, l
	ld l, a
	ld bc, MapTilemap
	add hl, bc
	ret

; @param d: the tile index to paint with
PaintSegmentA:
	ld hl, _SCRN0 ; dest in VRAM
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
