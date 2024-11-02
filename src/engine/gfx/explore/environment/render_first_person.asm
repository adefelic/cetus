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

SECTION "First Person Environment Renderer", ROM0

; first person perspective can display up to 6 rooms in this order:
;
; [5][4][6]
; [2][1][3]
;


;zzz this is where control blasts off

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
	call z, PaintWallLeftSideNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftSideNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftSideNearTypeC
.checkTopWall
	ld hl, wRoomNearCenter
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
	cp a, WALL_TYPE_A
	call z, PaintWallCenterFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallCenterFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallCenterFrontNearTypeC
.checkRightWall
	ld hl, wRoomNearCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundCenterNear
	cp a, WALL_TYPE_A
	call z, PaintWallRightSideNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightSideNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightSideNearTypeC
.paintGroundCenterNear
	ld e, BG_PALETTE_GROUND_NEAR
	ld d, TILE_EXPLORE_GROUND
	call PaintSegmentQGround

ProcessRoomLeftNear:
.checkTopWall
	ld hl, wRoomNearLeft
	call GetTopWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundLeftNear
	cp a, WALL_TYPE_A
	call z, PaintWallLeftFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftFrontNearTypeC
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
	cp a, WALL_TYPE_A
	call z, PaintWallRightFrontNearTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightFrontNearTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightFrontNearTypeC
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
	jp z, .paintGroundLeftFar
	cp a, WALL_TYPE_A
	call z, PaintWallLeftSideFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftSideFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftSideFarTypeC
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
	cp a, WALL_TYPE_A
	call z, PaintWallCenterFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallCenterFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallCenterFrontFarTypeC
	jp .checkRightWall
.paintDistanceFog
	ld e, BG_PALETTE_FOG
	call PaintSegmentCDistanceFog

.checkRightWall
	ld hl, wRoomFarCenter
	call GetRightWallTypeFromRoomAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintGroundRightFar
	cp a, WALL_TYPE_A
	call z, PaintWallRightSideFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightSideFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightSideFarTypeC
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
	cp a, WALL_TYPE_A
	call z, PaintWallLeftFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallLeftFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallLeftFrontFarTypeC
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
	cp a, WALL_TYPE_A
	call z, PaintWallRightFrontFarTypeA
	cp a, WALL_TYPE_B
	call z, PaintWallRightFrontFarTypeB
	cp a, WALL_TYPE_C
	call z, PaintWallRightFrontFarTypeC
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
