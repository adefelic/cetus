INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"
INCLUDE "src/ram/hram.inc"
INCLUDE "src/utils/hardware.inc"

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

; todo change map stuff to compass directions. trbl is player relative, nesw is absolute
; trbl are all relative to the player's orientation
LoadFPShadowTilemap::
	; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
	; todo bounds check and skip rooms that are oob
	; currently this does no bounds checking for rooms with negative coords.
	;   the whole map starts at 1,1 rather than 0,0 to make it unnecessary
ProcessTileCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; todo, put coords in ram?
	call GetRoomAddrFromCoords ; puts player tilemap entry addr in hl. should probably put this somewhere?
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
.paintLeftWall
	; okay instead we can say ... load that wall's panel (metatile) index
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, FP_TILE_DIAG_L
	call CheckSegmentPDiag
.checkTopWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_WALL_SIDE
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
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintRightWall
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
	call CheckSegmentR
	ld d, FP_TILE_DIAG_R
	call CheckSegmentRDiag
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call CheckSegmentQ

ProcessTileLeftNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsLeftNearWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_GROUND
	call CheckSegmentP
	call CheckSegmentPDiag

ProcessTileRightNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsRightNearWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_GROUND
	call CheckSegmentR
	call CheckSegmentRDiag

ProcessTileCenterFar:
.checkLeftWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintLeftGround ; paint ground if no left wall
.paintLeftWall
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentL
	ld d, FP_TILE_DIAG_L
	call CheckSegmentLDiag
	jp .checkTopWall
.paintLeftGround
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_GROUND
	call CheckSegmentL
	call CheckSegmentLDiag
.checkTopWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld d, FP_TILE_WALL_SIDE
	ld e, INDEX_OW_PALETTE_Z2
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_DARK
	call CheckSegmentC
.checkRightWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintRightGround ; paint ground if no right wall
.paintRightWall
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentN
	ld d, FP_TILE_DIAG_R
	call CheckSegmentNDiag
	jp .paintCenterGround
.paintRightGround
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_GROUND
	call CheckSegmentN
	call CheckSegmentNDiag
.paintCenterGround
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_GROUND
	call CheckSegmentM

ProcessTileLeftFar:
.checkTopWall
	call GetRoomCoordsLeftFarWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z2
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_DARK
	call CheckSegmentA
	call CheckSegmentB
.paintGround
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag

ProcessTileRightFar:
.checkTopWall
	call GetRoomCoordsRightFarWRTPlayer
	call GetRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z2
	ld d, FP_TILE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, FP_TILE_DARK
	call CheckSegmentD
	call CheckSegmentE
.paintGround
	ld e, INDEX_OW_PALETTE_Z1
	ld d, FP_TILE_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	ret

; Map1 + wPlayerX + wPlayerY*32
; @param d: player X coord
; @param e: player Y coord
; @return hl: tile address of player occupied tile of Map1 (this need to change)
GetRoomAddrFromCoords::
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
	ld a, [wActiveMap]
	ld b, a
	ld a, [wActiveMap+1]
	ld c, a
	;ld bc, wActiveMap
	add hl, bc
	ret
