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
PaintWallRightSideNearTypeB::
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
PaintWallLeftFrontNearTypeB::
PaintWallLeftFrontNearTypeC::
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentK
	ret

PaintWallCenterFrontNearTypeA::
PaintWallCenterFrontNearTypeB::
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
PaintWallRightFrontNearTypeB::
PaintWallRightFrontNearTypeC::
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentE
	call PaintSegmentO
	ret

; side far
PaintWallLeftSideFarTypeA::
PaintWallLeftSideFarTypeB::
PaintWallLeftSideFarTypeC::
	ld e, BG_PALETTE_SIDE_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentB
	call PaintSegmentL
	ld d, TILE_EXPLORE_DIAG_L
	call PaintSegmentLDiag
	ret

PaintWallRightSideFarTypeA::
PaintWallRightSideFarTypeB::
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
PaintWallLeftFrontFarTypeB::
PaintWallLeftFrontFarTypeC::
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentB
	ret

PaintWallCenterFrontFarTypeA::
PaintWallCenterFrontFarTypeB::
PaintWallCenterFrontFarTypeC::
	ld d, TILE_EXPLORE_WALL
	ld e, BG_PALETTE_FRONT_FAR
	call PaintSegmentC
	ret

PaintWallRightFrontFarTypeA::
PaintWallRightFrontFarTypeB::
PaintWallRightFrontFarTypeC::
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentD
	call PaintSegmentE
	ret
