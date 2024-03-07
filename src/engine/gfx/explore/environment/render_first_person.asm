INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "First Person Environment Renderer", ROMX

; first person perspective can render up to 6 tiles:
;
; [1][2][3]
; [4][5][6]
;
; player is in tile 5 facing tile 2.

RenderFirstPersonView::
	; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
	; todo bounds check and skip rooms that are oob
	; currently this does no bounds checking for rooms with negative coords.
	;   the whole map starts at 1,1 rather than 0,0 to make it unnecessary
ProcessRoomCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; todo, put coords in ram?
	call GetActiveMapRoomAddrFromCoords ; puts player tilemap entry addr in hl. should probably put this somewhere?
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
.paintLeftWall
	; okay instead we can say ... load that wall's panel index
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, TILE_EXPLORE_DIAG_L
	call CheckSegmentPDiag
.checkTopWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
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
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintRightWall
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
	call CheckSegmentR
	ld d, TILE_EXPLORE_DIAG_R
	call CheckSegmentRDiag
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call CheckSegmentQ

ProcessRoomLeftNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsLeftNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentP
	call CheckSegmentPDiag

ProcessRoomRightNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsRightNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentR
	call CheckSegmentRDiag

ProcessRoomCenterFar:
.checkLeftWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintLeftGround ; paint ground if no left wall
.paintLeftWall
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentL
	ld d, TILE_EXPLORE_DIAG_L
	call CheckSegmentLDiag
	jp .checkTopWall
.paintLeftGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentL
	call CheckSegmentLDiag
.checkTopWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld d, TILE_EXPLORE_WALL_SIDE
	ld e, BG_PALETTE_Z3
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG2
	ld d, TILE_EXPLORE_DARK
	call CheckSegmentC
	;call CheckSegmentCFog ; this looks cool but isnt wide enough
.checkRightWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintRightGround ; paint ground if no right wall
.paintRightWall
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentN
	ld d, TILE_EXPLORE_DIAG_R
	call CheckSegmentNDiag
	jp .paintCenterGround
.paintRightGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentN
	call CheckSegmentNDiag
.paintCenterGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentM

ProcessRoomLeftFar:
.checkTopWall
	call GetRoomCoordsLeftFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG2
	ld d, TILE_EXPLORE_DARK
	; add fog
	call CheckSegmentA
	call CheckSegmentB
	;call CheckSegmentAFog
	;call CheckSegmentBFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag

ProcessRoomRightFar:
.checkTopWall
	call GetRoomCoordsRightFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG2
	ld d, TILE_EXPLORE_DARK
	; add fog
	call CheckSegmentD
	call CheckSegmentE
	;call CheckSegmentDFog
	;call CheckSegmentEFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	ret
