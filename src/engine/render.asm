INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/map_constants.inc"

SECTION "FP Renderer Entry Point", ROMX

; first person perspective can render up to 6 tiles:
;
; [1][2][3]
; [4][5][6]
;
; player is in tile 5 facing tile 2.
;
; ceilings will not be rendered

; for attempt #1 this will write directly to vram
; future thoughts: could compare the 6-room submap that's being rendered for differences to the current submap and use that to set segment clean flags
; walls that matter:
;   - center near left
;       if same, set APK+diag to clean
;   - center near top
;       if same, set BCDL+diagMN+diag to clean
;   - center near right
;       if same, set EOR+diag to clean
;   - left near top
;       if same, set APK+diag to clean
;   - right near top
;   - center far left
;   - center far top
;   - center far right
;   - left far top
;   - right far top
; [T][TRL][T]
; [T][TRL][T]
;Section "Render Details", WRAM0
;wCurrentCenterNearWallAttrs:: db
;wCurrentLeftNearWallAttrs:: db
;wCurrentRightNearWallAttrs:: db
;wCurrentCenterFarWallAttrs:: db
;wCurrentLeftFarWallAttrs:: db
;wCurrentRightFarWallAttrs:: db
;wPreviousCenterNearWallAttrs:: db
;wPreviousLeftNearWallAttrs:: db
;wPreviousRightNearWallAttrs:: db
;wPreviousCenterFarWallAttrs:: db
;wPreviousLeftFarWallAttrs:: db
;wPreviousRightFarWallAttrs:: db

LoadFPTilemapByMapTile::
	; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
	; todo bounds check and skip rooms that are oob
	call DisableLcd
ProcessTileCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; todo, put coords in ram?
	call GetBGTileMapAddrFromMapCoords ; puts player tilemap entry addr in hl. should probably put this somewhere?
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
	call GetBGTileMapAddrFromMapCoords
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
.checkTopWall
	call GetRoomCoordsLeftFarWRTPlayer
	call GetBGTileMapAddrFromMapCoords
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
.checkTopWall
	call GetRoomCoordsRightFarWRTPlayer
	call GetBGTileMapAddrFromMapCoords
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
GetBGTileMapAddrFromMapCoords::
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
