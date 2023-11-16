INCLUDE "src/utils/hardware.inc"
INCLUDE "src/constants/gfx_constants.inc"

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

SECTION "Shadow BG Map", WRAM0
wShadowTilemap::
ds TILEMAP_SIZE
wShadowTilemapEnd::

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

; @param d: the tile index to paint with
PaintSegmentA::
	ld hl, wShadowTilemap + BG_ROW_0 ; dest in VRAM
	ld bc, 3      ; # of bytes (tile indices) remaining.
	call Paint
	ld hl, wShadowTilemap + BG_ROW_1
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_2
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_4
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_5
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_6
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_7
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_8
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_9
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_10
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_11
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_12
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wADirty], a
	ret

PaintSegmentB::
	ld hl, wShadowTilemap + BG_ROW_0 + BG_COL_3; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_4 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_5 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_6 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_7 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_8 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_9 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_10 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_11 + BG_COL_3
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_12 + BG_COL_3
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wBDirty], a
	ret

PaintSegmentC::
	ld hl, wShadowTilemap + BG_ROW_0 + BG_COL_6; dest in VRAM
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_4 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_5 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_6 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_7 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_8 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_9 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_10 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_11 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_12 + BG_COL_6
	ld bc, 8
	call Paint
	ld a, CLEAN
	ld [wCDirty], a
	ret

PaintSegmentD::
	ld hl, wShadowTilemap + BG_ROW_0 + BG_COL_14; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_4 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_5 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_6 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_7 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_8 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_9 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_10 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_11 + BG_COL_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_12 + BG_COL_14
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wDDirty], a
	ret

PaintSegmentE::
	ld hl, wShadowTilemap + BG_ROW_0 + BG_COL_17; dest in VRAM
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_1 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_2 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_3 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_4 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_5 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_6 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_7 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_8 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_9 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_10 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_11 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_12 + BG_COL_17
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wEDirty], a
	ret

PaintSegmentK::
	ld hl, wShadowTilemap + BG_ROW_13
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_15
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wKDirty], a
	ret

PaintSegmentL::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_3
	ld bc, 2
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_3
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wLDirty], a
	ret

PaintSegmentLDiag::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_5
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_4
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_15 + BG_COL_3
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wLDiagDirty], a
	ret

PaintSegmentM::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_6
	ld bc, 8
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_5
	ld bc, 10
	call Paint
	ld hl, wShadowTilemap + BG_ROW_15 + BG_COL_4
	ld bc, 12
	call Paint
	ld a, CLEAN
	ld [wMDirty], a
	ret

PaintSegmentN::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_15
	ld bc, 2
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_16
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wNDirty], a
	ret

PaintSegmentNDiag::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_14
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_15
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_15 + BG_COL_16
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wNDiagDirty], a
	ret

PaintSegmentO::
	ld hl, wShadowTilemap + BG_ROW_13 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_14 + BG_COL_17
	ld bc, 3
	call Paint
	ld hl, wShadowTilemap + BG_ROW_15 + BG_COL_17
	ld bc, 3
	call Paint
	ld a, CLEAN
	ld [wODirty], a
	ret

PaintSegmentP::
	ld hl, wShadowTilemap + BG_ROW_16
	ld bc, 2
	call Paint
	ld hl, wShadowTilemap + BG_ROW_17
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wPDirty], a
	ret

PaintSegmentPDiag::
	ld hl, wShadowTilemap + BG_ROW_16 + BG_COL_2
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_17 + BG_COL_1
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wPDiagDirty], a
	ret

PaintSegmentQ::
	ld hl, wShadowTilemap + BG_ROW_16 + BG_COL_3
	ld bc, 14
	call Paint
	ld hl, wShadowTilemap + BG_ROW_17 + BG_COL_2
	ld bc, 16
	call Paint
	ld a, CLEAN
	ld [wQDirty], a
	ret

PaintSegmentR::
	ld hl, wShadowTilemap + BG_ROW_16 + BG_COL_18
	ld bc, 2
	call Paint
	ld hl, wShadowTilemap + BG_ROW_17 + BG_COL_19
	ld bc, 1
	call Paint
	ld a, CLEAN
	ld [wRDirty], a
	ret

PaintSegmentRDiag::
	ld hl, wShadowTilemap + BG_ROW_16 + BG_COL_17
	ld bc, 1
	call Paint
	ld hl, wShadowTilemap + BG_ROW_17 + BG_COL_18
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
