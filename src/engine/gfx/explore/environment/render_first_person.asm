INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"


SECTION "First Person View Room Cache", WRAM0
; this is a cache of 1 byte RoomWallAttributes objects representing the rooms currently within the player's view
; this is useful when rendering
wRoomAttributesFarLeft:: db
wRoomAttributesFarCenter:: db
wRoomAttributesFarRight:: db
wRoomAttributesNearLeft:: db
wRoomAttributesNearCenter:: db
wRoomAttributesNearRight:: db

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
RenderFirstPersonView::
	; todo this shouldn't be called here, it should be called whenever the player's location is invalidated
	call UpdateRoomWallCache
ProcessRoomCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	ld hl, wRoomAttributesNearCenter
	call GetLeftWallTypeFromRoomAttrAddr
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
	ld hl, wRoomAttributesNearCenter
	call GetTopWallTypeFromRoomAttrAddr
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
	ld hl, wRoomAttributesNearCenter
	call GetRightWallTypeFromRoomAttrAddr
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
	ld hl, wRoomAttributesNearLeft
	call GetTopWallTypeFromRoomAttrAddr
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
	ld hl, wRoomAttributesNearRight
	call GetTopWallTypeFromRoomAttrAddr
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
	ld hl, wRoomAttributesFarCenter
	call GetLeftWallTypeFromRoomAttrAddr
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
.paintLeftGround ;todo ground?
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentL
	call CheckSegmentLDiag
.checkTopWall
	ld hl, wRoomAttributesFarCenter
	call GetTopWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld d, TILE_EXPLORE_WALL_SIDE
	ld e, BG_PALETTE_Z3
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG
	ld d, TILE_EXPLORE_DARK
	call CheckSegmentC
	; C will draw left border if B isn't fog, so if far-left has a right or back wall
	; C will draw right border if D isn't fog, so if far-right has a left or back wall
	; C will draw bottom border if M is ground, so if near-center has no top wall
	;call CheckSegmentCFog ; this looks cool but isnt wide enough
.checkRightWall
	ld hl, wRoomAttributesFarCenter
	call GetRightWallTypeFromRoomAttrAddr
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
	call CheckSegmentN ;todo ground?
	call CheckSegmentNDiag
.paintCenterGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentMGround

ProcessRoomLeftFar:
.checkTopWall
	ld hl, wRoomAttributesFarLeft
	call GetTopWallTypeFromRoomAttrAddr
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
	ld e, BG_PALETTE_FOG
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
	ld hl, wRoomAttributesFarRight
	call GetTopWallTypeFromRoomAttrAddr
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
	ld e, BG_PALETTE_FOG
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

; todo rotate room walls here so we dont have to do it later
UpdateRoomWallCache:
.getRooms
	; far left
	call GetRoomCoordsLeftFarWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesFarLeft], a

	; far center
	call GetRoomCoordsCenterFarWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesFarCenter], a

	; far right
	call GetRoomCoordsRightFarWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesFarRight], a

	; near left
	call GetRoomCoordsLeftNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesNearLeft], a

	; near center
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesNearCenter], a

	; near right
	call GetRoomCoordsRightNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords
	ld a, [hl]
	ld [wRoomAttributesNearRight], a
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
	ld hl, wRoomAttributesFarLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomAttributesFarCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomAttributesFarRight
rept 2
	rrc [hl]
endr
	ld hl, wRoomAttributesNearLeft
rept 2
	rrc [hl]
endr
	ld hl, wRoomAttributesNearCenter
rept 2
	rrc [hl]
endr
	ld hl, wRoomAttributesNearRight
rept 2
	rrc [hl]
endr
	ret

RotateRoomCacheRightFourTimes:
	ld hl, wRoomAttributesFarLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomAttributesFarCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomAttributesFarRight
rept 4
	rrc [hl]
endr
	ld hl, wRoomAttributesNearLeft
rept 4
	rrc [hl]
endr
	ld hl, wRoomAttributesNearCenter
rept 4
	rrc [hl]
endr
	ld hl, wRoomAttributesNearRight
rept 4
	rrc [hl]
endr
	ret

RotateRoomCacheLeftTwice:
	ld hl, wRoomAttributesFarLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomAttributesFarCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomAttributesFarRight
rept 2
	rlc [hl]
endr
	ld hl, wRoomAttributesNearLeft
rept 2
	rlc [hl]
endr
	ld hl, wRoomAttributesNearCenter
rept 2
	rlc [hl]
endr
	ld hl, wRoomAttributesNearRight
rept 2
	rlc [hl]
endr
	ret
