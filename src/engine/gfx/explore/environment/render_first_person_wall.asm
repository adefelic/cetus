INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/constants/palette_constants.inc"

SECTION "First Person Environment Wall Renderer", ROMX


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
