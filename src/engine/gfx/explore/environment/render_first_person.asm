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
	;    so moves or rotations
	call UpdateRoomWallCache

; process rooms closest to farthest w/ dirtying to only draw topmost z segments
ProcessRoomCenterNear:
.checkLeftWall:
	ld hl, wRoomNearCenter
	call GetLeftWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
	cp a, WALL_TYPE_A
	jp z, .paintWallLeftSideNearTypeA
	cp a, WALL_TYPE_B
	jp z, .paintWallLeftSideNearTypeB
	; control should not reach here

.paintWallLeftSideNearTypeA
	ld e, BG_PALETTE_SIDE_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentK
	call PaintSegmentP
	ld d, TILE_EXPLORE_DIAG_L
	call PaintSegmentPDiag
	jp .checkTopWall
.paintWallLeftSideNearTypeB
	; hmm how will this work, if specials walls are different per-locale
	; get locale -> call CurrentLocaleSpecialWallBSideNear ??? would each locale come with ... a table of 6 custom function pointers per custom wall type? :(
	; maybe the paint functions should all be the same, at least initially?
	;   this will be impossible without very simplified paint functions
	; for the time being, i'll just add the one wall type and all locales can use it
	call PaintWallLeftSideNearTypeB
.checkTopWall
	ld hl, wRoomNearCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
.paintWallCenterFrontNearTypeA
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
.checkRightWall
	ld hl, wRoomNearCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundCenterNear
.paintWallRightSideNearTypeA
	ld e, BG_PALETTE_SIDE_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentE
	call PaintSegmentO
	call PaintSegmentR
	ld d, TILE_EXPLORE_DIAG_R
	call PaintSegmentRDiag
.paintGroundCenterNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call PaintSegmentQGround

ProcessRoomLeftNear:
.checkTopWall
	ld hl, wRoomNearLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundLeftNear
.paintWallLeftFrontNearTypeA
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentK
.paintGroundLeftNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentP
	call PaintSegmentPDiag

ProcessRoomRightNear:
.checkTopWall
	ld hl, wRoomNearRight
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundRightNear
.paintWallRightFrontNearTypeA
	ld e, BG_PALETTE_FRONT_NEAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentE
	call PaintSegmentO
.paintGroundRightNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentR
	call PaintSegmentRDiag

ProcessRoomCenterFar:
.checkLeftWall
	ld hl, wRoomFarCenter
	call GetLeftWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundLeftFar ; paint ground if no left wall
.paintWallLeftSideFarTypeA
	ld e, BG_PALETTE_SIDE_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentB
	call PaintSegmentL
	ld d, TILE_EXPLORE_DIAG_L
	call PaintSegmentLDiag
	jp .checkTopWall
.paintGroundLeftFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentL
	call PaintSegmentLDiag

.checkTopWall
	ld hl, wRoomFarCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
.paintWallCenterFrontFarTypeA
	ld d, TILE_EXPLORE_WALL
	ld e, BG_PALETTE_FRONT_FAR
	call PaintSegmentC
	jp .checkRightWall
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentCDistanceFog

.checkRightWall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundRightFar
.paintWallRightSideFarTypeA
	ld e, BG_PALETTE_SIDE_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentD
	call PaintSegmentN
	ld d, TILE_EXPLORE_DIAG_R
	call PaintSegmentNDiag
	jp .paintGroundCenterFar
.paintGroundRightFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentN
	call PaintSegmentNDiag

.paintGroundCenterFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentMGround

ProcessRoomLeftFar:
.checkTopWall
	ld hl, wRoomFarLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
.paintWallLeftFrontFarTypeA
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentA
	call PaintSegmentB
	jp .paintGroundLeftFar
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentADistanceFog
	call PaintSegmentBDistanceFog
.paintGroundLeftFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentK
	call PaintSegmentL
	call PaintSegmentLDiag

ProcessRoomRightFar:
.checkTopWall
	ld hl, wRoomFarRight
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistanceFog
.paintWallRightFrontFarTypeA
	ld e, BG_PALETTE_FRONT_FAR
	ld d, TILE_EXPLORE_WALL
	call PaintSegmentD
	call PaintSegmentE
	jp .paintGroundRightFar
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentDDistanceFog
	call PaintSegmentEDistanceFog
.paintGroundRightFar
	ld e, BG_PALETTE_GROUND_FAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentO
	call PaintSegmentN
	call PaintSegmentNDiag
.finishProcessingRooms
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
