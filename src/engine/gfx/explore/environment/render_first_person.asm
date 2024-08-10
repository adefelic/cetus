INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "First Person View Room Cache", WRAM0
; this is a cache of 1 byte RoomWallAttributes objects representing the rooms currently within the player's view
; this is useful when rendering
wRoomFarLeft:: db
wRoomFarCenter:: db
wRoomFarRight:: db
wRoomNearLeft:: db
wRoomNearCenter:: db
wRoomNearRight:: db

SECTION "First Person Environment Renderer", ROMX

; first person perspective can display up to 6 rooms in this order:
;
; [5][4][6]
; [2][1][3]
;

	; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
	; todo bounds check and skip rooms that are oob
	; currently this does no bounds checking for rooms with negative coords.
	;   the whole map starts at 1,1 rather than 0,0 to make it unnecessary
RenderExploreEnvironmentWalls::
	; todo this shouldn't be called here, it should be called whenever the player's location is invalidated
	call UpdateRoomWallCache
	; process rooms closest to farthest w/ dirtying to only draw topmost z segments
ProcessRoomCenterNear:
.checkLeftWall:
	ld hl, wRoomNearCenter
	call GetLeftWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
	cp a, WALL_TYPE_A
	jp z, .paintLeftWallTypeA
	cp a, WALL_TYPE_B
	jp z, .paintLeftWallTypeB
	; control should not reach here
.paintLeftWallTypeA
	; okay instead we can say ... load that wall's panel index
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, TILE_EXPLORE_DIAG_L
	call CheckSegmentPDiag
	jp .checkTopWall
.paintLeftWallTypeB
	; todo
	jp .checkTopWall
.checkTopWall
	ld hl, wRoomNearCenter
	call GetTopWallTypeFromRoomAddr
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
	ld hl, wRoomNearCenter
	call GetRightWallTypeFromRoomAddr
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
	call CheckSegmentQGround

ProcessRoomLeftNear:
.checkTopWall
	ld hl, wRoomNearLeft
	call GetTopWallTypeFromRoomAddr
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
.checkTopWall
	ld hl, wRoomNearRight
	call GetTopWallTypeFromRoomAddr
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
	ld hl, wRoomFarCenter
	call GetLeftWallTypeFromRoomAddr
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
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld d, TILE_EXPLORE_WALL_SIDE
	ld e, BG_PALETTE_Z3
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	ld e, BG_PALETTE_FOG
	call CheckSegmentCDistanceFog
.checkRightWall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
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
	call CheckSegmentMGround

ProcessRoomLeftFar:
.checkTopWall
	ld hl, wRoomFarLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.paintDistance
	ld e, BG_PALETTE_FOG
	call CheckSegmentADistanceFog
	call CheckSegmentBDistanceFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag

ProcessRoomRightFar:
.checkTopWall
	ld hl, wRoomFarRight
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.paintDistance
	ld e, BG_PALETTE_FOG
	call CheckSegmentDDistanceFog
	call CheckSegmentEDistanceFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	ret

; todo rotate room walls here so we dont have to do it later
UpdateRoomWallCache:
.getRooms
	; far left
	call GetRoomCoordsLeftFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarLeft], a

	; far center
	call GetRoomCoordsCenterFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarCenter], a

	; far right
	call GetRoomCoordsRightFarWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomFarRight], a

	; near left
	call GetRoomCoordsLeftNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearLeft], a

	; near center
	call GetRoomCoordsCenterNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearCenter], a

	; near right
	call GetRoomCoordsRightNearWRTPlayer
	call GetCurrentMapWallsRoomAddrFromRoomCoords
	ld a, [hl]
	ld [wRoomNearRight], a
.rotateBitsToMatchPlayerOrientation
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_WEST
	jp z, RotateRoomCacheRightTwice
	cp a, ORIENTATION_SOUTH
	jp z, RotateRoomCacheRightFourTimes
	cp a, ORIENTATION_EAST
	jp z, RotateRoomCacheLeftTwice
	ret

RotateRoomCacheRightTwice:
	ld hl, wRoomFarLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomFarCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomFarRight
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomNearRight
rept 2
	rrc [hl]
endr
	ret

RotateRoomCacheRightFourTimes:
	ld hl, wRoomFarLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomFarCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomFarRight
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomNearRight
rept 4
	rrc [hl]
endr
	ret

RotateRoomCacheLeftTwice:
	ld hl, wRoomFarLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomFarCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomFarRight
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomNearRight
rept 2
	rlc [hl]
endr
	ret
